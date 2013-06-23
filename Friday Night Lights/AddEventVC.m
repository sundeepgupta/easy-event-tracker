//
//  AddEventVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "AddEventVC.h"
#import "Model.h"
#import "Event.h"
#import "NSString+Helpers.h"
#import "TDDatePickerController.h"
#import "EventHelper.h"
#import "NSDate+Helpers.h"
#import "AddressBookHelper.h"
#import "Participant.h"
#import "UIAlertView+Helpers.h"

@interface AddEventVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) TDDatePickerController* datePickerController;
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;

@property (strong, nonatomic) IBOutlet UITextField *dateValue;
@property (strong, nonatomic) IBOutlet UITextField *costValue;

@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;


@end

@implementation AddEventVC

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

    self.title = @"Add Game";
    
    Global *global = [Global sharedGlobal];
    self.model = global.model;
    
    //TODO - Remove once date picker fixed.
    self.event.date = [NSDate date];
    self.dateValue.text = [self.event.date dateAndTimeString];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setDateValue:nil];
    [self setCostValue:nil];
    [self setDateCell:nil];
    [super viewDidUnload];
}

#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowChange = NO;
    
    if ([textField isEqual:self.costValue]) {
        allowChange = [self validReplacementString:string forCostFieldString:textField.text];
    }

    return allowChange;
}
- (BOOL)validReplacementString:(NSString *)replacementString forCostFieldString:(NSString *)costFieldString {
    
    BOOL isNumbersOnly = [replacementString hasNumbersOnly];
    
    BOOL hasNoLeadingZero = YES;
    if ((costFieldString.length == 0) && [replacementString hasPrefix:@"0"]) {
        hasNoLeadingZero = NO;
    }
    
    BOOL hasNoMultipleDecimals = YES;
    if ([replacementString containsString:@"."] && [costFieldString containsString:@"."]) {
        hasNoMultipleDecimals = NO;
    }
    
    return (isNumbersOnly && hasNoLeadingZero && hasNoMultipleDecimals);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.costValue]) {
        [self saveCostValue];
    }
}
- (void)saveCostValue {
    if (self.costValue.text.length == 0) {
        self.event.cost = 0;
    } else {
        self.event.cost = [NSNumber numberWithFloat:self.costValue.text.floatValue];
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.dateCell]) {
        //TODO - This is being presented behind this modal.  For now, just use current date.
        [self presentDatePicker];
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



- (IBAction)cancelButtonPress:(UIBarButtonItem *)sender {
    [self deleteEvent];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)deleteEvent {
    [self.model deleteObject:self.event];
    self.event = nil;
}

- (IBAction)saveAndInviteButtonPress:(UIButton *)sender {
    [self saveEvent];
    [self inviteParticipants];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveEvent {
    [self.model saveContext];
}
- (void)inviteParticipants {
    if([MFMessageComposeViewController canSendText]) {
        [self setupMessageComposeVc];
        [self presentViewController:self.messageComposeVc animated:YES completion:nil];
    }
}
- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    [self setupMessageComposeRecipients];
    [self setupMessageComposeBody];
    self.messageComposeVc.messageComposeDelegate = self;
}
- (void)setupMessageComposeRecipients {
    NSArray *participants = [self.model participants];
    NSArray *mobileNumbers = [self mobileNumbersFromPartipants:participants];
    self.messageComposeVc.recipients = mobileNumbers;
}
- (NSArray *)mobileNumbersFromPartipants:(NSArray *)participants {
    NSMutableArray *mobileNumbers = [[NSMutableArray alloc] init];
    
    for (Participant *participant in participants) {
        NSString *mobileNumber = [AddressBookHelper mobileNumberFromAbRecordId:participant.abRecordId];
        
        if (mobileNumber.length > 0) {
            [mobileNumbers addObject:mobileNumber];
        } else {
            [self handleMissingMobileNumberForParticipant:participant];
        }
    }
    return mobileNumbers;
}
- (void)handleMissingMobileNumberForParticipant:(Participant *)participant {
    NSString *compositeName = [AddressBookHelper abCompositeNameFromAbRecordId:participant.abRecordId];
    NSString *message = [NSString stringWithFormat:@"%@ doesn't have a mobile number set. Invite won't be sent to him/her.", compositeName];
    [UIAlertView showAlertWithTitle:@"Woops!" withMessage:message];
}

- (void)setupMessageComposeBody {
    NSString *dateString = [self.event.date dateAndTimeString];
    NSString *body = [NSString stringWithFormat:@"Who's in for hockey on %@ ?", dateString];
    self.messageComposeVc.body = body;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
