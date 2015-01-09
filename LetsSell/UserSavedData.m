//
//  UserSavedData.m
//  test
//
//  Created by Zilun Peng  on 2015-01-04.
//  Copyright (c) 2015 Zilun Peng . All rights reserved.
//

#import "UserSavedData.h"

@implementation UserSavedData

@synthesize userSavedData;

#pragma mark Singleton Implementation
static UserSavedData *sharedObject;
+ (UserSavedData*)sharedInstance
{
    if (sharedObject == nil) {
        sharedObject = [[super allocWithZone:NULL] init];
        sharedObject.userSavedData = [[NSMutableArray alloc] init];
    }
    return sharedObject;
}

#pragma mark Shared Public Methods
+(NSMutableArray *) getUserSavedData {
    // Ensure we are using the shared instance
    UserSavedData *shared = [UserSavedData sharedInstance];
    return shared.userSavedData;
}

+(void) setUserSavedData:(NSDictionary *)item {
    // Ensure we are using the shared instance
    UserSavedData *shared = [UserSavedData sharedInstance];
    [shared.userSavedData addObject:item];
}

+(void) removeUserSavedData: (NSInteger) index{
    UserSavedData *shared = [UserSavedData sharedInstance];
    [shared.userSavedData removeObjectAtIndex:index];
}


@end
