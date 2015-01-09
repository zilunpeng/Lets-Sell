//
//  LogInViewController.m
//  test
//
//  Created by Zilun Peng  on 2014-12-30.
//  Copyright (c) 2014 Zilun Peng . All rights reserved.
//

#import "LogInViewController.h"
#import "CreateItemViewController.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (weak, nonatomic) IBOutlet UILabel *userInstitution;
@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSString *userSchool;
@property NSUserDefaults *userDefaults;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Ask for basic permissions on login
    [_fbLoginView setReadPermissions:@[@"public_profile"]];
    [_fbLoginView setDelegate:self];
    _objectID = nil;
   self.userDefaults = [NSUserDefaults standardUserDefaults];
}

-(NSString *) getSchoolName {
    if ([self.userSchool rangeOfString: @"University of British Columbia"].location == NSNotFound) {
        return @"";
    }
    return @"University of British Columbia";
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;
    self.userInstitution.text = [self getSchoolName];
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"User logged in");
    [self requestUserInfo];
    //enable create item button
    [self.userDefaults setBool:true forKey:@"userStatus"];
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"User logged out");
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.userInstitution.text = @"";
    [self.userDefaults setBool:false forKey:@"userStatus"];
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;

    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

// ------------> Login code ends here <------------


- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            _info = (NSDictionary *)result;
            //pass user info to LoginViewController
            [self.userDefaults setObject: result forKey:@"userInfo"];
            
            //pass user's school to LoginViewController
            self.userSchool = [[_info valueForKeyPath:@"education.school.name"] componentsJoinedByString:@""];
            [self.userDefaults setObject: self.userSchool forKey:@"userEducation"];
            
            NSLog(@"user info: %@", _info);
            NSLog(@"user info: %@", self.userSchool);
            
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
        }
    }];
}

- (void)requestUserInfo
{
    // We will request the user's public picture and the user's education history
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"public_profile", @"user_education_history"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // Parse the list of existing permissions and extract them for easier use
                                  NSMutableArray *currentPermissions = [[NSMutableArray alloc] init];
                                  NSArray *returnedPermissions = (NSArray *)[result data];
                                  for (NSDictionary *perm in returnedPermissions) {
                                      if ([[perm objectForKey:@"status"] isEqualToString:@"granted"]) {
                                          [currentPermissions addObject:[perm objectForKey:@"permission"]];
                                      }
                                  }
                                  
                                  // Build the list of requested permissions by starting with the permissions
                                  // needed and then removing any current permissions
                                  NSLog(@"Needed: %@", permissionsNeeded);
                                  NSLog(@"Current: %@", currentPermissions);
                                  
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:permissionsNeeded copyItems:YES];
                                  [requestPermissions removeObjectsInArray:currentPermissions];
                                  
                                  NSLog(@"Asking: %@", requestPermissions);
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
}

- (void) displaySuccessMsg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Success"
                          message:@"You have successfully posted"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)postToGroup:(id)sender {
    NSString *post = self.inputText.text;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            post, @"message",
                            nil
                            ];
    [FBRequestConnection startWithGraphPath:@"/103809373347/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              [self displaySuccessMsg];
                          }];
}
- (IBAction)postToAnotherGroup:(id)sender {
    NSString *post = self.inputText.text;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            post, @"message",
                            nil
                            ];
    [FBRequestConnection startWithGraphPath:@"/393133927503544/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              [self displaySuccessMsg];
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
