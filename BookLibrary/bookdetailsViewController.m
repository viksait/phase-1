//
//  bookdetailsViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "bookdetailsViewController.h"
#import "tablecell.h"
#import "lendViewController.h"
#import "DBManager.h"
@interface bookdetailsViewController ()

@end

@implementation bookdetailsViewController
@synthesize outputarray,tabledatasource,flag,pickerview,pickersource;
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
    NSLog(@"book detail");
    self.title=@"Book Details";
    headers=@[@"Author",@"Publisher",@"Genre",@"Description",@"Status"];
    
   // tabledatasource=[[NSMutableArray alloc] initWithObjects:@"Dave Mark & Jeff Lavarche",@"Apress(July21,2009)",@"computers",@"Features the best practices in the art and science of constructing software--topics include design, applying good techniques to construction, eliminating errors, planning, managing construction activities, and relating personal character to superior software. Original. (Intermediate)",@"Available", nil];
    
    pickersource=[[NSMutableArray alloc] initWithObjects:@"abc",@"kjnjk",@"uiweui",@"jknjk", nil];
    
    UIBarButtonItem *bar=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addcopies)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObject:bar];
   // UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-button.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    
   // [self.navigationItem setLeftBarButtonItem:btn];
	// Do any additional setup after loading the view.
}
-(void)addcopies
{
    NSInteger i=[[DBManager getSharedInstance] searchcopies:[tabledatasource objectAtIndex:0]];
    NSString *msg=[NSString stringWithFormat:@"Number of copies available:%d",i];
    UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Enter Number of copies to add" message:msg delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Add", nil ];
    alertview.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    [alertview show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
   
    NSInteger i=[[[alertView textFieldAtIndex:0] text] integerValue];
    
    if (i>0) {
        [[DBManager getSharedInstance]updatecopies:[tabledatasource objectAtIndex:0] copies:i];
    }
    else
    {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Invalid Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
        [alertview show];
    }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tablecell";
    
    tablecell *cell = [tableView
                       dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    tablecell *cell2=[tableView dequeueReusableCellWithIdentifier:@"Cell2"];
    if (cell == nil)
    {
        cell = [[tablecell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    if (cell1 == nil)
    {
        cell1 = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Cell"];
    }
    if (cell2 == nil)
    {
        cell2 = [[tablecell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:@"Cell2"];
    }
 NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   
    switch (indexPath.row) {
        case 0:
            
            cell.imgview.image=[UIImage imageWithData:[defaults objectForKey:[tabledatasource objectAtIndex:0]]];
            cell.nameLabel.text=[tabledatasource objectAtIndex:1];
            cell.idLabel.text=[tabledatasource objectAtIndex:2];
           
            CGSize expsize = [cell.nameLabel.text sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(165.0, INFINITY) lineBreakMode:cell.nameLabel.lineBreakMode];
            CGSize expsize2 = [cell.idLabel.text sizeWithFont:cell.idLabel.font constrainedToSize:CGSizeMake(165.0, INFINITY) lineBreakMode:cell.idLabel.lineBreakMode];
         
            customnumberofstars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(88,expsize.height + expsize2.height +20, 140, 41) andStars:5 isFractional:YES];
            customnumberofstars.delegate=self;
            customnumberofstars.backgroundColor=[UIColor clearColor];
            customnumberofstars.rating=[[tabledatasource objectAtIndex:6] doubleValue];
            customnumberofstars.enabled=false;
            [cell.contentView addSubview:customnumberofstars];
            return cell;
            break;
        case 5:
            if ([[tabledatasource objectAtIndex:7] intValue]>0) {
                cell1.detailTextLabel.text=@"Available";
            }
            else
            {
                cell1.detailTextLabel.text=@"Finished";
            }
            cell1.textLabel.text=[headers objectAtIndex:indexPath.row-1];
            return cell1;
            break;
         case 6:
            NSLog(@"%d",flag);
            switch (flag) {
                case 1:
                    cell2.borrow.enabled=false;
                    cell2.ret.enabled=false;
                    cell2.lend.enabled=true;
                    break;
                case 2:
                    cell2.borrow.enabled=false;
                    cell2.ret.enabled=false;
                    cell2.lend.enabled=true;
                    break;
                case 3:
                    cell2.borrow.enabled=true;
                    cell2.ret.enabled=false;
                    cell2.lend.enabled=false;
                    break;
                case 4:
                    cell2.borrow.enabled=false;
                    cell2.ret.enabled=true;
                    cell2.lend.enabled=false;
                    break;
                default:
                    break;
            }
            return cell2;
            break;
        default:
            cell1.detailTextLabel.text=[tabledatasource objectAtIndex:indexPath.row+1];
            cell1.textLabel.text=[headers objectAtIndex:indexPath.row-1];
            return cell1;
            break;
    }
       
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        return 130;
    }
    else if (indexPath.row==6)
    {
        return 54;
    }
    else if (indexPath.row==5)
    {
        return 54;
    }
    else
    {
        NSString *str=[tabledatasource objectAtIndex:indexPath.row+1];
        UIFont *font=[UIFont systemFontOfSize:14];
        CGSize expsize = [str sizeWithFont:font constrainedToSize:CGSizeMake(274.0, INFINITY) lineBreakMode:UILineBreakModeWordWrap];
        
        return expsize.height+30;
    }
    
}
-(IBAction)takebook:(id)sender
{
   action = [[UIActionSheet alloc] initWithTitle:@"Select Email ID"
                                       delegate:self
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil];
    //action.actionSheetStyle=UIActionSheetStyleBlackOpaque;
   
    pickerview=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
    pickerview.delegate=self;
    pickerview.dataSource=self;
    pickerview.showsSelectionIndicator=YES;

   
  
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [action addSubview:pickerview];
    [action addSubview:pickerToolbar];
    
    [action showInView:self.view];
    [action setBounds:CGRectMake(0,0,320,450)];
  /*  CGRect pickerRect = pickerview.bounds;
    pickerRect.origin.y = -40;
    pickerview.bounds = pickerRect;*/
}

-(IBAction)doneButtonPressed:(UIDatePicker*)sender
{
    [action dismissWithClickedButtonIndex:0 animated:YES];
    
}
-(IBAction)cancel:(id)sender
{
     [action dismissWithClickedButtonIndex:0 animated:YES];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [pickersource count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.pickersource objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    NSLog(@"%@",[pickersource objectAtIndex:row]);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *button=(UIButton*)sender;
    lendViewController *lend=[segue destinationViewController];
    if(button.tag==0)
    {
        lend.pagetitle=@"Lend Book";
    }
    else
    {
    lend.pagetitle=@"Borrow Book";
    }
}

@end
