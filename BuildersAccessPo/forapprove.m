//
//  forapprove.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-27.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "forapprove.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "userInfo.h"
#import "contractforapprovecials.h"
#import "calendarforapprove.h"
#import "Reachability.h"
#import "forapprovepocials.h"
#import "coforapprovecials.h"
#import "coforapprove.h"
#import "contractforapprove.h"
#import "forapprovepols.h"
#import "suggestforapprove.h"
#import "bustoutls.h"
#import "bustoutcials.h"
#import "requestedvpols.h"

@interface forapprove ()<UITabBarDelegate>

@end

@implementation forapprove

@synthesize ntabbar, rtnlist, mastercia;

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
    
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    ntabbar.delegate = self;
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh:) ];
    
    
	// Do any additional setup after loading the view.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString: @"Home"]) {
        [self gohome:item];
    }else if ([item.title isEqualToString: @"Refresh"]) {
        [self dorefresh:item];
    }
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
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.buildersaccess.com/iphone/app.html"]];
        
    }else{
        [self getMenuList];
    }
}


-(void)viewWillAppear:(BOOL)animated{
[self getMenuList];
}
-(void)getMenuList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetMenuForApprove:self action:@selector(xGetMenuForApproveHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"3"];
    }
    
    
    
    }


- (void) xGetMenuForApproveHandler: (id) value {
    
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
    rtnlist = (NSMutableArray*)value;
    
    UIScrollView *sv =(UIScrollView *)[self.view viewWithTag:1];
//    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    
    if (tbview!=nil) {
        [tbview reloadData];
        [ntabbar setSelectedItem:nil];
    }else{
        if (self.view.frame.size.height>480) {
            tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 454)];
            sv.contentSize=CGSizeMake(320.0,545);
        }else{
            tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 366)];
            sv.contentSize=CGSizeMake(320.0,366);
        }
        
       
        
        tbview.rowHeight=50;
//        tbview.layer.cornerRadius = 10;
        tbview.tag=2;
        tbview.delegate = self;
        tbview.dataSource = self;
        [sv addSubview:tbview];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([self.rtnlist count]); // or self.items.count;
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;    }
    
    wcfKeyValueItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)", kv.Key, kv.Value];
//     cell.textLabel.font=[UIFont systemFontOfSize:17.0];
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

-(void)gotonextpage {
    NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
    [tbview deselectRowAtIndexPath:indexPath animated:YES];
     wcfKeyValueItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
    if ([kv.Value isEqualToString:@"0"]) {
        return;
    }
    
    if ([kv.Key isEqualToString:@"Suggested Price"]) {
        suggestforapprove *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"suggestforapprove"];
        pl.masterciaid=self.mastercia;
        pl.managedObjectContext=self.managedObjectContext;
        pl.title=kv.Key;
        [self.navigationController pushViewController:pl animated:YES];
    }else if ([kv.Key isEqualToString:@"Bust Out"]) {
        xtype=0;
        [self getcialistofcoforapprove];
        
//        bustoutls *pl =[[bustoutls alloc]init];
//        pl.masterciaid=self.mastercia;
//        pl.managedObjectContext=self.managedObjectContext;
//        pl.title=kv.Key;
//        [self.navigationController pushViewController:pl animated:YES];
    }else if ([kv.Key isEqualToString:@"Change Orders"]) {
//        coforapprove *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"coforapprove"];
//        pl.managedObjectContext=self.managedObjectContext;
//        pl.masterciaid=self.mastercia;
//        [self.navigationController pushViewController:pl animated:YES];
        xtype=1;
        [self getcialistofcoforapprove];
        
    }else if ([kv.Key isEqualToString:@"Contract ISP"]) {
        xtype=2;
         [self getcialistofcoforapprove];
//        contractforapprovecials *pl =[[contractforapprovecials alloc]init];
//        pl.mastercia=self.mastercia;
//        pl.title=kv.Key;
//        pl.managedObjectContext=self.managedObjectContext;
//        [self.navigationController pushViewController:pl animated:YES];
    }else if ([kv.Key isEqualToString:@"Calendar Builder"]) {
        calendarforapprove *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"calendarforapprove"];
        pl.mxtype=1;
         pl.masterciaid=self.mastercia;
        pl.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:pl animated:YES];
    }else if ([kv.Key isEqualToString:@"Calendar Buyer"]) {
        calendarforapprove *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"calendarforapprove"];
        pl.mxtype=2;
         pl.masterciaid=self.mastercia;
        pl.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:pl animated:YES];

  }else if ([kv.Key isEqualToString:@"PO For Approve"]) {
      
      xtype=3;
      [self getcialistofcoforapprove];
      potitle=kv.Key;
//      forapprovepocials *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"forapprovepocials"];
//      pl.mxtype=1;
//      pl.title=kv.Key;
//      pl.masterciaid=self.mastercia;
//      pl.managedObjectContext=self.managedObjectContext;
//      [self.navigationController pushViewController:pl animated:YES];
      
  }else if ([kv.Key isEqualToString:@"PO Turn In"]) {
      xtype=4;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
//      forapprovepocials *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"forapprovepocials"];
//      pl.mxtype=2;
//       pl.title=kv.Key;
//      pl.masterciaid=self.mastercia;
//      pl.managedObjectContext=self.managedObjectContext;
//      [self.navigationController pushViewController:pl animated:YES];
  }else if ([kv.Key isEqualToString:@"PO Hold"]) {
//      forapprovepocials *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"forapprovepocials"];
//      pl.mxtype=3;
//       pl.title=kv.Key;
//      pl.masterciaid=self.mastercia;
//      pl.managedObjectContext=self.managedObjectContext;
//      [self.navigationController pushViewController:pl animated:YES];
      
      xtype=5;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
      
  }else if ([kv.Key isEqualToString:@"Requested VPO"]) {
     
      xtype=6;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
  }else if ([kv.Key isEqualToString:@"Requested VPO Hold"]) {
      
      xtype=7;
      potitle=kv.Key;
      [self getcialistofcoforapprove];
  }
    
    
}


