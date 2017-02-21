//
//  forapprovepocials.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-19.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "forapprovepocials.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "forapprovepols.h"
#import "requestedvpols.h"

@interface forapprovepocials ()<UITabBarDelegate>

@end

@implementation forapprovepocials

@synthesize searchtxt, ntabbar, ciatbview, mxtype, result,result1,masterciaid;



- (void)viewDidLoad
{
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
    searchtxt.delegate=self;
    ntabbar.delegate = self;
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"For Approve" ];
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshPrject:)];
    [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh3.png"] ];
    [[ntabbar.items objectAtIndex:3]setTitle:@"Refresh" ];
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"For Approve"]) {
        [self goback1: item];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self refreshPrject:item];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    result=[[NSMutableArray alloc]init];
    result1=[[NSMutableArray alloc]init];
    [searchtxt setText:@""];
    [self getPols];
}

-(IBAction)goback1:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)refreshPrject:(id)sender{
    [ciatbview reloadData];
    [self getPols];
}

-(void)getPols{
  
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (mxtype==4) {
            [service xGetMenuRequestedPOForApprove:self action:@selector(xGetMenuPOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"3"];
        }   else  if (mxtype==5) {
                [service xGetMenuRequestedPOHold:self action:@selector(xGetMenuPOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:masterciaid EquipmentType:@"3"];
        }else{
            [service xGetMenuPOForApprove:self action:@selector(xGetMenuPOForApproveHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] mastercompany:masterciaid xtype:[[NSNumber numberWithInt:mxtype] stringValue] EquipmentType:@"3"];
        }
    }
}

- (void) xGetMenuPOForApproveHandler: (id) value {
    
	
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
    [ciatbview reloadData];
//    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
//    if (ciatbview ==nil) {
//        if (self.view.frame.size.height>480) {
//            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325+87)];
//            uv.contentSize=CGSizeMake(self.view.frame.size.width,326+87);
//        }else{
//            ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325)];
//            uv.contentSize=CGSizeMake(self.view.frame.size.width,326);
//        }
//        
//        ciatbview.tag=2;
//        [uv addSubview:ciatbview];
//        ciatbview.delegate = self;
//        ciatbview.dataSource = self;
//    }else{
//        [uv addSubview: ciatbview];
//        [ciatbview reloadData];
//    }
    
 

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [result count];
}




- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
    if (mxtype==4 ||mxtype==5) {
      
        
        cell.textLabel.text=kv.Value;
      
    }else{
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@ (%@)", [firstSplit objectAtIndex:1], kv.Value];
    }
    cell.textLabel.font=[UIFont boldSystemFontOfSize:17.0];
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
        
        [searchtxt resignFirstResponder];
        
        NSIndexPath *indexPath = [ciatbview indexPathForSelectedRow];
        
        [ciatbview deselectRowAtIndexPath:indexPath animated:YES];
        
        
        wcfKeyValueItem *kv =[result objectAtIndex:(indexPath.row)];
        if (mxtype==4 || mxtype==5) {
            NSArray *firstSplit = [kv.Value componentsSeparatedByString:@"("];
            [userInfo initCiaInfo:[kv.Key integerValue] andNm:[firstSplit objectAtIndex:0]];
            requestedvpols *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"requestedvpols"];
            LoginS.managedObjectContext=self.managedObjectContext;
             LoginS.xtype=mxtype+2;
            LoginS.title=self.title;
            [self.navigationController pushViewController:LoginS animated:YES];
        }else{
        NSArray *firstSplit = [kv.Key componentsSeparatedByString:@","];
        forapprovepols *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"forapprovepols"];
        LoginS.managedObjectContext=self.managedObjectContext;
        LoginS.mxtype=self.mxtype;
        LoginS.title=self.title;
        [userInfo initCiaInfo:[[firstSplit objectAtIndex:0] integerValue] andNm:[firstSplit objectAtIndex:1]];
            [self.navigationController pushViewController:LoginS animated:YES];
        
        }
    }
    
    
}




- (void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str;
    
    str=[NSString stringWithFormat:@"Key like [c]'*%@*' or Value like [c]'*%@*'", searchtxt.text, searchtxt.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    result=[[result1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [ciatbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
