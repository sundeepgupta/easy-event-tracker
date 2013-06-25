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

@interface Model()

@property (strong, nonatomic) NSPersistentStoreCoordinator *storeCoordinator;
@property (strong, nonatomic) NSPersistentStore *store;
@property (strong, nonatomic) NSURL *storeUrl;

@end

@implementation Model

#pragma mark - Create
- (Participant *)newParticipant {
    NSString *entityName = NSStringFromClass([Participant class]);
    return (Participant *)[self newObjectWithEntityName:entityName];
}

- (Event *)newEvent {
    NSString *entityName = NSStringFromClass([Event class]);
    Event *event = (Event *)[self newObjectWithEntityName:entityName];
    event.date = [NSDate date];
    return event;
}

- (NSManagedObject *)newObjectWithEntityName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}


#pragma mark - Read
- (NSArray *)participants {
    NSString *entityName = NSStringFromClass([Participant class]);
    NSArray *objects = [self objectsWithEntityName:entityName];
        
    return objects;
}

- (NSArray *)events {
    NSString *entityName = NSStringFromClass([Event class]);
    NSArray *objects = [self objectsWithEntityName:entityName];
    
    NSArray *sortDescriptors = [self descriptorsFromKey:@"date" isAscending:NO];
    NSArray *sortedObjects = [self sortedObjects:objects withSortDescriptors:sortDescriptors];
    
    return sortedObjects;
}

- (NSArray *)objectsWithEntityName:(NSString *)entityName {
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:entityName];
    return [self objectsFromExecutedFetchRequest:fetchRequest];
}

- (NSFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName {
    NSEntityDescription *entityDescription = [self entityDescriptionWithEntityName:entityName];
    return [self fetchRequestWithEntityDescription:entityDescription];
}

- (NSEntityDescription *)entityDescriptionWithEntityName:(NSString *)entityName {
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

- (NSFetchRequest *)fetchRequestWithEntityDescription:(NSEntityDescription *)entityDescription {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    return fetchRequest;
}

- (NSArray *)objectsFromExecutedFetchRequest:(NSFetchRequest *)fetchRequest {
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!results) {
        NSLog(@"error fetching: %@", error.localizedDescription);
    }
    return results;
}

- (NSArray *)descriptorsFromKey:(NSString *)key isAscending:(BOOL)isAscending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];
    return [NSArray arrayWithObject:sortDescriptor];
}
- (NSArray *)sortedObjects:(NSArray *)objects withSortDescriptors:(NSArray *)sortDescriptors {
    NSMutableArray *mutableObjects = objects.mutableCopy;
    return [mutableObjects sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray *)participantsWithAttributeValue:(NSString *)value forKey:(NSString *)key {
    NSString *entityName = NSStringFromClass([Participant class]);
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:entityName];
    
    NSPredicate *predicate = [self predicateWithAttributeValue:value forKey:key];
    
    fetchRequest.predicate = predicate;
    
    return [self objectsFromExecutedFetchRequest:fetchRequest];
}

- (NSPredicate *)predicateWithAttributeValue:(NSString *)value forKey:(NSString *)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == %@", key, value];
    return predicate;
}

- (NSArray *)participantAbRecordIds {
    NSString *entityName = NSStringFromClass([Participant class]);
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:entityName];
    NSArray *properties = @[@"abRecordId"];
    fetchRequest.propertiesToFetch = properties;
    return [self objectsFromExecutedFetchRequest:fetchRequest];
}


#pragma mark - Update
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



#pragma mark - Delete
- (void)deleteObject:(NSManagedObject *)object {
    NSError *error;
    [self.managedObjectContext deleteObject:object];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error deleting object: %@", [error localizedDescription]);
    }
    [self saveContext];
}



- (void)resetStore {
    //FROM http://stackoverflow.com/questions/1077810/delete-reset-all-entries-in-core-data Note it does not delete external storage files.
    
    [self.managedObjectContext lock];
    [self.managedObjectContext reset]; 

    [self setupStoreDetails];
    [self deleteStore];
    [self addStore];
    
    [self.managedObjectContext unlock];
}
     
- (void)setupStoreDetails {
    self.storeCoordinator = self.managedObjectContext.persistentStoreCoordinator;
    self.store = self.storeCoordinator.persistentStores.lastObject;
    self.storeUrl = self.store.URL;
}

- (void)deleteStore {
    NSError *error = nil;
    [self.storeCoordinator removePersistentStore:self.store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:self.storeUrl error:&error];
}

- (void)addStore {
    NSError *error = nil;
    [self.storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeUrl options:nil error:&error];
}







@end
