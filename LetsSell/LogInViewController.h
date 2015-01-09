//
//  LogInViewController.h
//  test
//
//  Created by Zilun Peng  on 2014-12-30.
//  Copyright (c) 2014 Zilun Peng . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LogInViewController : UIViewController <FBLoginViewDelegate>
@property (strong, nonatomic) NSDictionary *info;

@end
