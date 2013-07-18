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
#import "Transaction.h"
#import "AppDelegate.h"

@interface Model()

//@property (strong, nonatomic) NSPersistentStoreCoordinator *storeCoordinator;
//@property (strong, nonatomic) NSPersistentStore *store;
//@property (strong, nonatomic) NSURL *storeUrl;

@end

@implementation Model

#pragma mark - Events
+ (Event *)newEvent {
    NSString *entityName = NSStringFromClass([Event class]);
    Event *event = (Event *)[self newObjectWithEntityName:entityName];
    event.date = [NSDate date];
    return event;
}


+ (NSArray *)events {
    NSString *entityName = NSStringFromClass([Event class]);
    NSArray *objects = [self objectsWithEntityName:entityName];
    
    NSArray *sortedObjects = [self objectsSortedByDate:objects];
    
    return sortedObjects;
}
+ (NSArray *)confirmedParticipantsForEvent:(Event *)event {
    NSArray *objects = event.participants.allObjects;
    return objects;
}
+ (NSArray *)unconfirmedParticipantsForEvent:(Event *)event {
    NSArray *confirmedParticipants = [self confirmedParticipantsForEvent:event];
    NSArray *allParticipants = [self participants];
    
    NSMutableArray *unconfirmedParticipants = [[NSMutableArray alloc] init];
    
    for (Participant *participant in allParticipants) {
        BOOL isConfirmed = NO;
        for (Participant *confirmedParticipant in confirmedParticipants) {
            if ([participant isEqual:confirmedParticipant]) {
                isConfirmed = YES;
            }
        }
        
        if (!isConfirmed) {
            [unconfirmedParticipants addObject:participant];
        }
    }
    
    return unconfirmedParticipants;
}
+ (NSInteger)numberOfConfirmedParticipantsForEvent:(Event *)event {
    NSArray *objects = [self confirmedParticipantsForEvent:event];
    return objects.count;
}


+ (void)addParticipant:(Participant *)participant toEvent:(Event *)event {
    [event addParticipantsObject:participant];
}
+ (void)deleteParticipant:(Participant *)participant fromEvent:(Event *)event {
    [event removeParticipantsObject:participant];
}



#pragma mark - Participants
+ (Participant *)newParticipant {
    NSString *entityName = NSStringFromClass([Participant class]);
    return (Participant *)[self newObjectWithEntityName:entityName];
}


+ (NSArray *)participants {
    NSString *entityName = NSStringFromClass([Participant class]);
    NSArray *objects = [self objectsWithEntityName:entityName];
    
    NSArray *sortDescriptors = [self descriptorsFromKey:@"name" isAscending:YES];
    NSArray *sortedObjects = [self sortedObjects:objects withSortDescriptors:sortDescriptors];

    return sortedObjects;
}
+ (NSArray *)confirmedEventsForParticipant:(Participant *)participant {
    NSArray *objects = participant.events.allObjects;
    NSArray *sortedObjects = [self objectsSortedByDate:objects];
    return sortedObjects;
}
+ (NSInteger)numberOfConfirmedEventsForParticipant:(Participant *)participant {
    NSArray *objects = [self confirmedEventsForParticipant:participant];
    return objects.count;
}
+ (NSArray *)participantsWithAttributeValue:(NSString *)value forKey:(NSString *)key {
    NSString *entityName = NSStringFromClass([Participant class]);
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:entityName];
    
    NSPredicate *predicate = [self predicateWithAttributeValue:value forKey:key];
    
    fetchRequest.predicate = predicate;
    
    return [self objectsFromExecutedFetchRequest:fetchRequest];
}
+ (NSArray *)participantAbRecordIds {
    NSString *entityName = NSStringFromClass([Participant class]);
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:entityName];
    NSArray *properties = @[@"abRecordId"];
    fetchRequest.propertiesToFetch = properties;
    return [self objectsFromExecutedFetchRequest:fetchRequest];
}


#pragma mark - Transactions
+ (Transaction *)newTransactionForParticipant:(Participant *)participant {
    Transaction *transaction = [self newTransaction];
    transaction.participant = participant;
    return transaction;
}
+ (Transaction *)newTransaction {
    NSString *entityName = NSStringFromClass([Transaction class]);
    Transaction *object = (Transaction *)[self newObjectWithEntityName:entityName];
    object.date = [NSDate date];
    return object;
}


