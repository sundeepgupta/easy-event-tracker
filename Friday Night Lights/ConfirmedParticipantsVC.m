//
//  ConfirmedParticipantsVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-13.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ConfirmedParticipantsVC.h"
#import "ParticipantHelper.h"
#import "Participant.h"
#import "ParticipantsCell.h"
#import "DeletedParticipantsSummaryCell.h"

@interface ConfirmedParticipantsVC ()

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *confirmedParticipants;
@property (nonatomic) NSInteger deletedParticipantsCount;

@end

@implementation ConfirmedParticipantsVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ParticipantsCell setupReuseIdForTableView:self.tableView];
    [DeletedParticipantsSummaryCell setupReuseIdForTableView:self.tableView];
    [DesignHelper customizeTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
    [self setupDeletedParticipantsCount];
}
- (void)setupDataSource {
    if (self.isActiveState) {
        self.dataSource = [ParticipantHelper activeParticipants];
    } else {
        self.dataSource = [ParticipantHelper deletedParticipants];
    }
    self.confirmedParticipants = [Model confirmedParticipantsForEvent:self.event];
}
- (void)setupDeletedParticipantsCount {
    NSArray *deletedParticipants = [ParticipantHelper deletedParticipants];
    self.deletedParticipantsCount = deletedParticipants.count;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    if (self.deletedParticipantsCount > 0  &&  self.isActiveState) {
        numberOfRows = self.dataSource.count + 1;
    } else {
        numberOfRows = self.dataSource.count;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == self.dataSource.count  &&  self.isActiveState) {
        cell = [self deletedParticipantsSummaryCell];
    } else {
        cell = [self participantsCellForIndexPath:indexPath];
    }
    
    return cell;
}

- (DeletedParticipantsSummaryCell *)deletedParticipantsSummaryCell {
    NSString *cellClassName = NSStringFromClass([DeletedParticipantsSummaryCell class]);
    DeletedParticipantsSummaryCell *deletedParticipantsSummaryCell = [self.tableView dequeueReusableCellWithIdentifier:cellClassName];
    NSString *countString = [NSString stringWithFormat:@"%d Deleted Participants", self.deletedParticipantsCount];
    deletedParticipantsSummaryCell.countValue.text = countString;
    return deletedParticipantsSummaryCell;
}

- (ParticipantsCell *)participantsCellForIndexPath:(NSIndexPath *)indexPath {
    ParticipantsCell *participantsCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ParticipantsCell class])];
    
    Participant *object = [self.dataSource objectAtIndex:indexPath.row];
    [ParticipantHelper configureCell:participantsCell forParticipant:object];
    
    [self setupAccessoryForParticipantsCell:participantsCell forParticipant:object];
    
    return participantsCell;
}
- (void)setupAccessoryForParticipantsCell:(ParticipantsCell *)cell forParticipant:(Participant *)participant {
    for (Participant *confirmedParticipant in self.confirmedParticipants) {
        if ([participant isEqual:confirmedParticipant]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSource.count  &&  self.isActiveState) {
        [self pushDeletedParticipantsVc];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [self toggleParticipantConfirmedForIndexPath:indexPath];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (void)pushDeletedParticipantsVc {
    ConfirmedParticipantsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ConfirmedParticipantsVC class])];
    vc.title = @"Deleted";
    vc.event = self.event;
    vc.isActiveState = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toggleParticipantConfirmedForIndexPath:(NSIndexPath *)indexPath {
    Participant *participant = [self.dataSource objectAtIndex:indexPath.row];
    ParticipantsCell *cell = (ParticipantsCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [Model addParticipant:participant toEvent:self.event];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [Model deleteParticipant:participant fromEvent:self.event];
    }
    
    [self updateVisibleCellsBalances];
    [Model saveContext];
}
- (void)updateVisibleCellsBalances {
    NSArray *cells = self.tableView.visibleCells;
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[ParticipantsCell class]]) {
            ParticipantsCell *castedCell = (ParticipantsCell *)cell;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:castedCell];
            Participant *participant = self.dataSource[indexPath.row];
            castedCell.balanceValue.text = [ParticipantHelper balanceStringForParticipant:participant];
        }
    }
}

@end
