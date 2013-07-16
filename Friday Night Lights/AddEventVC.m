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
 
@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) TDDatePickerController* datePickerController;
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;

@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UITextField *costValue;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;


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
    
    [self customizeDesign];
    
    [self setupViewValues];
    
    [Helper addTapRecognizerToVc:self];
}
- (void)customizeDesign {
    [DesignHelper addBackgroundToView:self.view];
    

}
- (void)setupViewValues {
    self.dateValue.text = [self.event.date dateAndTimeString];
}

- (void)viewWillAppear:(BOOL)animated {
    [DesignHelper customizeCells:self.cells];
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [EventHelper validReplacementString:string forCostFieldString:textField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [EventHelper saveCostString:textField.text toEvent:self.event];
    [EventHelper setupCostValueForTextField:self.costValue forEvent:self.event];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.dateCell]) {
        [EventHelper presentDatePickerInVc:self];
    }
}


-(void)datePickerSetDate:(TDDatePickerController*)viewController {
    NSDate *date = viewController.datePicker.date;
    self.event.date = date;
    self.dateValue.text =  [date dateAndTimeString];
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
    [self saveEvent];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveAndInviteButtonPress:(UIButton *)sender {
    if([MFMessageComposeViewController canSendText]) {
        [self saveEvent];
        [self inviteParticipants];
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}

- (void)saveEvent {
    [Model saveContext];
}

- (void)inviteParticipants {
    [self setupMessageComposeVc];
    [self presentViewController:self.messageComposeVc animated:YES completion:nil];
}
- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    [self setupMessageComposeRecipients];
    [self setupMessageComposeBody];
    self.messageComposeVc.messageComposeDelegate = self;
}
- (void)setupMessageComposeRecipients {
    NSArray *participants = [Model participants];
    NSArray *mobileNumbers = [MessageHelper mobileNumbersFromPartipants:participants];
    self.messageComposeVc.recipients = mobileNumbers;
}

- (void)setupMessageComposeBody {
    NSString *dateString = [self.event.date dateAndTimeString];
    NSString *body = [NSString stringWithFormat:@"Who's in for hockey on %@ ?", dateString];
    self.messageComposeVc.body = body;
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



@end
