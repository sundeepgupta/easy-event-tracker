//
//  TransactionDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "TransactionDetailVC.h"
#import "TDDatePickerController.h"
#import "Helper.h"
#import "NSDate+Helpers.h"
#import "Transaction.h"
#import "TransactionHelper.h"
#import "UITableView+Helpers.h"


@interface TransactionDetailVC ()

@property (strong, nonatomic) TDDatePickerController* datePickerController;

@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UITextField *amountValue;


@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;

@end

@implementation TransactionDetailVC

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
    self.title = @"Add Funds";
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
    [self setupDateValue];
    [self setupAmountValue];
}
- (void)setupDateValue {
    NSDate *date = [NSDate date];
    NSString *dateString = [date dateString];
    self.dateValue.text = dateString;
}
- (void)setupAmountValue {
    
}


#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [Helper isValidReplacementString:string forAmountFieldString:textField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.transaction.amount = [Helper amountNumberForTextFieldAmountString:textField.text];
    self.amountValue.text = [Helper stringForAmountNumber:self.transaction.amount];
    [self saveTransaction];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.dateCell]) {
        [Helper presentDatePickerInVc:self withDateMode:YES];
    }
}

#pragma mark - Date Picker Delegates
-(void)datePickerSetDate:(TDDatePickerController*)viewController {
    NSDate *date = viewController.datePicker.date;
    self.transaction.date = date;
    [self saveTransaction];
    self.dateValue.text =  [date dateString];
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

- (void)saveTransaction {
    [Model saveContext];
}

#pragma mark - IB Actions
- (IBAction)cancelButtonPress:(id)sender {
    [self deleteTransaction];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)deleteTransaction {
    [Model deleteObject:self.transaction];
    self.transaction = nil;
}


- (IBAction)doneButtonPress:(id)sender {
    [self saveTransaction];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
