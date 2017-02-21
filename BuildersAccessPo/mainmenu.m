//
//  mainmenu.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "mainmenu.h"
#import "ciaList.h"
#import "wcfArrayOfKeyValueItem.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "favorite.h"
#import "myprofile.h"
#import "cl_cia.h"
#import "userInfo.h"
#import "cl_phone.h"
#import "cl_project.h"
#import "Reachability.h"
#import "phonelist.h"
#import "projectls.h"
#import "wcfService.h"
#import "cl_sync.h"
#import "forapprove.h"
#import "mastercialist.h"
#import "kirbytitle.h"
#import "calendarqa.h"
#import "multiSearch.h"
#import "selectionCalendar.h"
#import "BuildersAccess-Swift.h"

@interface mainmenu ()<MBProgressHUDDelegate, UITabBarDelegate>{
    MBProgressHUD *HUD;
    int donext;
    UIButton *lbla;
}
@end

int currentpage, pageno;
NSMutableArray *menulist;
NSMutableArray *detailstrarr;
NSString *atitle;

@implementation mainmenu
@synthesize xget, uv, ntabbar, ciatbview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (IBAction)logout:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    donext=0;
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    
    
//      self.view.backgroundColor = [Mysql groupTableViewBackgroundColor];
    menulist =[[NSMutableArray alloc]init];
    detailstrarr=[[NSMutableArray alloc]init];
    wcfKeyValueItem *kv;
    NSString *details;
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"Favorites";
    details = @"List of your favorites projects";
    [detailstrarr addObject:details];
    kv.Value=@"menu_favorite.png";
    [menulist addObject:kv];
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"For Approve";
    details = @"List of your for approve";
    [detailstrarr addObject:details];
    kv.Value=@"menu_forapprove1.png";
    [menulist addObject:kv];
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"Task Due";
    details = @"Schedule Task Due";
    [detailstrarr addObject:details];
    kv.Value=@"kirbytitle.png";
    [menulist addObject:kv];
    
//    NSLog(@"%@", xget);
    NSArray *firstSplit = [xget componentsSeparatedByString:@";"];
    
    if ([[firstSplit objectAtIndex:0] hasSuffix:@"1"]) {
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Kirby Title";
        details = @"List of Kirby Title";
        [detailstrarr addObject:details];
        kv.Value=@"kirbytitle.png";
        [menulist addObject:kv];
    }
    
    if ([[firstSplit objectAtIndex:1] hasSuffix:@"1"]) {
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Selection Calendar";
        details = @"List of Selection Calendar";
        [detailstrarr addObject:details];
        kv.Value=@"kirbytitle.png";
        [menulist addObject:kv];
        
    }
    
    if ([[firstSplit objectAtIndex:2] hasSuffix:@"1"]) {
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"QA Calendar";
        details = @"List of Calendar QA";
        [detailstrarr addObject:details];
        kv.Value=@"calendarqa.png";
        [menulist addObject:kv];
        
    }
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"Development";
    kv.Value=@"menu_development.png";
    details = @"Look up subdivision and site plans";
    [detailstrarr addObject:details];
    [menulist addObject:kv];
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"Active Units";
    kv.Value=@"menu_active.png";
    details = @"Projects under construction";
    [detailstrarr addObject:details];
    [menulist addObject:kv];
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"Not Started";
    kv.Value=@"menu_notstarted.png";
    details = @"Projects without scheduling";
    [detailstrarr addObject:details];
    [menulist addObject:kv];
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"Archive Units";
    kv.Value=@"menu_archive.png";
    details = @"Search closed projects information";
    [detailstrarr addObject:details];
    [menulist addObject:kv];
    
    kv =[[wcfKeyValueItem alloc]init];
    kv.Key=@"Project Multi Search";
    kv.Value=@"zoom.png";
    details = @"Search projects by name for all the companies that you work with.";
    [detailstrarr addObject:details];
    [menulist addObject:kv];
    if ([[firstSplit objectAtIndex:3] hasSuffix:@"1"]) {
        kv =[[wcfKeyValueItem alloc]init];
        kv.Key=@"Vendor Multi Search";
        kv.Value=@"zoom.png";
        details = @"Search vendors by name for all the companies that you work with.";
        [detailstrarr addObject:details];
        [menulist addObject:kv];
    }
    
    ntabbar.delegate = self;

    
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"phonelist.png"] ];
//       [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home1.png"] ];
//    UITabBarItem *bi =[ntabbar.items objectAtIndex:0];
//    
//   bi.image = [UIImage imageNamed:@"home1.png"];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Phone List" ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goPhoneList:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"id.png"] ];
    [[ntabbar.items objectAtIndex:1]setTitle:@"My Profile" ];
