//
//  newpovendorls.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "newpovendorls.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import "poemail.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "development.h"
#import "project.h"
#import "newpoqtyls.h"
#import "cl_reason.h"
#import "wcfArrayOfVendor.h"
#import "CustomKeyboard.h"

@interface newpovendorls ()<UITableViewDelegate, UITableViewDataSource, CustomKeyboardDelegate, UISearchBarDelegate,UITabBarDelegate>{
    UITabBar *ntabbar;
    UIScrollView *uv;
    UISearchBar *searchBar;
    CustomKeyboard *keyboard;
    UITableView *ciatbview;
    NSMutableArray *result1;
}

@end

int pageNo;
int currentPageNo;

@implementation newpovendorls

@synthesize  xidproject, rtnlist, xtype, searchField, xidvendor, idmaster, xxnvendor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [view addSubview: searchBar];
    searchBar.delegate=self;
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    self.view = view;
    
    if (view.frame.size.height>480) {
        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 370+84, self.view.frame.size.width, 50)];
    }else{
        
        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 366, self.view.frame.size.width, 50)];
    }
    [view addSubview:ntabbar];
    
    UITabBarItem *firstItem0 ;
    firstItem0= [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]init];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    ntabbar.delegate = self;
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3] setEnabled:NO];
    
    if (self.view.frame.size.height>480) {
        uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 326+84)];
    }else{
        uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 326)];
    }
    [view addSubview:uv];
    
    view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:item];
    }
}
-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        
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
    str=[NSString stringWithFormat:@"name like [c]'*%@*'", searchBar.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result1=[[rtnlist filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Select a Reason";
    searchField.text=@"";
    currentPageNo=1;
    [self getReason];
}

-(void)getReason{
    cl_reason *mp=[[cl_reason alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    
    NSString *str;
    if (xtype==1) {
         str=[NSString stringWithFormat:@"idcia ='%@' and idnumber=99", idmaster];
    }else{
     str=[NSString stringWithFormat:@"idcia ='%@'  and idnumber!=99 ", idmaster];
    }
   
    rtnlist = [mp getReasonList:str];
    result1=rtnlist;
    if (ciatbview ==nil) {
        if (self.view.frame.size.height>480) {
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325+84)];
            uv.contentSize=CGSizeMake(self.view.frame.size.width,326+87);
        }else{
            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325)];
            uv.contentSize=CGSizeMake(self.view.frame.size.width,326);
        }
        ciatbview.layer.cornerRadius = 10;
        ciatbview.tag=2;
        [uv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
    }else{
        [uv addSubview: ciatbview];
        [ciatbview reloadData];
    }

    
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([result1 count]); // or self.items.count;
    
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
    
    NSEntityDescription *kv =[result1 objectAtIndex:(indexPath.row)];
    cell.textLabel.text = [kv valueForKey:@"name"];
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        
        
        NSEntityDescription *kv =[result1 objectAtIndex:(indexPath.row)];
        newpoqtyls *bug=[[newpoqtyls alloc]init];
        bug.managedObjectContext=self.managedObjectContext;
        bug.xidreason=[kv valueForKey:@"idnumber"];
        bug.xnreason=[kv valueForKey:@"name"];
        bug.xidproject=self.xidproject;
        bug.xidvendor=self.xidvendor;
        bug.xnvendor=self.xxnvendor;
        [self.navigationController pushViewController:bug animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
