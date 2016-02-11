//
//  projectpols.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-6.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectpols.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "po1.h"
#import "project.h"
#import "development.h"
#import "wcfArrayOfStartPackItem.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"

@interface projectpols ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate, MBProgressHUDDelegate, UITabBarDelegate>{
    CustomKeyboard *keyboard;
    UIScrollView *uv;
    NSMutableArray* result1;
    UITableView *ciatbview;
    UISearchBar *searchBar;
    UITabBar *ntabbar;
    int currentpage;
    int pageNo;
    MBProgressHUD *HUD;
}


@end

@implementation projectpols

@synthesize idproject, result, xtatus, isfromdevelopment, idvendor;

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
    
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    [view addSubview: searchBar];
    searchBar.delegate=self;
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    self.view = view;
    
    CGFloat screenWidth = view.frame.size.width;
    CGFloat screenHieight = view.frame.size.height;
    
    ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, screenHieight-29, screenWidth, 49)];
    
    [view addSubview:ntabbar];
    UITabBarItem *firstItem0 ;
    if (isfromdevelopment==1) {
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Development" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else  if (isfromdevelopment==0) {
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    }
    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gotoProject:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh:)];
    
    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, screenWidth, screenHieight - 93)];
    
    [view addSubview:uv];
    
    view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
//    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gotoProject:item];
    }else if(item.tag == 2){
        [self dorefresh:item];
    }
}

-(IBAction)gotoProject:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if(isfromdevelopment==1){
            if ([temp isKindOfClass:[development class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }else  if(isfromdevelopment==0){
        
        
        if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        
        }else{
            [self gohome:nil];
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.xtatus isEqualToString:@"Show All"]) {
        [self setTitle:@"All POs"];
    }else{
        [self setTitle:[NSString stringWithFormat:@"%@ POs", self.xtatus]];
    }
    if (!idvendor) {
        idvendor=@"";
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    result=nil;
    result1=nil;
    [searchBar setText:@""];
[self getPols:1];
}
-(void)getPols:(int)xpageNo {
    if (xpageNo==1) {
//        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:[NSString stringWithFormat:@"Downloading %@...",self.title ] delegate:self otherButtonTitles:nil];
//        [alertViewWithProgressbar show];
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        [self.navigationController.view addSubview:HUD];
        HUD.labelText=[NSString stringWithFormat:@"Downloading %@...",self.title ];
        
        HUD.progress=0;
        [HUD layoutSubviews];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [HUD show:YES];
        
    }else{
        HUD.progress= ((xpageNo-1)*1.0/pageNo);
    }
    currentpage=xpageNo;
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      
        [service xGetPO93list:self action:@selector(xGetPOForApproveListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] projectid:idproject idvendor:idvendor xstatus:xtatus currentPage:currentpage EquipmentType:@"3"];
    }
    
}
- (void) xGetPOForApproveListHandler: (id) value {
    
	
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
    
    NSMutableArray *ns1 =[(wcfArrayOfPOListItem*)value toMutableArray];
    
    wcfPOListItem *pi;
    if (pageNo==0) {
        pi= (wcfPOListItem *)[ns1 objectAtIndex:0];
        pageNo=[pi.TotalPage intValue];
    }
    
    [ ns1 removeObjectAtIndex:0];
    
    
    if (result==nil) {
        result=[[NSMutableArray alloc]init];
    }
    
    [result addObjectsFromArray:ns1];
    
    if (currentpage==pageNo) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        HUD.progress=1.0;
        [HUD hide];
        
        result1=result;
        
        
        if (ciatbview ==nil) {
            if (self.view.frame.size.height>480) {
                ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325+87)];
                uv.contentSize=CGSizeMake(self.view.frame.size.width,326+87);
            }else{
                ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325)];
                uv.contentSize=CGSizeMake(self.view.frame.size.width,326);
            }
//            uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
//            ciatbview.layer.cornerRadius = 10;
            ciatbview.tag = 2;
            ciatbview.rowHeight=82;
            [uv addSubview: ciatbview];
            ciatbview.delegate = self;
            ciatbview.dataSource = self;
        }else{
            [uv addSubview: ciatbview];
            [ciatbview reloadData];
        }
        [ntabbar setSelectedItem:nil];
    }else{
        [self getPols:(currentpage+1)];
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
    
    NSString* resultd = (NSString*)value;
    if ([resultd isEqualToString:@"1"]) {
        [ntabbar setSelectedItem:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        result=nil;
        result1=nil;
        [searchBar setText:@""];
        [self getPols:1];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.result count]); // or self.items.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfPOListItem *kv =[result objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text = kv.Doc;
    [cell.detailTextLabel setNumberOfLines:0];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@\n%@", kv.Nvendor, kv.Nproject, kv.Shipto];
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [searchBar resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfPOListItem *kv =[result objectAtIndex:(indexPath.row)];
        po1 *LoginS=[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"po1"];
        if (isfromdevelopment==1) {
            LoginS.fromforapprove=2;
        }else if (isfromdevelopment==0){
            LoginS.fromforapprove=3;
        }else{
        LoginS.fromforapprove=4;
        }
        
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.idpo1=kv.Idnumber;
        LoginS.xcode=kv.Code;
        LoginS.title=kv.Doc;
        [self.navigationController pushViewController:LoginS animated:YES];
    }
}



- (void)doneClicked{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText{
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"Doc like [c]'*%@*' or Nvendor like [c]'*%@*' or Nproject like [c]'*%@*' or Shipto like [c]'*%@*'", searchText, searchText, searchText, searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result=[[result1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
