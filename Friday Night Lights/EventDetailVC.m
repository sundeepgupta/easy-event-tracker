//
//  EventDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-21.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventDetailVC.h"
#import "Model.h"
#import "Event.h"
#import "EventDetailNameCell.h"

NSString * const CELL_ID_KEY = @"0";
NSString * const CELL_VALUE_KEY = @"1";
NSString * const SECTION_TITLE_KEY = @"2";
NSString * const SECTION_DATA_SOURCE = @"3";

@interface EventDetailVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation EventDetailVC

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
    
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupDataSource {
    NSDictionary *eventAttributesDataSource = [self setupEventAttributesDataSource];
    

    //setup declined participants
    //setup unkown participants
    
    NSDictionary *confirmedParticipantsDataSource = [self setupConfirmedParticipantsDataSource];
    
    self.dataSource = [NSArray arrayWithObjects:eventAttributesDataSource, confirmedParticipantsDataSource, nil];
}

- (NSDictionary *)setupEventAttributesDataSource {
    NSDictionary *nameCellData = [self nameCellData];
    //date cell
    //venu cell
    //put cell data into data source
    
    NSArray *objects = [NSArray arrayWithObjects:nameCellData, nil];
    
    return  [NSDictionary dictionaryWithObjectsAndKeys:@"Event Details", SECTION_TITLE_KEY, objects, SECTION_DATA_SOURCE, nil];
}

- (NSDictionary *)nameCellData {
    NSString *cellId = NSStringFromClass([EventDetailNameCell class]);
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:cellId, CELL_ID_KEY, self.event.name, CELL_VALUE_KEY, nil];
    return data;
}


- (NSDictionary *)setupConfirmedParticipantsDataSource {
    NSArray *objects = [self.model Participants];
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Confirmed Players", SECTION_TITLE_KEY, objects, SECTION_DATA_SOURCE, nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionDict = self.dataSource[section];
    NSArray *sectionDataSource = [sectionDict objectForKey:SECTION_DATA_SOURCE];
    return sectionDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventDetailNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
