//
//  CreateItemViewController.m
//  test
//
//  Created by Zilun Peng  on 2014-12-28.
//  Copyright (c) 2014 Zilun Peng . All rights reserved.
//
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "MasterViewController.h"
#import "CreateItemViewController.h"
#import "QSTodoService.h"
#import "Departments.h"

@interface CreateItemViewController (){
    NSArray *pickerData;
}
@property (weak, nonatomic) IBOutlet UIPickerView *DepartmentPicker;
@property (weak, nonatomic) IBOutlet UITextField *Course;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *Price;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (strong, nonatomic) QSTodoService *todoService;
@property (strong, nonatomic) MasterViewController *table;
@property NSUserDefaults *defaults;
@property NSDictionary *userInfo;
@property NSString *userEducation;
@property NSString *userName;
@property NSString *userFacebookProfile;
@end

@implementation CreateItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Initialize Data
    pickerData = [Departments getAllDepartments];
    self.todoService = [QSTodoService defaultService];
    self.table = [[MasterViewController alloc] init];
    // Connect data
    self.DepartmentPicker.dataSource = self;
    self.DepartmentPicker.delegate = self;
    //Initialize user defaults
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userInfo = [self.defaults dictionaryForKey:@"userInfo"];
    self.userEducation = [self.defaults stringForKey:@"userEducation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (NSString*) getSelectedDepartment
{
    NSString *selValue = [pickerData objectAtIndex:[_DepartmentPicker selectedRowInComponent:0]];
    return selValue;
}

//check if user is logged in
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

- (bool) isFormValid
{
    bool isValid = true;
    if (_Course.text.length == 0) {
        isValid = false;
        _Course.layer.borderColor = [[UIColor redColor] CGColor];
        _Course.layer.borderWidth = 1.0f;
    }
    if (_Title.text.length == 0) {
        isValid = false;
        _Title.layer.borderColor = [[UIColor redColor] CGColor];
        _Title.layer.borderWidth = 1.0f;
    }
    if (_Price.text.length == 0) {
        isValid = false;
        _Price.layer.borderColor = [[UIColor redColor] CGColor];
        _Price.layer.borderWidth = 1.0f;
    }
    
    if (isValid) {
        _Course.layer.borderColor = [[UIColor clearColor] CGColor];
        _Title.layer.borderColor = [[UIColor clearColor] CGColor];
        _Price.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    
    return isValid;
}

- (void) displayInvaldFormErrorMsg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Invalid form"
                          message:@"You cannot leave any of those fields as blank"
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

- (IBAction)onAdd:(id)sender {
    if (![self isFormValid]) {
        [self displayInvaldFormErrorMsg];
    }
    else if (![self isLoggedIn]) {
        [self displayFacebookErrorMsg];
    }
    else if (![self isUbcStudent]) {
        [self displayUBCStudentErrorMsg];
    }
    
    [self retrieveUserNameAndLink];
    
    if ([self isLoggedIn] && [self isFormValid] && [self isUbcStudent]) {
        NSString *department = [self getSelectedDepartment];
        NSDictionary *item = @{ @"department": department,@"course": _Course.text,@"title": _Title.text,
                                @"name": self.userName, @"link": self.userFacebookProfile,
                                @"phone": _PhoneNumber.text, @"price": _Price.text, @"type": @"Text Book"};
        
        [self.todoService addItem:item completion:^(NSUInteger index)
         {
         }];
    [self displaySuccessMsg];
    }
    
    //clear data
    _Course.text = @"";
    _PhoneNumber.text = @"";
    _Price.text = @"";
    _Title.text = @"";
}

@end
