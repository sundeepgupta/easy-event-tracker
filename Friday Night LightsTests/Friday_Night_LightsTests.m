//
//  Friday_Night_LightsTests.m
//  Friday Night LightsTests
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Friday_Night_LightsTests.h"
#import "ParticipantsVC.h"
#import "Model.h"

@interface Friday_Night_LightsTests ()

@property (strong, nonatomic) ParticipantsVC *vc;
@property (strong, nonatomic) Model *model;

@end

@implementation Friday_Night_LightsTests

- (void)setUp
{
    [super setUp];
    
    self.vc = [[ParticipantsVC alloc] init];
    self.model = [[Model alloc] init];
}

- (void)tearDown
{
    self.vc = nil;
    self.model = nil;
    
    [super tearDown];
}

- (void)testNewParticipantButtonPress {
    STAssertNoThrow([self.vc newButtonPress:nil], @"Exception was thrown");
}

- (void)testResetStore {
    STAssertNoThrow([self.model resetStore], nil);
}

@end
