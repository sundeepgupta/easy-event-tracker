//
//  MessageHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "MessageHelper.h"
#import "UIAlertView+Helpers.h"
#import "Participant.h"
#import "AddressBookHelper.h"

@implementation MessageHelper

+ (void)showCantSendTextAlert {
    [UIAlertView showAlertWithTitle:@"Device Can't Send" withMessage:@"It seems that your device is unable to send text messages."];
}

+ (NSArray *)mobileNumbersFromPartipants:(NSArray *)participants {
    NSMutableArray *mobileNumbers = [[NSMutableArray alloc] init];
    
    for (Participant *participant in participants) {
        NSString *mobileNumber = [AddressBookHelper mobileNumberFromAbRecordId:participant.abRecordId];
        
        if (mobileNumber.length > 0) {
            [mobileNumbers addObject:mobileNumber];
        } else {
            [self handleMissingMobileNumberForParticipant:participant];
        }
    }
    return mobileNumbers;
}
+ (void)handleMissingMobileNumberForParticipant:(Participant *)participant {
    NSString *compositeName = [AddressBookHelper abCompositeNameFromAbRecordId:participant.abRecordId];
    NSString *message = [NSString stringWithFormat:@"%@ doesn't have a mobile number set. Invite won't be sent to him/her.", compositeName];
    [UIAlertView showAlertWithTitle:@"FYI..." withMessage:message];
}

@end
