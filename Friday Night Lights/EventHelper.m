//
//  EventHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventHelper.h"
#import "NSString+Helpers.h"
#import "Event.h"
#import "TDDatePickerController.h"

@interface EventHelper ()

@property (strong, nonatomic) TDDatePickerController* datePickerController;


@end

@implementation EventHelper

+ (BOOL)validReplacementString:(NSString *)replacementString forCostFieldString:(NSString *)costFieldString {
    
    BOOL isNumbersOnly = [replacementString hasNumbersOnly];
    
    BOOL hasNoLeadingZero = YES;
    if ((costFieldString.length == 0) && [replacementString hasPrefix:@"0"]) {
        hasNoLeadingZero = NO;
    }
    
    BOOL hasNoMultipleDecimals = YES;
    if ([replacementString containsString:@"."] && [costFieldString containsString:@"."]) {
        hasNoMultipleDecimals = NO;
    }
    
    return (isNumbersOnly && hasNoLeadingZero && hasNoMultipleDecimals);
}

+ (void)saveCostString:(NSString *)costString toEvent:(Event *)event {
    if (costString.length == 0) {
        event.cost = 0;
    } else {
        event.cost = [NSNumber numberWithFloat:costString.floatValue];
    }
}

+ (void)presentDatePicker:(TDDatePickerController *)datePickerController InVc:(UIViewController *)vc {
    datePickerController = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
    datePickerController.delegate = vc;
    [vc presentSemiModalViewController:datePickerController inView:vc.view];
}



@end
