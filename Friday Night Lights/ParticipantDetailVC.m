//
//  ParticipantDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ParticipantDetailVC.h"
#import "Participant.h"


@interface ParticipantDetailVC ()

@property (strong, nonatomic) Model *model;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
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

    for (UITableViewCell *cell in self.cells) {
        [DesignHelper customizeCell:cell];
    }
}
     

- (void)viewWillAppear:(BOOL)animated {
    [self setupView];
    
    
    
    
}

- (void)setupView {
    if (self.participant) {
//        self.nameField.text = self.participant.name;
        self.doneButton.enabled = NO;
    } 
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
    if (self.nameField.text.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)handleInvalidFields {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name is required." message:@"Please enter a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)saveParticipant {
    self.participant = [Model newParticipant];
//    self.participant.name = self.nameField.text;
    [Model saveContext];
}

- (void)viewDidUnload {
    [self setNameField:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}
@end
