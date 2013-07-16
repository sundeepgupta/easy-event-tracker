//
//  Helper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-14.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Helper.h"
#import "NSString+Helpers.h"
#import "TDDatePickerController.h"
#import "EventDetailVC.h"
#import "AddEventVC.h"
#import "TransactionDetailVC.h"


@interface Helper ()

@end


@implementation Helper

+ (void)addTapRecognizerToVc:(UIViewController *)vc {
    //Needed to dismiss keyboard on text field
    //http://stackoverflow.com/questions/5306240/iphone-dismiss-keyboard-when-touching-outside-of-textfield
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:vc action:@selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = FALSE;
    [vc.view addGestureRecognizer:tap];
}


#pragma mark - Amounts for strings, textfields
+ (BOOL)isValidReplacementString:(NSString *)replacementString forAmountFieldString:(NSString *)amountFieldString {
    
    BOOL isNumbersOnly = [replacementString hasNumbersOnly];
    
    BOOL hasNoLeadingZero = YES;
    if ((amountFieldString.length == 0) && [replacementString hasPrefix:@"0"]) {
        hasNoLeadingZero = NO;
    }
    
    BOOL hasNoMultipleDecimals = YES;
    if ([replacementString containsString:@"."] && [amountFieldString containsString:@"."]) {
        hasNoMultipleDecimals = NO;
    }
    
    return (isNumbersOnly && hasNoLeadingZero && hasNoMultipleDecimals);
}
+ (NSNumber *)amountNumberForTextFieldAmountString:(NSString *)amountString {
    NSNumber *number = 0;
    if (amountString.length != 0) {
        number = [NSNumber numberWithFloat:amountString.floatValue];
    }
    return  number;
}


+ (NSString *)stringForAmountNumber:(NSNumber *)number {
    NSString *string = nil;
    CGFloat floatNumber = number.floatValue;
    if (floatNumber != 0) {
        string = [self stringForAmount:floatNumber];
    }
    return  string;
}
+ (NSString *)stringForAmount:(CGFloat)amount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *amountString = [formatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    return amountString;
}



#pragma mark - Date PIcker
+ (void)presentDatePickerInVc:(UIViewController *)vc withDateMode:(BOOL)withDateMode {
    TDDatePickerController *datePickerController = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
    
    if (withDateMode) {
        datePickerController.datePickerMode = UIDatePickerModeDate;
    }
    
    [datePickerController.datePicker setDatePickerMode:UIDatePickerModeDate];
    datePickerController.delegate = vc;
    [vc setValue:datePickerController forKey:@"datePickerController"];
    [vc presentSemiModalViewController:datePickerController inView:vc.view];
}







@end
