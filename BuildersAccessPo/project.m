//
//  project.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "project.h"
#import "userInfo.h"
#import "Mysql.h"
#import "cl_favorite.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "cl_project.h"
#import "Reachability.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI
#import "phoneDetail.h"
#import "cl_sync.h"
#import "MBProgressHUD.h"
#import "cl_phone.h"
#import "startPark.h"
#import "website.h"
#import "projectpo.h"
#import "projectSuggestPrice.h"
#import "projectcols.h"
#import "projectaddc.h"
#import "qainspectionb.h"
#import "qainspection.h"
#import "requestedvpols.h"
#import "newSchedule1.h"
#import "contractforapproveupd.h"
#import "developmentVendorLs.h"
//#import "ZSYPopoverListView.h"
#import "projectPhotoFolder.h"
#import "ProjectPhotoName.h"
#import "newSchedule2.h"
#import "projectContractFiles.h"

@interface project ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate, UITabBarDelegate>{
    MBProgressHUD *HUD;
    UIAlertView *myAlertView;
    int y;
    BOOL isaddfavorite;
    NSURL *turl;
    wcfProjectItem* result;
    NSMutableArray *rtnfiles;
    BOOL isshow;
    wcfProjectFile *key;
    NSString *xtoemail;
    NSString *xtoename;
    NSMutableArray *uploadLs;
    NSMutableArray *pmLs;
    NSMutableArray *pmEmailLs;
}


@end
@implementation project
@synthesize idproject,ntabbar, docController;

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
    }else if ([item.title isEqualToString:@"Remove"]) {
        [self addtoFavorite: item];
    }else if ([item.title isEqualToString:@"Favorite"]) {
        [self addtoFavorite: item];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self refreshPrject: item];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [Mysql groupTableViewBackgroundColor];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    self.title=[userInfo getCiaName];
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
    ntabbar.delegate= self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    
    cl_favorite *mf =[[cl_favorite alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    if ([mf isInFavorite:self.idproject]) {
        [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"favorite_delete.png"] ];
        [[ntabbar.items objectAtIndex:1]setTitle:@"Remove" ];
        isaddfavorite=NO;
    }else{
        [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"favorite_add.png"] ];
        [[ntabbar.items objectAtIndex:1]setTitle:@"Favorite" ];
        isaddfavorite=YES;
    }
//    [[ntabbar.items objectAtIndex:1] setAction:@selector(addtoFavorite:)];
    
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    
    [self getDetail];
    
}

-(void)gotoprofile:(NSString *)xemail1{
    xemail=xemail1;
    
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
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        xtoemail=xemail;
        [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp isFirttimeToSync:result.mastercia :@"5"]) {
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"This is the first time, we will sync Phone List with your device, this will take some time, Are you sure you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 3;
            [alert show];
        }else{
            
            phoneDetail *pd =[self.storyboard instantiateViewControllerWithIdentifier:@"phoneDetail"];
            pd.managedObjectContext=self.managedObjectContext;
            pd.email =xemail;
            pd.idmaster=result.mastercia;
            pd.ename=xtoename;
            [self.navigationController pushViewController:pd animated:YES];
        }
    }
    
    
}
-(void)contactPm1:(int) row{
    xtoename=[pmLs objectAtIndex:row];
    [self gotoprofile:[pmEmailLs objectAtIndex:row]];
}
-(void)contactSales1{
    xtoename=result.Sales1;
    [self gotoprofile:result.Sales1Email];
}
-(void)contactSales2{
    xtoename=result.Sales2;
    [self gotoprofile:result.Sales2Email];
}


-(IBAction)refreshPrject:(id)sender{
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
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self getDetail];
    }
    
    
}



-(IBAction)addtoFavorite:(id)sender{
    cl_favorite *mf =[[cl_favorite alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    if(isaddfavorite){
        if ([mf addToFavorite:self.idproject]) {
            UIAlertView *alert=[self getSuccessAlert:@"Add to Favorite successfully."];
            alert.tag=1;
            alert.delegate=self;
            [alert show];
        } ;
    }else{
        if ( [mf removeFromFavorite:self.idproject]) {
            UIAlertView *alert=[self getSuccessAlert:@"Remove from Favorite successfully."];
            alert.tag=2;
            alert.delegate=self;
            [alert show];
            
        };
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   
   if (alertView.tag==101){
         switch (buttonIndex) {
             case 2:
             {
                 UIImagePickerController *p = [[UIImagePickerController alloc]init];
                 p.delegate=self;
                 p.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                 [self presentViewController:p animated:YES completion:nil];
             }
                 break;
                 
             case 1:
             {
                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                     UIImagePickerController *p = [[UIImagePickerController alloc]init];
                     p.delegate=self;
                     p.sourceType=UIImagePickerControllerSourceTypeCamera;
                     [self presentViewController:p animated:YES completion:nil];
                     
                     
                 }else{
                     [[self getErrorAlert:@"There is no camera available."] show];
                 }
                 
                 
             }
         }
    }else{
    switch (buttonIndex) {
       
        case 0:
            if (alertView.tag==1) {
                [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"favorite_delete.png"] ];
                [[ntabbar.items objectAtIndex:1]setTitle:@"Remove" ];
                [ntabbar setSelectedItem:nil];
                isaddfavorite=NO;
            }else if (alertView.tag==2){
                [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"favorite_add.png"] ];
                [[ntabbar.items objectAtIndex:1]setTitle:@"Favorite" ];
                [ntabbar setSelectedItem:nil];
                isaddfavorite=YES;
            }
            break;
        case 1:{
            if (alertView.tag==10) {
                [[UIApplication sharedApplication] openURL:turl];
            }else if(alertView.tag==3){
                [self doSyncPhoneList];
            }
        }
            break;
            
    }
    }
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    
}

