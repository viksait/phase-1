//
//  libraryViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "libraryViewController.h"
#import "SWRevealViewController.h"
#import "booklistViewController.h"
#import "DBManager.h"
@interface libraryViewController ()

@end

@implementation libraryViewController
@synthesize tabledatasource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Library";
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.tabledatasource=@[@"Action",@"Adventure",@"Fiction",@"Psychology",@"Spiritual",@"Computers",@"Cooking"];
	// Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tabledatasource count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text=[self.tabledatasource objectAtIndex:indexPath.row];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Categories";
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if ([segue.identifier isEqualToString:@"toTheBookListViewController"]) {
    
        NSIndexPath *indexPath=[self.tableview indexPathForSelectedRow];
        //UINavigationController *destinationViewController=(UINavigationController *)segue.destinationViewController;
        booklistViewController *booklist=segue.destinationViewController;
        booklist.category=[self.tabledatasource objectAtIndex:indexPath.row];
        NSLog(@" in library view controller=%@",booklist.category);
        NSMutableArray *parameterForDestinationSegue=[[DBManager getSharedInstance] findDetailForCategory:booklist.category ];
        NSLog(@"%d",[parameterForDestinationSegue count]);
        booklist.tabledatasource=parameterForDestinationSegue;
        
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *index=[self.tableview indexPathForSelectedRow];
    if(index!=nil)
    {
        [self.tableview deselectRowAtIndexPath:index animated:YES];
    }
    
}

@end
