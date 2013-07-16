//
//  Helper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-14.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (void)addTapRecognizerToVc:(UIViewController *)vc;


+ (BOOL)isValidReplacementString:(NSString *)replacementString forAmountFieldString:(NSString *)amountFieldString;
+ (NSNumber *)amountNumberForTextFieldAmountString:(NSString *)amountString;
+ (NSString *)stringForAmountNumber:(NSNumber *)number;


+ (void)presentDatePickerInVc:(UIViewController *)vc withDateMode:(BOOL)withDateMode;


@end
