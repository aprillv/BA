//
//  development.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "development.h"
#import "Mysql.h"
#import "userInfo.h"
#import "cl_favorite.h"
#import "cl_project.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h> // For UTI
#import "phoneDetail.h"
//#import "AGAlertViewWithProgressbar.h"
#import "cl_phone.h"
#import "cl_sync.h"
#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "projectpo.h"
#import "requestedvpols.h"
#import "developmentVendorLs.h"
#import "MBProgressHUD.h"
#import "projectPhotoFolder.h"
#import "ProjectPhotoName.h"

@interface development ()<MBProgressHUDDelegate, UITabBarDelegate>{
//    AGAlertViewWithProgressbar *alertViewWithProgressbar;
    MBProgressHUD *HUD;
     NSMutableArray *qllist;
    BOOL isaddfavorite;
    UIAlertView *myAlertView;
    BOOL isshow;
    wcfProjectFile *key;
    int y;
    NSString *xtoemail;
    NSString *xtoename;
    wcfProjectItem* result;
    NSMutableArray *rtnfiles;
    NSURL *turl;
      NSMutableArray *uploadLs;
    NSMutableArray *pmLs;
    NSMutableArray *pmEmailLs;
}


@end


@implementation development
@synthesize ntabbar, idproject, docController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
//    NSLog(@"%@", idproject);
//    self.view.backgroundColor = [Mysql groupTableViewBackgroundColor];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    self.title=[userInfo getCiaName];
    
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    ntabbar.delegate= self;
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
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
    
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    
    
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        xtoemail=xemail;
        [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp isFirttimeToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"5"]) {
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
            }else{
                [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"favorite_add.png"] ];
                [[ntabbar.items objectAtIndex:1]setTitle:@"Favorite" ];
                [ntabbar setSelectedItem:nil];
                isaddfavorite=YES;
            }
            break;
        case 1:{
            if (alertView.tag==10) {
                [[UIApplication sharedApplication] openURL:turl];
            }else if(alertView.tag==3) {
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
    pn.isDevelopment=YES;
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
    NSMutableArray* result3 = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result3];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    
    [HUD hide];
    [ntabbar setSelectedItem:nil];
    phoneDetail *pd =[self.storyboard instantiateViewControllerWithIdentifier:@"phoneDetail"];
    pd.managedObjectContext=self.managedObjectContext;
    pd.email = xtoemail;
    pd.ename = xtoename;
    pd.idmaster=result.mastercia;
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
        [service xGetProject:self action:@selector(xGetProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: self.idproject xtype: 1 EquipmentType: @"3"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [ntabbar setSelectedItem:nil];
    [self getDetail];
//    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
//    sv.contentSize=CGSizeMake(sv.contentSize.width, 685);
   
}

- (void) xGetProjectHandler: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	// Handle errors
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

    
    
	// Do something with the wcfProjectItem* result
    result = (wcfProjectItem*)value;
    [self drawScreen1];
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
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
    
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    UITableView *uv =(UITableView *)[sv viewWithTag:4];
    if (uv !=nil) {
        [uv reloadData];
        uv =(UITableView *)[sv viewWithTag:5];
        [uv reloadData];
    }else{
        
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=[NSString stringWithFormat:@"Development # %@", idproject];
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int rowheight=32;
        UITableView *ciatbview;
        
        UIView *lbl1;
        
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, 32)];
        lbl1.layer.cornerRadius=10.0;
        lbl1.backgroundColor = [UIColor whiteColor];
        [uv addSubview:lbl1];
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, 300, rowheight-1)];
        lbl.text=result.Name;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, 300, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Total Units: %d", result.TotalUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, 300, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Closed: %d", result.ClosedUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, 290, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Sold: %d", result.SoldUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Specs: %d", result.SpecsUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight-1;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y-1, 300, rowheight-1)];
        lbl.text=[NSString stringWithFormat:@"Active Projects: %d", result.ActiveUnits];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:16.0];
        [sv addSubview:lbl];
        y=y+rowheight-1;
        y=y+10;
        
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Sitemap";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, 44)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=5;
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+44+10;
        
        
        uploadLs =[[NSMutableArray alloc]init];
        if ([result.AddPhoto intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload Photos (%@)", result.AddPhoto]];
        }
        if ([result.AddPMNotes intValue]>=0){
            [uploadLs addObject:[NSString stringWithFormat:@"Upload PM Notes (%@)", result.AddPMNotes]];
        }
        
        if ([uploadLs count]>0) {
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, [uploadLs count]*44)];
            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag=30;
            
            [ciatbview setRowHeight:44.0f];
            ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
            [sv addSubview:ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
            y=y+[uploadLs count]*44+10;
        }
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
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
        
        
        
        if (result.poyn || ![result.requestvpo isEqualToString:@"0"]) {
           
            
           
            
            if (result.poyn) {
                [qllist addObject:@"Purchase Order"];
            }
            if (![result.requestvpo isEqualToString:@"0"]) {
                [qllist addObject:@"Requested VPO"];
            }
            
            
        }
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, [qllist count]*44)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=15;
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+[qllist count]*44+10;
        
        
        
    }
}

