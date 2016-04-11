//
//  projectls.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-11.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "projectls.h"
#import "wcfService.h"
#import "wcfArrayOfKeyValueItem.h"
#import "wcfKeyValueItem.h"
#import "userInfo.h"
#import "Mysql.h"
#import "cl_project.h"
#import "project.h"
#import "development.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "cl_sync.h"
#import "MBProgressHUD.h"
#import "dowloadproject.h"
#import "wcfArrayOfProjectTaskDue.h"
#import "wcfProjectTaskDue.h"
#import "newSchedule2.h"

@interface projectls ()<MBProgressHUDDelegate, dowloadprojectDelegate, UITabBarDelegate>
@property (nonatomic, retain) NSArray *rtnlist;
@property (nonatomic, retain) NSArray *rtnlist1;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (nonatomic, retain) UIActivityIndicatorView *refresher;

@end


@implementation projectls{
    int pageNo;
    int currentPage;
    int xatype;
    MBProgressHUD *HUD;
    int iii;
    NSMutableArray *tn;
    int pageno;
    NSString *scheduleyn;
}


@synthesize searchtxt, ntabbar, islocked, tbview;


-(UIActivityIndicatorView *)refresher{
    if (!_refresher) {
        _refresher  = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 50, 50, 50)];
        _refresher.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview: _refresher];
        _refresher.hidesWhenStopped = YES;
        _refresher.center = self.view.center;
        
    }
    return _refresher;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setRtnlist: (NSArray *)rtnlist{
    _rtnlist = rtnlist;
    [self.tbview reloadData];
    if (_rtnlist.count > 0) {
        self.tbview.separatorColor = [UIColor grayColor];
    }else{
        self.tbview.separatorColor = [UIColor clearColor];
    }
}

-(void)setRtnlist1: (NSArray *)rtnlist{
    _rtnlist1 = rtnlist;
//    [self.tbview reloadData];
//    if (_rtnlist1.count > 0) {
//        self.tbview.separatorColor = [UIColor grayColor];
//    }else{
//        self.tbview.separatorColor = [UIColor clearColor];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    if ([self.title isEqualToString:@"Task Due"]) {
        self.rtnlist = self.rtnlist1 = nil;
        [self.tbview reloadData];
        self.lblError.hidden = YES;
        [self.refresher startAnimating];
        [self getProjectLsFromTaskDue];
    }else{
        [self getPojectls];
    }
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   

    tbview.separatorColor = [UIColor clearColor];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];

   
    currentPage=1;
    searchtxt.delegate=self;
   
    
    
    if ([self.title isEqualToString:@"Development"]) {
        xatype=1;
    }else if([self.title isEqualToString:@"Active Units"]){
        xatype=2;
    }else if([self.title isEqualToString:@"Not Started"]){
        xatype=3;
    }else{
        xatype=4;
    }
    
    
    
    ntabbar.userInteractionEnabled = YES;
    ntabbar.delegate = self;
    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshPrject:)];
    if ([self.title isEqualToString:@"Task Due"]) {
        [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
        [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
    }else{
        [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh1.png"] ];
        [[ntabbar.items objectAtIndex:3]setTitle:@"Sync" ];
    }
    
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Home"]) {
        [self gohome:item];
    }else if([item.title isEqualToString:@"Sync"]){
        [self refreshPrject:item];
       
    }else if([item.title isEqualToString:@"Refresh"]){
        [self viewWillAppear:YES];
    }
}

-(void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)getProjectLsFromTaskDue{
    wcfService *service =[wcfService service];
    [service xGetProjectTaskDue:self action:@selector(xGetProjectTaskDueHandler:)  xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] EquipmentType:@"3"];
}

- (void) xGetProjectTaskDueHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.refresher stopAnimating];
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
         self.lblError.text = @"    Network Error.";
        self.lblError.hidden = NO;
        return;
    }else{
        NSMutableArray *natemp = [[NSMutableArray alloc]init];
        NSMutableDictionary *dictmp;
        for (wcfProjectTaskDue *project in (wcfArrayOfProjectTaskDue *)value) {
//            NSLog(@"%@", project.ProjectName);
//            NSString* _IDNumber;
//            NSString* _Idcia;
//            NSString* _Ncia;
//            NSString* _ProjectName;
//            NSString* _StageName;
//            NSString* _Status;
//            str=[NSString stringWithFormat:@"name like [c]'*%@*' or planname like [c]'*%@*' or idnumber like [c]'%@*' or status like [c]'*%@*'", searchText, searchText, searchText,searchText];
//            project.wcfProjectTaskDue;
//            
            dictmp = [[NSMutableDictionary alloc] init];
            [dictmp setObject:project.IDNumber forKey: @"idnumber"];
            [dictmp setObject:project.StageName forKey: @"planname"];
            [dictmp setObject:project.ProjectName forKey: @"name"];
            [dictmp setObject:project.Status forKey: @"status"];
//            [dictmp setObject:@"name" forKey:project.ProjectName];
            
            [natemp addObject:dictmp];
        }
        if (self.rtnlist.count == 0){
            self.lblError.text = @"    No Project Found.";
            self.lblError.hidden = NO;
        }
        self.rtnlist = natemp;
        self.rtnlist1 = self.rtnlist;
//        rtnlist = (wcfArrayOfProjectTaskDue *)value;
//        
//        rtnlist1=rtnlist;
    }
//    NSLog(@"%@", value);
}


- (void)getPojectls
{
    cl_project *mp=[[cl_project alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
    NSString *str;
    NSString *lastsync;
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    
    switch (xatype) {
        case 1:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
            break;
        case 2:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
            break;
        case 3:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0' ", [userInfo getCiaId]];
            break;

        default:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
            break;
    }
    
   self.rtnlist = [mp getProjectList:str];
    
    self.rtnlist1=self.rtnlist;
    
    
    
    UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 12, self.view.frame.size.width-20, 40)];
    lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", lastsync];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.textColor=[UIColor lightGrayColor];
    lbl.tag=14;
    lbl.numberOfLines=0;
    [lbl sizeToFit];
//    lbl.textColor= [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
    lbl.font=[UIFont boldSystemFontOfSize:10.0];
    lbl.backgroundColor=[UIColor clearColor];
    [ntabbar addSubview:lbl];
   }

-(IBAction)refreshPrject:(id)sender{
    
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
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                                       message:[NSString stringWithFormat: @"We will sync all %@ with your device, this will take some time, Are you sure you want to continue?", self.title]
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
                [self refreshProjectList:1];
            }
                break;
        }
    }
}


