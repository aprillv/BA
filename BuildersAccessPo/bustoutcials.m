//
//  bustoutcials.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "bustoutcials.h"
#import <QuartzCore/QuartzCore.h>
#import "Mysql.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "bustoutls.h"
#import "CustomKeyboard.h"

@interface bustoutcials ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustomKeyboardDelegate, UITabBarDelegate>{
    CustomKeyboard *keyboard;
    NSMutableArray* result1;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *ciatbview;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;


@end

@implementation bustoutcials
@synthesize mastercia, result, ciatbview,searchBar, ntabbar;


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:item];
    }else if(item.tag == 2){
        [self refreshPrject:item];
    }
}
-(IBAction)goback1:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler2:) version:version];
    }
}
- (void) xisupdate_iphoneHandler2: (id) value {
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
    
    NSString* result5 = (NSString*)value;
    if ([result5 isEqualToString:@"1"]) {
        
        //        UIAlertView *alert = nil;
        //        alert = [[UIAlertView alloc]
        //                 initWithTitle:@"BuildersAccess"
        //                 message:@"There is a new version?"
        //                 delegate:self
        //                 cancelButtonTitle:@"Cancel"
        //                 otherButtonTitles:@"Ok", nil];
        //        alert.tag = 1;
        //        [alert show];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [searchBar resignFirstResponder];
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        
        [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
        bustoutls *pl =[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"bustoutls"];
        pl.title=@"Bust Out";
        pl.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:pl animated:YES];
    }
    
    
}


-(IBAction)refreshPrject:(id)sender{
    
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
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        
        //        UIAlertView *alert = nil;
        //        alert = [[UIAlertView alloc]
        //                 initWithTitle:@"BuildersAccess"
        //                 message:@"There is a new version?"
        //                 delegate:self
        //                 cancelButtonTitle:@"Cancel"
        //                 otherButtonTitles:@"Ok", nil];
        //        alert.tag = 1;
        //        [alert show];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
            [alert show];
        }else{
            wcfService* service = [wcfService service];
            NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler3:) version:version];
        }
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
    
    NSString* result3 = (NSString*)value;
    if ([result3 isEqualToString:@"1"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        [ciatbview removeFromSuperview];
        [self getcialistofcoforapprove];
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [ciatbview removeFromSuperview];
    [self getcialistofcoforapprove];
}

-(void)getcialistofcoforapprove{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetMenuBustOutForApprove:self action:@selector(xGetMenuCOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:mastercia EquipmentType:@"3"];
    }
    
    
}

- (void) xGetMenuCOForApproveHandler: (id) value {
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
    
    result=[(wcfArrayOfKeyValueItem*)value toMutableArray];
    
    result1=result;
//    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    
    [ciatbview reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchBar setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    
    
    
    
    UITabBarItem *firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshPrject:)];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    //    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
//    uv.contentSize=CGSizeMake(320.0,425.0+80);
    
	// Do any additional setup after loading the view.
    if (result!=nil) {
        result1=result;
        [ciatbview reloadData];
    }else{
        [self getcialistofcoforapprove];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [result count];
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
    
    wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
    NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)", [firstSplit objectAtIndex:1], kv.Value];
//    cell.textLabel.font=[UIFont systemFontOfSize:17.0];
    [cell .imageView setImage:nil];
    return cell;
    
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
    str=[NSString stringWithFormat:@"Key like [c]'*%@*' or Value like [c]'%@'", searchBar.text, searchBar.text];
    
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
