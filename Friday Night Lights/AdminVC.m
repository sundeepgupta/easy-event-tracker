//
//  AdminVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-18.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "AdminVC.h"
#import "MessageHelper.h"
#import "Helper.h"
#import "UIAlertView+Helpers.h"
#import "FileHelper.h"
#import "CsvApi.h"
#import "ParticipantHelper.h"

#define FILENAME @"EET_Data.csv"

@interface AdminVC ()
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;
@property (strong, nonatomic) CsvApi *csvApi;
@property (strong, nonatomic) UIAlertView *firstDeleteConfirmation;
@property (strong, nonatomic) UIAlertView *secondDeleteConfirmation;

@property (strong, nonatomic) IBOutlet UITextField *bankValue;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *textCells;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *buttonCells;
@end

@implementation AdminVC

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
    self.title = @"Admin";
    [self customizeDesign];
}
- (void)customizeDesign {
    [DesignHelper addBackgroundToView:self.view];
    [DesignHelper removeBorderForGroupedCells:self.buttonCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupViewValues];
    [DesignHelper customizeCells:self.textCells];
}
- (void)setupViewValues {
    [self setupBankValue];
}
- (void)setupBankValue {
    self.bankValue.text = [Helper stringForBankAmount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IB
- (IBAction)messagePlayersButtonPress:(id)sender {
    if([MFMessageComposeViewController canSendText]) {
        [self inviteParticipants];
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}
- (void)inviteParticipants {
    NSArray *participants = [Model participantsWithStatus:STATUS_ACTIVE];
    if (participants.count > 0) {
        NSArray *mobileNumbers = [MessageHelper mobileNumbersFromPartipants:participants];
        if (mobileNumbers.count > 0) {
            [self setupMessageComposeVc];
            [self presentViewController:self.messageComposeVc animated:YES completion:nil];
        } else {
            [UIAlertView showAlertWithTitle:@"No Mobile Numbers" withMessage:@"No mobile numbers were found for your participants."];
        }
    } else {
        [UIAlertView showAlertWithTitle:@"No Participants" withMessage:@"No mobile numbers were found for your recipients."];
    }
}
- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    [self setupMessageComposeRecipients];
    self.messageComposeVc.messageComposeDelegate = self;
}
- (void)setupMessageComposeRecipients {
    NSArray *participants = [Model participantsWithStatus:STATUS_ACTIVE];
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


- (IBAction)emailDataButtonPress:(id)sender {
    [self generateReport];
    [self emailReport];
}

- (void)generateReport {
    [self setupCsvApi];
    [self writeCsv];
}
- (void)setupCsvApi {
    NSString *path = [FileHelper pathForFileName:FILENAME];
    self.csvApi = [[CsvApi alloc] initWithPath:path];
}
- (void)writeCsv {
    [self writeAdmin];
    [self writeEvents];
    [self writeParticipants];
    [self.csvApi closeStream];
}
- (void)writeAdmin {
    [self writeSectionTitle:@"TOTAL BALANCE"];
    NSString *bank = [Helper stringForBankAmount];
    [self.csvApi writeLineOfFields:@[bank]];
    [self.csvApi finishSection];
}

- (void)writeEvents {
    [self writeEventsHeader];
    
    NSArray *events = [Model events];
    for (Event *event in events) {
        [self writeEvent:event];
    }
    
    [self.csvApi finishSection];
}
- (void)writeEventsHeader {
    [self writeSectionTitle:@"EVENTS"];
    NSArray *headerStrings = @[@"Name", @"Venue", @"Cost", @"Date", @"Number Of Participants"];
    [self.csvApi writeLineOfFields:headerStrings];
    [self.csvApi finishLine];
}
- (void)writeEvent:(Event *)event {
    [self.csvApi writeEvent:event];
    
    NSArray *participants = [Model confirmedParticipantsForEvent:event];
    for (Participant *participant in participants) {
        [self.csvApi writeNameForParticipant:participant];
    }
    [self.csvApi finishLine];
}

- (void)writeParticipants {
    [self writeParticipantsHeader];
    
    NSArray *participants = [ParticipantHelper allParticipants];
    for (Participant *participant in participants) {
        [self writeParticipant:participant];
    }
    
    [self.csvApi finishSection];
}
- (void)writeParticipantsHeader {
    [self writeSectionTitle:@"PARTICIPANTS & TRANSACTIONS"];
    NSArray *headerStrings = @[@"Name", @"Status", @"Balance"];
    [self.csvApi writeLineOfFields:headerStrings];
    [self.csvApi finishLine];
}
- (void)writeParticipant:(Participant *)participant {
    [self.csvApi writeParticipant:participant];
    
    NSArray *transactions = [Model transactionsForParticipant:participant];
    for (Transaction *transaction in transactions) {
        [self.csvApi writeTransaction:transaction];
    }
    [self.csvApi finishLine];
}


- (void)writeSectionTitle:(NSString *)title {
    [self.csvApi writeField:title];
    [self.csvApi finishLine];
}



- (void)emailReport {
    MFMailComposeViewController *mailer = [self setupMailer];
    [self presentViewController:mailer animated:YES completion:nil];
}
- (MFMailComposeViewController *)setupMailer {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [self setupPropertiesforMailer:mailer];
    return mailer;
}
- (void)setupPropertiesforMailer:(MFMailComposeViewController *)mailer {
    mailer.mailComposeDelegate = self;
    [self setupSubjectForMailer:mailer];
    [self setupAttachmentForMailer:mailer];
}

- (void)setupSubjectForMailer:(MFMailComposeViewController *)mailer {
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleName"];
    
    NSString *subject = [NSString stringWithFormat:@"%@ Data", prodName];
    [mailer setSubject:subject];
}
- (void)setupAttachmentForMailer:(MFMailComposeViewController *)mailer {
    NSData *data = [FileHelper dataForFilename:FILENAME];
    [mailer addAttachmentData:data mimeType:@"text/csv" fileName:FILENAME];
}


#pragma mark - MFMailComposerViewController Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)deleteDataButtonPress:(id)sender {
    [self showFirstDeleteConfirmation];
}
- (void)showFirstDeleteConfirmation {
    self.firstDeleteConfirmation = [[UIAlertView alloc] initWithTitle:@"Confirm Delete" message:@"This will delete all data and cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [self.firstDeleteConfirmation show];
}
- (void)showSecondDeleteConfirmation {
    self.secondDeleteConfirmation = [[UIAlertView alloc] initWithTitle:@"Are You 100% Sure?" message:@"There will be absolutely no way to get your data back. If you haven't already done so, we suggest emailing the data to yourself to serve as a backup before deleting your data." delegate:self cancelButtonTitle:@"No, Cancel" otherButtonTitles:@"Yes, Delete", nil];
    [self.secondDeleteConfirmation show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([alertView isEqual:self.firstDeleteConfirmation]) {
            [self showSecondDeleteConfirmation];
        } else if ([alertView isEqual:self.secondDeleteConfirmation]) {
            [Model resetStore];
            [self setupViewValues];
        }
    }
}




@end
