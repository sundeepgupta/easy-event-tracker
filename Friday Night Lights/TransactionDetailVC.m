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
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [EventHelper saveCostString:textField.text toEvent:self.event];
//
//    [EventHelper setupCostValueForTextField:self.costValue forEvent:self.event];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (IBAction)cancelButtonPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPress:(id)sender {
    
    [Model saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveTransaction {
    
}


@end
