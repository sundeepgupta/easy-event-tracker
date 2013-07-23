//
//  Helper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-14.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STATUS_ACTIVE @"Active"
#define STATUS_DELETED @"Deleted"


@interface Helper : NSObject

+ (void)addTapRecognizerToVc:(UIViewController *)vc;


+ (BOOL)isValidReplacementString:(NSString *)replacementString forAmountFieldString:(NSString *)amountFieldString;
+ (NSString *)formattedStringForUnformattedAmountString:(NSString *)unformattedString;
+ (NSNumber *)numberForFormattedAmountString:(NSString *)string;
+ (NSString *)formattedStringForAmountNumber:(NSNumber *)number;
+ (NSString *)formattedStringForAmountFloat:(CGFloat)aFloat;
+ (NSString *)unformattedStringForFormattedAmountString:(NSString *)formattedString;


+ (NSString *)stringForNumberOfConfirmedParticipantsForEvent:(Event *)event;


+ (void)presentDatePickerInVc:(UIViewController *)vc withDateMode:(BOOL)withDateMode;


+ (NSString *)stringForBankAmount;
@end
