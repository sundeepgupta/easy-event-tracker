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
    
    BOOL hasNoMultipleHyphens = YES;
    if ([replacementString containsString:@"-"] && [amountFieldString containsString:@"-"]) {
        hasNoMultipleHyphens = NO;
    }

    BOOL hasLeadingHyphenOnly = YES;
    if ((amountFieldString.length > 0) && [replacementString containsString:@"-"]) {
        hasNoLeadingZero = NO;
    }
    
    return (isNumbersOnly && hasNoLeadingZero && hasNoMultipleDecimals && hasNoMultipleHyphens && hasLeadingHyphenOnly);
}

+ (NSString *)formattedStringForUnformattedAmountString:(NSString *)unformattedString {
    NSNumber *number = [self numberForUnformattedAmountString:unformattedString];
    NSString *formattedString = [self formattedStringForAmountNumber:number];
    return formattedString;
}
+ (NSNumber *)numberForUnformattedAmountString:(NSString *)unformattedString {
    NSNumber *number;
    if (unformattedString.length == 0) {
        number = 0;
    } else {
        number = [NSNumber numberWithFloat:unformattedString.floatValue];
    }

    return number;
}




+ (NSString *)unformattedStringForFormattedAmountString:(NSString *)formattedString {
    NSNumber *number = [self numberForFormattedAmountString:formattedString];
    NSString *unformattedString = number.stringValue;
    return unformattedString;
}
+ (NSNumber *)numberForFormattedAmountString:(NSString *)string {
    NSNumberFormatter *formatter = [self formatterForAmounts];
    NSNumber *number = [formatter numberFromString:string];
    return number;
}

+ (NSString *)formattedStringForAmountNumber:(NSNumber *)number {
    NSString *string = nil;
    CGFloat floatNumber = number.floatValue;
    if (floatNumber != 0) {
        string = [self formattedStringForAmountFloat:floatNumber];
    }
    return  string;
}
+ (NSString *)formattedStringForAmountFloat:(CGFloat)aFloat {
    NSNumber *amountNumber = [NSNumber numberWithFloat:aFloat];
    NSString *amountString = [self formattedStringForNumber:amountNumber];
    return amountString;
}
+ (NSString *)formattedStringForNumber:(NSNumber *)number {
    NSNumberFormatter *formatter = [self formatterForAmounts];
    NSString *formattedString = [formatter stringFromNumber:number];
    return formattedString;
}


+ (NSNumberFormatter *)formatterForAmounts {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return formatter;
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




#pragma mark - Admin 
+ (NSString *)stringForBankAmount {
    CGFloat balance = [self bankBalance];
    NSString *formattedString = [self formattedStringForAmountFloat:balance];
    return formattedString;
}

+ (CGFloat)bankBalance {
    NSNumber *transactionSum = [self transactionSum];
    NSNumber *eventCostSum = [self eventCostSum];
    CGFloat balance = transactionSum.floatValue - eventCostSum.floatValue;
    return balance;
}

+ (NSNumber *)transactionSum {
    NSArray *objects = [Model transactions];
    NSNumber *sum = [self sumForObjects:objects forKey:@"amount"];
    return sum;
}
+ (NSNumber *)eventCostSum {
    NSArray *objects = [Model events];
    NSNumber *sum = [self sumForObjects:objects forKey:@"cost"];
    return sum;
}

+ (NSNumber *)sumForObjects:(NSArray *)objects forKey:(NSString *)key {
    NSString *keyValueOperator = [NSString stringWithFormat:@"@sum.%@", key];
    NSNumber *sum = [objects valueForKeyPath:keyValueOperator];
    return sum;
}


@end
