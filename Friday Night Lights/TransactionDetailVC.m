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
@property (strong, nonatomic) IBOutlet UITextView *noteValue;


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
    [self setupTitle];
    [self setupBarButtons];
    [self setupViewValues];
    [DesignHelper customizeCells:self.cells];
}
- (void)setupTitle {
    if (self.isNewMode) {
        self.title = @"Add Transaction";
    } else {
        self.title = @"Edit Transaction";
    }
}
- (void)setupBarButtons {
    [self setupLeftBarButton];
    [self setupRightBarButton];
}
- (void)setupLeftBarButton {
    if (self.isNewMode) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPress)];
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
    }
}
- (void)setupRightBarButton {
    if (!self.isNewMode) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


- (void)setupViewValues {
    [self setupDateValue];
    [self setupAmountValue];
    [self setupNoteValue];
}
- (void)setupDateValue {
    NSDate *date;
    if (self.isNewMode) {
        date = [NSDate date];
    } else {
        date = self.transaction.date;
    }
    self.dateValue.text =  [date dateString];
}
- (void)setupAmountValue {
    if (!self.isNewMode) {
        self.amountValue.text = [Helper formattedStringForAmountNumber:self.transaction.amount];
    }
}
- (void)setupNoteValue {
    self.noteValue.text = self.transaction.note;
}


#pragma mark - TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = [Helper unformattedStringForFormattedAmountString:textField.text];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [Helper isValidReplacementString:string forAmountFieldString:textField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.amountValue.text = [Helper formattedStringForUnformattedAmountString:textField.text];
    self.transaction.amount = [Helper numberForFormattedAmountString:textField.text];
    [self saveTransaction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - TextView Delegates 
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.transaction.note = textView.text;
    [self saveTransaction];
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
    self.dateValue.text =  [date dateString];
    [self saveTransaction];
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


#pragma mark - IB Actions
- (void)cancelButtonPress {
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

- (void)saveTransaction {
    [Model saveContext];
}



-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endEditing];
}

- (void)endEditing {
    [self.view.window endEditing: YES];
}

@end