- (void)scaleImage:(UIImage *)image

{
    
    ProjectPhotoName *pn =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ProjectPhotoName"];
    pn.managedObjectContext=self.managedObjectContext;
    pn.idproject=self.idproject;
    pn.isDevelopment=NO;
    pn.imgsss=image;
    pn.isPhoto=NO;
    [self.navigationController pushViewController:pn animated:YES];

}
-(void)doSyncPhoneList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
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
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: result.mastercia EquipmentType: @"3"];
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
    NSMutableArray* result7 = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result7 andidcia:result.mastercia];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync: result.mastercia:@"5" :[[NSDate alloc]init]];
    
    [HUD hide];
    [ntabbar setSelectedItem:nil];
    phoneDetail *pd =[self.storyboard instantiateViewControllerWithIdentifier:@"phoneDetail"];
    pd.managedObjectContext=self.managedObjectContext;
    pd.email =xtoemail;
    pd.idmaster=result.mastercia;
    pd.ename=xtoename;
    [self.navigationController pushViewController:pd animated:YES];
    
}



-(void)getDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        NSLog(@"[userInfo getUserPwd] %@ %@", [userInfo getUserPwd], self.idproject);
        [service xGetProject:self action:@selector(xGetProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: self.idproject xtype: 0 EquipmentType: @"3"];
        
    }
    
}

- (void) xGetProjectHandler: (id) value {
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        
        return;
    }

    
    
	// Do something with the wcfProjectItem* result
    result = (wcfProjectItem*)value;
    
    [self drawScreen1];
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [service xGetProjectFiles:self action:@selector(xGetProjectFilesHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: self.idproject EquipmentType: @"3"];
    }
    
    
    
    
    
}

- (void) xGetProjectFilesHandler: (id) value {
    
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
    rtnfiles = (NSMutableArray*)value;
	[self drawScreen2];
    
    cl_project *cp =[[cl_project alloc]init];
    cp.managedObjectContext=self.managedObjectContext;
    [cp updProject:result andId:idproject];
    
    cl_favorite *cf =[[cl_favorite alloc]init];
    cf.managedObjectContext=self.managedObjectContext;
    [cf updProject:result andId:idproject];
    
    [ntabbar setSelectedItem:nil];
}