-(void) drawScreen2{
    
    
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
//    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    UITableView *uv =(UITableView *)[sv viewWithTag:7];
    if (uv !=nil) {
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:8];
        [uv reloadData];
        uv=(UITableView *)[sv viewWithTag:11];
        [uv reloadData];
         
    }else{
        
        UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text= @"Development Files";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [sv addSubview:lbl];
        y=y+30;
        
        int  rtn=[rtnfiles count];
        if (rtn==0) {
            rtn=1;
        }
        UITableView* ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=7;
        
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
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
            [pmEmailLs addObject:result.PM1Email];
        }
        if (result.PM2) {
            [pmLs addObject:result.PM2];
            [pmEmailLs addObject:result.PM2Email];
        }
        //        NSLog(@"%@ %@ %@ %@", result.PM3, result.PM4, result.PM3Email, result.PM4Email);
        if (result.PM3) {
            [pmLs addObject:result.PM3];
            [pmEmailLs addObject:result.PM3Email];
        }
        if (result.PM4) {
            [pmLs addObject:result.PM4];
            [pmEmailLs addObject:result.PM4Email];
        }

        rtn=[pmLs count];
        if (rtn==0) {
            rtn=1;
        }
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=8;
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
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
        if(rtn==0){
            rtn=1;
        }
        
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, rtn*44.0)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=11;
        [ciatbview setRowHeight:44.0f];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [sv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        
        y=y+44*rtn+10;
        
       sv.contentSize=CGSizeMake(320.0,y+25);
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        if (tableView.tag==30) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            cell.textLabel.text =[uploadLs objectAtIndex:indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            [cell .imageView setImage:nil];
        }else{
        if(tableView.tag==5){
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;            }
            if (result.SiteMapyn) {
                cell.textLabel.text =@"View Sitemap";
                
            }else{
                cell.textLabel.text =@"Sitemap not found";
                cell.textLabel.textColor=[UIColor redColor];
                cell.userInteractionEnabled=NO;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                           
              //  [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//                UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
//                                                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                [spinner setAlpha:0.0];
//                [cell setAccessoryView:spinner];
            
            
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            
            
            [cell .imageView setImage:nil];
        }else if(tableView.tag==8){
            if ([pmLs count]==0) {
                cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
                CGRect rect = CGRectMake(10, 0, 295, 44);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                label.text=@"n / a";
                label.textColor=[UIColor redColor];
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }else{
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    else
                    {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                }
                
                
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                
                [cell .imageView setImage:nil];
                
                cell.textLabel.text=[pmLs objectAtIndex:indexPath.row];
            }
        }else if(tableView.tag==15){
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                else{
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
            }
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            [cell.imageView setImage:nil];
            if (indexPath.row==0 && !result.HasVendorYN) {
                cell.textLabel.text=[qllist objectAtIndex:indexPath.row];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor=[UIColor redColor];
                cell.userInteractionEnabled = NO;
                   cell.accessoryType=UITableViewCellAccessoryNone;
            }else{
                 cell.textLabel.text=[qllist objectAtIndex:indexPath.row];
            }
           

        }else if(tableView.tag==11){
            if (result.Sales1==nil && result.Sales2==nil) {
                cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
                CGRect rect = CGRectMake(10, 0, 295, 44);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                label.text=@"n / a";
                label.textColor=[UIColor redColor];
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }else{
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    else
                    {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                }
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
        }else{
            if ([rtnfiles count]==0) {
                cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
                CGRect rect = CGRectMake(10, 0, 295, 44);
                UILabel * label= [[UILabel alloc]initWithFrame:rect];
                label.textAlignment=NSTextAlignmentLeft;
                label.font=[UIFont systemFontOfSize:16.0];
                label.text=@"n / a";
                label.textColor=[UIColor redColor];
                [cell.contentView addSubview:label];
                cell.userInteractionEnabled = NO;
            }else{
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                    else
                    {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                }
                wcfProjectFile *pf =[rtnfiles objectAtIndex:indexPath.row];
                cell.textLabel.text =pf.Name;
                cell.textLabel.font=[UIFont systemFontOfSize:16.0];
                
                [cell .imageView setImage:nil];
            }
            
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
        case 5:
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
        case 7:
            rtn=[rtnfiles count];
            if (rtn==0) {
                rtn=1;
            }
            break;
            
        default:
            rtn=4;
            break;
    }
    return rtn;
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
        projectpo *cc =[[projectpo alloc]init];
        cc.idmaster=result.mastercia;
        if ([result.Status isEqualToString:@"Closed"]) {
            cc.xtype=1;
        }else{
            cc.xtype=0;
        }
        cc.result=poresult;
        cc.idvendor=@"-1";
        cc.idproject=self.idproject;
        cc.isfromdevelopment=1;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==15) {
        if ([[qllist objectAtIndex:indexPath.row] isEqualToString:@"Preferred Vendors"]) {
            developmentVendorLs *dl = [self.storyboard instantiateViewControllerWithIdentifier:@"developmentVendorLs"];
            dl.managedObjectContext=self.managedObjectContext;
            dl.idproject=self.idproject;
            dl.idmaster=result.mastercia;
            
            [self.navigationController pushViewController:dl animated:YES];
        }else if ([[qllist objectAtIndex:indexPath.row] isEqualToString:@"Purchase Order"]) {
            [self getProjectPo];
        }else{
            requestedvpols *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"requestedvpols"];
            LoginS.managedObjectContext=self.managedObjectContext;
            LoginS.xtype=8;
            LoginS.idproject=self.idproject;
            LoginS.title=@"Requested VPO";
            [self.navigationController pushViewController:LoginS animated:YES];
        }
        
    }else if (tableView.tag==30) {
        NSString *key1 =[uploadLs objectAtIndex:indexPath.row];
        if ([key1 hasPrefix:@"Upload Photos"]) {
            
            projectPhotoFolder *pf =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectPhotoFolder"];
            pf.managedObjectContext=self.managedObjectContext;
            pf.idproject=self.idproject;
            pf.isDevelopment=YES;
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

        
    }else if (tableView.tag==8) {
        [self contactPm1:indexPath.row];
        
    } else if (tableView.tag==11) {
        if (indexPath.row==0) {
            if ( result.Sales1) {
                [self contactSales1];
            }else{
                [self contactSales2];
            }
            
        }else{
            [self contactSales2];
        }
    }else{
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            if (tableView.tag==5) {
//                sitemap *si = [self.storyboard instantiateViewControllerWithIdentifier:@"sitemap"];
//                sitemap *si=[[sitemap alloc]init];
//                si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%d&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], [userInfo getCiaId], idproject];
//                
//                [self presentViewController:si animated:YES completion:nil];
                
                ViewController *si=[[ViewController alloc]init];
                si.managedObjectContext=self.managedObjectContext;
                si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%d&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], [userInfo getCiaId], idproject];
                
                [self presentViewController:si animated:YES completion:nil];
                
            }else{
                key =(wcfProjectFile *)[rtnfiles objectAtIndex:indexPath.row];
                isshow=YES;
//                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Development File..." delegate:self otherButtonTitles:nil];
//                
//                [alertViewWithProgressbar show];
                
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Download Development File...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                
                NSString *str;
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                
                wcfService *service=[wcfService service];
                str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
                     NSASCIIStringEncoding];
                
                NSString* escapedUrlString =
                [[NSString stringWithFormat:@"<view> %@", key.FName] stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
                
                [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Development File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
                
            }
        }
    }
}


