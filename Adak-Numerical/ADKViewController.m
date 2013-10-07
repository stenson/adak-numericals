//
//  ADKViewController.m
//  Adak-Numerical
//
//  Created by Robert Stenson on 10/5/13.
//  Copyright (c) 2013 ADK. All rights reserved.
//

#import "ADKViewController.h"
#import "ADKNumericControl.h"

@interface ADKViewController () {
    ADKNumericControl *_digits;
    ADKNumericControl *_series;
}

@end

@implementation ADKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _digits = [ADKNumericControl numericControlFromMinimum:1.f toMaximum:10.f increment:1.f numberToString:^NSString *(NSInteger index, CGFloat number) { return [NSString stringWithFormat:@"%.0f", number]; } whenValueUpdates:^(CGFloat value) { NSLog(@"updated %f", value); }];
    
    _series = [ADKNumericControl numericControlWithValues:@[@12.5, @31.3, @81] numberToString:^NSString *(NSInteger index, CGFloat number) {
        return [NSString stringWithFormat:@"%.1f", number];
    } whenValueUpdates:^(CGFloat number) {
        NSLog(@"updated %f", number);
    }];
    
    _digits.font = [UIFont boldSystemFontOfSize:24.f];
    
    _series.cellHeight = 100.f;
    _series.font = [UIFont italicSystemFontOfSize:38.f];
    
    [self.view addSubview:_digits];
    [self.view addSubview:_series];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect rDigits, rSeries;
    CGRectDivide(self.view.bounds, &rDigits, &rSeries, floorf(CGRectGetWidth(self.view.bounds)/2.f), CGRectMinXEdge);
    _digits.frame = rDigits;
    _series.frame = rSeries;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
