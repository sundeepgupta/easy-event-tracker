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
#import "NSDate+Helpers.h"
#import "AddEventVC.h"


@interface EventsVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSArray *dataSource;

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
    
    self.title = @"Games";
    
    [DesignHelper customizeTableView:self.tableView];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventsVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Event *objectAtIndexPath = [self objectAtIndexPath:indexPath];
    NSString *dateString = [objectAtIndexPath.date dateAndTimeString];
    
    cell.textLabel.text = dateString;
    
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
