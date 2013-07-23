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
#import "ParticipantsCell.h"

@implementation ParticipantHelper

#pragma mark - Table View
+ (NSArray *)allParticipants {
    NSArray *participants = [Model participants];
    NSArray *sortedParticipants = [self sortedWithNamesParticipants:participants];
    return sortedParticipants;
}

+ (NSArray *)activeParticipants {
    NSArray *participants = [Model participantsWithStatus:STATUS_ACTIVE];
    NSArray *sortedParticipants = [self sortedWithNamesParticipants:participants];
    return sortedParticipants;
}
+ (NSArray *)sortedWithNamesParticipants:(NSArray *)participants {
    NSArray *participantsWithNames = [self participantsWithNames:participants];
    NSArray *sortedParticipants = [self sortedParticipants:participantsWithNames];
    return sortedParticipants;
}
+ (NSArray *)participantsWithNames:(NSArray *)participants {
    NSMutableArray *mutableParticipants = participants.mutableCopy;
    for (Participant *participant in mutableParticipants) {
        participant.name = [self nameForParticipant:participant];
    }
    return mutableParticipants;
}
+ (NSArray *)sortedParticipants:(NSArray *)participants {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSMutableArray *mutableObjects = participants.mutableCopy;
    return  [mutableObjects sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSString *)nameForParticipant:(Participant *)participant {
    NSNumber *abRecordId = participant.abRecordId;
    return [AddressBookHelper abCompositeNameFromAbRecordId:abRecordId];
}

+ (void)configureCell:(ParticipantsCell *)cell forParticipant:(Participant *)participant {
    cell.nameValue.text = [self nameForParticipant:participant];
    cell.balanceValue.text = [self balanceStringForParticipant:participant];
}



#pragma mark - Communication
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

+ (Participant *)participantForAbRecordRef:(ABRecordRef)abRecordRef {
    Participant *matchingParticipant;
    NSNumber *abRecordId = [AddressBookHelper abRecordIdFromAbRecordRef:abRecordRef];
    NSArray *participants = [Model participants];
    for (Participant *participant in participants) {
        if ([participant.abRecordId isEqualToNumber:abRecordId]) {
            matchingParticipant = participant;
        }
    }
    return matchingParticipant;
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
        costPerParticipant = [EventHelper costPerParticipantFloatForEvent:event];
        sum = sum + costPerParticipant;
    }
    
    return sum;
}



@end
