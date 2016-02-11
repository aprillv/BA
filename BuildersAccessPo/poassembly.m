
//
//  poassembly.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "poassembly.h"
#import "wcfService.h"
#import "wcfArrayOfKeyValueItem.h"
#import "wcfKeyValueItem.h"
#import "userInfo.h"
#import "Mysql.h"
#import "cl_vendor.h"
//#import "AGAlertViewWithProgressbar.h"
#import "project.h"
#import "development.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "cl_sync.h"
#import "cl_reason.h"
#import "newpovendorls.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"

@interface poassembly ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate ,UIAlertViewDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate,UITabBarDelegate>
@end

@implementation poassembly{
    int pageNo;
    int currentPage;
    
    int currentpage, pageno;
     CustomKeyboard *keyboard;
    MBProgressHUD *HUD;
}

@synthesize rtnlist;
@synthesize searchtxt, ntabbar, islocked, tbview, idmaster, xtype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    currentPage=1;
    searchtxt.delegate=self;
    self.title=@"Select a Vendor";
    [self getAssemblyls];
    
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Project" ];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshAssembly:)];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh1.png"] ];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Sync" ];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Project"]) {
        [self goback1:item];
    }else if([item.title isEqualToString:@"Sync"]){
        [self refreshAssembly:item];
    }
}

-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        
    }
}


-(void)doneClicked{
    [searchtxt resignFirstResponder];
}
- (void)getAssemblyls
{
    cl_vendor *mp=[[cl_vendor alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
    NSString *str;
    NSString *lastsync;
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    
    lastsync=[ms getLastSync:idmaster :@"7"];
    str=[NSString stringWithFormat:@"idcia ='%@'", idmaster];
    rtnlist = [mp getVendorList:str];
    
    
    
    UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 12, self.view.frame.size.width-20, 40)];
    lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", lastsync];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.tag=14;
    lbl.numberOfLines=0;
    [lbl sizeToFit];
    lbl.textColor= [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
    lbl.font=[UIFont boldSystemFontOfSize:10.0];
    lbl.backgroundColor=[UIColor clearColor];
    [ntabbar addSubview:lbl];
    
//    if (self.view.frame.size.height>480) {
//        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325+87)];
//        sv.contentSize=CGSizeMake(self.view.frame.size.width,326+87);
//    }else{
//        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325)];
//        sv.contentSize=CGSizeMake(self.view.frame.size.width,326);
//    }
//    
////    tbview.layer.cornerRadius = 10;
//    tbview.delegate = self;
//    tbview.dataSource = self;
//    [sv addSubview:tbview];
}

-(IBAction)refreshAssembly:(id)sender{
    
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
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                                       message:@"We will sync all Vendors with your device, this will take some time, Are you sure you want to continue?"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        alert.tag = 1;
        [alert show];
    }
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView .tag==1){
        //sync cialist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                searchtxt.text=@"";
                

                currentpage=1;
                [self refreshAssemblyList:1];
            }
                break;
        }
    }
}


-(void)refreshAssemblyList:(int)xpageNo {
    
    
    if (xpageNo==1) {
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Vendors..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
//        islocked=1;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Vendors...";
        
        HUD.progress=0.01;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
    }else{
        HUD.progress= (currentPage*1.0/(pageno+1));
        
    }
    currentPage=xpageNo;
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xGetPoVendor:self action:@selector(xGetAssemblysHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] currentPage:xpageNo EquipmentType:@"3"];
    }
}

- (void) xGetAssemblysHandler: (id) value {
    
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    
    if([result isKindOfClass:[wcfArrayOfVendor class]]){
        
        cl_vendor *mp=[[cl_vendor alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if (currentPage==1) {
            [mp deletaAll:idmaster];
        }
        
        if ([result count]>0) {
            wcfVendor *kv = (wcfVendor *)[result objectAtIndex:0];
            pageno=[kv.TotalPage intValue];
            [result removeObjectAtIndex:0];
            
            
            [mp addToVendor:result];
            
            if (currentpage < pageno) {
                
                currentpage=currentpage+1;
                [self refreshAssemblyList:currentpage];
            }else{
                HUD.progress = (pageno*1.0/(pageno+1));
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                [ms updSync:idmaster :@"7" :[[NSDate alloc] init]];
                
                [self SyncReason];
            }
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms updSync:idmaster :@"7" :[[NSDate alloc] init]];
            
            [self SyncReason];
        }
    }
}


-(void)SyncReason{
    wcfService *service = [wcfService service];
    [service xGetReasons:self action:@selector(xGetReasonsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] EquipmentType:@"3"];
}

-(void)xGetReasonsHandler: (id) value {
    
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [HUD hide];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        
        return;
    }
    
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    if([result isKindOfClass:[wcfArrayOfReasonListItem class]]){
        cl_reason *mp=[[cl_reason alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp deletaAll:idmaster];
        [mp addToReason:result :idmaster];
        
        
    }
    HUD.progress = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [HUD hide];
    [self getAssemblyls];
    [ntabbar setSelectedItem:nil];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    cl_vendor *mp =[[cl_vendor alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    NSString *str =[NSString stringWithFormat:@"((idNumber like [c]'%@*') or (name like [c]'*%@*'))", searchtxt.text, searchtxt.text];
    
    
    rtnlist=[mp getVendorList:str];
    
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [rtnlist count];
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
    
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    cell.textLabel.text = [kv valueForKey:@"name"];
    [cell .imageView setImage:nil];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self autoUpd];
}
-(void)autoUpd{
    
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
        [self gotonextpage];
    }
    
    
}

-(void)gotonextpage {
    
    [searchtxt resignFirstResponder];
    NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
    
    [tbview deselectRowAtIndexPath:indexPath animated:YES];
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    
    newpovendorls *next =[newpovendorls alloc];
    next.managedObjectContext=self.managedObjectContext;
    next.xidvendor=[kv valueForKey:@"idNumber"];
    next.xxnvendor=[kv valueForKey:@"name"];
    next.xidproject=self.idproject;
    next.idmaster=self.idmaster;
    next.xtype=self.xtype;
    [self.navigationController pushViewController:next animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