-(void) drawScreen1{
    y=10;
    
    UIScrollView *sv = self.uv;
    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    for (UIView *ii in sv.subviews) {
        [ii removeFromSuperview];
    }
//    cl_project *cp =[[cl_project alloc]init];
//    cp.managedObjectContext=self.managedObjectContext;
//    wcfProjectItem *wi= [[wcfProjectItem alloc]init];

    
    UITableView *uv =(UITableView *)[sv viewWithTag:4];
    if (uv !=nil) {
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:5];
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:6];
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:9];
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:10];
        [uv reloadData];
    }else{
        UILabel *lbl;
        float rowheight=32.0;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text=[NSString stringWithFormat:@"Project # %@", idproject];
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int tmph =rowheight*4;
        if(result.Stage !=nil){
            
            if ([result.Status isEqualToString:@"Sold"]|| [result.Status isEqualToString:@"Closed"]) {
                tmph=tmph+10;
            }else{
                tmph=tmph+52;
            }
        }
        if ([result.Status isEqualToString:@"Sold"]|| [result.Status isEqualToString:@"Closed"]) {
            tmph=tmph+10;
        }
        UIView *lbl1;
        
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, tmph)];
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.layer.cornerRadius=10.0;
        [sv addSubview:lbl1];
      
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, rowheight-1)];
        lbl.text=result.Name;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
          UITableView *ciatbview;
        if(result.Stage ==nil){
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, self.view.frame.size.width-20, rowheight-1)];
            lbl.text=@"Schedule Not Started";
            lbl.textColor=[UIColor redColor];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:16.0];
            [sv addSubview:lbl];
             y=y+rowheight;
        }else{
//            lbl.text=result.Stage;
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, 41)];
            ciatbview.tag=17;
            ciatbview.separatorColor=[UIColor clearColor];
            [ciatbview setRowHeight:41];
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
              y=y+42;
            if (![result.Status isEqualToString:@"Sold"] && ![result.Status isEqualToString:@"Closed"]) {
                ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, 41)];
                ciatbview.tag=57;
                ciatbview.separatorColor=[UIColor clearColor];
                [ciatbview setRowHeight:41];
                ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
                [sv addSubview:ciatbview];
                ciatbview.delegate = self;
                ciatbview.dataSource = self;
                y=y+42;
            }
            
            
        }
        
       
       
        
        if ([result.Status isEqualToString:@"Sold"]|| [result.Status isEqualToString:@"Closed"]) {
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, 41)];
            ciatbview.tag=18;
            ciatbview.separatorColor=[UIColor clearColor];
            [ciatbview setRowHeight:41];
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
             y=y+42;
        }else{
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, self.view.frame.size.width-20, rowheight-1)];
            lbl.text=result.Status;
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:16.0];
            [sv addSubview:lbl];
             y=y+rowheight;
            
        }
        
       
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, self.view.frame.size.width-20, rowheight-1)];
        if ([result.Status isEqualToString:@"Specs"]) {
            lbl.text=[NSString stringWithFormat:@"Asking  $ %@", result.Asking];
        }
        
         if (![result.Status isEqualToString:@"Specs"] && [result.Sold intValue]>0){
            lbl.text=[NSString stringWithFormat:@"Sold  $ %@", result.Sold];
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        
        
        y=y+10;
        
        
        if (result.Askingyn && [result.Status isEqualToString:@"Specs"]) {
            y=y+5;
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=16;
            [ciatbview setRowHeight:44];
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+44+10;
        }
        
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Legal Description";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*4)];
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.layer.cornerRadius=10.0;
        [sv addSubview:lbl1];
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, rowheight-1)];
        lbl.backgroundColor=[UIColor clearColor];
        if (result.Permit !=nil) {
            lbl.text=[NSString stringWithFormat:@"City Permit:  %@", result.Permit ];
            lbl.font=[UIFont systemFontOfSize:16.0];

            [sv addSubview:lbl];
        }else{
           lbl.text=@"City Permit:";
            CGRect rect2 = CGRectMake(20, y+4, 92, rowheight-1);
            lbl.frame=rect2;
//            rect2 = CGRectMake(lbl.frame.size.width+10, 0, 295, 32);
            lbl.font=[UIFont systemFontOfSize:16.0];
            [sv addSubview:lbl];
            rect2 = CGRectMake(110, y+4, 92, rowheight-1);
            UILabel * label1= [[UILabel alloc]initWithFrame:rect2];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.font=[UIFont systemFontOfSize:16.0];
            label1.text=@"n / a";
            label1.textColor=[UIColor redColor];
            [sv addSubview:label1];
        }
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, self.view.frame.size.width-20, rowheight-1)];
        if(result.Lot ==nil){
            lbl.text=@"Lot:";
        }else{
            lbl.text=[NSString stringWithFormat:@"Lot:  %@", result.Lot ];
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, self.view.frame.size.width-20, rowheight-1)];
        if(result.Block ==nil){
            lbl.text=@"Block:";
        }else{
            lbl.text=[NSString stringWithFormat:@"Block:  %@", result.Block ]; }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, self.view.frame.size.width-30, rowheight-1)];
        if(result.Section ==nil){
            lbl.text=@"Section:";
        }else{
            lbl.text=[NSString stringWithFormat:@"Section:  %@", result.Section ];
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight+10;
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Floorplan";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int rtn =4;
        if (result.Reverseyn ) {
            rtn=rtn+1;
        }
        if (result.Repeated){
            rtn=rtn+1;
        }
        
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*rtn)];
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.layer.cornerRadius=10.0;
        [sv addSubview:lbl1];
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, rowheight-1)];
        lbl.backgroundColor=[UIColor clearColor];
        if (result.IDFloorplan !=nil) {
            lbl.text=[NSString stringWithFormat:@"Plan No. %@", result.IDFloorplan ];
        }else{
            lbl.text=@"Plan No.";
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, self.view.frame.size.width-20, rowheight-1)];
        if (result.PlanName==nil) {
            lbl.text=@"n / a";
            lbl.textColor=[UIColor redColor];
        }else{
            lbl.text=result.PlanName;
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, self.view.frame.size.width-20, rowheight-1)];
        if (result.Bedrooms ==nil || result.Baths == nil) {
            lbl.text=@"Beds  / Baths ";
        }else if (result.Bedrooms ==nil ) {
            lbl.text=[NSString stringWithFormat:@"Beds  / Baths %@", result.Baths];
        }else if(result.Baths==nil){
            lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths ", result.Bedrooms];
        }else{
            lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths %@", result.Bedrooms, result.Baths];
        }   
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, self.view.frame.size.width-30, rowheight-1)];
        if(result.Garage !=nil){
            lbl.text=[NSString stringWithFormat:@"Garage %@", result.Garage];
        }else{
            lbl.text=@"Garage";
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        if (result.Reverseyn ) {
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width-20, rowheight-1)];
            lbl.text=@"Builder Reverse";
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:16.0];
            [sv addSubview:lbl];
            y=y+rowheight-1;
        }
        
        if (result.Repeated){
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y-1, self.view.frame.size.width-20, rowheight-1)];
            lbl.text=@"Repeated Plan";
            lbl.backgroundColor=[UIColor clearColor];
            lbl.font=[UIFont systemFontOfSize:16.0];
            [sv addSubview:lbl];
            y=y+rowheight-1;
        }
        y=y+10;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Brochure";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        rtn=1;
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rtn*44)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=10;
        
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+rtn*44+10;
        
        uploadLs =[[NSMutableArray alloc]init];
        if ([result.AddPhoto intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload Photos (%@)", result.AddPhoto]];
        }
        if ([result.AddPMNotes intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload PM Notes (%@)", result.AddPMNotes]];
        }
        
        if ([uploadLs count]>0) {
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, [uploadLs count]*44)];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=30;
            
            [ciatbview setRowHeight:44.0f];
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+[uploadLs count]*44+10;
        }
            
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Quick Link";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        
        qllist =[[NSMutableArray alloc]init];
        if (result.HasVendorYN) {
            [qllist addObject:@"Preferred Vendors"];
        }else{
            [qllist addObject:@"Preferred vendors not assigned"];
        }
        
        //april
        if (![result.requestvpo isEqualToString:@"0"]) {
            [qllist addObject:@"Requested VPO"];
        }
        if (result.poyn) {
//            if ([[userInfo getUserName] isEqualToString:@"roberto@buildersaccess.com"]) {
//                [qllist addObject:@"Create Purchase Order"];
//            }
            
            [qllist addObject:@"Purchase Order"];
        }
        if (result.coyn) {
            [qllist addObject:@"Change Order"];
        }
        if (result.contractyn) {
            if (![result.contractCnt isEqualToString:@"0"]){
             [qllist addObject:[NSString stringWithFormat:@"Contract(%@)", result.contractCnt]];
            }
           
        }
        if ([result.Status isEqualToString:@"Sold"] || [result.Status isEqualToString:@"Closed"]) {
            [qllist addObject:@"Addendum C"];
        }
        
        [qllist addObject:@"Start Pack"];
        [qllist addObject:@"Interior Selection List"];
        [qllist addObject:@"Interior Selection Pictures"];
        [qllist addObject:@"Exterior Selection List"];
        [qllist addObject:@"Exterior Selection Picture"];
        if (![result.IdQaInspection isEqualToString:@"0"]) {
             [qllist addObject:@"QA Inspection"];
        }
        
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, [qllist count]*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=15;
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+[qllist count]*44+10;
        
    }
    
    
}
-(void) drawScreen2{
    
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    UITableView *uv =(UITableView *)[sv viewWithTag:7];
    if (uv !=nil) {
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:8];
        [uv reloadData];
        
        uv=(UITableView *)[sv viewWithTag:11];
        [uv reloadData];
        
    }else{
        
        float rowheight=32.0;
        UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text= [NSString stringWithFormat:@"Base Plans (Rev.%d)", result.Revision];
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        UITableView* ciatbview;
        int  rtn=[rtnfiles count];
        if (result.UnderRevision ||result.ForPermitting) {
            
            rtn=0;
            if (result.UnderRevision) {
                rtn=rtn+1;
            }
            if (result.ForPermitting) {
                rtn=rtn+1;
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rtn*44)];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.separatorColor=[UIColor clearColor];
            ciatbview.tag=9;
            [ciatbview setRowHeight:rowheight];
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+44*rtn+10;
        }else{
            if (rtn==0) {
                rtn=1;
            }
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rtn*44.0)];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=7;
            [ciatbview setRowHeight:44.0f];
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            
            y=y+44*rtn+10;
        }
        
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Project Manager";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        pmLs=[[NSMutableArray alloc]init];
        pmEmailLs=[[NSMutableArray alloc]init];
        if (result.PM1) {
            [pmLs addObject:result.PM1];
            if (result.PM1Email) {
            [pmEmailLs addObject:result.PM1Email];
            }else{
            [pmEmailLs addObject:@""];
            }
            
        }
        if (result.PM2) {
            [pmLs addObject:result.PM2];
//            [pmEmailLs addObject:result.PM2Email];
            if (result.PM2Email) {
                [pmEmailLs addObject:result.PM2Email];
            }else{
                [pmEmailLs addObject:@""];
            }
        }
