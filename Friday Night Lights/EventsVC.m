//
//  EventsVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventsVC.h"
#import "Model.h"
#import "UIAlertView+Helpers.h"
#import "Event.h"
#import "EventDetailVC.h"


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

    Global *global = [Global sharedGlobal];
    self.model = global.model;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Games";
    
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    self.view.backgroundColor = bgColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
    [self.tableView reloadData];
}

- (void)setupDataSource {
    self.dataSource = [self.model Events];
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
    
    cell.textLabel.text = objectAtIndexPath.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *objectAtIndexPath = [self objectAtIndexPath:indexPath];
        [self.model deleteObject:objectAtIndexPath];
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
    //present addEvent view
    
}



//- (void)saveNewParticpantFromAbRecordRef:(ABRecordRef)abRecordRef {
//    [self setupNewEventFromAbRecord:abRecordRef];
//    [self.model saveContext];
//}

//- (void)setupNewEventFromAbRecord:(ABRecordRef)abRecordRef {
//    Event *Event = [self.model newEvent];
//    
//    Event.abRecordId = [AddressBookHelper abRecordIdFromAbRecordRef:abRecordRef];
//    Event.name = [AddressBookHelper abCompositeNameFromAbRecordRef:abRecordRef];
//}

@end
