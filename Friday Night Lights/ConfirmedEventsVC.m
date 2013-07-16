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
#import "NSDate+Helpers.h"

@interface ConfirmedEventsVC ()

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *confirmedEvents;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConfirmedEventsVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [DesignHelper customizeCell:cell];
    
    Event *object = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [object.date dateAndTimeString];
    
    for (Event *confirmedEvent in self.confirmedEvents) {
        if ([object isEqual:confirmedEvent]) {
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
    Event *event = [self.dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [Model addParticipant:self.participant toEvent:event];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [Model deleteParticipant:self.participant fromEvent:event];
    }
    
    [Model saveContext];
}

@end