//    [[ntabbar.items objectAtIndex:1]setAction:@selector(goMyProfile:) ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
   
    
    
    kv =[[wcfKeyValueItem alloc]init];
    if ([[self unlockPasscode] isEqualToString:@"0"] || [[self unlockPasscode] isEqualToString:@"1"]){
        
//        [[ntabbar.items objectAtIndex:3] setAction:@selector(goSetPin:)];
        [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"setpin.png"] ];
        [[ntabbar.items objectAtIndex:3]setTitle:@"Set PIN" ];
        
//        kv.Key=@"Set PIN";
//        kv.Value=@"sp.png";
//        details = @"Add security level to your account";
    }else{
//        [[ntabbar.items objectAtIndex:3] setAction:@selector(goSetPin:)];
        [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"removepin.png"] ];
        [[ntabbar.items objectAtIndex:3]setTitle:@"Remove PIN" ];
        
//        kv.Key=@"Reset PIN";
//        kv.Value=@"lock_open.png";
//        details = @"Reset security level to your account";
        //        [pintab setTitle:@"Reset Pin"];
        //        [pintab setImage:[UIImage imageNamed:@"reset_pin.png"]];
    }

    
//    kv =[[wcfKeyValueItem alloc]init];
//    kv.Key=@"Phone List";
//    kv.Value=@"menu_phonelist.png";
//    details = @"Find coworkers contact information";
//    [detailstrarr addObject:details];
//    [menulist addObject:kv];
    
//    kv =[[wcfKeyValueItem alloc]init];
//    kv.Key=@"My Profile";
//    kv.Value=@"mp.png";
//    details = @"Update your profile information";
//    [detailstrarr addObject:details];
//    [menulist addObject:kv];
//    
//    kv =[[wcfKeyValueItem alloc]init];
//    if ([[self unlockPasscode] isEqualToString:@"0"] || [[self unlockPasscode] isEqualToString:@"1"]){
//       
//        kv.Key=@"Set PIN";
//        kv.Value=@"sp.png";
//        details = @"Add security level to your account";
//    }else{
//        kv.Key=@"Reset PIN";
//        kv.Value=@"lock_open.png";
//        details = @"Reset security level to your account";
////        [pintab setTitle:@"Reset Pin"];
////        [pintab setImage:[UIImage imageNamed:@"reset_pin.png"]];
//    }
//    [detailstrarr addObject:details];
//    [menulist addObject:kv];
//    
//    kv =[[wcfKeyValueItem alloc]init];
//    kv.Key=@"Logout";
//    kv.Value=@"logout.png";
//    details = @"Logout your account";
//    [detailstrarr addObject:details];
//    [menulist addObject:kv];
    
  
    
//    int tbheight;
//    if (self.view.frame.size.height>480) {
//        tbheight=70;
//        uv.contentSize=CGSizeMake(self.view.frame.size.width,456);
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 456)];
////        NSLog(@"%f %f", self.view.frame.size.height, tbheight*6.9+20);
//    }else{
//        tbheight=65;
//        uv.contentSize=CGSizeMake(self.view.frame.size.width,368);
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 368)];
//    }
//    
//    //    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-20, tbheight*6)];
//    [UITableView appearance].separatorColor = [UIColor grayColor];
//    ciatbview.rowHeight = tbheight;
////    ciatbview.separatorColor = [UIColor grayColor];
////    ciatbview.layer.cornerRadius = 10;
//    
//    [uv addSubview:ciatbview];
//    ciatbview.delegate = self;
//    ciatbview.dataSource = self;
    
}



