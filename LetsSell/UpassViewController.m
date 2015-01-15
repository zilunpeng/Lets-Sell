//
//  UpassViewController.m
//  test
//
//  Created by Zilun Peng  on 2014-12-30.
//  Copyright (c) 2014 Zilun Peng . All rights reserved.
//
#import "UpassViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "QSTodoService.h"

@interface UpassViewController () {
    NSArray *pickerData;
}
@property (strong, nonatomic) QSTodoService *todoService;
@property (weak, nonatomic) IBOutlet UIPickerView *monthPicker;
@property (weak, nonatomic) IBOutlet UISlider *pricePicker;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property NSUserDefaults *defaults;
@property NSDictionary *userInfo;
@property NSString *userEducation;
@property NSString *userName;
@property NSString *userFacebookProfile;

@end

@implementation UpassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize Data
    pickerData = @[@"January", @"Febuary", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    //initialize service
    self.todoService = [QSTodoService defaultService];
    
    //connect data
    self.monthPicker.dataSource = self;
    self.monthPicker.delegate = self;
    
    //set slider
    self.pricePicker.minimumValue = 0;
    self.pricePicker.maximumValue = 100;
    
    //Initialize user defaults
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userInfo = [self.defaults dictionaryForKey:@"userInfo"];
    self.userEducation = [self.defaults stringForKey:@"userEducation"];
}

//Initialization for picker
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (IBAction)sliderValueChanged:(id)sender {
    NSInteger val = lround(self.pricePicker.value);
    self.amount.text = [NSString stringWithFormat:@"%ld", (long)val];
}

- (NSString*) getSelectedMonth
{
    NSString *selValue = [pickerData objectAtIndex:[_monthPicker selectedRowInComponent:0]];
    return selValue;
}

- (bool) isPriceValid:(NSString*) price {
    if ([price isEqualToString:@"0"]) {
        return true;
    }
    return false;
}

- (void) displayPriceError {
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Invalid price"
                          message:@"Price cannot be 0"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}

- (bool) isUbcStudent {
    if ([self.userEducation rangeOfString: @"University of British Columbia"].location == NSNotFound) {
        return false;
    }
    return true;
}

- (void) displayUBCStudentErrorMsg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Invalid school"
                          message:@"Sorry, we currently only support UBC students for this product"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}

- (bool) isLoggedIn
{
    bool getStatus  = [self.defaults boolForKey:@"userStatus"];
    if (!getStatus) {
        return false;
    }
    return true;
}

- (void) displayFacebookErrorMsg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Fail to create item"
                          message:@"You have to log onto Facebook in order to create item"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}

- (void) retrieveUserNameAndLink
{
    self.userName = [self.userInfo objectForKey:@"name"];
    self.userFacebookProfile = [self.userInfo objectForKey:@"link"];
}

- (void) displaySuccessMsg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Success"
                          message:@"You have successfully created an item"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)onAddUpass:(id)sender {
    NSString *price = self.amount.text;
    NSString *month = [self getSelectedMonth];
    if ([self isPriceValid:price]) {
        [self displayPriceError];
    }
    else if (![self isLoggedIn]) {
        [self displayFacebookErrorMsg];
    }
    else if (![self isUbcStudent]) {
        [self displayUBCStudentErrorMsg];
    }
    
    [self retrieveUserNameAndLink];
    
    if ([self isLoggedIn] && ![self isPriceValid:price] && [self isUbcStudent]) {
        NSDictionary *upass = @{@"month": month, @"price": price, @"name": self.userName, @"link": self.userFacebookProfile, @"phone": self.phone.text ,@"type": @"Upass"};
        [self.todoService addUpass:upass completion:^(NSUInteger index)
         {
         }];
    [self displaySuccessMsg];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