-(IBAction)didPresentAlertView:(UIAlertView *)alertView{
    if (isshow && [HUD.labelText isEqualToString:@"Download Sitemap Image..."]) {
        isshow=NO;
        wcfService *service=[wcfService service];
        NSString *fname=[[NSString stringWithFormat:@"%@_sitemap.png", result.Name]stringByAddingPercentEscapesUsingEncoding:
        NSASCIIStringEncoding];
        fname=[Mysql stringreplace:fname];
        
        NSString* str=[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name];
        
        fname =
        [[NSString stringWithFormat:@"<view> %@", fname] stringByAddingPercentEscapesUsingEncoding:
         NSASCIIStringEncoding];
        
        [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Download Sitemap Image" keyname: str filename:fname  EquipmentType: @"3"];
        
        str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%d&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], [userInfo getCiaId], idproject];
        
        NSURL *url = [NSURL URLWithString:str];
        if (turl==url) {
            BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                NSString *filePath = [self GetTempPath:fname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }else{
                NSData *data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:[self GetTempPath:fname] atomically:NO];
                BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                if (exist) {
                    HUD.progress=1;
                    [HUD hide];
                    NSString *filePath = [self GetTempPath:fname];
                    NSURL *URL = [NSURL fileURLWithPath:filePath];
                    [self openDocumentInteractionController:URL];
                }
                
            }
            
        }else{
            turl=url;
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:[self GetTempPath:fname] atomically:NO];
            BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                NSString *filePath = [self GetTempPath:fname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }
            
        }
    }else if (isshow && [HUD.labelText isEqualToString:@"Download Sitemap PDF..."]){
        isshow=NO;
        wcfService *service=[wcfService service];
        NSString *fname=[NSString stringWithFormat:@"%@_sitemap.pdf", result.Name];
        fname=[Mysql stringreplace:fname];
        NSString* str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
        NSASCIIStringEncoding];
        fname = [[NSString stringWithFormat:@"<view> %@", fname] stringByAddingPercentEscapesUsingEncoding:
         NSASCIIStringEncoding];
        
        [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Download Sitemap PDF" keyname: str filename:fname  EquipmentType: @"3"];
        str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemappdf.aspx?email=%@&password=%@&idcia=%d&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], [userInfo getCiaId], idproject];
       
        NSURL *url = [NSURL URLWithString:str];
        if (turl==url) {
            BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                NSString *filePath = [self GetTempPath:fname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }else{
                NSData *data = [NSData dataWithContentsOfURL:url];
                if (data!=nil) {
                    [data writeToFile:[self GetTempPath:fname] atomically:NO];
                    BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
                    HUD.progress=1;
                    [HUD hide];
                    if (exist) {
                        NSString *filePath = [self GetTempPath:fname];
                        NSURL *URL = [NSURL fileURLWithPath:filePath];
                        [self openDocumentInteractionController:URL];
                    }

                }else{
                    HUD.progress=1;
                    [HUD hide];
                    UIAlertView *a=[self getErrorAlert:@"Cannot download this file."];
                    [a show];
                }              
            }
            
        }else{
            turl=url;
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data!=nil) {
                [data writeToFile:[self GetTempPath:fname] atomically:NO];
                
                BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                if (exist) {
                    HUD.progress=1;
                    [HUD hide];
                    
                    NSString *filePath = [self GetTempPath:fname];
                    NSURL *URL = [NSURL fileURLWithPath:filePath];
                    [self openDocumentInteractionController:URL];
                }

            }else{
            
                HUD.progress=1;
                [HUD hide];
                
                UIAlertView *a=[self getErrorAlert:@"Cannot download this file."];
                [a show];
            }
            
        }
    }    
}



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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No suitable Apps installed", @"No suitable App installed")
                                                        message:message
                                                       delegate:nil
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
    
    NSString* result4 = (NSString*)value;
    if ([result4 isEqualToString:@"1"]) {
        
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
        
        [self getDetail];
    }
    
    
}

