//
//  ciaList.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-8.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import "ciaList.h"
#import "userInfo.h"
#import "wcfService.h"
#import "wcfKeyValueItem.h"
#import "wcfArrayOfKeyValueItem.h"
#import "Mysql.h"
#import "projectls.h"
#import "MBProgressHUD.h"
#import "wcfProjectListItem.h"
#import "cl_cia.h"
#import "cl_project.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "cl_sync.h"
#import "phonelist.h"
#import "cl_phone.h"
#import "dowloadproject.h"
#import "ProjectLsFromTaskDue.h"
#import "BuildersAccess-Swift.h"

@interface ciaList ()<MBProgressHUDDelegate, dowloadprojectDelegate, UITabBarDelegate>{
    MBProgressHUD *HUD;
     int iii;
    NSMutableArray *tn;
    NSString *scheduleyn;
}
@end

int currentpage, pageno;

@implementation ciaList

@synthesize ciaListresult, islocked, ntabbar, searchtxt, ciatbview;

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
    
    
    // Do any additional setup after loading the view from its nib.
   islocked=0;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
    ntabbar.delegate =  self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    
    ntabbar.userInteractionEnabled = YES;
     [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh1.png"] ];
     [[ntabbar.items objectAtIndex:3]setTitle:@"Sync" ];
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshCiaList:)];
   
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
     [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
    searchtxt.delegate=self;
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    [self getcialist];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Home"]) {
        [self gohome:item];
    }else if([item.title isEqualToString:@"Sync"]){
        [self refreshCiaList:item];
    }
}

- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
    cl_cia *mp =[[cl_cia alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    NSString *str =[NSString stringWithFormat:@"(cianame like [c]'*%@*') or (ciaid like '%@*')", searchtxt.text, searchtxt.text] ;
        
    ciaListresult=[mp getCiaListWithStr:str];
    
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)getcialist{
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    ciaListresult =[mcia getCiaList];
   
//    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
////    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
////    NSLog(@"height %f", self.view.frame.size.height);
//    
//    if (self.view.frame.size.height>480) {
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325+87)];
//        sv.contentSize=CGSizeMake(self.view.frame.size.width,326+87);
//    }else{
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325)];
//        sv.contentSize=CGSizeMake(self.view.frame.size.width,326);
//    }
    
//    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    
//     ciatbview.layer.cornerRadius = 10;
//    ciatbview.tag=2;
////    [sv addSubview:ciatbview];
//    ciatbview.delegate = self;
//    ciatbview.dataSource = self;
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.ciaListresult count]; // or self.items.count;
    
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    NSEntityDescription *cia =[ciaListresult objectAtIndex:indexPath.row];
    NSString *idnm = [cia valueForKey:@"ciaid"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ~ %@", idnm, [cia valueForKey:@"cianame"]];
    [cell .imageView setImage:nil];
    return cell;

    
}

-(void)viewWillAppear:(BOOL)animated{
        cl_cia *mcia =[[cl_cia alloc]init];
        mcia.managedObjectContext=self.managedObjectContext;
        ciaListresult =[mcia getCiaList];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
      NSIndexPath *selectedIndexPath = [ciatbview indexPathForSelectedRow];
    
    [ciatbview deselectRowAtIndexPath:selectedIndexPath animated:YES];
    [searchtxt resignFirstResponder];
  
   
    
   NSEntityDescription *cia =[ciaListresult objectAtIndex:selectedIndexPath.row];
    NSLog(@"%@", [cia valueForKey:@"ciaid"]);
   [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"]integerValue] andNm:[cia valueForKey:@"cianame"]];

    if ([self.title isEqualToString:@"Task Due"]) {
//        ProjectLsFromTaskDue *pt = [self.storyboard instantiateViewControllerWithIdentifier:@"NaviSearchTabBaseViewController"];;
//        [self.navigationController pushViewController: pt animated: YES];
        projectls *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"projectls"];
        LoginS.managedObjectContext=self.managedObjectContext;
        
        LoginS.title=self.title;
        
        self.islocked=0;
        [self.navigationController pushViewController:LoginS animated:YES];
    }else if ([self.title isEqualToString:@"Phone List"]) {
        cl_phone *mp =[[cl_phone alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp IsFirstTimeToSyncPhone]) {
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
            [self gotoNextPage];
            
        }
    }else{
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        
        if ([mp isFirttimeToSync: [[NSNumber numberWithInt:[userInfo getCiaId] ] stringValue] :@"1"]) {
            
            cl_project *cp =[[cl_project alloc]init];
            cp.managedObjectContext=self.managedObjectContext;
            [cp deletaAll:0];
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"This is the first time, we will sync all projects with your phone, this will take some time, Are you sure you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 0;
            [alert show];
        }else{
            [self gotoNextPage];
            
        }
    }
    
}