-(void)viewDidLayoutSubviews
{
    if ([ciatbview respondsToSelector:@selector(setSeparatorInset:)]) {
        [ciatbview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([ciatbview respondsToSelector:@selector(setLayoutMargins:)]) {
        [ciatbview setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Phone List"]) {
        [self goPhoneList:item];
    }else if([item.title isEqualToString:@"My Profile"]){
        [self goMyProfile:item];
    }else if([item.title isEqualToString:@"Set PIN"]){
        [self goSetPin: item];
    }else if([item.title isEqualToString:@"Remove PIN"]){
        [self goSetPin: item];
    }
}


-(IBAction)goPhoneList:(id)sender{
    donext=2;
    [self checkupd];
}

-(IBAction)goMyProfile:(id)sender{
    donext=3;
    [self checkupd];
}

-(IBAction)goSetPin:(UITabBarItem *)sender{
    if ([sender.title isEqualToString:@"Set PIN"]) {
        donext=4;
        [self checkupd];
    }else{
        donext=5;
        [self checkupd];
    }
}



-(void)changePin{
    
//   wcfKeyValueItem *kv= [menulist objectAtIndex:([menulist count]-2)];
//    NSString *str;
    if ([[self unlockPasscode] isEqualToString:@"0"] || [[self unlockPasscode] isEqualToString:@"1"]){
        
//        [[ntabbar.items objectAtIndex:3] setAction:@selector(goSetPin:)];
        [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"setpin.png"] ];
        [[ntabbar.items objectAtIndex:3]setTitle:@"Set PIN" ];
        
//        kv.Key=@"Set PIN";
//        kv.Value=@"sp.png";
//       str =@"Add security level to your account";
    }else{
//        [[ntabbar.items objectAtIndex:3] setAction:@selector(goSetPin:)];
        [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"removepin.png"] ];
        [[ntabbar.items objectAtIndex:3]setTitle:@"Remove PIN" ];
//        kv.Key=@"Reset PIN";
//        kv.Value=@"lock_open.png";
//         str =@"Reset security level to your account";
    }
//    [detailstrarr removeObjectAtIndex:([menulist count]-2)];
//    [detailstrarr insertObject:str atIndex:([menulist count]-2)];
//    [ciatbview reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [menulist count]; // or self.items.count;
    
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    

    
    wcfKeyValueItem *kv = [menulist objectAtIndex:indexPath.row];
    
    cell.textLabel.text = kv.Key;
    cell.detailTextLabel.numberOfLines=0;
//    cell.detailTextLabel.font=[UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.text = [detailstrarr objectAtIndex:indexPath.row];
    [cell.detailTextLabel sizeToFit];
    UIImage *img = [UIImage imageNamed:kv.Value];
    [cell .imageView setImage:[self scaleImage:img toScale:.7]];
    return cell;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(
                                CGSizeMake(image.size.width * scaleSize,
                                           image.size.height * scaleSize));
                                
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
                                
                                }
                                
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    donext=1;
    [self checkupd];
}

-(void)checkupd{
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
        [self gotonextpage];
    }
    
    
}