//        NSLog(@"%@ %@ %@ %@", result.PM3, result.PM4, result.PM3Email, result.PM4Email);
        if (result.PM3) {
            [pmLs addObject:result.PM3];
//            [pmEmailLs addObject:result.PM3Email];
            if (result.PM3Email) {
                [pmEmailLs addObject:result.PM3Email];
            }else{
                [pmEmailLs addObject:@""];
            }
        }
        if (result.PM4) {
            [pmLs addObject:result.PM4];
            if (result.PM4Email) {
                [pmEmailLs addObject:result.PM4Email];
            }else{
                [pmEmailLs addObject:@""];
            }
//            [pmEmailLs addObject:result.PM4Email];
        }
        
        rtn=[pmLs count];
        if (rtn==0) {
            rtn=1;
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=8;
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Sales Consultant";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        rtn=2;
        if (!result.Sales1) {
            rtn=rtn-1;
        }
        if(!result.Sales2){
            rtn=rtn-1;
        }
        if (rtn==0) {
            rtn=1;
        }
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=11;
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;

        
        sv.contentSize=CGSizeMake(self.view.frame.size.width,y+25);
    }
}





- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        if (tableView.tag==30) {
            cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            cell.textLabel.text =[uploadLs objectAtIndex:indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            [cell .imageView setImage:nil];
        }else{
        if (tableView.tag!=7 && tableView.tag!=10 && tableView.tag!=8 && tableView.tag!=11 && tableView.tag!=15 && tableView.tag!=16 && tableView.tag!=17 && tableView.tag!=18 && tableView.tag!=57) {
            cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 32)];
            CGRect rect = CGRectMake(10, 0, 295, 32);
            UILabel * label= [[UILabel alloc]initWithFrame:rect];
            label.textAlignment=NSTextAlignmentLeft;
            label.font=[UIFont systemFontOfSize:16.0];
            switch (tableView.tag) {
                                case 9:{
                    switch (indexPath.row){
                        case 0:
                            if (result.UnderRevision) {
                                label.text =@"Plans Under Revision";
                                label.textColor=[UIColor redColor];
                            }else{
                                label.text =@"For Permitting Only";
                                label.textColor=[UIColor redColor];
                            }
                            
                            
                            break;
                        default:
                            if (result.UnderRevision && result.ForPermitting) {
                                label.text =@"For Permitting Only";
                                label.textColor=[UIColor redColor];
                            }
                            
                            break;
                    }
                }
                    
                    break;
                    
        
                    
                    
                default:
                    break;
                    
            }
            
            [cell.contentView addSubview:label];
            cell.userInteractionEnabled = NO;
        }else if(tableView.tag==8){
            
            if ([pmLs count]==0) {
                cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 44)];
                CGRect rect = CGRectMake(10, 0, 295, 44);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                label.text=@"n / a";
                label.textColor=[UIColor redColor];
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }else{
               
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;                
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                
                [cell .imageView setImage:nil];
                
                cell.textLabel.text=[pmLs objectAtIndex:indexPath.row];

            }
            
        }else if(tableView.tag==11){
            if (result.Sales1==nil && result.Sales2==nil) {
                cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 44)];
                CGRect rect = CGRectMake(10, 0, 295, 44);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                label.text=@"n / a";
                label.textColor=[UIColor redColor];
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }else{
                if (cell == nil){
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;                }
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                [cell .imageView setImage:nil];
                switch (indexPath.row){
                    case 0:
                        if (result.Sales1 !=nil) {
                            cell.textLabel.text=result.Sales1;
                        }else{
                            cell.textLabel.text=result.Sales2;
                        }
                        break;
                    case 1:
                        cell.textLabel.text=result.Sales2;
                        break;
                }
            }
        }else if(tableView.tag==10){
            if (result.Brochure) {
                if (cell == nil){
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;                }
                cell.textLabel.text =@"Download Brochure";
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                
                [cell .imageView setImage:nil];
                
            }else{
                cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 44)];
                CGRect rect = CGRectMake(10, 0, 295, 44);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                label.text=@"n / a";
                label.textColor=[UIColor redColor];
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }
            
        }else if(tableView.tag==7){
            
            if ([rtnfiles count]==0) {
                cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 44)];
                CGRect rect = CGRectMake(10, 0, 295, 44);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                label.text=@"n / a";
                label.textColor=[UIColor redColor];
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }else{
                
                    cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;                
                wcfProjectFile *pf =[rtnfiles objectAtIndex:indexPath.row];
                cell.textLabel.text =pf.Name;
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                [cell .imageView setImage:nil];

            }
        }else if(tableView.tag==15){
            if (cell == nil){
                cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;            }
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            [cell .imageView setImage:nil];
            if (indexPath.row==0 && !result.HasVendorYN) {
                cell.textLabel.text=[qllist objectAtIndex:indexPath.row];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor=[UIColor redColor];
                cell.userInteractionEnabled = NO;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }else{
                cell.textLabel.text=[qllist objectAtIndex:indexPath.row];
            }
            
        
         }else if(tableView.tag==16){
            if (cell == nil){
                cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;            }
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            [cell.imageView setImage:nil];
             cell.textLabel.text=@"Suggest New Price";
         }else if(tableView.tag==57){
             if (cell == nil){
                 cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                 cell.selectionStyle = UITableViewCellSelectionStyleBlue;            }
             cell.textLabel.font=[UIFont systemFontOfSize:16.0];
             [cell.imageView setImage:nil];
             cell.textLabel.text=@"Task Due";
         }else if(tableView.tag==18){
             if (cell == nil){
                 cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                 cell.selectionStyle = UITableViewCellSelectionStyleBlue;            }
             cell.textLabel.font=[UIFont systemFontOfSize:16.0];
             [cell.imageView setImage:nil];
             cell.textLabel.text=result.Status;
         }else{
             if (cell == nil){
                 cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                 cell.selectionStyle = UITableViewCellSelectionStyleBlue;            }
             cell.textLabel.font=[UIFont systemFontOfSize:16.0];
             [cell.imageView setImage:nil];
             cell.textLabel.text=[NSString stringWithFormat:@"%@", result.Stage];
         }}
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int rtn;
    switch (tableView.tag) {
        case 30:
            rtn=[uploadLs count];
            break;
        case 15:
            rtn=[qllist count];
            break;
        case 16:
        case 18:
        case 17:
        case 57:
            rtn=1;
            break;
        case 8:
            if ([pmLs count]==0) {
                rtn=1;
            }else{
                rtn=[pmLs count];
            }
            break;
            case 11:
            rtn=2;
            if (!result.Sales1) {
                rtn=rtn-1;
            }
            if(!result.Sales2){
                rtn=rtn-1;
            }
            if (rtn==0) {
                rtn=1;
            }
            break;
        case 7:{
            rtn=[rtnfiles count];
            if (rtn==0) {
                rtn=1;
            }
        }
            break;
        case 9:
            rtn=0;
            if (result.UnderRevision) {
                rtn=rtn+1;
            }
            if (result.ForPermitting) {
                rtn=rtn+1;
            }
            break;
        case 10:
            rtn=1;
            break;
            
        default:
            rtn=4;
            break;
    }
    return rtn;
}


