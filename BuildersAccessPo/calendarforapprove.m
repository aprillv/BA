//
//  calendarforapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "calendarforapprove.h"
#import "wcfService.h"
#import "userInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "calendarforapproveupd.h"
#import "Reachability.h"

@interface calendarforapprove ()<UITabBarDelegate>

@end

@implementation calendarforapprove

@synthesize ntabbar, rtnlist,searchtxt, tbview, rtnlist1, mxtype, masterciaid;


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
    if (mxtype==1) {
        self.title=@"Calendar Builder";
    }else{
    self.title=@"Calendar Buyer";
    }
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    searchtxt.delegate=self;
        
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    ntabbar.delegate= self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh:) ];
    
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
	// Do any additional setup after loading the view.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"For Approve"]) {
        [self goback1:item];
    }else if([item.title isEqualToString:@"Refresh"]){
        [self dorefresh: item];
    }
}


-(IBAction)goback1:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dorefresh:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler:) version:version];
    }
}
- (void) xisupdate_iphoneHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self getCalendarList];
    }
    
    
}


- (void)doneClicked {
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Subject like [c]'*%@*' or Original like [c]'%@*' or Reschedule like '%@*'", searchtxt.text, searchtxt.text, searchtxt.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}


-(void) getCalendarList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        if (mxtype!=1) {
            [service xGetCalendarBuyerForApprove:self action:@selector(xGetCalendarForApproveHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"3"];
        }else{
            [service xGetCalendarBuilderForApprove:self action:@selector(xGetCalendarForApproveHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"3"];
        }

    }
        
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getCalendarList];
}

- (void) xGetCalendarForApproveHandler: (id)value {
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
	// Do something with the NSMutableArray* result
    rtnlist=[(wcfArrayOfCalendarItem*)value toMutableArray];
    rtnlist1=rtnlist ;
    
    UIScrollView *sv =(UIScrollView *)[self.view viewWithTag:1];
    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    if (tbview !=nil) {
        [tbview reloadData];
        [ntabbar setSelectedItem:nil];
        [searchtxt setText:@""];
    }else{
        if (self.view.frame.size.height>480) {
            tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325+87)];
            sv.contentSize=CGSizeMake(self.view.frame.size.width,326+87);
        }else{
            tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325)];
            sv.contentSize=CGSizeMake(self.view.frame.size.width,326);
        }
       
        tbview.tag=2;
        tbview.delegate = self;
        tbview.dataSource = self;
        [sv addSubview:tbview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.rtnlist count]); // or self.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfCalendarItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text = kv.Subject;
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Original: %@\nReschedule: %@", kv.Original, kv.Reschedule];
    [cell.detailTextLabel sizeToFit];
    [cell .imageView setImage:nil];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler1:) version:version];
    }
}
- (void) xisupdate_iphoneHandler1: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
         NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
        [tbview deselectRowAtIndexPath:indexPath animated:YES];
        
        calendarforapproveupd *pd =[self.storyboard instantiateViewControllerWithIdentifier:@"calendarforapproveupd"];
        pd.managedObjectContext=self.managedObjectContext;
        pd.xmtype=mxtype;
        wcfCalendarItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
        pd.idnumber=kv.IDNumber;
        [self.navigationController pushViewController:pd animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
