//
//  requestedvpols.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-13.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "requestedvpols.h"
#import "Reachability.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "po1.h"
#import "forapprove.h"
#import "requestvpo.h"
#import "project.h"
#import "development.h"

@interface requestedvpols ()
@property (weak, nonatomic) IBOutlet UITableView *ciatable;

@end
@implementation requestedvpols{
}

@synthesize searchtxt, ntabbar, result,result1, xtype, idproject, ciatable;


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
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
   
    
    //    [self getPols:1];
    

    
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    if (xtype==8) {
        [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    }else{
     [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
    }
    
    [[ntabbar.items objectAtIndex:0] setTag:1];
    [[ntabbar.items objectAtIndex:3] setTag:2];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:item];
    }else if(item.tag == 2){
        [self refreshPrject:item];
    }
}

-(IBAction)goback1:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }else if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }else if ([temp isKindOfClass:[development class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

-(IBAction)refreshPrject:(id)sender{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler3:) version:version];
    }
}
- (void) xisupdate_iphoneHandler3: (id) value {
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
    
    NSString* result4 = (NSString*)value;
    if ([result4 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        result=nil;
        result1=nil;
        [searchtxt setText:@""];
        [self getPols];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    result=[[NSMutableArray alloc]init];
    result1=[[NSMutableArray alloc]init];
    [searchtxt setText:@""];
    [self getPols];
}


-(void)getPols {
   
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (xtype==6) {
            [service xGetRequestedPOForApproveLs:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType:@"3"];
        }else  if (xtype==8) {
            [service xGetProjectRequestedPOLs:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:idproject EquipmentType:@"3"];
        }else{
        [service xGetRequestedPOHoldLs:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType:@"3"];
        }
        
    }
    
}
- (void) xGetPOForApproveListHandler: (id) value {
    
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    
	// Do something with the NSMutableArray* result
      
    result =[(wcfArrayOfRequestedPOListItem*)value toMutableArray];
  
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        result1=result;
    ciatbview= ciatable;
    
            [ciatbview reloadData];
    
        
        [ntabbar setSelectedItem:nil];
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    
    return 88*(font.pointSize/15.0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [result count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfRequestedPOListItem *kv =[result objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text = kv.Nproject;
    [cell.detailTextLabel setNumberOfLines:0];
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\nRequested: %@", kv.Nvendor, kv.RequestedDate];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Request # %@ @ %@\n%@\nTotal: %@",kv.IdNumber, kv.RequestedDate,kv.Nvendor, kv.Total];
    
    [cell .imageView setImage:nil];
    return cell;
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [searchtxt resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfRequestedPOListItem *kv =[result objectAtIndex:(indexPath.row)];
        requestvpo *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"requestvpo"];
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.idnum=kv.IdNumber;
        if (xtype==8) {
            LoginS.fromforapprove=0;
        }else{
        LoginS.fromforapprove=1;
        }
        
        [self.navigationController pushViewController:LoginS animated:YES];
    }
    
    
}

- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Nproject like [c]'*%@*' or Nvendor like '*%@*' or RequestedDate like [c]'*%@*'", searchtxt.text, searchtxt.text, searchtxt.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result=[[result1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0){
            for (UIAlertView* cc in subviews) {
                if ([cc isKindOfClass:[UIAlertView class]]) {
                    [cc dismissWithClickedButtonIndex:0 animated:YES];
                }
            }
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
