//
//  developmentVendorLs.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/27/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "developmentVendorLs.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import "Reachability.h"
#import "developmentVendorInfo.h"
#import "development.h"

@interface developmentVendorLs ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ciatbview;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation developmentVendorLs{
    UITableView *uVendorTable;
    NSMutableArray* result ;
}

@synthesize  idproject, searchkey, idmaster, ntabbar, ciatbview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        if ([idproject isEqualToString:@"-1"]) {
            [self gohome: item];
        }else{
            [self goBack: item];
        }
        
        
        
    }else if (item.tag == 2) {
        [self dorefresh];
    }
    
}


-(void)dorefresh{
      [self getVenodrInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([idproject isEqualToString:@"-1"]) {
         self.title=searchkey;
    }else{
        self.title=@"Preferred Vendors";
    }
    
    uVendorTable = ciatbview;
    
    UITabBarItem *firstItem0 ;
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2;
    if ([idproject isEqualToString:@"-1"]) {
        firstItem0= [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
        
        firstItem2 = [[UITabBarItem alloc]init];
        
    }else{
        BOOL aaa =NO;
        for (UIViewController *uc in self.navigationController.viewControllers) {
            if ([uc isKindOfClass:[development class]]) {
                aaa=YES;
                break;
            }
        }
        if (aaa) {
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"Development" image:[UIImage imageNamed:@"home.png"] tag:1];
        }else{
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
        }
        
        
        firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
        
    }
    
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    if ([idproject isEqualToString:@"-1"]) {
        //    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
        [[ntabbar.items objectAtIndex:3]setEnabled:NO ];
    }else{
        //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
        //        [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh)];
    }
    ntabbar.delegate = self;
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [self getVenodrInfo];
}
-(void)getVenodrInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        if ([idproject isEqualToString:@"-1"]) {
            [service xSearchVendorList:self action:@selector(xGetDevelopmentVendorListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] keyword:searchkey EquipmentType:@"3"];
        }else{
            [service xGetDevelopmentVendorList:self action:@selector(xGetDevelopmentVendorListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:idproject EquipmentType:@"3"];
        }
        
        
    }

}

- (void) xGetDevelopmentVendorListHandler: (id) value {
    
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
    result = (NSMutableArray*)value;
    if (result.count>0) {
        if([result isKindOfClass:[wcfArrayOfVendor class]]){
            
                [uVendorTable reloadData];
                [ntabbar setSelectedItem:nil];
            
            
            
        }
    }else{
//        [uVendorTable removeFromSuperview];
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-20, 21)];
        lbl.text=@"Vendors not Found.";
        lbl.textColor=[UIColor redColor];
        [uVendorTable addSubview:lbl];
         [ntabbar setSelectedItem:nil];
    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([result count]); // or self.items.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    wcfVendor *kv =[result objectAtIndex:(indexPath.row)];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
//    cell.textLabel.text=[NSString stringWithFormat:@"%@ ~ %@", kv.Idnumber, kv.Name];
    cell.textLabel.text=kv.Name;
    cell.detailTextLabel.text=kv.Contact;
    //    cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
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
    
    NSString* result22 = (NSString*)value;
    if ([result22 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSIndexPath *indexPath = [uVendorTable indexPathForSelectedRow];
        wcfVendor *vitem =[result objectAtIndex:indexPath.row];
//        NSLog(@"%@",vitem);
        if (vitem.Idcia) {
            [userInfo initCiaInfo:[vitem.Idcia intValue] andNm:@""];
        }
        developmentVendorInfo *pf =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"developmentVendorInfo"];
        pf.managedObjectContext=self.managedObjectContext;
        pf.idproject=self.idproject;
//        pf.title=vitem.Name;
        pf.idmaster=self.idmaster;
        pf.title=@"Vendor Profile";
        pf.idvendor=vitem.Idnumber;
        
        [self.navigationController pushViewController:pf animated:YES];
        
    }
}

//-(void)viewWillDisappear:(BOOL)animated{
//[userInfo initCiaInfo:0 andNm:@""];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
