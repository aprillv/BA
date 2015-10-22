//
//  bustoutls.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "bustoutls.h"
#import "userInfo.h"
#import "Mysql.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "po1.h"
#import "forapprove.h"
#import "bustoutdetail.h"
#import "wcfArrayOfStartPackItem.h"
#import "CustomKeyboard.h"


@interface bustoutls ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate, UITabBarDelegate>{
    CustomKeyboard *keyboard;
    UIScrollView *uv;
    NSMutableArray* result1;
    NSMutableArray* result;
    int currentpage;
    int pageNo;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UITableView *ciatbview;


@end

@implementation bustoutls

@synthesize masterciaid, searchBar, ntabbar, ciatbview;

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
        [self goBack1:item];
    }else if(item.tag == 2){
        [self dorefresh: item];
    }
}

-(IBAction)goBack1:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    [ntabbar setItems:itemsArray animated:YES];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    [self drawpage];
    [self getPols];
}


-(void)getPols {
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetBustOutListForApprove:self action:@selector(xGetProjectCOListHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] EquipmentType:@"3"];
    }
    
}
- (void) xGetProjectCOListHandler: (id) value {
    
	
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
    
    result =[(wcfArrayOfBustOutListItem*)value toMutableArray];
    result1=result;
    [self drawpage];
}

-(void)drawpage{
    result1=result;
    [ciatbview reloadData];
    
    [ntabbar setSelectedItem:nil];
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
        [self getPols];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([result count]); // or self.items.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;    }
    
    wcfBustOutListItem *kv =[result objectAtIndex:(indexPath.row)];
    cell.textLabel.text =kv.Nproject;
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Consultant: %@\nDate: %@", kv.Sales1, kv.refdate];
    [cell.detailTextLabel sizeToFit];
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
        
        wcfBustOutListItem *kv =[result objectAtIndex:(indexPath.row)];
        bustoutdetail *cpd =[self.storyboard instantiateViewControllerWithIdentifier:@"bustoutdetail"];
        cpd.managedObjectContext=self.managedObjectContext;
        cpd.xidbustout=kv.Idnumber;
        
        [self.navigationController pushViewController:cpd animated:YES];
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
    str=[NSString stringWithFormat:@"Sales1 like [c]'*%@*' or refdate like '*%@*' or Nproject like [c]'*%@*'", searchBar.text, searchBar.text, searchBar.text];
    
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
