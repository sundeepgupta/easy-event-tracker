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
    [self finishLine];
}
- (NSArray *)stringsForEvent:(Event *)event {
    NSString *date = [event.date dateAndTimeString];
    NSString *cost = event.cost.stringValue;
    NSString *numberOfParticipants = [NSString stringWithFormat:@"%d", event.participants.count];
    NSArray *strings = @[date, cost, numberOfParticipants];
    return strings;
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
