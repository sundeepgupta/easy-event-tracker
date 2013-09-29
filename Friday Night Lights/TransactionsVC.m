//
//  TransactionsVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-17.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TransactionsVC.h"
#import "Participant.h"
#import "TransactionsCell.h"
#import "NSDate+Helpers.h"
#import "Transaction.h"
#import "Helper.h"
#import "TransactionDetailVC.h"
#import "TransactionHelper.h"

@interface TransactionsVC ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation TransactionsVC

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
    self.title = @"Transactions";
    [TransactionsCell setupReuseIdForTableView:self.tableView];
    [DesignHelper customizeTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
    [self.tableView reloadData];
}
- (void)setupDataSource {
    self.dataSource = [Model transactionsForParticipant:self.participant];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TransactionsCell class])];
    
    Transaction *object = self.dataSource[indexPath.row];
    
    cell.dateValue.text = [object.date dateString];
    cell.amountValue.text = [Helper formattedStringForAmountNumber:object.amount];
    
    [DesignHelper customizeCell:cell];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *object = self.dataSource[indexPath.row];
        [Model deleteObject:object];
        [self setupDataSource];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Transaction *object = self.dataSource[indexPath.row];
    
    NSString *vcId = NSStringFromClass([TransactionDetailVC class]);
    TransactionDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcId];
    vc.transaction = object;
    vc.participant = self.participant;
    vc.isNewMode = NO;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - IB
- (IBAction)addButtonPress:(id)sender {
    [TransactionHelper presentTransactionDetailVcForVc:self withParticipant:self.participant];
}


@end
