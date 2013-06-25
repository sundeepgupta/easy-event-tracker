//
//  EventDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventDetailVC.h"
#import "Model.h"
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

@interface EventDetailVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) TDDatePickerController* datePickerController;
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;

@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UITextField *costValue;

@property (strong, nonatomic) IBOutlet UITableViewCell *confirmedParticipantsCell;
@property (strong, nonatomic) IBOutlet UILabel *confirmedParticipantsValue;

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
    
    Global *global = [Global sharedGlobal];
    self.model = global.model;
    
    [self addTapRecognizer];
}
- (void)addTapRecognizer {
    //Needed to dismiss keyboard on text field
    //http://stackoverflow.com/questions/5306240/iphone-dismiss-keyboard-when-touching-outside-of-textfield
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tap];
}
- (void)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [self setupViewValues];
}
- (void)setupViewValues {
    self.dateValue.text = [self.event.date dateAndTimeString];
    self.costValue.text = self.event.cost.stringValue;
    [self setupNumberConfirmedValue];
}
- (void)setupNumberConfirmedValue {
    //get confirmed players
    //count them
    //set the value
}


- (void)viewWillDisappear:(BOOL)animated {
    [self saveEvent];
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [EventHelper validReplacementString:string forCostFieldString:textField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [EventHelper saveCostString:textField.text toEvent:self.event];
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.dateCell]) {
        [self presentDatePicker];
    }
}
- (void)presentDatePicker {
    self.datePickerController = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
    self.datePickerController.delegate = self;
    [self presentSemiModalViewController:self.datePickerController inView:self.navigationController.view];
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


- (IBAction)messageConfirmed:(id)sender {
    
}

- (IBAction)messageAll:(id)sender {
    if([MFMessageComposeViewController canSendText]) {
        [self setupMessageComposeVc];
        NSArray *participants = [self.model participants];
        [self setupMessageComposeRecipientsForParticipants:participants];
        [self presentViewController:self.messageComposeVc animated:YES completion:nil];
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}

- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    self.messageComposeVc.messageComposeDelegate = self;
}
- (void)setupMessageComposeRecipientsForParticipants:(NSArray *)participants {
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
    [self.model saveContext];
}

@end
