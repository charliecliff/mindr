#import "MDRUserManager.h"
#import "MDRLocationManager.h"
#import "MDRUserClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MDRUserManager ()

@property (nonatomic, strong, readwrite) MDRUserContext *currentUserContext;

@end

@implementation MDRUserManager

#pragma mark - Singleton

+ (MDRUserManager *)sharedManager {
    static MDRUserManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Init

- (MDRUserManager *)init {
    self = [super init];
    if (self != nil) {
        self.currentUserContext = [[MDRUserContext alloc] init];
        self.currentUserContext.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    }
    return self;
}

#pragma mark - Setters

- (void)setUserID:(NSString *)userID {
    self.currentUserContext.userID = userID;
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUserContext.userID forKey:@"push_token"];
}

#pragma mark - Binding

- (void)bindToLocationManager:(MDRLocationManager *)locationManager {
    __weak __typeof(self)weakSelf = self;
    [RACObserve(locationManager, currentLocation) subscribeNext:^(CLLocation *newLocation) {
        self.currentUserContext.currentLocation = newLocation;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf updateContext];
    }];
}

#pragma mark - API Calls

- (void)updateContext {
    if (self.currentUserContext != nil) {
        [MDRUserClient postContextForUserContext:self.currentUserContext withSuccess:nil withFailure:nil];
    }
}

@end
