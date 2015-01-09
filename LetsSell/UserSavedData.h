//
//  UserSavedData.h
//  test
//
//  Created by Zilun Peng  on 2015-01-04.
//  Copyright (c) 2015 Zilun Peng . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSavedData : NSObject

@property (strong, nonatomic) NSMutableArray *userSavedData;

// Required: A method to retrieve the shared instance
+(UserSavedData *) sharedInstance;

+(NSMutableArray *) getUserSavedData;
+(void) setUserSavedData: (NSDictionary *) item;
+(void) removeUserSavedData: (NSInteger) index;

@end
