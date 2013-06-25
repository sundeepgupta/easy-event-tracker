//
//  EventDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-21.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventDetailVCOld.h"
#import "Model.h"
#import "Event.h"
#import "EventAttributeCell.h"
#import "Participant.h"
#import "AddressBookHelper.h"
#import "NSDate+Helpers.h"
#import "TDSemiModal.h"
#import "TDDatePickerController.h"


NSString * const CELL_LABEL_KEY = @"0";
NSString * const CELL_VALUE_KEY = @"1";
NSString * const SECTION_TITLE_KEY = @"2";
NSString * const SECTION_DATA_SOURCE = @"3";

@interface EventDetailVCOld ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *confirmedParticipants;

@property (strong, nonatomic) TDDatePickerController* datePickerController;

@end

@implementation EventDetailVCOld

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
    NSDictionary *confirmedParticipantsDataSource = [self confirmedParticipantsDataSource];
    self.dataSource = [NSArray arrayWithObjects:eventAttributesDataSource, confirmedParticipantsDataSource, nil];
}

- (NSDictionary *)setupEventAttributesDataSource {
//    NSDictionary *nameCellData = [self nameCellData];
    NSDictionary *dateCellData = [self dateCellData];
    NSArray *objects = [NSArray arrayWithObjects:dateCellData, nil];
    return  [NSDictionary dictionaryWithObjectsAndKeys:@"Event Details", SECTION_TITLE_KEY, objects, SECTION_DATA_SOURCE, nil];
}

- (NSDictionary *)nameCellData {
    NSString *label = @"Name";
    NSString *fieldValue = self.event.name;
    return [self eventAttributeCellDataWithLabel:label withValue:fieldValue];

}
- (NSDictionary *)dateCellData {
    NSString *label = @"Date";
    NSString *fieldValue = [self.event.date dateAndTimeString];
    return [self eventAttributeCellDataWithLabel:label withValue:fieldValue];
}

- (NSDictionary *)eventAttributeCellDataWithLabel:(NSString *)cellId withValue:(NSString *)fieldValue {
    return [NSDictionary dictionaryWithObjectsAndKeys:cellId, CELL_LABEL_KEY, fieldValue, CELL_VALUE_KEY, nil];
}

- (NSDictionary *)confirmedParticipantsDataSource {
    self.confirmedParticipants = [self.model participants];
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Confirmed Players", SECTION_TITLE_KEY, self.confirmedParticipants, SECTION_DATA_SOURCE, nil];
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
    static NSString *cellId;
    
    NSDictionary *sectionDict = self.dataSource[indexPath.section];
    NSArray *sectionDataSource = [sectionDict objectForKey:SECTION_DATA_SOURCE];
    
    switch (indexPath.section) {
        case 0: { //event attributes
            cellId = NSStringFromClass([EventAttributeCell class]);
            EventAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            
            NSDictionary *cellDict = sectionDataSource[indexPath.row];
            NSString *label = [cellDict objectForKey:CELL_LABEL_KEY];
            NSString *fieldValue = [cellDict objectForKey:CELL_VALUE_KEY];
            
            cell.fieldLabel.text = label;
            cell.fieldValue.text = fieldValue;
            
            return cell;
            break;
        } case 1: { //confirmed participants
            Participant *participant = [self.confirmedParticipants objectAtIndex:indexPath.row];
            NSString *name = [AddressBookHelper abCompositeNameFromAbRecordId:participant.abRecordId];
            
            cellId = @"ConfirmedParticipantCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            cell.textLabel.text = name;
            return cell;
            break;
        }
            
        default: {
            cellId = NSStringFromClass([EventAttributeCell class]);
            EventAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            cell.fieldValue.text = self.event.name;
            return cell;
            break;
        }
    }
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
    //get the object
    //check if dict?
    //if dict, is it date?
    //if date, pop something up.
    
    NSDictionary *sectionDict = self.dataSource[indexPath.section];
    NSArray *sectionDataSource = [sectionDict objectForKey:SECTION_DATA_SOURCE];
    id objectAtRow = sectionDataSource[indexPath.row];
    
    if ([objectAtRow isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictAtRow = (NSDictionary *)objectAtRow;
        NSString *label = [dictAtRow objectForKey:CELL_LABEL_KEY];
        
        if ([label isEqualToString:@"Date"]) {
            
            [self presentDatePicker];
            
        }
    }
}
             
- (void)presentDatePicker {
    self.datePickerController = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
    self.datePickerController.delegate = self;
    [self presentSemiModalViewController:self.datePickerController];
}

-(void)datePickerSetDate:(TDDatePickerController*)viewController {

}
-(void)datePickerClearDate:(TDDatePickerController*)viewController {
    
}
-(void)datePickerCancel:(TDDatePickerController*)viewController {
    [self dismissSemiModalViewController:self.datePickerController];
}



@end
