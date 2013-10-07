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
    ADKNumericControl *_large;
}

@end

@implementation ADKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _digits = [ADKNumericControl numericControlFromMinimum:1.f toMaximum:10.f increment:1.f
                                            numberToString:^NSString *(NSInteger index, CGFloat number) {
                                                return [NSString stringWithFormat:@"%.0f", number];
                                            } whenValueUpdates:^(CGFloat value) {
                                                NSLog(@"updated %f", value);
                                            }];
    
    _series = [ADKNumericControl numericControlWithValues:@[@12.5, @31.3, @81]
                                           numberToString:^NSString *(NSInteger index, CGFloat number) {
                                               return [NSString stringWithFormat:@"%.1f", number];
                                           } whenValueUpdates:^(CGFloat number) {
                                               NSLog(@"updated %f", number);
                                           }];
    
    _large = [ADKNumericControl numericControlFromMinimum:-20.f toMaximum:20.f increment:0.75f
                                           numberToString:^NSString *(NSInteger index, CGFloat number) {
                                               return [NSString stringWithFormat:@"%.2f", number];
                                           } whenValueUpdates:^(CGFloat value) {
                                               NSLog(@"updated large: %f", value);
                                           }];
    
    _digits.font = [UIFont boldSystemFontOfSize:24.f];
    
    _series.cellHeight = 100.f;
    _series.font = [UIFont italicSystemFontOfSize:38.f];
    
    _large.cellHeight = 32.f;
    _large.font = [UIFont boldSystemFontOfSize:18.f];
    
    [self.view addSubview:_digits];
    [self.view addSubview:_series];
    [self.view addSubview:_large];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect third = CGRectMake(0.f, 0.f, floorf(CGRectGetWidth(self.view.bounds) * 0.33f), CGRectGetHeight(self.view.bounds));
    _digits.frame = third;
    _series.frame = CGRectOffset(_digits.frame, third.size.width, 0.f);
    _large.frame = CGRectOffset(_series.frame, third.size.width, 0.f);
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
