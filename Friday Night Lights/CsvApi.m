//
//  CsvApi.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-23.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "CsvApi.h"
#import "CHCSVParser.h"
#import "Event.h"
#import "NSDate+Helpers.h"
#import "ParticipantHelper.h"
#import "Participant.h"
#import "Transaction.h"


@interface CsvApi ()

@end

@implementation CsvApi

- (id)initWithPath:(NSString *)path {
    self = [super init];
    if (!self) {
        self = nil;
    } else {
        self.writer = [[CHCSVWriter alloc] initForWritingToCSVFile:path];
    }
    return self;
}


- (void)writeEvent:(Event *)event {
    NSArray *strings = [self stringsForEvent:event];
    [self writeLineOfFields:strings];
}
- (NSArray *)stringsForEvent:(Event *)event {
    NSString *date = [event.date dateAndTimeString];
    NSString *cost = event.cost.stringValue;
    NSString *numberOfParticipants = [NSString stringWithFormat:@"%d", event.participants.count];
    NSArray *strings = @[date, cost, numberOfParticipants];
    return strings;
}

- (void)writeNameForParticipant:(Participant *)participant {
    NSString *name = [ParticipantHelper nameForParticipant:participant];
    [self writeField:name];
    [self finishLine];
}


- (void)writeParticipant:(Participant *)participant {
    NSArray *strings = [self stringsForParticipant:participant];
    [self writeLineOfFields:strings];
}
- (NSArray *)stringsForParticipant:(Participant *)participant {
    NSString *name = [ParticipantHelper nameForParticipant:participant];
    NSString *status = participant.status;
    NSString *balance = [ParticipantHelper balanceStringForParticipant:participant];
    NSArray *strings = @[name, status, balance];
    return strings;
}


- (void)writeTransaction:(Transaction *)transaction {
    NSArray *strings = [self stringsForTransaction:transaction];
    [self writeLineOfFields:strings];
}
- (NSArray *)stringsForTransaction:(Transaction *)transaction {
    NSString *date = [transaction.date dateString];
    NSString *amount = [Helper formattedStringForAmountNumber:transaction.amount];
    NSArray *strings = @[date, amount];
    return strings;
}









- (void)finishSection {
    [self finishLine];
    [self finishLine];
    [self finishLine];
}





#pragma mark - Original methods
- (void)writeField:(NSString *)field {
    [self.writer writeField:field];
}
- (void)finishLine {
    [self.writer finishLine];
}
- (void)writeLineOfFields:(id<NSFastEnumeration>)fields {
    [self.writer writeLineOfFields:fields];
}
- (void)closeStream {
    [self.writer closeStream];
}



@end
