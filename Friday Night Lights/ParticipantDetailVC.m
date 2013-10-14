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
#import "TransactionsVC.h"
#import "TransactionHelper.h"


@interface ParticipantDetailVC ()

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) TextMessageManager *textMessageManager;

@property (strong, nonatomic) IBOutlet UITextField *balanceValue;
@property (strong, nonatomic) IBOutlet UILabel *confirmedEventsValue;
@property (strong, nonatomic) IBOutlet UITableViewCell *balanceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *confirmedEventsCell;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *textCells;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *buttonCells;
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
    [DesignHelper removeBorderForGroupedCells:self.buttonCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupViewValues];
    [DesignHelper customizeCells:self.textCells];
}

- (void)setupViewValues {
    [self setupBalanceValue];
    [self setupNumberOfEventsValue];
}
- (void)setupBalanceValue {
    self.balanceValue.text = [ParticipantHelper balanceStringForParticipant:self.participant];
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
        [self pushConfirmedEventsVc];
    } else if ([cell isEqual:self.balanceCell]) {
        [self pushTransactionsVc];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)pushConfirmedEventsVc {
    NSString *vcId = NSStringFromClass([ConfirmedEventsVC class]);
    ConfirmedEventsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    vc.participant = self.participant;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushTransactionsVc {
    NSString *vcId = NSStringFromClass([TransactionsVC class]);
    TransactionsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    vc.participant = self.participant;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - IB Actions
- (IBAction)transactionButtonPress:(id)sender {
    [TransactionHelper presentTransactionDetailVcForVc:self withParticipant:self.participant];
}


- (IBAction)textButtonPress:(id)sender {
    [self sendMessage];
}

- (IBAction)callButtonPress:(id)sender {
    [self call];
}



#pragma mark - Text Messaging
- (void)sendMessage {
    if([MFMessageComposeViewController canSendText]) {
        [self textParticipants];
    } else {
        [MessageHelper showCantSendTextAlert];
    }
}
- (void)textParticipants {
    NSArray *recipients = [self recipientsForTextMessage];
    NSString *body = [self bodyForTextMessage];
    self.textMessageManager = [[TextMessageManager alloc] initWithRecipients:recipients body:body delegate:self];
    [self.textMessageManager sendTextMessage];
}
- (NSArray *)recipientsForTextMessage {
    NSArray *participants = @[self.participant];
    NSArray *recipients = [MessageHelper mobileNumbersFromPartipants:participants];
    return recipients;
}
- (NSString *)bodyForTextMessage {
    NSString *name = self.participant.name;
    NSString *body = [NSString stringWithFormat:@"Dear %@, ", name];
    return body;
}

#pragma mark - TextMessageManager Delegates
- (void)presentMessageComposeVc:(MFMessageComposeViewController *)messageComposeVc {
    [self presentViewController:messageComposeVc animated:YES completion:nil];
}


- (void)call {
    NSURL *url = [ParticipantHelper phoneUrlForParticipant:self.participant];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [UIAlertView showAlertWithTitle:@"Call Error" withMessage:@"It seems that your device cannot make phone calls."];
    }
}


@end