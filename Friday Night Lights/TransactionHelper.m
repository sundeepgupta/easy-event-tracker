//
//  TransactionHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TransactionHelper.h"
#import "Participant.h"
#import "TransactionDetailVC.h"

@implementation TransactionHelper



+ (void)presentTransactionDetailVcForVc:(UIViewController *)vc withParticipant:(Participant *)participant {
    UINavigationController *nc = [vc.storyboard instantiateViewControllerWithIdentifier:@"ParticipantTransactionNC"];
    TransactionDetailVC *transactionDetailVc = (TransactionDetailVC *)nc.topViewController;
    [self setupTransactionDetailVc:transactionDetailVc withParticipant:participant];
    [vc presentViewController:nc animated:YES completion:nil];
}
+ (void)setupTransactionDetailVc:(TransactionDetailVC *)vc withParticipant:(Participant *)participant {
    vc.participant = participant;
    Transaction *transaction = [Model newTransactionForParticipant:participant];
    vc.transaction = transaction;
}












@end