-(void)viewWillAppear:(BOOL)animated{
    [ntabbar setSelectedItem:nil];
    [self getDetail];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tbview=tableView;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
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
        NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
        [tbview deselectRowAtIndexPath:indexPath animated:YES];
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            if (tbview.tag==7) {
                key =(wcfProjectFile *)[rtnfiles objectAtIndex:indexPath.row];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Download Project File...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
//                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Project File..." delegate:self otherButtonTitles:nil];
               
               //                [alertViewWithProgressbar show];
                NSString *str;
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                wcfService *service=[wcfService service];
                
                
                str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
                     NSASCIIStringEncoding];
                
                NSString* escapedUrlString =
                [[NSString stringWithFormat:@"<view> %@", key.FName] stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
                
                [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Project File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
                
            } else if (tbview.tag==8) {
                [self contactPm1:indexPath.row];
                
            } else if (tbview.tag==11) {
                if (indexPath.row==0) {
                    if ( result.Sales1) {
                        [self contactSales1];
                    }else{
                        [self contactSales2];
                    }
                    
                }else{
                    [self contactSales2];
                }
                
                
            } else if (tbview.tag==10) {
                // @"Download Project Brochure..."
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Download Project Brochure...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
               [HUD show:YES];
                
                wcfService *service=[wcfService service];
                
                NSString *str;
                str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
                     NSASCIIStringEncoding];
                
                NSString* escapedUrlString =
                [[NSString stringWithFormat:@"<view> %@_brochure.pdf", result.Name] stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
                [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Download Brochure" keyname: str filename: escapedUrlString EquipmentType: @"3"];
                
                

                
               
//                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Project Brochure..." delegate:self otherButtonTitles:nil];
               
//                [alertViewWithProgressbar show];
            }else if (tbview.tag==15) {
                
                BAUITableViewCell *ccell = [tbview cellForRowAtIndexPath:indexPath];
                NSString *str =[qllist objectAtIndex:indexPath.row];
                
                NSString *surl;
                if ([str isEqualToString:@"Purchase Order"]) {
                    //po
                    [self getProjectPo];
                    
//                }else if ([str isEqualToString:@"Create Purchase Order"]) {
//                        //po
//                        [self getPoAssembly];
                }else if([str isEqualToString:@"Requested VPO"]){
                    
                    
                    requestedvpols *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"requestedvpols"];
                    LoginS.managedObjectContext=self.managedObjectContext;
                    LoginS.xtype=8;
                    LoginS.idproject=self.idproject;
                    LoginS.title=@"Requested VPO";
                    [self.navigationController pushViewController:LoginS animated:YES];
                    
                }else if([str isEqualToString:@"Addendum C"]){
                    projectaddc *a =[self.storyboard instantiateViewControllerWithIdentifier:@"projectaddc"];;
                    a.managedObjectContext=self.managedObjectContext;
                    a.idproject=self.idproject;
                    [self.navigationController pushViewController:a animated:YES];
                    
                }else if([str isEqualToString:@"Change Order"]){
                    
                    [self getCols];
                }else if([str hasPrefix: @"Contract("]){
                    [self gotoContractFiles: str];
                }else if ([str isEqualToString:@"Preferred Vendors"]) {
                        developmentVendorLs *dl = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"developmentVendorLs"];
                        dl.managedObjectContext=self.managedObjectContext;
                        dl.idproject=self.idproject;
                    dl.idmaster=result.mastercia;
                        [self.navigationController pushViewController:dl animated:YES];
                }else if([str isEqualToString:@"Start Pack"]){
                    startPark *cc = [self.storyboard instantiateViewControllerWithIdentifier:@"startPark"];
                    cc.idproject=self.idproject;
                    cc.managedObjectContext=self.managedObjectContext;
                    [self.navigationController pushViewController:cc animated:YES];
                }else if([str isEqualToString:@"QA Inspection"]){
                    
                    wcfService* service = [wcfService service];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    [service xGetQACalendarStatus:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:result.IdQaInspection EquipmentType:@"3"];
                }else{
                    if ([str isEqualToString:@"Interior Selection List"]) {
                        if (result.newinterior ) {
                            surl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/interiorSelectionList.aspx?email=%@&password=%@&idcia=%@&idproject=%@&mastercia=%@&EquipmentType=3&idfloorplan=%@",[userInfo getUserName],[userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] , idproject, result.mastercia, result.IDFloorplan];
                        }else{
                            surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewlist.aspx?xidcia=%@&xidproject=%@&xtype=1", result.Elovecia, idproject];
                        }
                        
                    }else if([str isEqualToString:@"Interior Selection Pictures"]){
                        surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewselection.aspx?xidcia=%@&xidproject=%@&xtype=1", result.Elovecia, idproject];
                    }else if([str isEqualToString:@"Exterior Selection List"]){
                        if (result.newexterior) {
                        surl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/ExteriorSelectionList.aspx?email=%@&password=%@&idcia=%@&idproject=%@&mastercia=%@&EquipmentType=3&idfloorplan=%@",[userInfo getUserName],[userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] , idproject, result.mastercia, result.IDFloorplan];
                        }else{
                            surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewlist.aspx?xidcia=%@&xidproject=%@&xtype=2", result.Elovecia, idproject];
                        }
                    }else{
                        surl=[NSString stringWithFormat:@"http://www.buildersaccess.com/Intranet/net/viewselection.aspx?xidcia=%@&xidproject=%@&xtype=2", result.Elovecia, idproject];
                    }
                    NSLog(@"%@", surl);
                    website *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"website"];
                    LoginS.managedObjectContext=self.managedObjectContext;
                    LoginS.title=ccell.textLabel.text;
                    LoginS.Url = surl;
                    [self.navigationController pushViewController:LoginS animated:YES];
                }
                }else if (tbview.tag==16) {
                    wcfService* service = [wcfService service];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    [service xFoundForApprove:self action:@selector(xFoundForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:idproject];
                }else if (tbview.tag==17) {
//                    if ([[[userInfo getUserName] lowercaseString] isEqualToString:@"roberto@buildersaccess.com"]) {
                        newSchedule1 * ns =[self.storyboard instantiateViewControllerWithIdentifier:@"newSchedule1"];
                        ns.xidproject = self.idproject;
                        ns.managedObjectContext=self.managedObjectContext;
                        ns.isshowTaskDue=!result.ArchiveYN;
                        [self.navigationController pushViewController:ns animated:YES];
//                    }
                }else if (tbview.tag==57) {
                    newSchedule2 *ns =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"newSchedule2"];
                    ns.managedObjectContext=self.managedObjectContext;
                    ns.xidproject=self.idproject;
                    ns.xidstep=@"-1";
                    ns.title=@"Task Due List";
                    [self.navigationController pushViewController:ns animated:YES];
                }else if (tbview.tag==18) {
                    if (result.IdContract==nil) {
                        UIAlertView *alert=[self getErrorAlert:@"There is no Contract with this project."];
                        [alert show];
                    }else{
                        contractforapproveupd *a =[self.storyboard instantiateViewControllerWithIdentifier:@"contractforapproveupd"];
                        a.managedObjectContext=self.managedObjectContext;
                        a.oidcia=[NSString stringWithFormat:@"%d", [userInfo getCiaId]];
                        a.xfromtype=2;
                        //                    a.title=[NSString stringWithFormat:@"Contract-%@", @"1025"];
                        a.ocontractid=result.IdContract;
                        [self.navigationController pushViewController:a animated:YES];
                    }
                 }else if (tbview.tag==30) {
                     
                     NSString *key1 =[uploadLs objectAtIndex:indexPath.row];
                     if ([key1 hasPrefix:@"Upload Photos"]) {
                         
                         projectPhotoFolder *pf =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectPhotoFolder"];
                         pf.managedObjectContext=self.managedObjectContext;
                         pf.idproject=self.idproject;
                         pf.isDevelopment=NO;
                         [self.navigationController pushViewController:pf animated:YES];
                     }else{

                         UIAlertView *alert = nil;
                         alert = [[UIAlertView alloc]
                                  initWithTitle:@"BuildersAccess"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"New Photo",@"Choose from Library", nil];
                         alert.tag = 101;
                         [alert show];
                     }
            }
        }
    }
    
    
}


