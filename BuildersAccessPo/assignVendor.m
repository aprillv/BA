//
//  assignVendor.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-20.
//  Copyright (c) 2012年 lovetthomes. All rights reserved.
//

#import "assignVendor.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import "poemail.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "development.h"
#import "project.h"
#import "wcfArrayOfVendor.h"
#import "CustomKeyboard.h"
#import "forapprove.h"

@interface assignVendor ()<UITableViewDelegate, UITableViewDataSource, CustomKeyboardDelegate, UISearchBarDelegate, UITabBarDelegate>{
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

@implementation assignVendor

@synthesize xpocode, xpoid, xidcostcode, xidproject, rtnlist, searchField, xshipto, xdelivery, fromforapprove;

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
    
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [view addSubview: searchBar];
    searchBar.delegate=self;
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    self.view = view;
    
    if (view.frame.size.height>480) {
        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 454, 320, 50)];
    }else{
        
        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 366, 320, 50)];
    }
    [view addSubview:ntabbar];
    
    UITabBarItem *firstItem0 ;
    if (fromforapprove==1){
          firstItem0= [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else if (fromforapprove==2) {
        firstItem0= [[UITabBarItem alloc]initWithTitle:@"Development" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else if (fromforapprove==3){
        firstItem0= [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
    firstItem0= [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    }

    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh:)];
    
    if (self.view.frame.size.height>480) {
        uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 410)];
    }else{
        uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 322)];
    }
    [view addSubview:uv];
    
    view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
//    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:item];
    }else if(item.tag == 2){
        [self dorefresh:item];
    }
}

-(IBAction)dorefresh:(id)sender{
    currentPageNo=1;
    rtnlist=nil;
    [ciatbview removeFromSuperview];
    [self getVenderls:currentPageNo];
}
-(IBAction)goback1:(id)sender{
    if (fromforapprove==4) {
        [self gohome:nil];
    }else{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if (fromforapprove==2) {
            if ([temp isKindOfClass:[development class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }else if(fromforapprove==1){
            if ([temp isKindOfClass:[forapprove class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }

        }else{
            if ([temp isKindOfClass:[project class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
    
        
        }}}
    
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
    str=[NSString stringWithFormat:@"Contact like [c]'*%@*' or Name like [c]'*%@*' or Idnumber like '*%@*'", searchBar.text, searchBar.text, searchBar.text];
    
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
     self.title=@"Select Vendor";
    searchField.text=@"";
    currentPageNo=1;
    [self getVenderls:currentPageNo];
}

-(void)getVenderls: (int)xpageNo{
//    NSLog(@"%d", xpageNo);
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        currentPageNo=xpageNo;
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetVendors:self action:@selector(xGetVendorsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidcostcode:xidcostcode projectid:xidproject currentPage:xpageNo EquipmentType:@"3"];
    }
    
}

- (void) xGetVendorsHandler: (id) value {
   
    
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
    
    UIScrollView *sv =uv;
    
    
   
    
	if([result isKindOfClass:[wcfArrayOfVendor class]]){
        wcfVendor *vitme=[result objectAtIndex:0];
        if (currentPageNo==1) {
            pageNo=[vitme.TotalPage intValue];
        }
        [result removeObjectAtIndex:0];
        if (rtnlist==nil) {
            rtnlist=[[NSMutableArray alloc]init];
        }
        
        [rtnlist addObjectsFromArray:[(wcfArrayOfVendor *)result toMutableArray]];
//        if (currentPageNo==1) {
//            NSLog(@"%d", [rtnlist count]);
//        }
//        for(wcfVendor *vitme in result){
//            [rtnlist addObject:vitme];
//        }
//        if (currentPageNo==1) {
//            NSLog(@"%d", [rtnlist count]);
//        }
        if (pageNo==currentPageNo) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if ([rtnlist count]>0) {
                result1=rtnlist;
                if (ciatbview ==nil) {
                    if (self.view.frame.size.height>480) {
                        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 325+84)];
                        uv.contentSize=CGSizeMake(320.0,326+87);
                    }else{
                        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 325)];
                        uv.contentSize=CGSizeMake(320.0,326);
                    }
//                    ciatbview.layer.cornerRadius = 10;
                    ciatbview.tag=2;
                    [uv addSubview:ciatbview];
                    ciatbview.delegate = self;
                    ciatbview.dataSource = self;
                    [ntabbar setSelectedItem:nil];
                }else{
                    [uv addSubview: ciatbview];
                    [ciatbview reloadData];
                    [ntabbar setSelectedItem:nil];
                }

                
            }else{
                UILabel *lbl;
                
                lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 170, 300, 35)];
                lbl.tag=3;
                lbl.text=@" Vendor not found.";
                lbl.textColor=[UIColor redColor];
                [sv addSubview:lbl];
                [ntabbar setSelectedItem:nil];
            }

        }else{
            [self getVenderls:(currentPageNo +1)];
        }
        
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
    
    wcfVendor *kv =[result1 objectAtIndex:(indexPath.row)];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text=kv.Name;
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
    
    NSString* result = (NSString*)value;
    if ([result isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
         NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        wcfVendor *vitem =[rtnlist objectAtIndex:indexPath.row];
        poemail *bug=[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"poemail"];
        bug.managedObjectContext=self.managedObjectContext;
        bug.idpo1=self.xpoid;
        bug.xmcode=self.xpocode;
        bug.idvendor=vitem.Idnumber;
        bug.xtype=0;
        bug.isfromassign=YES;
        [self.navigationController pushViewController:bug animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
