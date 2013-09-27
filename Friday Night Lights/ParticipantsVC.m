//
//  ParticipantsVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ParticipantsVC.h"
#import "Participant.h"
#import "ParticipantDetailVC.h"
#import "AddressBookHelper.h"
#import "UIAlertView+Helpers.h"
#import "DesignHelper.h"
#import "ParticipantHelper.h"
#import "Event.h"
#import "ParticipantsCell.h"


@interface ParticipantsVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
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
    [ParticipantsCell setupReuseIdForTableView:self.tableView];
    [DesignHelper customizeTableView:self.tableView];    
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupVc];
    [self setupDataSource];
    [self.tableView reloadData];
}
- (void)setupVc {
    self.title = @"Players";
}
- (void)setupDataSource {
    self.dataSource = [ParticipantHelper activeParticipants];
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
    ParticipantsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ParticipantsCell class])];
    
    Participant *object = [self.dataSource objectAtIndex:indexPath.row];
    [ParticipantHelper configureCell:cell forParticipant:object];

    
    [DesignHelper customizeCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Participant *object = [self.dataSource objectAtIndex:indexPath.row];
        [Model updateParticipant:object withStatus:STATUS_DELETED];
        [self setupDataSource];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushNextVcWithParticipantAtIndexPath:indexPath];
}


- (void)pushNextVcWithParticipantAtIndexPath:(NSIndexPath *)indexPath {
    Participant *participant = [self.dataSource objectAtIndex:indexPath.row];
    NSString *vcId = NSStringFromClass([ParticipantDetailVC class]);
    ParticipantDetailVC *participantDetailVc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    participantDetailVc.participant = participant;
    [self.navigationController pushViewController:participantDetailVc animated:YES];
}



- (IBAction)addButtonPress:(UIBarButtonItem *)sender {
    ABPeoplePickerNavigationController *peoplePicker = [self preparedPeoplePicker];
    [self presentViewController:peoplePicker animated:YES completion:nil];
}

- (ABPeoplePickerNavigationController *)preparedPeoplePicker {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.navigationBar.topItem.title = @"Add To Players";
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
        [self handleValidAbRecordRef:abRecordRef];
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
- (void)handleValidAbRecordRef:(ABRecordRef)abRecordRef {
    if ([self abRecordRefIsUnique:abRecordRef]) {
        [self saveNewParticpantFromAbRecordRef:abRecordRef];
    } else {
        [self handleDuplicateAbRecordRef:abRecordRef];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)abRecordRefIsUnique:(ABRecordRef)abRecordRef {
    NSNumber *abRecordId = [AddressBookHelper abRecordIdFromAbRecordRef:abRecordRef];
    BOOL abRecordRefIsUnique = YES;
    NSArray *allParticipants = [Model participants];
    for (Participant *participant in allParticipants) {
        if ([participant.abRecordId isEqualToNumber:abRecordId]) {
            abRecordRefIsUnique = NO;
        }
    }
    return abRecordRefIsUnique;
}
- (void)saveNewParticpantFromAbRecordRef:(ABRecordRef)abRecordRef {
    [self setupNewParticipantFromAbRecord:abRecordRef];
    [Model saveContext];
}
- (void)setupNewParticipantFromAbRecord:(ABRecordRef)abRecordRef {
    Participant *participant = [Model newParticipant];
    participant.abRecordId = [AddressBookHelper abRecordIdFromAbRecordRef:abRecordRef];
}

- (void)handleDuplicateAbRecordRef:(ABRecordRef)abRecordRef {
    Participant *participant = [ParticipantHelper participantForAbRecordRef:abRecordRef];
    if ([participant.status isEqualToString:STATUS_DELETED]) {
        [UIAlertView showAlertWithTitle:@"Previously Deleted Player" withMessage:@"The selected contact was previously deleted. This contact will be re-activated."];
        [Model updateParticipant:participant withStatus:STATUS_ACTIVE];
    } else {
        [UIAlertView showAlertWithTitle:@"Duplicate Player" withMessage:@"The selected contact is already an active Player."];
    }
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
- (void)viewDidUnload {
    [self setAddButton:nil];
    [super viewDidUnload];
}
@end
