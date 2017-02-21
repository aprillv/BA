//
//  mastercialist.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-2.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mastercialist.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "userInfo.h"
#import "wcfKeyValueItem.h"
#import "forapprove.h"
#import "wcfService.h"
#import "Reachability.h"
#import "cl_phone.h"
#import "cl_sync.h"
#import "phonelist.h"
#import "MBProgressHUD.h"
#import "multiSearch.h"

@interface mastercialist ()<MBProgressHUDDelegate, UITabBarDelegate>{
    UITableView *ciatbview;
}


@end

@implementation mastercialist{
    MBProgressHUD *HUD;
}

@synthesize ntabbar, searchtxt, rtnlist, rtnlist1, type, tbview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Home"]) {
        [self gohome:item];
    }else if([item.title isEqualToString:@"Refresh"]){
        [self dorefresh:item];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    rtnlist1=rtnlist;

    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh:) ];
    
    searchtxt.delegate=self;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
//    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    
    
    ciatbview = tbview;
  
    ciatbview.tag=2;
    [sv addSubview:ciatbview];
    
}

- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
//    UITableView *tbview=(UITableView *)[self.view viewWithTag:2];

    NSString *str;
    str=[NSString stringWithFormat:@"Key like '%@*' or Value like [c]'*%@*'", searchtxt.text, searchtxt.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [tbview reloadData];
    
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
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            wcfService *service =[wcfService service];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"3"];
        }

    }
    
    
}


- (void) xGetMasterCiaHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
    self.rtnlist =[(wcfArrayOfKeyValueItem*)value toMutableArray];
    rtnlist1=rtnlist;
    UITableView *tbview=(UITableView *)[self.view viewWithTag:2];
    searchtxt.text=@"";
    [tbview reloadData];
    [ntabbar setSelectedItem:nil];
}


#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.rtnlist count]; // or self.items.count;
    
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfKeyValueItem *cia =[rtnlist objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cia.Value;
  
    
    [cell .imageView setImage:nil];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        
    }else {
        if ([self.title isEqualToString:@"Phone List"]) {
            NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
            
            [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
            
            wcfKeyValueItem *kv =[rtnlist objectAtIndex:indexPath.row];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            
            cl_sync *mp =[[cl_sync alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
             if ([mp isFirttimeToSync:kv.Key :@"5"]) {
                UIAlertView *alert = nil;
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"This is the first time, we will sync Phone Lis with your phone, this will take some time, Are you sure you want to continue?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"Continue", nil];
                alert.tag = 2;
                [alert show];
            }else{
                phonelist *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"phonelist"];
                pl.managedObjectContext=self.managedObjectContext;
                pl.title=self.title;
                
                [self.navigationController pushViewController:pl animated:YES];
            }
                
        }else if ([self.title isEqualToString:@"For Approve"]) {
            NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
            
            [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
            
            wcfKeyValueItem *kv =[rtnlist objectAtIndex:indexPath.row];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            forapprove *fr =[self.storyboard instantiateViewControllerWithIdentifier:@"forapprove"];
            fr.managedObjectContext=self.managedObjectContext;
            fr.mastercia=kv.Key;
            fr.title=@"For Approve";
            [self.navigationController pushViewController:fr animated:YES];
        }else{
            NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
            
            [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
            wcfKeyValueItem *kv =[rtnlist objectAtIndex:indexPath.row];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            multiSearch *k =[[multiSearch alloc]init];
            k.managedObjectContext=self.managedObjectContext;
            k.title=self.title;
            [self.navigationController pushViewController:k animated:YES];
            
        }
        
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView .tag==2){
        //sync phonelist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self doSyncPhoneList];
            }
                break;
        }
    }
}

-(void)doSyncPhoneList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Phone List..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Phone List...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType: @"3"];
    }
    
}

- (void) xGetPhoneListHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
    if([value isKindOfClass:[NSError class]]) {
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide];
        SoapFault *sf =value;
        
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }
    
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    [HUD hide];
    phonelist *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"phonelist"];
    pl.managedObjectContext=self.managedObjectContext;
    pl.title=self.title;
    
    [self.navigationController pushViewController:pl animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