-(void)gotoContractFiles:(NSString *) str{
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [service xGetProjectContractFiles:self action: @selector(xGetProjectContractFilesHandler:)  xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]  projectid:idproject EquipmentType:@"3"];
    
}

- (void) xGetProjectContractFilesHandler: (id) value {
    
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
    
    wcfArrayOfProjectFile* result2 = (wcfArrayOfProjectFile*)value;
    if (result2.count == 1) {
        wcfProjectFile *item = [result2.items firstObject];
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"Download Project's Contract File...";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        //                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Project File..." delegate:self otherButtonTitles:nil];
        
        //                [alertViewWithProgressbar show];
        NSString *str;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        NSString *url1 = [NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname%@", item.ID, [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue], item.FSize, [item.FName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        wcfService* service = [wcfService service];
        str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
             NSASCIIStringEncoding];
        
        NSString* escapedUrlString =
        [[NSString stringWithFormat:@"<view> %@", item.FName] stringByAddingPercentEscapesUsingEncoding:
         NSASCIIStringEncoding];
        
        [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Project File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
        
        NSURL *url = [NSURL URLWithString:url1];
        turl = url;
        [self downloadFile: url];
        
        //                NSData *data = [NSData dataWithContentsOfURL:url];
    }else{
        projectContractFiles *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"projectContractFiles"];
        pl.managedObjectContext=self.managedObjectContext;
        pl.title=@"Contract Files";
        pl.idproject = self.idproject;
        pl.projectname = result.Name;
        pl.fileListresult = result2.items;
        
        [self.navigationController pushViewController:pl animated:YES];
    }
    
}

