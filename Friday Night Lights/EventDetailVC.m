//
//  EventDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventDetailVC.h"
#import "Event.h"
#import "NSString+Helpers.h"
#import "TDDatePickerController.h"
#import "EventHelper.h"
#import "NSDate+Helpers.h"
#import "AddressBookHelper.h"
#import "Participant.h"
#import "UIAlertView+Helpers.h"
#import "UITableView+Helpers.h"
#import "MessageHelper.h"
#import "ConfirmedParticipantsVC.h"
#import "Helper.h"

@interface EventDetailVC ()

@property (strong, nonatomic) TDDatePickerController* datePickerController;
@property (strong, nonatomic) TextMessageManager *textMessageManager;

@property (strong, nonatomic) IBOutlet UITextField *nameValue;
@property (strong, nonatomic) IBOutlet UITextField *venueValue;
@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UITextField *costValue;

@property (strong, nonatomic) IBOutlet UITableViewCell *confirmedParticipantsCell;
@property (strong, nonatomic) IBOutlet UILabel *confirmedParticipantsValue;
@property (strong, nonatomic) IBOutlet UITextField *costPerParticipantValue;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *textCells;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *buttonCells;

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
    self.title = @"Event Details";
    [self customizeDesign];
    [Helper addTapRecognizerToVc:self];
}
- (void)customizeDesign {
    [DesignHelper addBackgroundToView:self.view];
    [DesignHelper removeBorderForGroupedCells:self.buttonCells];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [self setupViewValues];
    [DesignHelper customizeCells:self.textCells];
}
- (void)setupViewValues {
    self.nameValue.text = self.event.name;
    self.venueValue.text = self.event.venueName;
    self.dateValue.text = [self.event.date dateAndTimeString];
    self.costValue.text = [Helper formattedStringForAmountNumber:self.event.cost];
    [self setupAmountValues];
}
- (void)setupAmountValues {
    [self setupNumberConfirmedValue];
    [self setupCostPerParticipantValue];
}
- (void)setupNumberConfirmedValue {
    self.confirmedParticipantsValue.text = [Helper stringForNumberOfConfirmedParticipantsForEvent:self.event];
}
- (void)setupCostPerParticipantValue {
    self.costPerParticipantValue.text = [EventHelper costPerParticipantStringForEvent:self.event];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setDateValue:nil];
    [self setCostValue:nil];
    [self setDateCell:nil];
    [self setConfirmedParticipantsValue:nil];
    [self setConfirmedParticipantsCell:nil];
    [super viewDidUnload];
}


#pragma mark - TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.costValue]) {
        textField.text = [Helper unformattedStringForFormattedAmountString:textField.text];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChangeCharacters = YES;
    if ([textField isEqual:self.costValue]) {
        shouldChangeCharacters = [Helper isValidReplacementString:string forAmountFieldString:textField.text];
    }
    return shouldChangeCharacters;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.costValue]) {
        [self costValueTextFieldDidEndEditing];
    } else if ([textField isEqual:self.nameValue]) {
        [self nameValueTextFieldDidEndEditing];
    } else if ([textField isEqual:self.venueValue]) {
        [self venueValueTextFieldDidEndEditing];
    }
    [self saveEvent];
}
- (void)costValueTextFieldDidEndEditing {
    self.costValue.text = [Helper formattedStringForUnformattedAmountString:self.costValue.text];
    self.event.cost = [Helper numberForFormattedAmountString:self.costValue.text];
}
- (void)nameValueTextFieldDidEndEditing {
    self.event.name = self.nameValue.text;
}
- (void)venueValueTextFieldDidEndEditing {
    self.event.venueName = self.venueValue.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.dateCell]) {
        [Helper presentDatePickerInVc:self withDateMode:NO];
    } else if ([cell isEqual:self.confirmedParticipantsCell]) {
        NSString *vcId = NSStringFromClass([ConfirmedParticipantsVC class]);
        ConfirmedParticipantsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
        vc.event = self.event;
        [self.navigationController pushViewController:vc animated:YES];
        [self.tableView deselectSelectedRow];
    }
}


-(void)datePickerSetDate:(TDDatePickerController*)viewController {
    NSDate *date = viewController.datePicker.date;
    self.event.date = date;
    self.dateValue.text =  [date dateAndTimeString];
    [self saveEvent];
    [self resetView];
}
-(void)datePickerClearDate:(TDDatePickerController*)viewController {
    //not being used here
}
-(void)datePickerCancel:(TDDatePickerController*)viewController {
    [self resetView];
}
- (void)resetView {
    [self dismissSemiModalViewController:self.datePickerController];
    [self.tableView deselectSelectedRow];
}


#pragma mark - Text Messaging
- (IBAction)textConfirmedParticipantsButtonPress:(id)sender {
    [self sendMessageForConfirmedParticipants:YES];
}
- (IBAction)textUnconfirmedParticipantsButtonPress:(id)sender {
    [self sendMessageForConfirmedParticipants:NO];
}
- (void)sendMessageForConfirmedParticipants:(BOOL)forConfirmedParticipants {
    if([MFMessageComposeViewController canSendText]) {
        if (forConfirmedParticipants) {
            [self textParticipantsForConfirmedParticipants:YES];
        } else {
            [self textParticipantsForConfirmedParticipants:NO];
        }
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}



- (void)textParticipantsForConfirmedParticipants:(BOOL)forConfirmedParticipants {
    NSArray *recipients = [self recipientsForTextMessageForConfirmedParticipants:forConfirmedParticipants];
    NSString *body = [self bodyForTextMessage];
    self.textMessageManager = [[TextMessageManager alloc] initWithRecipients:recipients body:body delegate:self];
    [self.textMessageManager sendTextMessage];
}
- (NSArray *)recipientsForTextMessageForConfirmedParticipants:(BOOL)forConfirmedParticipants {
    NSArray *participants;
    if (forConfirmedParticipants) {
        participants = [Model confirmedParticipantsForEvent:self.event];
    } else {
        participants = [Model unconfirmedParticipantsForEvent:self.event];
    }
    NSArray *recipients = [MessageHelper mobileNumbersFromPartipants:participants];
    return recipients;
}
- (NSString *)bodyForTextMessage {
    NSString *dateString = [self.event.date dateAndTimeString];
    NSString *body = [NSString stringWithFormat:@"In regards to the event \"%@\" to be held at \"%@\" on %@, ", self.event.name, self.event.venueName, dateString];
    return body;
}


#pragma mark - TextMessageManager Delegates
- (void)presentMessageComposeVc:(MFMessageComposeViewController *)messageComposeVc {
    [self presentViewController:messageComposeVc animated:YES completion:nil];
}





- (void)saveEvent {
    [Model saveContext];
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endEditing];
}

- (void)endEditing {
    [self.view.window endEditing: YES];
}

@end
