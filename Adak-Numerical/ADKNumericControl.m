//
//  ADKNumericControl.m
//  Adak-Numerical
//
//  Created by Robert Stenson on 10/5/13.
//  Copyright (c) 2013 ADK. All rights reserved.
//

#import "ADKNumericControl.h"

@interface ADKNumericControl ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL _scrollNotNativelyGestureInitiated;
}
@end

#define IDENTIFIER @"CellIdentifier"

@implementation ADKNumericControl

+ (ADKNumericControl *)numericControlFromMinimum:(CGFloat)minimumValue toMaximum:(CGFloat)maximumValue increment:(CGFloat)increment numberToString:(ADKNumericControlNumberToStringBlock)stringBlock whenValueUpdates:(ADKNumericControlWasUpdatedBlock)valueUpdated
{
    NSMutableArray *values = [NSMutableArray array];
    for (CGFloat value = minimumValue; value <= maximumValue; value += increment) {
        [values addObject:@(value)];
    }
    
    return [ADKNumericControl numericControlWithValues:values numberToString:stringBlock whenValueUpdates:valueUpdated];
}

+ (ADKNumericControl *)numericControlWithValues:(NSArray *)values numberToString:(ADKNumericControlNumberToStringBlock)stringBlock whenValueUpdates:(ADKNumericControlWasUpdatedBlock)valueUpdated
{
    ADKNumericControl *control = [[ADKNumericControl alloc] initWithFrame:CGRectZero];
    control.possibleValues = values;
    control.numberToStringBlock = stringBlock;
    control.valueWasUpdatedBlock = valueUpdated;
    return control;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellHeight = 44.f;
        _textColor = [UIColor colorWithWhite:0.5f alpha:1.f];
        
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect padding = CGRectMake(0.f, 0.f, CGRectGetWidth(_tableView.frame), floorf(CGRectGetHeight(_tableView.frame)/2.f) - floorf(self.cellHeight/2.f));
    UIView *headerView = [[UIView alloc] initWithFrame:padding];
    
    padding.origin.y = CGRectGetHeight(_tableView.frame) - CGRectGetHeight(padding);
    UIView *footerView = [[UIView alloc] initWithFrame:padding];
    
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = footerView;
}

- (void)setCurrentValue:(CGFloat)currentValue
{
    if (_currentValue != currentValue) {
        CGFloat previousValue = _currentValue;
        _currentValue = currentValue;
        
        if (_scrollNotNativelyGestureInitiated == NO) {
            _valueWasUpdatedBlock(_currentValue);
        }
        
        [self updateTextColor:[UIColor blackColor] forCellWithValue:_currentValue];
        [self updateTextColor:_textColor forCellWithValue:previousValue];
    }
}

- (void)setCurrentValue:(CGFloat)value animated:(BOOL)animated
{
    _scrollNotNativelyGestureInitiated = YES;
    [self setCurrentValue:value];
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        _tableView.contentOffset = CGPointMake(0.f, ([self indexFromValue:value] * _cellHeight));
    } completion:^(BOOL finished) {
        _scrollNotNativelyGestureInitiated = NO;
    }];
}

- (void)updateTextColor:(UIColor *)textColor forCellWithValue:(CGFloat)value
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexFromValue:value] inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = textColor;
    [cell.textLabel setNeedsDisplay];
}

- (NSInteger)indexFromValue:(CGFloat)value
{
    NSInteger index = 0;
    for (NSNumber *number in _possibleValues) {
        if (fabsf([number floatValue] - value) < 0.01f) { // TODO: get a better delta
            break;
        } else {
            index += 1;
        }
    }
    return index;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _possibleValues.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = _numberToStringBlock(indexPath.row, [_possibleValues[indexPath.row] floatValue]);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = _font;
    cell.textLabel.textColor = _textColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCurrentValue:[_possibleValues[indexPath.row] floatValue] animated:YES];
    _valueWasUpdatedBlock(_currentValue);
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.transform = CGAffineTransformMakeTranslation(20.f, 0.f);
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_scrollNotNativelyGestureInitiated) {
        NSInteger index = roundf(scrollView.contentOffset.y / _cellHeight);
        index = MIN(MAX(index, 0), _possibleValues.count - 1);
        self.currentValue = [_possibleValues[index] floatValue];
    }
    
//    [[_tableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger i, BOOL *stop) {
//        cell.textLabel.transform = CGAffineTransformMakeTranslation(i * 2.f, 0.f);
//    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    *targetContentOffset = CGPointMake(0.f, roundf(targetContentOffset->y / _cellHeight) * _cellHeight);
}

@end
