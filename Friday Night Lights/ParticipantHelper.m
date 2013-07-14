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

@end
