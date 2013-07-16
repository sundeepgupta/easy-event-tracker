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


@interface ParticipantDetailVC ()

@property (strong, nonatomic) Model *model;

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


- (IBAction)doneButtonPress:(UIBarButtonItem *)sender {
    [self processNewCustomer];
}

- (void)processNewCustomer {
    if ([self fieldsAreValid]) {
        [self saveParticipant];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self handleInvalidFields];
    }
}

- (BOOL)fieldsAreValid {
    
}

- (void)handleInvalidFields {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name is required." message:@"Please enter a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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

- (IBAction)addMoneyButtonPress:(id)sender {
}

- (IBAction)textButtonPress:(id)sender {
}

- (IBAction)emailButtonPress:(id)sender {
}

- (IBAction)callButtonPress:(id)sender {
}




@end
