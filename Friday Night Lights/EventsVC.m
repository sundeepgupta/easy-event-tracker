//
//  EventsVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventsVC.h"
#import "UIAlertView+Helpers.h"
#import "Event.h"
#import "EventDetailVC.h"
#import "EventHelper.h"
#import "AddEventVC.h"
#import "EventsCell.h"
#import "Helper.h"


@interface EventsVC ()

@property (strong, nonatomic) NSArray *dataSource;
@property (nonatomic) CGFloat cellHeight;

@end

@implementation EventsVC

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
    self.title = @"Events";
    [self customizeDesign];
    [self prepareForTableViewCells];
}
- (void)customizeDesign {
    [DesignHelper customizeTableView:self.tableView];
}
- (void)prepareForTableViewCells {
    [EventsCell setupReuseIdForTableView:self.tableView];
    self.cellHeight = [EventsCell height];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
    [self.tableView reloadData];
}

- (void)setupDataSource {
    self.dataSource = [Model events];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = NSStringFromClass([EventsCell class]);
    EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Event *object = [self objectAtIndexPath:indexPath];
    [EventHelper configureCell:cell forEvent:object];
    
    [DesignHelper customizeCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *objectAtIndexPath = [self objectAtIndexPath:indexPath];
        [Model deleteObject:objectAtIndexPath];
        [self setupDataSource];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (Event *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *objectAtIndex = [self.dataSource objectAtIndex:indexPath.row];
    
    NSString *vcId = NSStringFromClass([EventDetailVC class]);
    EventDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    vc.Event = objectAtIndex;
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (IBAction)addButtonPress:(UIBarButtonItem *)sender {
    Event *event = [Model newEvent];
    UIViewController *vc = [self preparedVcWithEvent:event];
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIViewController *)preparedVcWithEvent:(Event *)event {
    NSString *ncId = @"AddEventNC";
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:ncId];
    
    AddEventVC *vc = (AddEventVC *)nc.topViewController;
    vc.event = event;
    
    return nc;
}

@end