-(IBAction)refreshCiaList:(id)sender{
    
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
                                                       message:@"We will sync all companies with your device, this will take some time, Are you sure you want to continue?"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Continue", nil];
        alert.tag = 1;
        [alert show];
    }
    
    
}

- (void) vGetCiaListHandler: (id) value {
    // Handle errors
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    NSMutableArray *result1 = (NSMutableArray*)value;
    
    if([result1 isKindOfClass:[wcfArrayOfKeyValueItem class]]){
        cl_cia *mcia = [[cl_cia alloc]init];
        mcia.managedObjectContext=self.managedObjectContext;
        [mcia deletaAll];
        [mcia addToCia:result1];
    }
    
    HUD.progress= 1;
    [HUD hide];
    
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    ciaListresult =[mcia getCiaList];
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms updSync:@"0" :@"0" :[[NSDate alloc] init]];
    
   
    [ciatbview reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self getProjectList:1];
            }
               break;
                
		}
		return;
	}else if(alertView .tag==1){
    //sync cialist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                searchtxt.text=@"";
                [self doSyncCialist];
            }
            break;
        }
    }else if(alertView .tag==2){
        //sync phonelist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self doSyncPhoneList];
            }
                break;
        }
    }else if(alertView .tag==100){
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

-(void)doSyncCialist{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Company..." delegate:self otherButtonTitles:nil];
//        
//        [alertViewWithProgressbar show];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Synchronizing Company...";
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        [service xGetCiaList:self action:@selector(vGetCiaListHandler:) xemail: [userInfo getUserName] xpassword: [[userInfo getUserPwd] copy] EquipmentType:@"3"];
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
    
    HUD.progress=100;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    [HUD hide];
    [self gotoNextPage];
    
}


-(void)getProjectList:(int)xpageNo {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=[NSString stringWithFormat:@"Synchronizing %@...",self.title ];
    
    HUD.progress=0;
    [HUD layoutSubviews];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    iii=0;
    
    NSOperationQueue*  _queue=[[NSOperationQueue alloc] init];
    dowloadproject *operation=[[dowloadproject alloc] initDownloadWithPageNo:1 andxtype:0];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:2 andxtype:0];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:3 andxtype:0];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:4 andxtype:0];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:5 andxtype:0];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];

}

