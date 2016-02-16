//
//  multiSearchRslt.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/23/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "multiSearchRslt.h"
#import "Reachability.h"
#import "userInfo.h"
#import "wcfService.h"
#import "project.h"
#import "cl_cia.h"

@interface multiSearchRslt ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation multiSearchRslt{
    UIScrollView *sv;
    int donext;
    wcfArrayOfProjectListItem *wi;
}

@synthesize keyWord, ntabbar, tbview;




-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gohome:item];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *     fi =[[UITabBarItem alloc]init];
    
    
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]init];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setEnabled:NO ];
    
    self.title=keyWord;
    [self getSearchResult];
    
    
//    tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, xheight)];
//    //    tbview.layer.cornerRadius = 10;
//    tbview.delegate = self;
//    tbview.dataSource = self;
//    //    tbview.editing=YES;
//    [uv addSubview:tbview];
    
	// Do any additional setup after loading the view.
}

-(void)getSearchResult{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [service xSearchProjects:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] keyword:keyWord EquipmentType:@"3"];
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
    
    wi=(wcfArrayOfProjectListItem *)value;
    //    if (uv) {
    //        [uv removeFromSuperview];
    //    }
    if (wi.count>0) {
       
        [tbview reloadData];
        
    }else{
        UILabel *lbl;
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-20, 21)];
        lbl.text=@"Projects not Found.";
        lbl.textColor=[UIColor redColor];
        [tbview addSubview:lbl];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [wi count];
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
    
    wcfProjectListItem *kv =[wi objectAtIndex:(indexPath.row)];
    
  
    cell.textLabel.text =kv.ProjectName;
    //    cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0];
    if ([kv.Status isEqualToString:@"Development"]) {
        cell.detailTextLabel.text=@"Development";
    }else{
        if(kv.PlanName==nil){
            [cell.detailTextLabel setNumberOfLines:0];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"\n%@",kv.Status];
        }else{
            [cell.detailTextLabel setNumberOfLines:0];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", kv.PlanName, kv.Status];
        }
        
    }
    
    
    
    
    [cell .imageView setImage:nil];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    return 66*(font.pointSize/15.0);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self autoUpd];
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
        [self gotonextpage];
    }
    
    
}

-(void)gotonextpage {
    
  
    NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
    
    [tbview deselectRowAtIndexPath:indexPath animated:YES];
    wcfProjectListItem *kv =[wi objectAtIndex:(indexPath.row)];
    
//    if (xatype==1) {
//        development *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"development"];
//        LoginS.managedObjectContext=self.managedObjectContext;
//        LoginS.idproject=[kv valueForKey:@"idnumber"];
//        [self.navigationController pushViewController:LoginS animated:YES];
//    }else{
        project *LoginS=[self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"project"];
        LoginS.idproject=kv.IDNumber;
    cl_cia *ma = [[cl_cia alloc]init];
    ma.managedObjectContext=self.managedObjectContext;
//    NSLog(@"%@", kv.Idcia);
//     NSMutableArray *rtnls =[ma getCiaListWithStr:[NSString stringWithFormat:@"ciaid=%@",kv.Idcia]];
    
//    [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"] intValue] andNm:[cia valueForKey:@"cianame"]];
     [userInfo initCiaInfo:[kv.Idcia intValue] andNm:kv.Ncia];
//      [userInfo initCiaInfo:[kv.Idcia intValue] andNm:@""];
        LoginS.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:LoginS animated:YES];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