-(void)gotonextpage{
    if (donext==1) {
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        wcfKeyValueItem *kv  =[menulist objectAtIndex:indexPath.row];
        atitle=kv.Key;
       
            
            if ([kv.Key isEqualToString:@"Favorites"]) {
                favorite *ft =[self.storyboard instantiateViewControllerWithIdentifier:@"favorite"];
                ft.managedObjectContext=self.managedObjectContext;
                ft.title=kv.Key;
                [self.navigationController pushViewController:ft animated:YES];
            }else if([kv.Key isEqualToString:@"For Approve"]){
                wcfService *service =[wcfService service];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"3"];
            }else if([kv.Key isEqualToString:@"Project Multi Search"]|| [kv.Key isEqualToString:@"Vendor Multi Search"]){
                wcfService *service =[wcfService service];
                atitle=kv.Key;
                [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
                [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"3"];
//            }else if([kv.Key isEqualToString:@"Logout"]){
//               
//            }else if([kv.Key isEqualToString:@"Set PIN"]){
//              
//            }else if([kv.Key isEqualToString:@"Reset PIN"]){
//                [self changePasscode:nil];
            }else if([kv.Key isEqualToString:@"Kirby Title"]){
                [userInfo initCiaInfo:1 andNm:@""];
                kirbytitle *k =[self.storyboard instantiateViewControllerWithIdentifier:@"kirbytitle"];
                k.managedObjectContext=self.managedObjectContext;
                [self.navigationController pushViewController:k animated:YES];
                
            }else if([kv.Key isEqualToString:@"Selection Calendar"]){
                [userInfo initCiaInfo:1 andNm:@""];
                selectionCalendar *k =[self.storyboard instantiateViewControllerWithIdentifier:@"selectionCalendar"];
                k.managedObjectContext=self.managedObjectContext;
                k.title=kv.Key;
                [self.navigationController pushViewController:k animated:YES];
            }else if([kv.Key isEqualToString:@"QA Calendar"]){
                [userInfo initCiaInfo:1 andNm:@""];
//                calendarqa *k =[[calendarqa alloc]init];
                calendarqa *k =[self.storyboard instantiateViewControllerWithIdentifier:@"calendarqa"];
                k.managedObjectContext=self.managedObjectContext;
                [self.navigationController pushViewController:k animated:YES];
            }else{
                cl_cia *mc=[[cl_cia alloc]init];
                mc.managedObjectContext=self.managedObjectContext;
                NSMutableArray *na = [mc getCiaList];
                if ([na count]>1) {
                    ciaList *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"cialist"];
                    LoginS.managedObjectContext=self.managedObjectContext;
                    LoginS.title=kv.Key;
                    [self.navigationController pushViewController:LoginS animated:YES];
                }else{
                    
                    if([na count]==1){
                        NSEntityDescription *cia =[na objectAtIndex:0];
                        [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"]integerValue] andNm:[cia valueForKey:@"cianame"]];
                        
                        if ([atitle isEqualToString:@"Phone List"]) {
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
                            if ([mp isFirttimeToSync:[[NSNumber numberWithInt:[userInfo getCiaId] ]stringValue] :@"1"]) {
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
                }
            }
        

    }else if(donext==2){
        //phone list
        wcfService *service =[wcfService service];
        atitle=@"Phone List";
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetMasterCia:self action:@selector(xGetMasterCiaHandler:) xemail:[userInfo getUserName] password:[userInfo getUserPwd]  EquipmentType:@"3"];
    }else if(donext==3){
    //myprofile
        myprofile *ft =[self.storyboard instantiateViewControllerWithIdentifier:@"myprofile"];
        ft.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:ft animated:YES];
    }else if(donext==4){
        //setpin
          [self setPasscode:nil];
    }else if(donext==5){
         //remove pin
        [self changePasscode:nil];
    }else if(donext==6){
    
     [self logout:nil];
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
    NSMutableArray* result = (NSMutableArray*)value;
	if ([atitle isEqualToString:@"Phone List"]) {
        if ([result count]>1) {
            mastercialist *fr =[self.storyboard instantiateViewControllerWithIdentifier:@"mastercialist"];
            fr.managedObjectContext=self.managedObjectContext;
            fr.rtnlist= [(wcfArrayOfKeyValueItem*)value toMutableArray];
            fr.title=@"Phone List";
            [self.navigationController pushViewController:fr animated:YES];
            
        }else{
            wcfKeyValueItem *kv =[result objectAtIndex:0];
            //            forapprove *fr =[self.storyboard instantiateViewControllerWithIdentifier:@"forapprove"];
            //            fr.managedObjectContext=self.managedObjectContext;
            //            fr.mastercia=kv.Key;
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
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
                phonelist *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"phonelist"];
                pl.managedObjectContext=self.managedObjectContext;
                pl.title=self.title;
                
                [self.navigationController pushViewController:pl animated:YES];
                
            }
            
        }
    }else if ([atitle isEqualToString:@"For Approve"]) {
        if ([result count]>1) {
            mastercialist *fr =[self.storyboard instantiateViewControllerWithIdentifier:@"mastercialist"];
            fr.managedObjectContext=self.managedObjectContext;
            fr.rtnlist= [(wcfArrayOfKeyValueItem*)value toMutableArray];
            fr.title=@"For Approve";
            [self.navigationController pushViewController:fr animated:YES];
        }else{
            wcfKeyValueItem *kv =[result objectAtIndex:0];
            forapprove *fr =[self.storyboard instantiateViewControllerWithIdentifier:@"forapprove"];
            fr.managedObjectContext=self.managedObjectContext;
            fr.mastercia=kv.Key;
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            fr.title=@"For Approve";
            [self.navigationController pushViewController:fr animated:YES];
        }
    }else{
        if ([result count]>1) {
            mastercialist *fr =[self.storyboard instantiateViewControllerWithIdentifier:@"mastercialist"];
            fr.managedObjectContext=self.managedObjectContext;
            fr.rtnlist= [(wcfArrayOfKeyValueItem*)value toMutableArray];
            fr.title=atitle;
            [self.navigationController pushViewController:fr animated:YES];
        }else{
//            wcfKeyValueItem *kv =[result objectAtIndex:0];
//            forapprove *fr =[self.storyboard instantiateViewControllerWithIdentifier:@"forapprove"];
//            fr.managedObjectContext=self.managedObjectContext;
//            fr.mastercia=kv.Key;
//            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
//            fr.title=@"For Approve";
//            [self.navigationController pushViewController:fr animated:YES];
             wcfKeyValueItem *kv =[result objectAtIndex:0];
            [userInfo initCiaInfo:[kv.Key intValue] andNm:kv.Value];
            multiSearch *k =[[multiSearch alloc]init];
            k.managedObjectContext=self.managedObjectContext;
            k.title=atitle;
            [self.navigationController pushViewController:k animated:YES];
        }

    }
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
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [lbla removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ntabbar setSelectedItem:nil];
//    if (!lbla) {
//        lbla =[UIButton buttonWithType:UIButtonTypeCustom];
//        lbla .frame=CGRectMake(230, 5, 100, 30);
//        [lbla addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];    [lbla setTitle:@"Logout" forState:UIControlStateNormal];
//        UIColor * cg1 = [Mysql getBlueTextColor];
//        [lbla.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//        
//        [lbla setTitleColor:cg1 forState:UIControlStateNormal];
//        [self.navigationController.navigationBar addSubview:lbla];
//    }else{
//    [self.navigationController.navigationBar addSubview:lbla];
//    }
    
    
}

