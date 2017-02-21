//
//  qaInspector2.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "qaInspector2.h"
#import "wcfArrayOfQACalendarItem.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "calendarqa.h"
#import "qainspection.h"
#import "qainspectionb.h"

@interface qaInspector2 ()<UITableViewDataSource, UITableViewDelegate>{
    wcfArrayOfQACalendarItem * wi;
    NSString *xidnum;
}

@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation qaInspector2

@synthesize xyear, xmonth, xqaemail, tbview, ntabbar;

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
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Calendar" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi;
    fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    ntabbar.delegate =self;
    [ntabbar setItems:itemsArray animated:YES];
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}

-(void)goBack1{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[calendarqa class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }    }
    
}
-(void)dorefresh{
    [self getInspector];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getInspector];
}
-(void)getInspector{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        
        [service xGetInspectorByMonthAndEmail:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xyear:xyear xqaemail:xqaemail xmonth:xmonth EquipmentType:@"3"];
        // Do any additional setup after loading the view.
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
    
    wi=(wcfArrayOfQACalendarItem *)value;
    
    
    
    
    
    [tbview reloadData];
    [ntabbar setSelectedItem:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [wi count];
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
    
    wcfQACalendarItem *event =[wi objectAtIndex:(indexPath.row)];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [[cell textLabel] setText:event.Name];
    [[cell textLabel]setBackgroundColor:[UIColor clearColor]];
    UIView *myView = [[UIView alloc] init];
    

        
    
    if ([event.Color isEqualToString:@"Yellow"]) {
        myView.backgroundColor = [UIColor colorWithRed:218.0/256 green:165.0/256 blue:32.0/256 alpha:1.0];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else if([event.Color isEqualToString:@"Orange"]){
        //            myView.backgroundColor = [UIColor colorWithRed:255.0/256 green:204.0/256 blue:0.0 alpha:1.0];
        myView.backgroundColor=[UIColor orangeColor];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
        //        }else if([event.Color isEqualToString:@"Red"]){
        //            myView.backgroundColor = [UIColor redColor];
        //            [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else if([event.Color isEqualToString:@"Green"]){
        myView.backgroundColor = [UIColor colorWithRed:50.0/256 green:205.0/256 blue:50.0/256 alpha:1.0];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
        //        }else if([event.Color isEqualToString:@"Blue"]){
        //            myView.backgroundColor = [UIColor blueColor];
        //            [[cell textLabel]setTextColor:[UIColor blackColor]];
        //        }else if([event.Color isEqualToString:@"Purple"]){
        //            myView.backgroundColor = [UIColor purpleColor];
        //            [[cell textLabel]setTextColor:[UIColor blackColor]];
        //        }else if([event.Color isEqualToString:@"Pink"]){
        //            myView.backgroundColor = [UIColor colorWithRed:253.0/256 green:215.0/256 blue:228.0/256 alpha:1.0];
        //            [[cell textLabel]setTextColor:[UIColor blackColor]];
    }else if([event.Color isEqualToString:@"Brown"]){
        //255 192 203
        myView.backgroundColor = [UIColor brownColor];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else if([event.Color isEqualToString:@"Gray"]){
        //255 192 203
        myView.backgroundColor = [UIColor grayColor];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else{
        myView.backgroundColor = [UIColor whiteColor];
        [[cell textLabel]setTextColor:[UIColor blackColor]];
    }
    
       cell.backgroundView = myView;
    
    
    
    [cell .imageView setImage:nil];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    xidnum=((wcfQACalendarItem *)[wi objectAtIndex:indexPath.row]).Idnumber;
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
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      
            [service xGetQACalendarStatus:self action:@selector(xisupdate_iphoneHandler3:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:xidnum EquipmentType:@"3"];
               
        
        
        
        
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"0"]) {
        UIAlertView *alert = [self getErrorAlert: @"There is no QA Inspection in this event."];
        [alert show];
        return;
        
    }else{
        
        if ([result2 isEqualToString:@"Not Started"] || [result2 isEqualToString:@"Not Ready"]) {
            qainspection *qt =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"qainspection"];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=xidnum;
            qt.fromtype=1;
            [self.navigationController pushViewController:qt animated:YES];
        }else{
            qainspectionb *qt =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"qainspectionb"];
            qt.managedObjectContext=self.managedObjectContext;
            qt.idnumber=xidnum;
            qt.fromtype=1;
            [self.navigationController pushViewController:qt animated:YES];
        }
        
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
