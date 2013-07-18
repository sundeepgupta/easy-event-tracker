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
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;

@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UITextField *costValue;

@property (strong, nonatomic) IBOutlet UITableViewCell *confirmedParticipantsCell;
@property (strong, nonatomic) IBOutlet UILabel *confirmedParticipantsValue;
@property (strong, nonatomic) IBOutlet UITextField *costPerParticipantValue;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;

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
    self.title = @"Game Details";
    [self customizeDesign];
    [Helper addTapRecognizerToVc:self];
}
- (void)customizeDesign {
    [DesignHelper addBackgroundToView:self.view];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [self setupViewValues];
    [DesignHelper customizeCells:self.cells];
}
- (void)setupViewValues {
    self.dateValue.text = [self.event.date dateAndTimeString];
    self.costValue.text = [Helper formattedStringForAmountNumber:self.event.cost];
    [self setupAmountValues];
}
- (void)setupAmountValues {
    [self setupNumberConfirmedValue];
    [self setupCostPerParticipantValue];
}
- (void)setupNumberConfirmedValue {
    NSInteger number = [Model numberOfConfirmedParticipantsForEvent:self.event];
    self.confirmedParticipantsValue.text = [NSString stringWithFormat:@"%d", number];
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
    textField.text = [Helper unformattedStringForFormattedAmountString:textField.text];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [Helper isValidReplacementString:string forAmountFieldString:textField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.costValue.text = [Helper formattedStringForUnformattedAmountString:textField.text];
    self.event.cost = [Helper numberForFormattedAmountString:textField.text];
    [self saveEvent];
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


- (IBAction)textConfirmedParticipantsButtonPress:(id)sender {
    [self sendMessageToConfirmedParticipants:YES];
}
- (IBAction)textUnconfirmedParticipantsButtonPress:(id)sender {
    [self sendMessageToConfirmedParticipants:NO];
}
- (void)sendMessageToConfirmedParticipants:(BOOL)toConfirmedParticipants {
    if([MFMessageComposeViewController canSendText]) {
        [self setupMessageComposeVc];
        
        if (toConfirmedParticipants) {
            [self setupMessageConfirmedParticipants];
        } else {
            [self setupMessageUnconfirmedParticipants];
        }
        
        [self presentViewController:self.messageComposeVc animated:YES completion:nil];
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}
- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    self.messageComposeVc.messageComposeDelegate = self;
}
- (void)setupMessageConfirmedParticipants {
    NSArray *participants = [Model confirmedParticipantsForEvent:self.event];
    [self setupMessageWithRecipients:participants];
}
- (void)setupMessageUnconfirmedParticipants {
    NSArray *participants = [Model unconfirmedParticipantsForEvent:self.event];
    [self setupMessageWithRecipients:participants];
}
- (void)setupMessageWithRecipients:(NSArray *)participants {
    NSArray *mobileNumbers = [MessageHelper mobileNumbersFromPartipants:participants];
    self.messageComposeVc.recipients = mobileNumbers;
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled: {
            break;
        }
        case MessageComposeResultSent: {
            break;
        }
        case MessageComposeResultFailed: {
            [UIAlertView showAlertWithTitle:@"Send Error" withMessage:@"There was an error sending the text messages"];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
