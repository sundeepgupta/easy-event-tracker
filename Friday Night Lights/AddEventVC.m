//
//  AddEventVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "AddEventVC.h"
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
#import "Helper.h"

@interface AddEventVC ()
 
@property (strong, nonatomic) TDDatePickerController* datePickerController;
@property (strong, nonatomic) TextMessageManager *textMessageManager;

@property (strong, nonatomic) IBOutlet UITextField *nameValue;
@property (strong, nonatomic) IBOutlet UITextField *venueValue;
@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UITextField *costValue;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *textCells;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *buttonCells;

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
    self.title = @"Add Event";
    [self customizeDesign];
    [self setupViewValues];
    [Helper addTapRecognizerToVc:self];
}
- (void)customizeDesign {
    [DesignHelper addBackgroundToView:self.view];
    [DesignHelper removeBorderForGroupedCells:self.buttonCells];
}
- (void)setupViewValues {
    self.dateValue.text = [self.event.date dateAndTimeString];
}

- (void)viewWillAppear:(BOOL)animated {
    [DesignHelper customizeCells:self.textCells];
}


- (void)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setDateValue:nil];
    [self setCostValue:nil];
    [self setDateCell:nil];
    [self setInviteButton:nil];
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

- (IBAction)cancelButtonPress:(UIBarButtonItem *)sender {
    [self deleteEvent];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)deleteEvent {
    [Model deleteObject:self.event];
    self.event = nil;
}

- (IBAction)doneButtonPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Text Participants
- (IBAction)saveAndInviteButtonPress:(UIButton *)sender {
    if([MFMessageComposeViewController canSendText]) {
        [self inviteParticipants];
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}

- (void)inviteParticipants {
    NSArray *recipients = [self recipientsForTextMessage];
    NSString *body = [self bodyForTextMessage];
    self.textMessageManager = [[TextMessageManager alloc] initWithRecipients:recipients body:body delegate:self];
    [self.textMessageManager sendTextMessage];
}
- (NSArray *)recipientsForTextMessage {
    NSArray *participants = [Model participantsWithStatus:STATUS_ACTIVE];
    NSArray *recipients = [MessageHelper mobileNumbersFromPartipants:participants];
    return recipients;
}
- (NSString *)bodyForTextMessage {
    NSString *dateString = [self.event.date dateAndTimeString];
    NSString *body = [NSString stringWithFormat:@"The event \"%@\" is confirmed to be held at \"%@\" on %@. Please let me know if you will be participating. Thank you!", self.event.name, self.event.venueName, dateString];
    return body;
}


#pragma mark - TextMessageManager Delegates
- (void)presentMessageComposeVc:(MFMessageComposeViewController *)messageComposeVc {
    [self presentViewController:messageComposeVc animated:YES completion:nil];
}



- (void)saveEvent {
    [Model saveContext];
}


@end
