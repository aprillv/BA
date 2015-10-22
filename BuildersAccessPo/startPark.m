//
//  startPark.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-27.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "startPark.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "wcfArrayOfStartPackItem.h"

@interface startPark ()<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>{
    UIScrollView *uv;
}
@property (weak, nonatomic) IBOutlet UITableView *ciatbview;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;


@end

@implementation startPark
@synthesize idproject, rtnlist, ciatbview, ntabbar;

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
        [self goProject:item];
    }else if(item.tag == 2){
        [self dorefresh:item];
    }
}

-(IBAction)goProject:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Start Pack";
    
    UITabBarItem *firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    ntabbar.delegate = self;
    [ntabbar setItems:itemsArray animated:YES];
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goProject:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    [self getScheduleLog];
    // Do any additional setup after loading the view from its nib.
}

-(void)getScheduleLog{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetStartPackList:self action:@selector(xGetStartPackListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: idproject EquipmentType: @"3"];
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [ntabbar setSelectedItem:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetStartPackList:self action:@selector(xGetStartPackListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid: idproject EquipmentType: @"3"];
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
    
    UIScrollView *sv=uv;
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    if ([result isKindOfClass:[wcfArrayOfStartPackItem class]]) {

        
        [result removeObjectAtIndex:0];
        
        
        rtnlist=result;
        
        if([rtnlist count] > 0){
            
            if (ciatbview ==nil) {
                if (self.view.frame.size.height>480) {
                    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 369+87)];
                    uv.contentSize=CGSizeMake(320.0,370+87);
                }else{
                    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 369)];
                    uv.contentSize=CGSizeMake(320.0,370);
                }
//                ciatbview.layer.cornerRadius = 10;
                ciatbview.tag=2;
                [uv addSubview:ciatbview];
                ciatbview.delegate = self;
                ciatbview.dataSource = self;
            }else{
                [uv addSubview: ciatbview];
                [ciatbview reloadData];
            }

            
        }else{
           UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 315, 25)];
            lbl.text=[self.title stringByAppendingString:@" not found."];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.textColor=[UIColor redColor];
            [sv addSubview:lbl];
        }
        
    }
	
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.rtnlist count]); // or self.items.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 48;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     wcfStartPackItem *kv =[rtnlist objectAtIndex:(indexPath.row)];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text=kv.StartPack;
    cell.detailTextLabel.text=kv.MValue;
    [cell .imageView setImage:nil];
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
