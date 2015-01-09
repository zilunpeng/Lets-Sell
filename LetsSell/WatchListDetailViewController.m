//
//  WatchListDetailViewController.m
//  test
//
//  Created by Zilun Peng  on 2015-01-04.
//  Copyright (c) 2015 Zilun Peng . All rights reserved.
//

#import "WatchListDetailViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface WatchListDetailViewController ()
@property (weak, nonatomic) IBOutlet FBProfilePictureView *propfilePic;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;
@property (weak, nonatomic) IBOutlet UILabel *sellerNumber;
@property (weak, nonatomic) IBOutlet UILabel *itemCategory;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *iTitle;

@end

@implementation WatchListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.propfilePic.profileID = _userId;
    self.sellerName.text = _name;
    self.sellerNumber.text = _number;
    
    //item
    self.itemCategory.text = [NSString stringWithFormat: @"%@ %@", @"Category: ", _category];
    self.itemName.text = _iName;
    self.itemPrice.text = [NSString stringWithFormat:@"%@ %@", @"Price: ",_price];
    self.iTitle.text = _ititle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openFacebookProfile:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _link]];
}

@end
