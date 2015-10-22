//
//  selectitem.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "selectitem.h"
#import "Mysql.h"
#import "userInfo.h"
#import "wcfService.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "addItem.h"
#import "calendarqa.h"
#import "CustomKeyboard.h"
#import "project.h"

@interface selectitem ()<UISearchBarDelegate,CustomKeyboardDelegate >{
    NSMutableArray *rtn;
     NSMutableArray *rtnNotChange;
    NSString *nextid;
    NSString *isshow;
    NSString *selectedCategory;
    CustomKeyboard *keyboard;
}
@property (weak, nonatomic) IBOutlet UITableView *ut;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation selectitem

@synthesize idnumber,fromtype, ut, ntabbar, searchBar;

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
//        [self dorefresh: item];
    }
}

- (void)doneClicked{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText{
    
    NSString* str=[NSString stringWithFormat:@"SELF='%@'", searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    
    rtn = [[rtnNotChange filteredArrayUsingPredicate:predicate] mutableCopy];
    
   
    [ut reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [searchBar resignFirstResponder];
}


-(IBAction)goBack1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[calendarqa class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }else if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }

        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Select a Category";
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    UITabBarItem *firstItem0 ;
    if (fromtype==1) {
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Calendar" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }
    UITabBarItem *fi;
    fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh:)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [service xGetQAInspection2bAdd:self action:@selector(xGetCalendarEntryHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber EquipmentType:@"3"];
        // Do any additional setup after loading the view.
    }
    
}

-(void)autoUpd{
    
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
        addItem *ai=[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"addItem"];
        ai.managedObjectContext=self.managedObjectContext;
        ai.idnumber=nextid;
        ai.isshow=isshow;
        ai.fromtype=fromtype;
        ai.category=selectedCategory;
        [self.navigationController pushViewController:ai animated:YES];
    }
    
    
}


- (void) xGetCalendarEntryHandler: (id) value {
    
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
    
    rtn=[(wcfArrayOfstring *)value toMutableArray];
    rtnNotChange=rtn;
    if ([rtn count]>2) {
        nextid= [rtn objectAtIndex:0];
        [rtn removeObjectAtIndex:0];
        isshow=[rtn objectAtIndex:0];
        [rtn removeObjectAtIndex:0];
    }
    
   
    
  
    
    [ut setRowHeight:44];
    ut.delegate = self;
    [ut reloadData];
    
    
//    [self drawScreen];
//    [ntabbar setSelectedItem:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSString *item = [rtn objectAtIndex:indexPath.row];
    cell.textLabel.text =item;
    [cell .imageView setImage:nil];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedCategory=[rtn objectAtIndex:indexPath.row];
    [self autoUpd];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [rtn count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
