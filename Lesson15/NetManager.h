//
//  NetManager.h
//  Lesson15
//
//  Created by Azat Almeev on 06.02.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

+ (instancetype)sharedInstance;
- (void)signInUsingLogin:(NSString *)login andPassword:(NSString *)password completion:(void (^)(NSError *error))completion;
- (void)loadSomeDataProgress:(void (^)(NSInteger progress))progress completion:(void (^)(NSError *error))completion;

@end
