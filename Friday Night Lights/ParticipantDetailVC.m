//
//  ParticipantDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ParticipantDetailVC.h"
#import "Participant.h"
#import "ConfirmedEventsVC.h"
#import "ParticipantHelper.h"
#import "MessageHelper.h"
#import "UIAlertView+Helpers.h"
#import "TransactionDetailVC.h"
#import "Transaction.h"

@interface ParticipantDetailVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) MFMessageComposeViewController *messageComposeVc;

@property (strong, nonatomic) IBOutlet UITextField *balanceValue;
@property (strong, nonatomic) IBOutlet UILabel *confirmedEventsValue;
@property (strong, nonatomic) IBOutlet UITableViewCell *confirmedEventsCell;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;

@end

@implementation ParticipantDetailVC

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
    [self customizeDesign];
    self.title = [ParticipantHelper nameForParticipant:self.participant];
}
- (void)customizeDesign {
    [DesignHelper addBackgroundToView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupViewValues];
    [DesignHelper customizeCells:self.cells];
}

- (void)setupViewValues {
    [self setupNumberOfEventsValue];

}
- (void)setupNumberOfEventsValue {
    NSInteger number = [Model numberOfConfirmedEventsForParticipant:self.participant];
    self.confirmedEventsValue.text = [NSString stringWithFormat:@"%d", number];
}



-(void) viewWillDisappear:(BOOL)animated {
//http://stackoverflow.com/questions/1214965/setting-action-for-back-button-in-navigation-controller/3445994#3445994
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer in the navigation stack.
        
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.confirmedEventsCell]) {
        NSString *vcId = NSStringFromClass([ConfirmedEventsVC class]);
        ConfirmedEventsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
        vc.participant = self.participant;
        [self.navigationController pushViewController:vc animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)saveParticipant {
    self.participant = [Model newParticipant];
//    self.participant.name = self.nameField.text;
    [Model saveContext];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)transactionButtonPress:(id)sender {
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"ParticipantTransactionNC"];
    TransactionDetailVC *vc = (TransactionDetailVC *)nc.topViewController;
    [self setupTransactionDetailVc:vc];
    [self presentViewController:nc animated:YES completion:nil];
}
- (void)setupTransactionDetailVc:(TransactionDetailVC *)vc {
    vc.participant = self.participant;
    Transaction *transaction = [Model newTransaction];
    vc.transaction = transaction;
}


- (IBAction)textButtonPress:(id)sender {
    [self sendMessage];
}

- (IBAction)callButtonPress:(id)sender {
    [self call];
}

- (void)sendMessage {
    if([MFMessageComposeViewController canSendText]) {
        [self setupMessageComposeVc];
        [self setupMessageParticipants];
        [self presentViewController:self.messageComposeVc animated:YES completion:nil];
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}
- (void)setupMessageComposeVc {
    self.messageComposeVc = [[MFMessageComposeViewController alloc] init];
    self.messageComposeVc.messageComposeDelegate = self;
}
- (void)setupMessageParticipants {
    NSArray *participants = @[self.participant];
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

- (void)call {
    NSURL *url = [ParticipantHelper phoneUrlForParticipant:self.participant];
    [[UIApplication sharedApplication] openURL:url];
}


@end