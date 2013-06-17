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
#import "AddressBookHelper.h"
#import "UIAlertView+Helpers.h"


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
    ABAddressBookRef addressBook = [AddressBookHelper addressBook];
    NSString *compositeName = [self nameForParticipant:objectAtRow fromAddressBook:addressBook];
    
    cell.textLabel.text = compositeName;
    
    return cell;
}



- (NSString *)nameForParticipant:(Participant *)participant fromAddressBook:(ABAddressBookRef)addressBook{
    ABRecordID abRecordId = (ABRecordID)participant.abRecordId.intValue;
    ABRecordRef abRecordRef = ABAddressBookGetPersonWithRecordID(addressBook, abRecordId);
    return (__bridge NSString *)ABRecordCopyCompositeName(abRecordRef);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Participant *objectAtIndex = [self.dataSource objectAtIndex:indexPath.row];
    
    NSString *vcId = NSStringFromClass([ParticipantDetailVC class]);
    ParticipantDetailVC *participantDetailVc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    participantDetailVc.participant = objectAtIndex;
    
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
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self processSelectedAbRecordRef:person ];
    return NO;
}

- (void)processSelectedAbRecordRef:(ABRecordRef)abRecordRef {
    if ([self abRecordTypeIsValid:abRecordRef]) {
        if ([self abRecordRefIsUnique:abRecordRef]) {
            [self saveNewParticpantFromAbRecordRef:abRecordRef];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [UIAlertView showAlertWithTitle:@"Duplicate Contact" withMessage:@"The selected contact already exists."];
        }
    } else {
        [UIAlertView showAlertWithTitle:@"Invalid Selection" withMessage:@"Sorry, only individual contacts can be selected."];
    }
}

- (BOOL)abRecordTypeIsValid:(ABRecordRef)abRecordRef {
    BOOL abRecordTypeIsValid = NO;
    ABRecordType recordType = ABRecordGetRecordType(abRecordRef);
    if (recordType == kABPersonType) {
        abRecordTypeIsValid = YES;
    }
    return abRecordTypeIsValid;
}

- (BOOL)abRecordRefIsUnique:(ABRecordRef)abRecordRef {
    NSNumber *abRecordId = [AddressBookHelper abRecordIdFromAbRecordRef:abRecordRef];
    BOOL abRecordRefIsUnique = YES;
    for (Participant *participant in self.dataSource) {
        if ([participant.abRecordId isEqualToNumber:abRecordId]) {
            abRecordRefIsUnique = NO;
        }
    }
    return abRecordRefIsUnique;
}

- (void)saveNewParticpantFromAbRecordRef:(ABRecordRef)abRecordRef {
    [self setupNewParticipantFromAbRecord:abRecordRef];
    [self.model saveContext];
}

- (void)setupNewParticipantFromAbRecord:(ABRecordRef)abRecordRef {
    Participant *participant = [self.model newParticipant];
    
    participant.abRecordId = [AddressBookHelper abRecordIdFromAbRecordRef:abRecordRef];
    participant.name = [AddressBookHelper abCompositeNameFromAbRecordRef:abRecordRef];

}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
