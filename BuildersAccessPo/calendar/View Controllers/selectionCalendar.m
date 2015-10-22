//
//  selectionCalendar.m
//  BuildersAccess
//
//  Created by roberto ramirez on 12/17/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "selectionCalendar.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "userInfo.h"
#import "wcfService.h"
#import "Mysql.h"
#import "CKCalendarView.h"
#import "selectiondetail.h"

@interface selectionCalendar ()<MBProgressHUDDelegate, CKCalendarViewDataSource, CKCalendarViewDelegate>{
    
}
@property (nonatomic, strong) CKCalendarView *calendarView;

@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, strong) NSMutableArray *events;

@end

@implementation selectionCalendar{
NSDateFormatter *dateFormatter;
    UITabBar *ntabbar;
    MBProgressHUD *HUD;
    NSString *tdate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view = view;
    //
    
    CGFloat screenWidth = view.frame.size.width;
    CGFloat screenHieight = view.frame.size.height;
    
    ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, screenHieight-30, screenWidth, 50)];
    
    [view addSubview:ntabbar];
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    //
    [ntabbar setItems:itemsArray animated:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh:)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        
        [self goBack: item];
    }else if (item.tag == 2) {
        
        [self dorefresh: item];
    }
}

-(IBAction)dorefresh:(id)sender{
    [self loadDot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
 [self loadDot];
    //    [[self calendarView]removeFromSuperview];
    //    [self setEvents:nil];
    
}
-(void)loadDot{
    
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetSelectionCalendarCnt:self action:@selector(xGetSelectionCalendarCntHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:@"1" EquipmentType:@"3"];
        
    }
}

- (void) xGetSelectionCalendarCntHandler: (id) value {
    
	
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
    
    NSMutableArray *a=[((wcfArrayOfstring *)value) toMutableArray];
    [self setEvents:a];
    CKCalendarView *cv = [CKCalendarView new];
    CGRect ct = cv.frame;
    ct.origin.y += 64;
    cv.frame = ct;
    cv.xtype=1;
    [self setCalendarView:cv];
    [[self calendarView] setDataSource:self];
    [[self calendarView] setDelegate:self];
    [[self view] addSubview:[self calendarView]];
    [ntabbar setSelectedItem:nil];
    
    
    [[self calendarView] setDate:[[self calendarView] date] animated:NO];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Toolbar Items

- (void)modeChangedUsingControl:(id)sender
{
    [[self calendarView] setDisplayMode:[[self modePicker] selectedSegmentIndex]];
}

- (void)todayButtonTapped:(id)sender
{
    [[self calendarView] setDate:[NSDate date] animated:NO];
    
    
    
}

#pragma mark - CKCalendarViewDataSource

- (BOOL)calendarView:(CKCalendarView *)CalendarView eventsForDate:(NSDate *)date
{
    
    NSString* str=[NSString stringWithFormat:@"SELF='%@'", [self stringFromDate2:date]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    
    if ([[[self events] filteredArrayUsingPredicate:predicate] count]>0) {
        return YES;
    }
    
    return NO;
}

- (void) xisupdate_iphoneHandler1: (id) value {
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        [HUD hide:YES];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        [HUD hide:YES];
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        [ntabbar setSelectedItem:nil];
        return;
    }
    
    NSString* resultd = (NSString*)value;
    if ([resultd isEqualToString:@"1"]) {
        [HUD hide:YES];
        [ntabbar setSelectedItem:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [self getPols];
    }
    
    
}

-(void)getPols {
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide:YES];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [service xGetSelectionCalendarList:self action:@selector(xGetSelectionCalendarListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:@"1" tdate:tdate EquipmentType:@"3"];
    }
    
}
- (void) xGetSelectionCalendarListHandler: (id) value {
    
	[HUD hide:YES];
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
    
    //    result =[(wcfArrayOfKeyValueItem*)value toMutableArray];
    //    result1=result;
    //    [self drawpage];
    
    if ([value count]>0) {
        [[self calendarView]setEvents1:value];
    }else{
        [[self calendarView]setEvents1:nil];
    }
    
}



-(NSString *)stringFromDate2:(NSDate *)date{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date
{
    //    if ([self isEqual:[self delegate]]) {
    //        return;
    //    }
    //
    //    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
    //        [[self delegate] calendarView:calendarView willSelectDate:date];
    //    }
}

- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    
    NSString* str=[NSString stringWithFormat:@"SELF = '%@'", [self stringFromDate2:date]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    NSMutableArray *na =[[[self events] filteredArrayUsingPredicate:predicate] mutableCopy];
    if ([na count]>0) {
        tdate=na[0];
        //        kirbytitlelist * kl =[[kirbytitlelist alloc]init];
        //        kl.managedObjectContext=self.managedObjectContext;
        //        kl.tdate=na[0];
        //        [self.navigationController pushViewController:kl animated:YES];
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=@"   Loading Event...   ";
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [HUD hide:YES];
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
            [alert show];
            [ntabbar setSelectedItem:nil];
        }else{
            wcfService* service = [wcfService service];
            NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            
            
            [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler1:) version:version];
        }
    }else{
        [[self calendarView]setEvents1:nil];
    }
    
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(wcfKirbytileItem *)event{
    tdate=event.Idnumber;
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
        selectiondetail *pd =[[selectiondetail alloc]init];
        pd.managedObjectContext=self.managedObjectContext;
        pd.idnumber=tdate;
        [self.navigationController pushViewController:pd animated:YES];
    }
}


#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;
}


@end