-(void)getcialistofcoforapprove{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
         [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (xtype==1) {
             [service xGetMenuCOForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"3"];
        }else if(xtype==0){
             [service xGetMenuBustOutForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"3"];
        }else if(xtype==2){
            [service xGetMenuContractForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"3"];
        }else if(xtype==6){
            [service xGetMenuRequestedPOForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"3"];
        }else if(xtype==7){
            [service xGetMenuRequestedPOHold:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"3"];
        }else{
            [service xGetMenuPOForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia xtype:[[NSNumber numberWithInt:xtype-2] stringValue] EquipmentType:@"3"];
        }
       
    
    }
    
    
}

- (void) xGetMenuCOForApproveHandler: (id) value {
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
    NSMutableArray * rtnlist1=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    if (xtype==1) {
        if ([rtnlist1 count]==1) {
            wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
            
            [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
            coforapprove *pl =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"coforapprove"];
            pl.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:pl animated:YES];
        }else{
            coforapprovecials *cc =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"coforapprovecials"];
            cc.managedObjectContext=self.managedObjectContext;
            cc.mastercia=self.mastercia;
            cc.result=rtnlist1;
            cc.title=@"Change Order";
            [self.navigationController pushViewController:cc animated:YES];
        }
    }else if(xtype==0){
        if ([rtnlist1 count]==1) {
            wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
            
            [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
            bustoutls *pl =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"bustoutls"];
            
//            bustoutls *pl =[[bustoutls alloc]init];
            pl.title=@"Bust Out";
            pl.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:pl animated:YES];
        }else{
            bustoutcials *cc =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"bustoutcials"];
            cc.managedObjectContext=self.managedObjectContext;
            cc.mastercia=self.mastercia;
            cc.result=rtnlist1;
            cc.title=@"Bust Out";
            [self.navigationController pushViewController:cc animated:YES];
        }
    }else if(xtype==2){
        if ([rtnlist1 count]==1) {
            wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
            [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
            contractforapprove *pl =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"contractforapprove"];
            pl.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:pl animated:YES];
           
           
            
        }else{
            contractforapprovecials *cc =[self.storyboard instantiateViewControllerWithIdentifier:@"contractforapprovecials"];
            cc.managedObjectContext=self.managedObjectContext;
            cc.mastercia=self.mastercia;
            cc.result=rtnlist1;
            cc.title=@"Contract ISP";
            [self.navigationController pushViewController:cc animated:YES];
        }

    }else{
        if ([rtnlist1 count]==1) {
            wcfKeyValueItem *kv =[rtnlist1 objectAtIndex:0];
            if (xtype!=6 && xtype!=7) {
                NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
                forapprovepols *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"forapprovepols"];
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.mxtype=xtype-2;
                LoginS.title=potitle;
                [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
                [self.navigationController pushViewController:LoginS animated:YES];
            }else{
                NSArray *firstSplit = [kv.Value componentsSeparatedByString:@"("];
                [userInfo initCiaInfo:[kv.Key integerValue] andNm:[firstSplit objectAtIndex:0]];
                requestedvpols *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"requestedvpols"];
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.xtype=xtype;
                LoginS.title=potitle;
                [self.navigationController pushViewController:LoginS animated:YES];
            }
            
           
        }else{
        
            forapprovepocials *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"forapprovepocials"];
            pl.mxtype=xtype-2;
            pl.title=potitle;
            pl.masterciaid=self.mastercia;
            pl.managedObjectContext=self.managedObjectContext;
            [self.navigationController pushViewController:pl animated:YES];
        }
    }
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
