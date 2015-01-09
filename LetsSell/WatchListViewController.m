//
//  WatchListViewController.m
//  test
//
//  Created by Zilun Peng  on 2015-01-04.
//  Copyright (c) 2015 Zilun Peng . All rights reserved.
//

#import "WatchListViewController.h"
#import "WatchListDetailViewController.h"
#import "UserSavedData.h"

@interface WatchListViewController ()

@property (strong, nonatomic) NSMutableArray *userSavedItems;

@end

@implementation WatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.userSavedItems = [UserSavedData getUserSavedData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userSavedItems = [UserSavedData getUserSavedData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return [[UserSavedData getUserSavedData] count];
    return [self.userSavedItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedItem" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"savedItem"];
    }

    cell.textLabel.textColor = [UIColor blackColor];

    NSDictionary *item = [self.userSavedItems objectAtIndex:indexPath.row];
    if ([[item objectForKey:@"type"] isEqualToString:@"Text Book"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"department"], [item objectForKey:@"course"]];
    }
    if ([[item objectForKey:@"type"] isEqualToString:@"Upass"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"month"], @"Upass"];
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [UserSavedData removeUserSavedData: indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString*) getUserId: (NSDictionary *)item
{
    NSString *url = [item objectForKey:@"link"];
    NSURL *URL = [NSURL URLWithString:url];
    NSArray *components = [URL pathComponents];
    NSString *userID = [components lastObject];
    return userID;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"showSavedItemDetail"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         NSDictionary *item = [self.userSavedItems objectAtIndex:indexPath.row];
         WatchListDetailViewController *detailController = segue.destinationViewController;
         NSString *itemType = [item objectForKey:@"type"];
         NSString *userId = @"";
         userId = [self getUserId:item];
         
         //set attributes
         detailController.userId = userId;
         detailController.name = [item objectForKey:@"name"];
         detailController.link = [item objectForKey:@"link"];
         detailController.number = [item objectForKey:@"phone"];
         detailController.price = [item objectForKey:@"price"];
         detailController.category = itemType;
         
         if ([itemType isEqualToString:@"Upass"]) {
             detailController.iName = [NSString stringWithFormat:@"%@ %@", [item objectForKey:@"month"],@"Upass"];
             detailController.ititle = @"";
         }
         if ([itemType isEqualToString:@"Text Book"]) {
             detailController.iName = [NSString stringWithFormat:@"%@ %@", [item objectForKey:@"department"], [item objectForKey:@"course"]];
             detailController.ititle = [NSString stringWithFormat:@"%@ %@", @"Book's title: ",[item objectForKey:@"title"]];
         }
     }
}


@end
