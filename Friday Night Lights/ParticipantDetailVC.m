//
//  ParticipantDetailVC.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "ParticipantDetailVC.h"
#import "Participant.h"
#import "Model.h"

@interface ParticipantDetailVC ()

@property (strong, nonatomic) Model *model;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

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
    Global *global = [Global sharedGlobal];
    self.model = global.model;
    
    self.title = @"New Player";
}

- (void)viewWillAppear:(BOOL)animated {

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
    self.participant.name = self.nameField.text;
    [self.model saveContext];
}

- (void)viewDidUnload {
    [self setNameField:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}
@end