-(void) downloadFile:(NSURL *)url
{
//    NSURL * url = [NSURL URLWithString:@"https://s3.amazonaws.com/hayageek/downloads/SimpleBackgroundFetch.zip"];
    
//    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
//    dispatch_async(dispatch_get_global_queue(qos, 0)) {
//        let imageData = NSData(contentsOfURL: url)
//        dispatch_async(dispatch_get_main_queue()){
//            if url == self.imageURL{
//                if imageData != nil{
//                    self.image = UIImage(data: imageData!)
//                }else{
//                    self.image = nil
//                }
//            }
//            
//        }
//    }
    
//    id qos = [QOS_CLASS_USER_INITIATED rawValue];
    NSString *pdfname = @"tmp.pdf";
    dispatch_async((dispatch_get_global_queue(0, 0)), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [data writeToFile:[self GetTempPath:pdfname] atomically:NO];
            
            BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                
                NSString *filePath = [self GetTempPath:pdfname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }

        });
    });
    
}






- (void) xisupdate_iphoneHandler5: (id) value {
    
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
    if ([result2 isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"Something wrong happened. Please try it again later."];
        [alert show];
        return;
        
    }else{
        
        if ([result2 isEqualToString:@"Not Started"] || [result2 isEqualToString:@"Not Ready"]) {
            qainspection *qt =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"qainspection"];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=result.IdQaInspection;
            qt.fromtype=1;
            [self.navigationController pushViewController:qt animated:YES];
        }else{
            qainspectionb *qt =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"qainspectionb"];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=result.IdQaInspection;
            qt.fromtype=1;
            [self.navigationController pushViewController:qt animated:YES];
        }
        
        
        
    }
}

