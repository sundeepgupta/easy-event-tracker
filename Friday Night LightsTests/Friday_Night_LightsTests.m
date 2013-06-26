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
#import "ParticipantDetailVC.h"

@interface Friday_Night_LightsTests ()

@property (strong, nonatomic) ParticipantsVC *participantsVc;
@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) ParticipantDetailVC *participantDetailVc;

@end

@implementation Friday_Night_LightsTests

- (void)setUp
{
    [super setUp];
    
    self.participantsVc = [[ParticipantsVC alloc] init];
    Model = [[Model alloc] init];
}

- (void)tearDown
{
    self.participantsVc = nil;
    Model = nil;
    
    [super tearDown];
}

- (void)testNewParticipantButtonPress {
    STAssertNoThrow([self.participantsVc addButtonPress:nil], @"Exception was thrown");
}

- (void)testResetStore {
    STAssertNoThrow([Model resetStore], nil);
}

- (void)testSaveNewParticipant {
    STAssertNoThrow([self.participantDetailVc processNewCustomer], nil);
}

@end
