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
#import "ParticipantTransactionVC.h"


@interface Helper ()

@property (strong, nonatomic) TDDatePickerController* datePickerController;


@end


@implementation Helper

+ (void)addTapRecognizerToVc:(UIViewController *)vc {
    //Needed to dismiss keyboard on text field
    //http://stackoverflow.com/questions/5306240/iphone-dismiss-keyboard-when-touching-outside-of-textfield
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:vc action:@selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = FALSE;
    [vc.view addGestureRecognizer:tap];
}





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

+ (void)saveAmountString:(NSString *)amountString toNumberVariable:(NSNumber *)number {
    if (amountString.length == 0) {
        number = 0;
    } else {
        number = [NSNumber numberWithFloat:amountString.floatValue];
    }
}


//+ (void)presentDatePickerInVc:(UIViewController *)vc {
//    TDDatePickerController *datePickerController = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
//    datePickerController.delegate = vc;
//    [vc setValue:datePickerController forKey:@"datePickerController"];
//    [vc presentSemiModalViewController:datePickerController inView:vc.view];
//}
//
//
//+ (void)setupCostValueForTextField:(UITextField *)textField forEvent:(Event *)event {
//    textField.text = [self costStringForEvent:event];
//}
//+ (NSString *)costStringForEvent:(Event *)event {
//    NSString *string = nil;
//    CGFloat floatCost = event.cost.floatValue;
//    if (floatCost != 0) {
//        string = [self stringFromDollarAmount:event.cost.floatValue];
//    }
//    return  string;
//}
//+ (NSString *)stringFromDollarAmount:(CGFloat)amount {
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//    NSString *amountString = [formatter stringFromNumber:[NSNumber numberWithFloat:amount]];
//    return amountString;
//}




@end
