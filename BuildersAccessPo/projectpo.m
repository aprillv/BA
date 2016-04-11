//
//  projectpo.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-6.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectpo.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "projectpols.h"
#import "cl_sync.h"
#import "cl_vendor.h"
#import "cl_reason.h"
#import "poassembly.h"
#import "vpopendinglsViewController.h"
#import "MBProgressHUD.h"

@interface projectpo ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, UITabBarDelegate>{
    
    UIScrollView *uv;
    MBProgressHUD * HUD;
    bool isfirsttime;
    int selectedrow;
}

@end

int currentpage, pageno;

@implementation projectpo

@synthesize  idproject,xtype, idmaster, isfromdevelopment,result, idvendor, ciatbview, ntabbar;

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gotoProject:item];
    }else if(item.tag == 2){
        [self dorefresh:item];
    }
}

-(IBAction)gotoProject:(id)sender{
    if (isfromdevelopment==-1) {
        [self gohome:nil];
    }else{
     [self.navigationController popViewControllerAnimated:YES];
    }
   
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.title=@"Purchase Order";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    if ([idproject isEqualToString:@"-1"]) {
        idproject=@"";
    }else if ([idvendor isEqualToString:@"-1"]){
        idvendor=@"";
    }
    
    if (isfromdevelopment == 0) {
        [[ntabbar.items objectAtIndex:0] setTitle:@"Project" ];
    }else{
        [[ntabbar.items objectAtIndex:0] setTitle:@"Development" ];
    }
    if (result) {
         [self drawPage];
    }else{
        [self getDetail];
    }
   
    isfirsttime=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isfirsttime) {
        isfirsttime=NO;
    }else{
        [self dorefresh:nil];
    }
}
-(IBAction)dorefresh:(id)sender{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
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
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        [ntabbar setSelectedItem:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        
        [self getDetail];
    }
}


-(void)getDetail{
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    if ([idproject isEqualToString:@"-1"]) {
//        [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:@"" idvendor:@"" EquipmentType:@"3"];
//    }else if ([idvendor isEqualToString:@"-1"]){
//        [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:@"" EquipmentType:@"3"];
//    }else {
    [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:idvendor EquipmentType:@"3"];
//    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    switch (buttonIndex) {
        
        case 1:{
            if (alertView.tag==0) {
                currentpage=1;
                [self getAssemblyfromServer:1];
            }
        }
            break;
            
    }
    
    
}

-(void)getProjectPo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:@"" EquipmentType:@"3"];
    }

}

- (void) xGetStartPackListHandler: (id) value {
    [ntabbar setSelectedItem:nil];
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
    
    result=[(wcfArrayOfKeyValueItem*)value toMutableArray];
   
    
    [result removeObjectAtIndex: 0];
    [result removeObjectAtIndex: 0];
    [self drawPage];
}

-(void)drawPage{
  
    for (UIView *we in uv.subviews) {
        [we removeFromSuperview];
    }
    if (result.count==0) {
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-20, 21)];
        lbl.text=@"Purchase Order not Found.";
        lbl.textColor=[UIColor redColor];
        [ciatbview addSubview:lbl];
    }else{
        
            [ciatbview reloadData];
        
    }
   
   
    
}

-(IBAction)docreatevpo:(id)sender{
    cl_sync *mp =[[cl_sync alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    if ([mp isFirttimeToSync: idmaster :@"7"]) {
        
        cl_vendor *cp =[[cl_vendor alloc]init];
        cp.managedObjectContext=self.managedObjectContext;
        [cp deletaAll:idmaster];
        UIAlertView *alert = nil;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"BuildersAccess"
                 message:@"This is the first time, we will sync all vendors with your phone, this will take some time, Are you sure you want to continue?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Continue", nil];
        alert.tag = 0;
        [alert show];
    }else{
        [self gotoNextPageAssembly];
        
    }
}

-(void)getAssemblyfromServer:(int)xpageNo{
    currentpage=xpageNo;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
        
    }else{
        if (xpageNo==1) {
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Vendors..." delegate:self otherButtonTitles:nil];
//            
//            [alertViewWithProgressbar show];
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Synchronizing Vendors...";
            
            HUD.progress=0;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
        }else{
            HUD.progress= (currentpage*1.0/(pageno+1));
            
        }
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
    NSMutableArray* result3 = (NSMutableArray*)value;
    if([result3 isKindOfClass:[wcfArrayOfVendor class]]){
        if ([result3 count]>0) {
            wcfVendor *kv = (wcfVendor *)[result3 objectAtIndex:0];
            pageno=[kv.TotalPage intValue];
            [result3 removeObjectAtIndex:0];
            
            cl_vendor *mp=[[cl_vendor alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            [mp addToVendor:result3];
            
            if (currentpage < pageno) {
                
                currentpage=currentpage+1;
                [self getAssemblyfromServer:currentpage];
            }else{
                HUD.progress = (pageno*1.0/(pageno+1));
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                [ms addToSync:idmaster :@"7" :[[NSDate alloc] init]];
                
                [self SyncReason];
                
                
            }
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms addToSync:idmaster :@"7" :[[NSDate alloc] init]];
            
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
    NSMutableArray* result3 = (NSMutableArray*)value;
    if([result3 isKindOfClass:[wcfArrayOfReasonListItem class]]){
        cl_reason *mp=[[cl_reason alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp deletaAll:idmaster];
        [mp addToReason:result3 :idmaster];
        
        
    }
    HUD.progress = 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [HUD hide];
    [self gotoNextPageAssembly];
    
}
-(void)gotoNextPageAssembly{
    poassembly *pd =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"poassembly"];
    pd.managedObjectContext=self.managedObjectContext;
    pd.idproject =self.idproject;
    pd.idmaster=self.idmaster;
    pd.xtype=self.xtype;
    [self.navigationController pushViewController:pd animated:YES];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if ([[userInfo getUserName] isEqualToString:@"roberto@buildersaccess.com"]) {
//       
//    }else{
//    return ([result count]-1);
//    }
     return ([result count]);
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;    }
    
    wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text=kv.Value;
//    cell.textLabel.font=[UIFont systemFontOfSize:17.0];
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
        selectedrow = indexPath.row;
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler2:) version:version];
    }
}
- (void) xisupdate_iphoneHandler2: (id) value {
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
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfKeyValueItem *kv =[result objectAtIndex:selectedrow];
        
        if (![kv.Key isEqualToString:@"VPO Pending"]) {
            projectpols *pl =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectpols"];
            pl.isfromdevelopment=self.isfromdevelopment;
            pl.managedObjectContext=self.managedObjectContext;
            pl.idvendor=self.idvendor;
            pl.idproject=self.idproject;
            pl.xtatus=kv.Key;
            [self.navigationController pushViewController:pl animated:YES];
        }else{
            if ([kv.Value rangeOfString:@"(0)"].location == NSNotFound  ) {
                vpopendinglsViewController *vc =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"vpopendinglsViewController"];;
                vc.idproject=self.idproject;
                vc.managedObjectContext=self.managedObjectContext;
                [self.navigationController pushViewController:vc animated:YES];
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
