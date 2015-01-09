//
//  DetailViewController.h
//  test
//
//  Created by Zilun Peng  on 2014-12-26.
//  Copyright (c) 2014 Zilun Peng . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface DetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) IBOutlet UILabel *sellerName;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) IBOutlet UIButton *sellerProfileLink;
@property (strong, nonatomic) NSString *link;

@property (strong, nonatomic) IBOutlet UILabel *sellerNumber;
@property (strong, nonatomic) NSString *number;

@property (strong, nonatomic) IBOutlet UILabel *itemCategory;
@property (strong, nonatomic) NSString *category;

@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) NSString *iName;

@property (strong, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong, nonatomic) NSNumber *price;

@property (strong, nonatomic) IBOutlet UILabel *iTitle;
@property (strong, nonatomic) NSString *ititle;

@property (strong, nonatomic) NSDictionary *item;

@end

