//
//  gsDataBaseManager.h
//  GSTicket
//
//  Created by Charles Cliff on 1/9/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface g5PersistenceManager : NSObject

+ (g5PersistenceManager *)sharedManager;

- (void)saveDictionary:(NSDictionary *)dictionary withID:(NSString *)dictionaryID;
- (NSDictionary *)loadDictionaryWithID:(NSString *)dictionaryID;

- (void)deleteDatabase;
- (void)deleteInventoryDatabase;

@end
