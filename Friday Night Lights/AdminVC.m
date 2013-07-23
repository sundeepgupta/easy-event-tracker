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

#define FILENAME @"FNL_Report.csv"

@interface AdminVC ()
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;
@property (strong, nonatomic) CsvApi *csvApi;

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
    [self setupMessageComposeVc];
    [self presentViewController:self.messageComposeVc animated:YES completion:nil];
}
- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    [self setupMessageComposeRecipients];
    self.messageComposeVc.messageComposeDelegate = self;
}
- (void)setupMessageComposeRecipients {
    NSArray *participants = [Model participants];
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
    NSArray *events = [Model events];
    for (Event *event in events) {
        [self.csvApi writeEvent:event];
    }
    
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
//    [self setupRecipientsForMailer:mailer];
    [self setupSubjectForMailer:mailer];
    [self setupAttachmentForMailer:mailer];
}

//- (void)setupRecipientsForMailer:(MFMailComposeViewController *)mailer
//{
//    [self setupToRecipientsForMailer:mailer];
//}

//- (void)setupToRecipientsForMailer:(MFMailComposeViewController *)mailer
//{
//    NSMutableArray *emailStrings = [[NSMutableArray alloc] init];
//    for (SCEmail *email in self.order.customer.emailList.allObjects) {
//        [emailStrings addObject:email.address];
//    }
//    [mailer setToRecipients:emailStrings];
//}

- (void)setupSubjectForMailer:(MFMailComposeViewController *)mailer {
    NSString *subject = @"Friday Night Lights Data";
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
    [self reqeustDeleteConfirmation];
}
- (void)reqeustDeleteConfirmation {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete" message:@"This will delete all data and cannot be undone." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        [Model resetStore];
    }
}




@end
