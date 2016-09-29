#import "g5ReminderManager.h"
#import "g5PersistenceManager.h"
#import "MDRUserManager.h"
#import "MDRReminderClient.h"

#define REMINDERS @"REMINDERS"

@interface g5ReminderManager ()

@property(nonatomic, readwrite) BOOL didLoadReminders;
@property(nonatomic, strong, readwrite) NSMutableOrderedSet *reminderIDs;
@property(nonatomic, strong, readwrite) NSMutableDictionary *reminders;

@end

@implementation g5ReminderManager

#pragma mark - Singleton

+ (g5ReminderManager *)sharedManager {
    static g5ReminderManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Init

- (g5ReminderManager *)init {
    self = [super init];
    if (self != nil) {
        [self loadReminders];
    }
    return self;
}

#pragma mark - Getters

- (MDRReminder *)newReminder {
    MDRReminder *newReminder = [[MDRReminder alloc] init];
    return newReminder;
}

- (void)addReminder:(MDRReminder *)reminder {
  
  NSDictionary *reminderDict = [reminder encodeToDictionary];
  NSString *userID = [MDRUserManager sharedManager].currentUserContext.userID;

  __weak __typeof(self)weakSelf = self;
  [MDRReminderClient postReminder:reminderDict
                       withUserID:userID
                      withSuccess:^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf updateReminders];
                      }
                      withFailure:^{
                        
                      }];
}

- (void)removeReminder:(MDRReminder *)reminder {
  
  [self.reminderIDs removeObject:reminder.uid];
  [self.reminders removeObjectForKey:reminder.uid];
  self.didLoadReminders = YES;
}

- (MDRReminder *)reminderForIndex:(NSInteger)index {
  
    NSString *reminderID = [self.reminderIDs objectAtIndex:index];
    return [self reminderForID:reminderID];
}

- (MDRReminder *)reminderForID:(NSString *)reminderID {
  
    return [self.reminders objectForKey:reminderID];
}

#pragma mark - API Calls

- (void)updateReminders {
  NSString *userID = [MDRUserManager sharedManager].currentUserContext.userID;
  if (userID == nil) {
    return;
  }
  
  __weak __typeof(self)weakSelf = self;
  [MDRReminderClient getRemindersWithUserID:userID
                                withSuccess:^(NSArray *reminders)
  {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf updateRemindersFromJSONArray:reminders];
  }
                                withFailure:^
  {
    
  }];
}

- (void)updateRemindersFromJSONArray:(NSArray *)array {
  
  self.didLoadReminders = NO;
  self.reminders   = [[NSMutableDictionary alloc] init];
  self.reminderIDs = [[NSMutableOrderedSet alloc] init];
  for (NSDictionary *reminderDict in array) {
    MDRReminder *newReminder = [[MDRReminder alloc] initWithDictionary:reminderDict];
    [self.reminders setObject:newReminder forKey:newReminder.uid];
    [self.reminderIDs addObject:newReminder.uid];
  }
  [self saveReminders];
  self.didLoadReminders = YES;
}

#pragma mark - Persistence

- (void)saveReminders {
    
    NSMutableArray *arrayOfReminderDictionaries = [[NSMutableArray alloc] init];
    for (NSString *currentReminderID in self.reminderIDs) {
        MDRReminder *currentReminder = [self.reminders objectForKey:currentReminderID];
        NSDictionary *currentReminderDictionary = [currentReminder encodeToDictionary];
        [arrayOfReminderDictionaries addObject:currentReminderDictionary];
    }
    
    NSDictionary *dictionaryToPersist = @{@"reminders":arrayOfReminderDictionaries};
    [[g5PersistenceManager sharedManager] saveDictionary:dictionaryToPersist withID:REMINDERS];
}

- (void)loadReminders {
    
    self.reminderIDs = [[NSMutableOrderedSet alloc] init];
    self.reminders   = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dictionaryToLoad = [[g5PersistenceManager sharedManager] loadDictionaryWithID:REMINDERS];
    NSArray *arrayOfReminderDictionaries = [dictionaryToLoad objectForKey:@"reminders"];
    
    for (NSDictionary *currentReminderDictionary in arrayOfReminderDictionaries) {
        MDRReminder *currentReminder = [[MDRReminder alloc] initWithDictionary:currentReminderDictionary];
        [self.reminders setObject:currentReminder forKey:currentReminder.uid];
        [self.reminderIDs addObject:currentReminder.uid];
    }
}

@end