-(void)doexception{
 
    
    if (![HUD isHidden]) {
        HUD.hidden=YES;
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        
        [alert show];
    }
   
}
-(void)finishone:(NSMutableArray *)result andPageNo:(int)pagen{
   
    
    if (iii==0) {
        tn =[[NSMutableArray alloc]init];
    }
   
//    NSLog(@"%d -- %d", iii, result.count);
//    
//    NSLog(@"%@", [result objectAtIndex:2]);
    wcfProjectListItem *kv;
    if (result.count>2) {
       
        kv = (wcfProjectListItem *)[result objectAtIndex:0];
        pageno=kv.TotalPage;
//        NSLog(@"af %d", pageno);
        [result removeObjectAtIndex:0];
        if (!scheduleyn) {
            kv= (wcfProjectListItem *)[result objectAtIndex:0];
            scheduleyn=kv.IDNumber;
        }
        [result removeObjectAtIndex:0];
        
       
        if (pageno<5 ) {
            if (pagen<=pageno) {
                 iii+=1;
//                NSLog(@"%d ppp %d ", iii, pagen);
                 [tn addObjectsFromArray:[result copy]];
                
                if (iii==pageno) {
                    cl_project *mp=[[cl_project alloc]init];
                    mp.managedObjectContext=self.managedObjectContext;
                    [mp addToProject:tn andscheleyn:scheduleyn];
                    HUD.progress=0.9;
                    cl_sync *ms =[[cl_sync alloc]init];
                    ms.managedObjectContext=self.managedObjectContext;
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                    
                    
                    HUD.progress = 1;
                    [HUD hide:YES];
                    projectls *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"projectls"];
                    LoginS.managedObjectContext=self.managedObjectContext;
                    LoginS.title=self.title;
                    self.islocked=0;
                    [self.navigationController pushViewController:LoginS animated:YES];
                }
                
            }else{
                return;
            }
           
            
        }else{
//             NSLog(@"%d", iii);
             iii+=1;
             [tn addObjectsFromArray:[result copy]];
            
            HUD.progress=iii*0.7/pageno;
            if (pageno==iii) {
               
                
                {
                    cl_project *mp=[[cl_project alloc]init];
                    mp.managedObjectContext=self.managedObjectContext;
                    [mp addToProject:tn andscheleyn:scheduleyn];
                    HUD.progress=0.9;
                    cl_sync *ms =[[cl_sync alloc]init];
                    ms.managedObjectContext=self.managedObjectContext;
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                    HUD.progress=1;
                }
                [HUD hide:YES];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                projectls *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"projectls"];
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.title=self.title;
                self.islocked=0;
                [self.navigationController pushViewController:LoginS animated:YES];        }
        }
    }else{
        if (!HUD.isHidden) {
            HUD.hidden=YES;
            HUD.progress=0.9;
//            NSLog(@"cc %d", [userInfo getCiaId]);
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
            HUD.progress=1;
            [HUD hide:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            projectls *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"projectls"];
            LoginS.managedObjectContext=self.managedObjectContext;
            LoginS.title=self.title;
            self.islocked=0;
            [self.navigationController pushViewController:LoginS animated:YES];
        }
        
    }
   
}


- (void) xSearchProjectHandler: (id) value {

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
    if([result isKindOfClass:[wcfArrayOfProjectListItem class]]){
        if ([result count]>0) {
            wcfProjectListItem *kv;
                        
            kv = (wcfProjectListItem *)[result objectAtIndex:0];
            pageno=kv.TotalPage;
            [result removeObjectAtIndex:0];
            
            kv= (wcfProjectListItem *)[result objectAtIndex:0];
            scheduleyn=kv.IDNumber;
            [result removeObjectAtIndex:0];

            

            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            [mp addToProject:result andscheleyn:scheduleyn];
            
            if (currentpage < pageno) {
                
                currentpage=currentpage+1;
                [self getProjectList:currentpage];
            }else{
                HUD.progress = 1;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                [HUD hide];
                
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                
                
                if (self.islocked==2) {
                    if (![[self unlockPasscode] isEqualToString:@""] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                        
                        [self.navigationItem setHidesBackButton:NO];
                        
                        [self enterPasscode:nil];
                    }else{
                        [self gotoNextPage];                }
                    
                }else{
                    [self gotoNextPage];
                    
                }
            }
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
            [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
            
            
            [self gotoNextPage];
        
        }
        
    }
}

-(void)gotoNextPage{
    if([self.title isEqualToString:@"Phone List" ]){
        phonelist *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"phonelist"];
        pl.managedObjectContext=self.managedObjectContext;
        pl.title=self.title;
        
        [self.navigationController pushViewController:pl animated:YES];
    }else {
        projectls *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"projectls"];
        LoginS.managedObjectContext=self.managedObjectContext;
        
        LoginS.title=self.title;
        
        self.islocked=0;
        [self.navigationController pushViewController:LoginS animated:YES];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    if (islocked==2) {
        [self dismissViewControllerAnimated:YES completion:^() {
            
             [self gotoNextPage];
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
