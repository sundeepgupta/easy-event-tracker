//
//  ParticipantHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ParticipantHelper.h"
#import "Participant.h"
#import "AddressBookHelper.h"
#import "Transaction.h"
#import "Helper.h"
#import "Event.h"
#import "EventHelper.h"

@implementation ParticipantHelper

+ (NSArray *)dataSource {
    NSArray *participants = [Model participants];
    NSArray *participantsWithNames = [self participantsWithNames:participants];
    NSArray *sortedParticipants = [self sortParticipants:participantsWithNames];
    return sortedParticipants;
}
+ (NSArray *)participantsWithNames:(NSArray *)participants {
    NSMutableArray *mutableParticipants = participants.mutableCopy;
    for (Participant *participant in mutableParticipants) {
        participant.name = [self nameForParticipant:participant];
    }
    return mutableParticipants;
}
+ (NSArray *)sortParticipants:(NSArray *)participants {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSMutableArray *mutableObjects = participants.mutableCopy;
    return  [mutableObjects sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSString *)nameForParticipant:(Participant *)participant {
    NSNumber *abRecordId = participant.abRecordId;
    return [AddressBookHelper abCompositeNameFromAbRecordId:abRecordId];
}


+ (NSURL *)phoneUrlForParticipant:(Participant *)participant {
    NSString *mobileNumber = [self mobileNumberForParticipant:participant];
    NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@", mobileNumber];
    NSString *escapedString = [phoneString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *phoneUrl = [NSURL URLWithString:escapedString];
    return phoneUrl;
}
+ (NSString *)mobileNumberForParticipant:(Participant *)participant {
    NSNumber *abRecordId = participant.abRecordId;
    return [AddressBookHelper mobileNumberFromAbRecordId:abRecordId];
}


#pragma mark - Money
+ (NSString *)sumOfTransactionsStringForParticipant:(Participant *)participant {
    CGFloat sum = [self sumOfTransactionsForParticipant:participant];
    NSString *sumString = [Helper formattedStringForAmountFloat:sum];
    return sumString;
}


+ (NSString *)balanceStringForParticipant:(Participant *)participant {
    CGFloat balance = [self balanceForParticipant:participant];
    NSString *string = [Helper formattedStringForAmountFloat:balance];
    return string;
}
+ (CGFloat)balanceForParticipant:(Participant *)participant {
    CGFloat sumOfTransactions = [self sumOfTransactionsForParticipant:participant];
    CGFloat sumOfEventCosts = [self sumOfEventCostsForParticipant:participant];
    CGFloat balance = sumOfTransactions - sumOfEventCosts;
    return balance;
}
+ (CGFloat)sumOfTransactionsForParticipant:(Participant *)participant {
    CGFloat sum = 0;
    NSSet *transactions = participant.transactions;
    
    CGFloat amount;
    for (Transaction *transaction in transactions) {
        amount = transaction.amount.floatValue;
        sum = sum + amount;
    }
    
    return sum;
}
+ (CGFloat)sumOfEventCostsForParticipant:(Participant *)participant {
    CGFloat sum = 0;
    NSSet *events = participant.events;
    
    CGFloat costPerParticipant;
    for (Event *event in events) {
        costPerParticipant = [EventHelper costPerParticipantForEvent:event];
        sum = sum + costPerParticipant;
    }
    
    return sum;
}



@end
