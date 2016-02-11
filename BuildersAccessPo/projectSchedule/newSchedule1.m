//
//  newSchedule1.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "newSchedule1.h"
#import "wcfArrayOfProjectSchedule.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "newSchedule2.h"
#import "CKCalendarCellColors.h"

@interface newSchedule1 ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation newSchedule1{
    wcfArrayOfProjectSchedule * wi;
    wcfProjectSchedule *xidnum;
}

@synthesize xidproject, isshowTaskDue, tbview, ntabbar;

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
    
    self.title=@"Project Schedule";
    
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi;
//    if (isshowTaskDue) {
//        fi =[[UITabBarItem alloc]initWithTitle:@"Task Due" image:[UIImage imageNamed:@"schedule.png"] tag:2];
//    }else{
        fi =[[UITabBarItem alloc]init];
//    }
    
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:3];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
   
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    if (isshowTaskDue) {
        //         [[ntabbar.items objectAtIndex:1]setAction:@selector(goTaskDue)];
    }else{
        [[ntabbar.items objectAtIndex:1] setEnabled:NO ];
    }
    
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    tbview.rowHeight = 50.0f;
    //    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
    self.view.backgroundColor=[UIColor whiteColor];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:item];
    }else if(item.tag == 2){
        if (isshowTaskDue) {
            [self goTaskDue];
        }
    }else if(item.tag == 3){
        [self dorefresh];
    }
}

-(void)dorefresh{
    [self getMilestone];
}

-(void)goTaskDue{
    newSchedule2 *ns =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"newSchedule2"];
    ns.managedObjectContext=self.managedObjectContext;
    ns.xidproject=self.xidproject;
    ns.xidstep=@"-1";
    ns.title=@"Task Due List";
    [self.navigationController pushViewController:ns animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getMilestone];
}
-(void)getMilestone{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [service xGetNewSchedule1:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:xidproject EquipmentType:@"3"];
    }
    
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
    
    wi=(wcfArrayOfProjectSchedule *)value;
    
    
    
    
    
    [tbview reloadData];
    [ntabbar setSelectedItem:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [wi count];
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
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", event.Item, event.Name]];
    if (event.DcompleteYN) {
          cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@", event.Dstart, event.Dcomplete];
    }else{
      cell.detailTextLabel.text=event.Dcomplete;
    }
 
    
   
    
    
    
    
//    if ([event.Item isEqualToString:@"2"]) {
//        cell.textLabel.backgroundColor=[UIColor clearColor];
//        UIView *myView = [[UIView alloc] init];
//        myView.backgroundColor =kCalendarColorBlue;
//        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
//          cell.backgroundView = myView;
//    }
    
  
    

    
    
    [cell .imageView setImage:nil];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    xidnum=((wcfProjectSchedule *)[wi objectAtIndex:indexPath.row]);
    [self doupdateCheck];
}

-(void)doupdateCheck{
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
    }else{
        newSchedule2 *ns =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"newSchedule2"];
        ns.managedObjectContext=self.managedObjectContext;
        ns.xidproject=self.xidproject;
        ns.xidstep=xidnum.Item;
        ns.title=[NSString stringWithFormat:@"%@ - %@", xidnum.Item, xidnum.Name];
        [self.navigationController pushViewController:ns animated:YES];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
