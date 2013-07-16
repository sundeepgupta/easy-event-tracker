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

@interface ConfirmedParticipantsVC ()

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *confirmedParticipants;

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
    self.title = @"Confirmed";
    [DesignHelper customizeTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
}
- (void)setupDataSource {
    self.dataSource = [Model participants];
    self.confirmedParticipants = [Model confirmedParticipantsForEvent:self.event];
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConfirmedParticipantsVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [DesignHelper customizeCell:cell];
    
    Participant *object = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [ParticipantHelper nameForParticipant:object];
    
    for (Participant *confirmedParticipant in self.confirmedParticipants) {
        if ([object isEqual:confirmedParticipant]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self toggleParticipantConfirmedForIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)toggleParticipantConfirmedForIndexPath:(NSIndexPath *)indexPath {
    Participant *participant = [self.dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [Model addParticipant:participant toEvent:self.event];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [Model deleteParticipant:participant fromEvent:self.event];
    }
    
    [Model saveContext];
}

@end
