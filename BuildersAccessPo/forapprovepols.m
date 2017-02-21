//
//  forapprovepols.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-19.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "forapprovepols.h"
#import "Reachability.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "po1.h"
#import "forapprove.h"

@interface forapprovepols ()<MBProgressHUDDelegate, UITabBarDelegate>{
    int pageNo;
    int currentpage;
}

@end


@implementation forapprovepols{
    MBProgressHUD *HUD;
}

@synthesize searchtxt, ntabbar, ciatbview, mxtype, result,result1;


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
    
    
    searchtxt.delegate=self;
    
//    [self getPols:1];
    
    pageNo=0;
    
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    ntabbar.delegate = self;
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ( [item.title isEqualToString:@"For Approve"]) {
        [self goback1:item];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self refreshPrject:item];
    }
}


-(IBAction)goback1:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
   
    return 88*(font.pointSize/15.0);
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
        [self getPols:1];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    result=[[NSMutableArray alloc]init];
    result1=[[NSMutableArray alloc]init];
    [searchtxt setText:@""];
    [self getPols:1];
}


-(void)getPols:(int)xpageNo {
    if (xpageNo==1) {
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:[NSString stringWithFormat:@"Downloading %@...",self.title ] delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=[NSString stringWithFormat:@"Downloading %@...",self.title ];
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
    }else{
//        alertViewWithProgressbar.progress= ((xpageNo-1)*100/pageNo);
        
        HUD.progress=((xpageNo-1)*1.0/pageNo);
    }
    currentpage=xpageNo;
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetPOForApproveList:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xtype:[[NSNumber numberWithInt:mxtype]stringValue] currentPage:xpageNo EquipmentType:@"3"];
    }

}
- (void) xGetPOForApproveListHandler: (id) value {
    
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        [alert show];
        return;
    }
    
    
	// Do something with the NSMutableArray* result
    
    NSMutableArray *ns1 =[(wcfArrayOfPOListItem*)value toMutableArray];
    
    wcfPOListItem *pi;
    if (pageNo==0) {
        pi= (wcfPOListItem *)[ns1 objectAtIndex:0];
        pageNo=[pi.TotalPage intValue];
    }
    
    [ ns1 removeObjectAtIndex:0];
    

    if (result==nil) {
         result=[[NSMutableArray alloc]init];
    }
   
     [result addObjectsFromArray:ns1];
    
    if (currentpage==pageNo) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        HUD.progress=1;
        [HUD hide];
        
        result1=result;
       
        
       
            [ciatbview reloadData];
        

        [ntabbar setSelectedItem:nil];
    }else{
        [self getPols:(currentpage+1)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [result count];
}



- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfPOListItem *kv =[result objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text = kv.Doc;
    [cell.detailTextLabel setNumberOfLines:0];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@\n%@", kv.Nvendor, kv.Nproject, kv.Shipto];
    
    
    
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
        
        //        UIAlertView *alert = nil;
        //        alert = [[UIAlertView alloc]
        //                 initWithTitle:@"BuildersAccess"
        //                 message:@"There is a new version?"
        //                 delegate:self
        //                 cancelButtonTitle:@"Cancel"
        //                 otherButtonTitles:@"Ok", nil];
        //        alert.tag = 1;
        //        [alert show];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [searchtxt resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfPOListItem *kv =[result objectAtIndex:(indexPath.row)];
        po1 *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"po1"];
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.idpo1=kv.Idnumber;
        LoginS.fromforapprove=1;
        LoginS.xcode=kv.Code;
        LoginS.title=kv.Doc;
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
    str=[NSString stringWithFormat:@"Doc like [c]'*%@*' or Nvendor like '*%@*' or Nproject like [c]'*%@*' or Shipto like [c]'*%@*'", searchText, searchText, searchText, searchText];
    
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
