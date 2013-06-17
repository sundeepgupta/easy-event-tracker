//
//  ParticipantsVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ParticipantsVC.h"
#import "Model.h"
#import "Participant.h"
#import "ParticipantDetailVC.h"


@interface ParticipantsVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ParticipantsVC

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
    
    self.title = @"Players";
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
    [self.tableView reloadData];
}

- (void)setupDataSource {
    self.dataSource = [self.model Participants];
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
    static NSString *CellIdentifier = @"ParticipantsVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Participant *objectAtRow = self.dataSource[indexPath.row];
    ABAddressBookRef addressBook = [self addressBook];
    NSString *compositeName = [self nameForParticipant:objectAtRow fromAddressBook:addressBook];
    
    cell.textLabel.text = compositeName;
    
    return cell;
}

- (ABAddressBookRef)addressBook {
    ABAddressBookRef addressBook;
    if (&ABAddressBookCreateWithOptions != NULL) {
        addressBook = ABAddressBookCreateWithOptions(nil, nil);
    } else { //below iOS 6
        addressBook = ABAddressBookCreate();
    }
    return addressBook;
}

- (NSString *)nameForParticipant:(Participant *)participant fromAddressBook:(ABAddressBookRef)addressBook{
    ABRecordID abRecordId = (ABRecordID)participant.abRecordId.intValue;
    ABRecordRef abRecordRef = ABAddressBookGetPersonWithRecordID(addressBook, abRecordId);
    return (__bridge NSString *)ABRecordCopyCompositeName(abRecordRef);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Participant *object = [self.dataSource objectAtIndex:indexPath.row];
    
    NSString *vcId = NSStringFromClass([ParticipantDetailVC class]);
    ParticipantDetailVC *participantDetailVc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    participantDetailVc.participant = object;
    
    [self.navigationController pushViewController:participantDetailVc animated:YES];
}



- (IBAction)newButtonPress:(UIBarButtonItem *)sender {    
    ABPeoplePickerNavigationController *peoplePicker = [self preparedPeoplePicker];
    [self presentViewController:peoplePicker animated:YES completion:nil];
}

- (ABPeoplePickerNavigationController *)preparedPeoplePicker {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    return peoplePicker;
}

#pragma mark - People Picker delegate methods
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    ABRecordType recordType = ABRecordGetRecordType(person);
    if (recordType != kABPersonType) {
        [Global showAlertWithTitle:@"Invalid Selection" withMessage:@"Sorry, only individual contacts can be selected."];
    } else {
        [self setupNewParticipantFromAbRecord:person];
        [self.model saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)setupNewParticipantFromAbRecord:(ABRecordRef)abRecordRef {
    Participant *participant = [self.model newParticipant];
    
    NSNumber *abRecordId = [NSNumber numberWithInt:ABRecordGetRecordID(abRecordRef)];
    participant.abRecordId = abRecordId;
    
    NSString *name = (__bridge NSString *)(ABRecordCopyCompositeName(abRecordRef));
    participant.name = name;
}



@end
