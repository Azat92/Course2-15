//
//  NetManager.m
//  Lesson15
//
//  Created by Azat Almeev on 06.02.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

+ (instancetype)sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] initSingleton];
    });
    return _singleton;
}

- (id)init {
    @throw [NSException exceptionWithName:@"You could not create an instance of this class" reason:@"This class is designed under the singleton pattern" userInfo:nil];
}

- (instancetype)initSingleton {
    self = [super init];
    if (!self)
        return nil;
    return self;
}

- (void)signInUsingLogin:(NSString *)login andPassword:(NSString *)password completion:(void (^)(NSError *error))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random_uniform(3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([login isEqualToString:@"login"] && [password isEqualToString:@"password"])
            completion(nil);
        else
            completion([NSError errorWithDomain:@"network" code:401 userInfo:@{ NSLocalizedDescriptionKey : @"Invalid username or password" }]);
    });
}

- (void)loadSomeDataProgress:(void (^)(NSInteger progress))progress completion:(void (^)(NSError *error))completion {
    for (int i = 0; i < 10; i++)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2 * i + arc4random_uniform(2)) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            progress((i + 1) * 10);
        });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(nil);
    });
}

@end
