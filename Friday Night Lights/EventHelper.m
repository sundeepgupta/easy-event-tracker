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
#import "EventDetailVC.h"
#import "AddEventVC.h"

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


+ (void)presentDatePickerInVc:(UIViewController *)vc {
    TDDatePickerController *datePickerController = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
    datePickerController.delegate = vc;
    [vc setValue:datePickerController forKey:@"datePickerController"];
    [vc presentSemiModalViewController:datePickerController inView:vc.view];
}



+ (void)setupCostValueForTextField:(UITextField *)textField forEvent:(Event *)event {
    textField.text = [self costStringForEvent:event];
}
+ (NSString *)costStringForEvent:(Event *)event {
    NSString *string = nil;
    NSInteger integerCost = event.cost.integerValue;
    if (integerCost != 0) {
        string = [self stringFromDollarAmount:event.cost.floatValue];
    }
    return  string;
}
+ (NSString *)stringFromDollarAmount:(CGFloat)amount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *amountString = [formatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    return amountString;
}



@end
