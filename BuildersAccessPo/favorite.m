//
//  favorite.m
//  BuildersAccess
//
//  Created by amy zhao on 13-3-11.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "favorite.h"
#import "cl_favorite.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "development.h"
#import "project.h"
#import "userInfo.h"
#import "cl_cia.h"
#import "Reachability.h"
#import "wcfService.h"

@interface favorite ()<UITabBarDelegate>

@end

@implementation favorite

@synthesize rtnlist;
@synthesize searchtxt, ntabbar;


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
	// Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    searchtxt.delegate=self;
    
    ntabbar.userInteractionEnabled = YES;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
    ntabbar.delegate = self;
    
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setImage:nil ];
    [[ntabbar.items objectAtIndex:3]setTitle:nil ];
    [[ntabbar.items objectAtIndex:3]setEnabled:NO ];

    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [self getPojectls];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Home"]) {
        [self gohome:item];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [ntabbar setSelectedItem:nil];
}

-(void)getPojectls{

    cl_favorite *mf =[[cl_favorite alloc]init];
    mf.managedObjectContext=self.managedObjectContext;
    rtnlist = [mf getProject:nil];
    
    
    
    UIScrollView *sv =(UIScrollView *)[self.view viewWithTag:1];
//    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    if (self.view.frame.size.height>480) {
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325+87)];
        sv.contentSize=CGSizeMake(self.view.frame.size.width,326+87);
    }else{
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 325)];
        sv.contentSize=CGSizeMake(self.view.frame.size.width,326);
    }
  
    tbview.tag=2;
    tbview.delegate = self;
    tbview.dataSource = self;
    [sv addSubview:tbview];

    
}

-(void)doneClicked{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
    cl_favorite *mp =[[cl_favorite alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    NSString *kes =[Mysql TrimText:searchtxt.text];
    NSString *str =[NSString stringWithFormat:@"(idnumber like [c]'%@*') or (planname like [c]'*%@*') or (name like [c]'*%@*') or (status like [c]'*%@*')",kes,kes, kes,kes];
    rtnlist=[mp getProject:str];
    
    [tbview reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.rtnlist count]); // or self.items.count;
    
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
    
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text = [kv valueForKey:@"name"];
    if ([[kv valueForKey:@"status"] isEqualToString:@"Development"]) {
        cell.detailTextLabel.text=@"Development";
    }else{
        [cell.detailTextLabel setNumberOfLines:0];
        if ([kv valueForKey:@"planname"] ==nil) {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"\n%@", [kv valueForKey:@"status"]];
        }else{
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", [kv valueForKey:@"planname"], [kv valueForKey:@"status"]];
        }
        
    }
    [cell .imageView setImage:nil];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 66;
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
         NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
        
        [tbview deselectRowAtIndexPath:indexPath animated:YES];
        
        [searchtxt resignFirstResponder];
        NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
        
        cl_cia *ma = [[cl_cia alloc]init];
        ma.managedObjectContext=self.managedObjectContext;
        NSMutableArray *rtnls =[ma getCiaListWithStr:[NSString stringWithFormat:@"ciaid=%@", [kv valueForKey:@"idcia"]]];
        if ([rtnls count]==1) {
            NSEntityDescription *cia=[rtnls objectAtIndex:0];
            [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"] intValue] andNm:[cia valueForKey:@"cianame"]];
            
            if ([[kv valueForKey:@"Status"] isEqualToString:@"Development"]) {
                development *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"development"];
                LoginS.managedObjectContext=self.managedObjectContext;
                LoginS.idproject=[kv valueForKey:@"idnumber"];
                
                [self.navigationController pushViewController:LoginS animated:YES];
            }else{
                project *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"project"];
                LoginS.idproject=[kv valueForKey:@"idnumber"];
                LoginS.managedObjectContext=self.managedObjectContext;
                [self.navigationController pushViewController:LoginS animated:YES];
            }
        }
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