-(void)getProjectList:(int)xpageNo {
    
    currentpage=xpageNo;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        if (xpageNo==1) {
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Project..." delegate:self otherButtonTitles:nil];
//            
//            [alertViewWithProgressbar show];
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Synchronizing Project...";
            
            HUD.progress=0;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
        }else{
            HUD.progress= (currentpage*1.0/pageno);
            
        }
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xSearchProject:self action:@selector(xSearchProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]  xtype: 0 currentPage: xpageNo EquipmentType: @"3"];
    }
    
    
}

- (void) xSearchProjectHandler: (id) value {
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
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    
    if([result isKindOfClass:[wcfArrayOfProjectListItem class]]){
        if ([result count]>0) {
            wcfProjectListItem *kv;
            
            
            kv = (wcfProjectListItem *)[result objectAtIndex:0];
            pageno=kv.TotalPage;
            [result removeObjectAtIndex:0];
            
            kv= (wcfProjectListItem *)[result objectAtIndex:0];
            NSString *syn = kv.IDNumber;
            [result removeObjectAtIndex:0];
            
            
            cl_project *mp=[[cl_project alloc]init];
            mp.managedObjectContext=self.managedObjectContext;
            [mp addToProject:result andscheleyn:syn];
            
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
                
                
                [self gotoNextPage];
            }
        }else{
            //            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //
            //            [HUD hide];
            //
            //            UIAlertView *av =[self getErrorAlert:@"You have no authority to access projects."];
            //
            //            [av show];
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
    NSMutableArray* result = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result];
    
    HUD.progress=1;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    
    [HUD hide];
    [self gotoNextPage];
    
}



-(void)gotoNextPage{
    if([atitle isEqualToString:@"Phone List" ]){
        phonelist *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"phonelist"];
        pl.managedObjectContext=self.managedObjectContext;
        pl.title=atitle;
        
        [self.navigationController pushViewController:pl animated:YES];
    }else {
        projectls *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"projectls"];
        LoginS.managedObjectContext=self.managedObjectContext;
        
        LoginS.title=atitle;
        [self.navigationController pushViewController:LoginS animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
