//
//  DetailViewController.m
//  test
//
//  Created by Zilun Peng  on 2014-12-26.
//  Copyright (c) 2014 Zilun Peng . All rights reserved.
//

#import "DetailViewController.h"
#import "UserSavedData.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    // For now, just set them in here
    _profilePic.profileID = _userId;
    _sellerName.text = _name;
    _sellerNumber.text = _number;
    
    //item
    _itemCategory.text = [NSString stringWithFormat: @"%@ %@", @"Category: ", _category];
    _itemName.text = _iName;
    _itemPrice.text = [NSString stringWithFormat:@"%@ %@", @"Price: ",_price];
    _iTitle.text = _ititle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openFacebookProfile:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _link]];
}

- (void) displaySuccessMsg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Success"
                          message:@"You have successfully added to watch list"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)addToWatchList:(id)sender {
    [UserSavedData setUserSavedData:_item];
    [self displaySuccessMsg];
}

@end
