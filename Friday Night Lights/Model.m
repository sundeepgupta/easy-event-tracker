//
//  Model.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "Model.h"
#import "Participant.h"
#import "Event.h"

@implementation Model

- (Participant *)newParticipant {
    NSString *entityName = NSStringFromClass([Participant class]);
    return (Participant *)[self newObjectWithEntityName:entityName];
}

- (Event *)newEvent {
    NSString *entityName = NSStringFromClass([Event class]);
    return (Event *)[self newObjectWithEntityName:entityName];
}

- (NSManagedObject *)newObjectWithEntityName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}


- (NSArray *)Participants {
    NSString *entityName = NSStringFromClass([Participant class]);
    return [self objectsWithEntityName:entityName];
}

- (NSArray *)objectsWithEntityName:(NSString *)entityName {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityDescription:entityDescription];
    return [self resultsFromExecutedFetchRequest:fetchRequest];
}

- (NSFetchRequest *)fetchRequestWithEntityDescription:(NSEntityDescription *)entityDescription {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    return fetchRequest;
}

- (NSArray *)resultsFromExecutedFetchRequest:(NSFetchRequest *)fetchRequest {
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!results) {
        NSLog(@"error fetching: %@", error.localizedDescription);
    }
    return results;
}



- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}













@end
