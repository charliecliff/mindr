//
//  gsDataBaseManager.m
//  GSTicket
//
//  Created by Charles Cliff on 1/9/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5PersistenceManager.h"
#import <CouchbaseLite/CouchbaseLite.h>

#define TICKET_DATABASE_NAME @"tickets"
#define PROFILE_DATABASE_NAME @"profile"
#define PROFILE_MANAGER_SINGLETON_DATABASE_NAME @"profile_manager_singleton"
#define DEFAULT_PROFILE_MANAGER_SINGLETON_DOCUMENT_ID @"I am the world's most awesome string constant!"

#define DEFAULT_CURRENT_AUTH_TUPLE_DOCUMENT @"DEFAULT_CURRENT_AUTH_TUPLE_DOCUMENT"
#define DEFAULT_CURRENT_AUTH_TUPLE_KEY @"auth_tuple"


#define PROFILE_DOCUMENT_KEY_CURRENT_PROFILE_ID @"PROFILE_DOCUMENT_KEY_CURRENT_PROFILE_ID"

// Profile Content Keys
#define PROFILE_DOCUMENT_KEY_CONTACT_INFORMATION @"contact_information"
#define PROFILE_DOCUMENT_KEY_FIRST_NAME @"firstName"
#define PROFILE_DOCUMENT_KEY_LAST_NAME @"lastName"
#define PROFILE_DOCUMENT_KEY_FULL_NAME @"full_name"
#define PROFILE_DOCUMENT_KEY_MAIL_ADDRESS @"mail"
#define PROFILE_DOCUMENT_KEY_PHONE @"phone"
#define PROFILE_DOCUMENT_KEY_PASSWORD @"password"

#define PROFILE_DOCUMENT_KEY_AUTH_TUPLE @"authtuple"
#define PROFILE_DOCUMENT_KEY_UID @"uid"
#define PROFILE_DOCUMENT_KEY_SID @"sid"
#define PROFILE_DOCUMENT_KEY_APPID @"app_id"
#define PROFILE_DOCUMENT_KEY_MOBILE_PHONE_NUMBER @"mobilenumber"

#define PROFILE_DOCUMENT_KEY_BILLING_PROFILES @"billing_profiles"

// Profile Manager Content Keys
#define PROFILE_MANAGER_DOCUMENT_KEY_CURRENT_UID @"current_uid"
#define PROFILE_MANAGER_DOCUMENT_KEY_AVAILABLE_UIDS @"available_uids"

@interface g5PersistenceManager ()

@property (nonatomic, strong) CBLManager *localDatabaseManager;
@property (nonatomic, strong) CBLDatabase *ticketDatabase;
@property (nonatomic, strong) CBLDatabase *profileDatabase;

@property (nonatomic, strong) NSString *profileManagerDocumentID;
@property (nonatomic, strong) NSDictionary *documentIDsIndexedByProfileUID;

@end

@implementation g5PersistenceManager

#pragma mark - Singleton

+ (g5PersistenceManager *)sharedManager {
    static g5PersistenceManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Init

- (g5PersistenceManager *)init {
    self = [super init];
    if (self != nil) {
        NSError *error;
        self.localDatabaseManager = [CBLManager sharedInstance];
        if (!self.localDatabaseManager) {
            NSLog(@"Cannot create shared instance of CBLManager");
            return nil;
        }
        
        self.ticketDatabase = [self.localDatabaseManager databaseNamed:TICKET_DATABASE_NAME error:&error];
        if (!self.ticketDatabase) {
            NSLog(@"Cannot create ticket database. Error message: %@", error.localizedDescription);
            return nil;
        }
        
        [self configureDatabaseForProfileData];
    }
    return self;
}

- (void)configureDatabaseForProfileData {
    NSError *error;
    self.profileDatabase = [self.localDatabaseManager databaseNamed:PROFILE_DATABASE_NAME error:&error];
    if (!self.profileDatabase) {
        NSLog(@"Cannot create profile database. Error message: %@", error.localizedDescription);
        return;
    }

    if ([self.profileDatabase existingDocumentWithID:DEFAULT_PROFILE_MANAGER_SINGLETON_DOCUMENT_ID] == nil) {
        [self configureFirstRevisionOfProfileManagerDocument];
    }
}

- (void)configureFirstRevisionOfProfileManagerDocument {

    CBLDocument* newProfileManagerSingletonDocument = [self.profileDatabase documentWithID:DEFAULT_PROFILE_MANAGER_SINGLETON_DOCUMENT_ID];
    
    NSError *error;
    NSDictionary *placeholderData = @{PROFILE_MANAGER_DOCUMENT_KEY_CURRENT_UID:@"0"};
    CBLRevision *newRevision = [newProfileManagerSingletonDocument putProperties:placeholderData error:&error];
    if (!newRevision) {
        NSLog(@"Cannot update document. Error message: %@", error.localizedDescription);
    }
}

#pragma mark - Generic Saving

- (void)saveDictionary:(NSDictionary *)dictionary withID:(NSString *)dictionaryID {
    CBLDocument* document = [self.profileDatabase documentWithID:dictionaryID];
    NSString *documentRevisionID = document.currentRevision.revisionID;
    NSMutableDictionary *dictionaryContainingRevisionID = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if (documentRevisionID != nil) {
        [dictionaryContainingRevisionID setObject:documentRevisionID forKey:@"_rev"];
    }
    
    NSError* error;
    CBLSavedRevision *newRevision = [document putProperties:dictionaryContainingRevisionID error:&error];
    if (!newRevision) {
        NSLog(@"Cannot update document. Error message: %@", error.localizedDescription);
    }
}

- (NSDictionary *)loadDictionaryWithID:(NSString *)dictionaryID {
    CBLDocument* document = [self.profileDatabase documentWithID:dictionaryID];
    NSMutableDictionary *dictionary = [document.properties mutableCopy];
    if (!dictionary) {
        NSLog(@"Cannot load document.");
    }
    return dictionary;
}

- (void)deleteDatabase {
    [self.localDatabaseManager backgroundTellDatabaseNamed:self.ticketDatabase.name
                                                        to:^(CBLDatabase *db) {
                                                            NSError *error;
                                                            if (![db deleteDatabase:&error]) {
                                                                NSLog(@"%@", error.localizedDescription);
                                                            }
                                                        }];
    
    [self.localDatabaseManager backgroundTellDatabaseNamed:self.profileDatabase.name
                                                        to:^(CBLDatabase *db) {
                                                            NSError *error;
                                                            if (![db deleteDatabase:&error]) {
                                                                NSLog(@"%@", error.localizedDescription);
                                                            }
                                                        }];
}

- (void)deleteInventoryDatabase {
    [self.localDatabaseManager backgroundTellDatabaseNamed:self.ticketDatabase.name
                                                        to:^(CBLDatabase *db) {
                                                            NSError *error;
                                                            if (![db deleteDatabase:&error]) {
                                                                NSLog(@"%@", error.localizedDescription);
                                                            }
                                                        }];
}

@end