-(void)refreshProjectList:(int)xpageNo {
    
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
    dowloadproject *operation=[[dowloadproject alloc] initDownloadWithPageNo:1  andxtype:xatype];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:2 andxtype:xatype];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:3 andxtype:xatype];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:4 andxtype:xatype];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
    operation=[[dowloadproject alloc] initDownloadWithPageNo:5 andxtype:xatype];
    operation.managedObjectContext=self.managedObjectContext;
    operation.delegate=self;
    [_queue addOperation:operation];
}
-(void)doexception{
    [HUD hide:YES];
    UIAlertView *alert=[self getErrorAlert:@"Synchronize error, please try again later. Thanks for your patience."];
    [alert show];
}
-(void)finishone:(NSMutableArray *)result andPageNo:(int)pagen{
    
    if (iii==0) {
        tn =[[NSMutableArray alloc]init];
    }
    iii+=1;
    wcfProjectListItem *kv;
    kv = (wcfProjectListItem *)[result objectAtIndex:0];
    pageno=kv.TotalPage;
    [result removeObjectAtIndex:0];
    if (!scheduleyn) {
        kv= (wcfProjectListItem *)[result objectAtIndex:0];
        scheduleyn=kv.IDNumber;
    }
    [result removeObjectAtIndex:0];
    
    [tn addObjectsFromArray:[result copy]];
    
    cl_project *mp=[[cl_project alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
    if (pageno<5) {
        HUD.progress = 1;
        if (iii==5) {
            [HUD hide:YES];
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            
            [ntabbar setSelectedItem:nil];
            NSString *str;
            switch (xatype) {
                case 1:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
                    break;
                case 2:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
                    break;
                case 3:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0' ", [userInfo getCiaId]];
                    break;
                    
                default:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
                    break;
            }
            UILabel *lbl =(UILabel *)[ntabbar viewWithTag:14];
            lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", [Mysql stringFromDate:[[NSDate alloc]init]]];
            
            
            self.rtnlist=[mp getProjectList:str];
            self.rtnlist1=self.rtnlist;
//            [tbview reloadData];
            
//            if (self.islocked==2) {
//                if (![[self unlockPasscode] isEqualToString:@"0"] && ![[self unlockPasscode] isEqualToString:@"1"]) {
//                    
//                    [self.navigationItem setHidesBackButton:NO];
//                    
//                    [self enterPasscode:nil];
//                }else{
//                   
//                }
//                
//            }else{
//                rtnlist=[mp getProjectList:str];
//                rtnlist1=rtnlist;
//                [tbview reloadData];
//            }

        }
    }else{
        HUD.progress=iii*0.7/pageno;
        if (pageno==iii) {
            //            NSLog(@"%@", tn);
            
            {
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                
                [ntabbar setSelectedItem:nil];
                NSString *str;
                switch (xatype) {
                    case 1:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
                        break;
                    case 2:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
                        break;
                    case 3:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0' ", [userInfo getCiaId]];
                        break;
                        
                    default:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
                        break;
                }
                UILabel *lbl =(UILabel *)[ntabbar viewWithTag:14];
                lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", [Mysql stringFromDate:[[NSDate alloc]init]]];
                
                if (self.islocked==2) {
                    if (![[self unlockPasscode] isEqualToString:@"0"] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                        
                        [self.navigationItem setHidesBackButton:NO];
                        
                        [self enterPasscode:nil];
                    }else{
                        self.rtnlist=[mp getProjectList:str];
                        self.rtnlist1=self.rtnlist;
//                        [tbview reloadData];
                    }
                    
                }else{
                    self.rtnlist=[mp getProjectList:str];
                    self.rtnlist1=self.rtnlist;
//                    [tbview reloadData];
                }

                HUD.progress=1;
            }
            [HUD hide:YES];
            
        }
    }
}


- (void) xSearchProjectSyncHandler: (id) value {
    
    // Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        SoapFault *sf =value;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide];
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    if([result isKindOfClass:[wcfArrayOfProjectListItem class]]){
        if ([result count]==0) {
            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            HUD.progress = islocked;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [HUD hide];
            
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            
            [ntabbar setSelectedItem:nil];
            NSString *str;
            switch (xatype) {
                case 1:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
                    break;
                case 2:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
                    break;
                case 3:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0' ", [userInfo getCiaId]];
                    break;
                    
                default:
                    [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                    str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
                    break;
            }
            UILabel *lbl =(UILabel *)[ntabbar viewWithTag:14];
            lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", [Mysql stringFromDate:[[NSDate alloc]init]]];
            
            if (self.islocked==2) {
                if (![[self unlockPasscode] isEqualToString:@"0"] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                    
                    [self.navigationItem setHidesBackButton:NO];
                    
                    [self enterPasscode:nil];
                }else{
                    self.rtnlist=[mp getProjectList:str];
                    self.rtnlist1=self.rtnlist;
//                    [tbview reloadData];
                }
                
            }else{
                self.rtnlist=[mp getProjectList:str];
                self.rtnlist1=self.rtnlist;
//                [tbview reloadData];
            }
        }else{
            wcfProjectListItem *kv;
            
            
            kv = (wcfProjectListItem *)[result objectAtIndex:0];
            pageNo=kv.TotalPage;
            [result removeObjectAtIndex:0];
            
            kv= (wcfProjectListItem *)[result objectAtIndex:0];
            NSString *syn =kv.IDNumber;
            [result removeObjectAtIndex:0];
            
            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            
            if (currentPage==1) {
                [mp deletaAll:xatype];
            }
            [mp addToProject:result andscheleyn:syn];
            
            if (currentPage < pageNo) {
                
                currentPage=currentPage+1;
                [self refreshProjectList:currentPage];
            }else{
                HUD.progress =1;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                [HUD hide];
                
                cl_sync *ms =[[cl_sync alloc]init];
                ms.managedObjectContext=self.managedObjectContext;
                
                [ntabbar setSelectedItem:nil];
                NSString *str;
                switch (xatype) {
                    case 1:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
                        break;
                    case 2:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and isactive='1'", [userInfo getCiaId]];
                        break;
                    case 3:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0'", [userInfo getCiaId]];
                        break;
                        
                    default:
                        [ms updSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
                        str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
                        break;
                }
                UILabel *lbl =(UILabel *)[ntabbar viewWithTag:14];
                lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", [Mysql stringFromDate:[[NSDate alloc]init]]];
                
                if (self.islocked==2) {
                    if (![[self unlockPasscode] isEqualToString:@"0"] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                        
                        [self.navigationItem setHidesBackButton:NO];
                        
                        [self enterPasscode:nil];
                    }else{
                        self.rtnlist=[mp getProjectList:str];
                        self.rtnlist1=self.rtnlist;
//                        [tbview reloadData];
                    }
                    
                }else{
                    self.rtnlist=[mp getProjectList:str];
                    self.rtnlist1=self.rtnlist;
//                     NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
                                       
//                    [tbview reloadData];
                }
            }
        }
        
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(NSString *)getSearchCondition{
    NSString *str =[NSString stringWithFormat:@"((idnumber like [c]'%@*') or (planname like [c]'*%@*') or (name like [c]'*%@*')) and (idcia = %d)", searchtxt.text, searchtxt.text, searchtxt.text, [userInfo getCiaId]] ;
    
    switch (xatype) {
        case 1:
            str=[str stringByAppendingString :@" and status='Development'"];
            break;
        case 2:
            str=[str stringByAppendingString :@" and status<>'Development' and status<>'Closed' and isactive='1'"];
            break;
        case 3:
            str=[str stringByAppendingString :@" and status<>'Development' and status<>'Closed'  and isactive='0'"];
            break;
        default:
            str=[str stringByAppendingString :@"and status='Closed'"];
            break;
    }    return str;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
//    cl_project *mp =[[cl_project alloc]init];
//    mp.managedObjectContext=self.managedObjectContext;
//  
//    
//    rtnlist=[mp getProjectList:[self getSearchCondition]];
//    
//    [tbview reloadData];
    
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"name like [c]'*%@*' or planname like [c]'*%@*' or idnumber like [c]'%@*' or status like [c]'*%@*'", searchText, searchText, searchText,searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    self.rtnlist=[[self.rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
//    [tbview reloadData];
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.rtnlist count];
}




- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
     NSEntityDescription *kv =[self.rtnlist objectAtIndex:(indexPath.row)];
    
//    NSLog(@"%@ %@", [kv valueForKey:@"idnumber"], [kv valueForKey:@"status"]);
     cell.textLabel.text = [kv valueForKey:@"name"];
//    cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0];
    if ([[kv valueForKey:@"status"] isEqualToString:@"Development"]) {
        cell.detailTextLabel.text=@"Development";
    }else{
        if([kv valueForKey:@"planname"]==nil){
            [cell.detailTextLabel setNumberOfLines:0];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"\n%@", [kv valueForKey:@"status"]];
        }else{
            [cell.detailTextLabel setNumberOfLines:0];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", [kv valueForKey:@"planname"], [kv valueForKey:@"status"]];
        }
        
    }
   
    
    
    
    [cell .imageView setImage:nil];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    
    return 66*(font.pointSize/15.0);
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
    NSEntityDescription *kv =[self.rtnlist objectAtIndex:(indexPath.row)];
    
    if ([self.title isEqualToString:@"Task Due"]) {
        newSchedule2 *ns =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"newSchedule2"];
        ns.managedObjectContext=self.managedObjectContext;
        ns.xidproject=[kv valueForKey:@"idnumber"];
        ns.xidstep=@"-1";
        ns.title=@"Task Due List";
        [self.navigationController pushViewController:ns animated:YES];
    }else{
        if (xatype==1) {
            development *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"development"];
            LoginS.managedObjectContext=self.managedObjectContext;
            LoginS.idproject=[kv valueForKey:@"idnumber"];
            [self.navigationController pushViewController:LoginS animated:YES];
        }else{
            project *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"project"];
            LoginS.idproject=[kv valueForKey:@"idnumber"];
            LoginS.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:LoginS animated:YES];
        }
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end