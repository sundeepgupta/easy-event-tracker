//
//  ConfirmedEventsVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ConfirmedEventsVC.h"
#import "Event.h"
#import "EventHelper.h"
#import "Helper.h"
#import "EventsCell.h"

@interface ConfirmedEventsVC ()

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *confirmedEvents;
@property (nonatomic) CGFloat cellHeight;

@end

@implementation ConfirmedEventsVC

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
    [self prepareForTableViewCells];
}
- (void)prepareForTableViewCells {
    [EventsCell setupReuseIdForTableView:self.tableView];
    self.cellHeight = [EventsCell height];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
}
- (void)setupDataSource {
    self.dataSource = [Model events];
    self.confirmedEvents =[Model confirmedEventsForParticipant:self.participant];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EventsCell class])];
    
    Event *object = self.dataSource[indexPath.row];
    [EventHelper configureCell:cell forEvent:object];
    
    for (Event *confirmedEvent in self.confirmedEvents) {
        if ([object isEqual:confirmedEvent]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    [DesignHelper customizeCell:cell];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self toggleParticipantConfirmedForIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)toggleParticipantConfirmedForIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self.dataSource objectAtIndex:indexPath.row];
    EventsCell *cell = (EventsCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [Model addParticipant:self.participant toEvent:event];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [Model deleteParticipant:self.participant fromEvent:event];
    }

    cell.confirmedParticipantsValue.text = [Helper stringForNumberOfConfirmedParticipantsForEvent:event];
    [Model saveContext];
}

@end