- (void) xAddUserLogHandler: (BOOL) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	// Do something with the BOOL result
    
    if(isshow && [HUD.labelText isEqualToString:@"Download Development File..."]){
        isshow=NO;
        
        NSString *str;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
//        wcfService *service=[wcfService service];
//        str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, result.Name]stringByAddingPercentEscapesUsingEncoding:
//             NSASCIIStringEncoding];
//        
//        NSString* escapedUrlString =
//        [[NSString stringWithFormat:@"<view> %@", key.FName] stringByAddingPercentEscapesUsingEncoding:
//         NSASCIIStringEncoding];
        
//        [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Development File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
        
        
        str =[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname=%@", key.ID,[[NSNumber numberWithInt:[userInfo getCiaId] ] stringValue], [Mysql md5:key.FSize], [key.FName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        
        
        
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
                if (data!=nil) {
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
                }else{
                    
                    HUD.progress=1;
                    [HUD hide];
                    
                    UIAlertView *a=[self getErrorAlert:@"Cannot download this file."];
                    [a show];
                }
                
                
                
            }
            
        }else{
            turl=url;
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data!=nil) {
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
            }else{
                
                HUD.progress=1;
                [HUD hide];
                
                UIAlertView *a=[self getErrorAlert:@"Cannot download this file."];
                [a show];
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
