//
//  MasterViewController.m
//  test
//
//  Created by Zilun Peng  on 2014-12-26.
//  Copyright (c) 2014 Zilun Peng . All rights reserved.
//
#import "QSTodoService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) QSTodoService *todoService;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults; // Filtered search results
@property (strong, nonatomic) NSMutableArray *displayedItems; // results returned from services
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSString *scope;

@end

@implementation MasterViewController

@synthesize todoService;
@synthesize activityIndicator;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Create the todoService - this creates the Mobile Service client inside the wrapped service
    self.todoService = [QSTodoService defaultService];
    [self initSearch];

    // Set the busy method
    UIActivityIndicatorView *indicator = self.activityIndicator;
    self.todoService.busyUpdate = ^(BOOL busy)
    {
        if (busy)
        {
            [indicator startAnimating];
        } else
        {
            [indicator stopAnimating];
        }
    };
    
    // have refresh control reload all data from server
    [self.refreshControl addTarget:self
                            action:@selector(onRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    // load the data
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void) initCounters
{
    NSUInteger itemsCount = [self.todoService.items count];
    NSUInteger upassItemsCount = [self.todoService.upassItems count];
    self.displayedItems = [NSMutableArray arrayWithCapacity:(itemsCount + upassItemsCount)];
    self.displayedItems = [[self.todoService.items arrayByAddingObjectsFromArray:self.todoService.upassItems]mutableCopy];
}

- (void) refresh
{
    [self.refreshControl beginRefreshing];
    
    [self.todoService refreshDataOnSuccess:^
     {
         [self.refreshControl endRefreshing];
         [self initCounters];
         [self.tableView reloadData];
     }];
}

- (void) initSearch {
    // Create a mutable array to contain products for the search results table.
    self.searchResults = [NSMutableArray arrayWithCapacity:100]; //change to items.count
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:@"All"];
    [scopeButtonTitles addObject:@"Text Book"];
    [scopeButtonTitles addObject:@"Upass"];
    self.types = [NSArray arrayWithArray:scopeButtonTitles];
    
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRefresh:(id) sender
{
    [self refresh];
}

- (NSString*) getUserId: (NSDictionary *)item
{
    NSString *url = [item objectForKey:@"link"];
    NSURL *URL = [NSURL URLWithString:url];
    NSArray *components = [URL pathComponents];
    NSString *userID = [components lastObject];
    return userID;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *item = [self.displayedItems objectAtIndex:indexPath.row];
        DetailViewController *detailController = segue.destinationViewController;
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
        
        detailController.item = item;
    }
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Set the label on the cell and make sure the label color is black (in case this cell
    // has been reused and was previously greyed out
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (self.searchController.active) {
        if ([self.scope isEqualToString:@"Text Book"]){
        NSDictionary *item = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"department"], [item objectForKey:@"course"]];
        }
        if ([self.scope isEqualToString:@"Upass"]){
            NSDictionary *item = [self.searchResults objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"month"], @"Upass"];
        }
        if ([self.scope isEqualToString:@"All"]) {
            NSDictionary *item = [self.displayedItems objectAtIndex:indexPath.row];
            if ([[item objectForKey:@"type"] isEqualToString:@"Text Book"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"department"], [item objectForKey:@"course"]];
            }
            if ([[item objectForKey:@"type"] isEqualToString:@"Upass"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"month"], @"Upass"];
            }
        }
    }
    else{
        NSDictionary *item = [self.displayedItems objectAtIndex:indexPath.row];
        if ([[item objectForKey:@"type"] isEqualToString:@"Text Book"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"department"], [item objectForKey:@"course"]];
        }
        if ([[item objectForKey:@"type"] isEqualToString:@"Upass"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"month"], @"Upass"];
        }
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Always a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of items in the todoService items array
    if (self.searchController.active) {
        return [self.searchResults count];
    }
    else {
        return [self.displayedItems count];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    self.scope = nil;
    
    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
    if (selectedScopeButtonIndex > 0) {
        self.scope = [_types objectAtIndex:selectedScopeButtonIndex];
    }
    
    [self updateFilteredContentForProductName:searchString type:self.scope];
    
    [self refresh];
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)itemName type:(NSString *)typeName {
    
    // Update the filtered array based on the search text and scope.
    if ((itemName == nil) || [itemName length] == 0) {
        // If there is no search string and the scope is "All".
        if (typeName == nil) {
              self.searchResults = self.displayedItems;
        } else {
            // If there is no search string and the scope is chosen.
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
            if ([typeName isEqualToString:@"Text Book"]){
                for (NSDictionary *item in self.todoService.items) {
                    [searchResults addObject:item];
                }
            }
            if ([typeName isEqualToString:@"Upass"]){
                [self.searchResults removeAllObjects];
                for (NSDictionary *item in self.todoService.upassItems) {
                    [searchResults addObject:item];
                }
            }

            self.searchResults = searchResults;
        }
        return;
    }
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    
    //!!! Should not use two for loops here
    if ((typeName == nil) || [typeName isEqualToString:@"Text Book"]) {
        for (NSDictionary *item in self.todoService.items) {
            NSString *department = [item objectForKey:@"department"];
            NSString *course = [item objectForKey:@"course"];
            NSString *name = [NSString stringWithFormat:@"%@,%@", department, course];
            
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, name.length);
            NSRange foundRange = [
                                  name rangeOfString:itemName options:searchOptions range:productNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:item];
            }
        }
    }
    
    if ((typeName == nil) || [typeName isEqualToString:@"Upass"]) {
        for (NSDictionary *item in self.todoService.upassItems) {
            NSString *month = [item objectForKey:@"month"];
            
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, month.length);
            NSRange foundRange = [
                                  month rangeOfString:itemName options:searchOptions range:productNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:item];
            }
        }
    }
}

@end
