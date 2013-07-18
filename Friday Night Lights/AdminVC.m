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

@interface AdminVC ()

@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;


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


@end