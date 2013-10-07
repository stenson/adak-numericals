//
//  ADKNumericControl.h
//  Adak-Numerical
//
//  Created by Robert Stenson on 10/5/13.
//  Copyright (c) 2013 ADK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADKNumericControl : UIView

typedef NSString *(^ADKNumericControlNumberToStringBlock)(NSInteger index, CGFloat number);
typedef void (^ADKNumericControlWasUpdatedBlock)(CGFloat value);

+ (ADKNumericControl *)numericControlFromMinimum:(CGFloat)minimumValue toMaximum:(CGFloat)maximumValue increment:(CGFloat)increment numberToString:(ADKNumericControlNumberToStringBlock)stringBlock whenValueUpdates:(ADKNumericControlWasUpdatedBlock)valueUpdated;

+ (ADKNumericControl *)numericControlWithValues:(NSArray *)values numberToString:(ADKNumericControlNumberToStringBlock)stringBlock whenValueUpdates:(ADKNumericControlWasUpdatedBlock)valueUpdated;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) CGFloat currentValue;
@property (nonatomic) NSArray *possibleValues;
@property (nonatomic, strong) ADKNumericControlNumberToStringBlock numberToStringBlock;
@property (nonatomic, strong) ADKNumericControlWasUpdatedBlock valueWasUpdatedBlock;

@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) BOOL resetWhenDoubleTapped;

@end