+ (NSArray *)transactions {
    NSString *entityName = NSStringFromClass([Transaction class]);
    NSArray *objects = [self objectsWithEntityName:entityName];    
    return objects;
}

+ (NSArray *)transactionsForParticipant:(Participant *)participant {
    NSArray *objects = participant.transactions.allObjects;
    NSArray *sortedObjects = [self objectsSortedByDate:objects];
    return sortedObjects;
}

#pragma mark - Private Methods
+ (NSManagedObject *)newObjectWithEntityName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[self moc]];
}

+ (NSArray *)objectsWithEntityName:(NSString *)entityName {
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntityName:entityName];
    return [self objectsFromExecutedFetchRequest:fetchRequest];
}

+ (NSFetchRequest *)fetchRequestWithEntityName:(NSString *)entityName {
    NSEntityDescription *entityDescription = [self entityDescriptionWithEntityName:entityName];
    return [self fetchRequestWithEntityDescription:entityDescription];
}

+ (NSEntityDescription *)entityDescriptionWithEntityName:(NSString *)entityName {
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:[self moc]];
}

+ (NSFetchRequest *)fetchRequestWithEntityDescription:(NSEntityDescription *)entityDescription {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    return fetchRequest;
}

+ (NSArray *)objectsFromExecutedFetchRequest:(NSFetchRequest *)fetchRequest {
    NSError *error = nil;
    NSArray *results = [[self moc] executeFetchRequest:fetchRequest error:&error];
    
    if (!results) {
        NSLog(@"error fetching: %@", error.localizedDescription);
    }
    return results;
}

+ (NSArray *)descriptorsFromKey:(NSString *)key isAscending:(BOOL)isAscending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];
    return [NSArray arrayWithObject:sortDescriptor];
}
+ (NSArray *)sortedObjects:(NSArray *)objects withSortDescriptors:(NSArray *)sortDescriptors {
    NSMutableArray *mutableObjects = objects.mutableCopy;
    return [mutableObjects sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSPredicate *)predicateWithAttributeValue:(NSString *)value forKey:(NSString *)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == %@", key, value];
    return predicate;
}

+ (NSArray *)objectsSortedByDate:(NSArray *)objects {
    NSArray *sortDescriptors = [self descriptorsFromKey:@"date" isAscending:NO];
    NSArray *sortedObjects = [self sortedObjects:objects withSortDescriptors:sortDescriptors];
    return sortedObjects;
}



#pragma mark - Core Data
+ (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self moc];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+ (void)deleteObject:(NSManagedObject *)object {
    NSError *error;
    [[self moc] deleteObject:object];
    if (![[self moc] save:&error]) {
        NSLog(@"Error deleting object: %@", [error localizedDescription]);
    }
    [self saveContext];
}

+ (void)resetStore {
    //FROM http://stackoverflow.com/questions/1077810/delete-reset-all-entries-in-core-data Note it does not delete external storage files.
    
    [self lockMoc];

    NSPersistentStoreCoordinator *storeCoordinator = [self storeCoordinator];
    NSPersistentStore *store = storeCoordinator.persistentStores.lastObject;
    NSURL *storeUrl = store.URL;
    
    [self deleteStore];
    [self addStoreWithUrl:storeUrl];
    
    [self unlockMoc];
}
+ (void)lockMoc {
    NSManagedObjectContext *moc = [self moc];
    [moc lock];
    [moc reset];
}
+ (void)unlockMoc {
    NSManagedObjectContext *moc = [self moc];
    [moc unlock];
}
+ (void)deleteStore {
    NSPersistentStoreCoordinator *storeCoordinator = [self storeCoordinator];
    NSPersistentStore *store = storeCoordinator.persistentStores.lastObject;
    NSError *error = nil;
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:store.URL error:&error];
}
+ (void)addStoreWithUrl:(NSURL *)storeUrl {
    NSPersistentStoreCoordinator *storeCoordinator = [self storeCoordinator];
    NSError *error = nil;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
}

+ (NSManagedObjectContext *)moc {
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appDelegate = (AppDelegate *)app.delegate;
    return appDelegate.managedObjectContext;
}
+ (NSPersistentStoreCoordinator *)storeCoordinator {
    NSManagedObjectContext *moc = [self moc];
    return moc.persistentStoreCoordinator;
}




@end