-(void)getProjectPo{
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [service xGetPO93:self action:@selector(xGetStartPackListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:@"" EquipmentType:@"3"];
}

- (void) xGetStartPackListHandler: (id) value {
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
    
    NSMutableArray*  poresult=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    [poresult removeObjectAtIndex:0];
    [poresult removeObjectAtIndex:0];
    if ([poresult count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@"Purchase order not found for this project"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
         projectpo *cc =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectpo"];
          cc.idvendor=@"-1";
        cc.idproject=self.idproject;
        cc.result=poresult;
        cc.idmaster=result.mastercia;
        if ([result.Status isEqualToString:@"Closed"]) {
            cc.xtype=1;
        }else{
            cc.xtype=0;
        }
        cc.isfromdevelopment=0;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:YES];
    }
}




-(void)getCols {
    wcfService* service = [wcfService service];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [service xGetProjectCOList:self action:@selector(xGetProjectCOListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject EquipmentType:@"3"];
}
- (void) xGetProjectCOListHandler: (id) value {
    
	
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
    
   NSMutableArray* coresult =[(wcfArrayOfCOListItem*)value toMutableArray];
    [coresult removeObjectAtIndex:0];
    
    if ([coresult count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@"Change order not found for this project"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        projectcols *cc =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectcols"];
        cc.idproject=self.idproject;
        cc.result=coresult;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:YES];
    }
    
}


- (void) xFoundForApproveHandler: (id) value {
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}
    
    
	// Do something with the NSString* result
    NSString* result8 = (NSString*)value;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    if ([result8 isEqualToString:@"1"]) {
        projectSuggestPrice *ps =[self.storyboard instantiateViewControllerWithIdentifier:@"projectSuggestPrice"];
        ps.managedObjectContext=self.managedObjectContext;
        ps.idproject=self.idproject;
        ps.xsqft=result.sqft;
        [self.navigationController pushViewController:ps animated:YES];
    }else if([result8 isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@""
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:result8
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];

    }

    
}


- (void) xAddUserLogHandler: (BOOL) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	// Do something with the BOOL result
    if ( [HUD.labelText isEqualToString:@"Download Project File..."]) {
        {
            
            
           NSString* str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname=%@", key.ID,[[NSNumber numberWithInt:[userInfo getCiaId] ] stringValue], [Mysql md5:key.FSize],[key.FName stringByReplacingOccurrencesOfString:@" " withString:@""]];
            
            NSURL *url = [NSURL URLWithString:str];
            if (turl==url) {
                BOOL exist = [self isExistsFile:[self GetTempPath:key.FName]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                if (exist) {
                    HUD.progress=1;
                    [HUD hide];
                    NSString *filePath = [self GetTempPath:key.FName];
                    NSURL *URL = [NSURL fileURLWithPath:filePath];
                    [self openDocumentInteractionController:URL];
                }else{
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    [data writeToFile:[self GetTempPath:key.FName] atomically:NO];
                    
                    BOOL exist = [self isExistsFile:[self GetTempPath:key.FName]];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                    if (exist) {
                        HUD.progress=1;
                        [HUD hide];
                        NSString *filePath = [self GetTempPath:key.FName];
                        NSURL *URL = [NSURL fileURLWithPath:filePath];
                        [self openDocumentInteractionController:URL];
                    }
                    
                }
                
            }else{
                turl=url;
                NSData *data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:[self GetTempPath:key.FName] atomically:NO];
                
                BOOL exist = [self isExistsFile:[self GetTempPath:key.FName]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                if (exist) {
                    HUD.progress=100;
                    [HUD hide];
                    NSString *filePath = [self GetTempPath:key.FName];
                    NSURL *URL = [NSURL fileURLWithPath:filePath];
                    [self openDocumentInteractionController:URL];
                }
                
            }
        }

    }else if ( [HUD.labelText isEqualToString:@"Download Project Brochure..."]) {
        NSString*  str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/brochure.aspx?email=%@&password=%@&idfloorplan=%@&idcia=%d", [userInfo getUserName], [userInfo getUserPwd], result.IDFloorplan, [userInfo getCiaId]];
        
        NSURL *url = [NSURL URLWithString:str];
        if (turl==url) {
            NSString *pdfname =[NSString stringWithFormat:@"%@_brochure.pdf", result.Name];
            BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                
                NSString *filePath = [self GetTempPath:pdfname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }else{
                NSData *data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:[self GetTempPath:pdfname] atomically:NO];
                
                BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                if (exist) {
                    HUD.progress=1;
                    [HUD hide];
                    
                    NSString *filePath = [self GetTempPath:pdfname];
                    NSURL *URL = [NSURL fileURLWithPath:filePath];
                    [self openDocumentInteractionController:URL];
                }
                
            }
            
        }else{
            turl=url;
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *pdfname =[NSString stringWithFormat:@"%@_broshure.pdf", result.Name];
            [data writeToFile:[self GetTempPath:pdfname] atomically:NO];
            
            BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                
                NSString *filePath = [self GetTempPath:pdfname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }
            
        }

        
    }
//	NSLog(@"xAddUserLog returned the value: %@", [NSNumber numberWithBool:value]);
    
     
}

//- (NSString *)UTIForURL:(NSURL *)url
//{
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
//    return (__bridge NSString *)UTI;
//}

- (void)openDocumentInteractionController:(NSURL *)fileURL{
    docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    docController.delegate = self;
    BOOL isValid = [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
   
    if(!isValid){
        
        // There is no app to handle this file
        NSString *deviceType = [UIDevice currentDevice].localizedModel;
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?",
                                                                         @"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?"), deviceType];
        
        // Display alert
//        turl = fileURL;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No suitable Apps installed", @"No suitable App installed")
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue", nil];
        alert.delegate=self;
        alert.tag=10;
        [alert show];
    }
}

-(NSString *)GetTempPath:(NSString*)filename{
    NSString *tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingPathComponent:filename];
}


-(BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
