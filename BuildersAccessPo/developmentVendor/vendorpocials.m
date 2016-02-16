//
//  vendorpocials.m
//  BuildersAccess
//
//  Created by roberto ramirez on 10/9/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "vendorpocials.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import "Reachability.h"
#import "projectpo.h"

@interface vendorpocials ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *uVendorTable;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation vendorpocials{
    NSMutableArray *result;
    int tmcia;
    
}

@synthesize idvendor=_idvendor, ntabbar, uVendorTable;

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
        
            [self gohome:item];
        
        
    }else if(item.tag == 2){
        [self dorefresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"Open POs";
    
    UITabBarItem *firstItem0 ;
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2;
    
    firstItem0= [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    
    firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    
    
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    ntabbar.delegate = self;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    tmcia=[userInfo getCiaId];
    [self getCiaList];
}

-(void)dorefresh{
    [self getCiaList];
}

-(void)getCiaList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetVendorPOSelectCia:self action:@selector(xGetVendorPOSelectCiaHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] idvendor:_idvendor EquipmentType:@"3"];
       
        
    }

}

- (void) xGetVendorPOSelectCiaHandler: (id) value {
    
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
       
            [uVendorTable reloadData];
            [ntabbar setSelectedItem:nil];
        
    }else{
//        [uVendorTable removeFromSuperview];
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-20, 21)];
        lbl.text=@"Company not Found.";
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
    
    wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    
    NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)", [firstSplit objectAtIndex:1], kv.Value];
    
        
  
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
        wcfKeyValueItem *kv =[result objectAtIndex:indexPath.row];
        //        NSLog(@"%@",vitem);
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        
      
         projectpo *cc =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectpo"];
        
        tmcia=[userInfo getCiaId];
        cc.idmaster=[NSString stringWithFormat:@"%d", [userInfo getCiaId]];
         [userInfo initCiaInfo:[ [firstSplit objectAtIndex:0] intValue] andNm: [firstSplit objectAtIndex:1]];
        //                    if ([result.Status isEqualToString:@"Closed"]) {
        //                        cc.xtype=1;
        //                    }else{
        //                        cc.xtype=0;
        //                    }
        cc.idvendor=self.idvendor;
        cc.idproject=@"-1";
        cc.isfromdevelopment=-1;
        cc.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:cc animated:YES];
       
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [userInfo initCiaInfo:tmcia andNm: @""];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
