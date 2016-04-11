//
//  developmentVendorInfo.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/27/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "developmentVendorInfo.h"
#import "development.h"
#import "wcfService.h"
#import "Mysql.h"
#import "Reachability.h"
#import "userInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "project.h"
#import "vendorpocials.h"
#import "projectpo.h"

@interface developmentVendorInfo ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation developmentVendorInfo{
    wcfVendorInfo *result;
    UITableView *tbview;
    NSMutableArray *naContactList;
    BOOL aaa;
}

@synthesize idproject=_idproject, idvendor=_idvendor, idmaster, uv, ntabbar;


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
        if ([self.idproject isEqualToString:@"-1"]) {
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
             [self gohome:item];
        }else{
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
             [self goBack1];
        }
       
    }else if(item.tag == 2){
        [self dorefresh];
    }
}
-(void)goBack1{
    for (UIViewController *uc in self.navigationController.viewControllers) {
        if ([uc isKindOfClass:[development class]] || [uc isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:uc animated:YES];
        }
    }
}
-(void) dorefresh{
    
 [self getVendorInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UITabBarItem *firstItem0 ;
    if ([self.idproject isEqualToString:@"-1"]) {
        firstItem0= [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
        aaa =NO;
        for (UIViewController *uc in self.navigationController.viewControllers) {
            if ([uc isKindOfClass:[development class]]) {
                aaa=YES;
                break;
            }
        }
        if (aaa) {
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"Development" image:[UIImage imageNamed:@"home.png"] tag:1];
        }else{
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
        }
        
    }
    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
    //    if ([self.idproject isEqualToString:@"-1"]) {
    //        [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    //    }else{
    //        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
    //    }
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh)];
    
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    [self getVendorInfo];
}


-(void)getVendorInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
       
        if ([_idproject isEqualToString:@"-1"]) {
             [service xGetVendorInfo2:self action:@selector(xGetVendorsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xciaid:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xvendorid:_idvendor EquipmentType:@"3"];
            
        }else{
            [service xGetVendorInfo:self action:@selector(xGetVendorsHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xciaid:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xiddevelopment:_idproject xvendorid:_idvendor EquipmentType:@"3"];
        }
    }

}

- (void) xGetVendorsHandler: (id) value {
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
    result = (wcfVendorInfo*)value;
 

    for (UIView *uw1 in uv.subviews) {
        [uw1 removeFromSuperview];
    }
    [self drawPage];
    
}
-(void)drawPage{
    int y=10;
    int x=10;
    int lblwidth =(self.view.frame.size.width-20);
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 21)];
    lbl.text=result.Name;
    lbl.font=[UIFont boldSystemFontOfSize:17.0];
    lbl.textColor= [Mysql getLabelTitleColor];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y = y+30;
    
    UILabel *lbl2 =[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 30)];
    lbl2.layer.cornerRadius=8;
    int tmph =10;
    int tmpy=y;
    [uv addSubview:lbl2];
    y = y+5;
    
    int x2=18;
    int lblwidth2=284;
    if (result.cname) {
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(x2, y, lblwidth2, 21)];
        lbl.text=result.cname;
        [uv addSubview:lbl];
        y = y+30;
        tmph=tmph+30;
    }
    UITableView *tb;
    
    if (result.phone) {
        tb=[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, 35)];
        tb.delegate=self;
        tb.dataSource=self;
        tb.separatorColor=[UIColor clearColor];
//        tb.rowHeight=35;
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
        tb.rowHeight=35*(font.pointSize/15.0);
        
        tb.tag=10;
        [uv addSubview:tb];
        y = y+35;
        tmph =tmph+35;
    }
   
    
    if (result.Fax) {
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(x2, y, lblwidth2, 35)];
        lbl.text=[NSString stringWithFormat:@"Fax: %@", result.Fax];
        [uv addSubview:lbl];
        y = y+35;
         tmph =tmph+35;
    }
    
    if (result.Mobile) {
        tb =[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, 35)];
        tb.delegate=self;
        tb.dataSource=self;
        tb.separatorColor=[UIColor clearColor];
        tb.tag=11;
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
        tb.rowHeight=35*(font.pointSize/15.0);
        [uv addSubview:tb];
        y = y+35;
         tmph =tmph+35;

    }
    
    tb =[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, 35)];
    tb.delegate=self;
    tb.dataSource=self;
    tb.separatorColor=[UIColor clearColor];
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    tb.rowHeight=35*(font.pointSize/15.0);
    tb.tag=12;
    [uv addSubview:tb];
    y = y+40;
     tmph =tmph+35;
    
    y= y+15;
  
    lbl2.frame=CGRectMake(x, tmpy, lblwidth, tmph);
    
    
    if (result.ContractList &&[result.ContractList count]>0) {
        
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 21)];
        lbl.text=@"Contact List";
        lbl.textColor= [Mysql getLabelTitleColor];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont boldSystemFontOfSize:17.0];
        [uv addSubview:lbl];
        y = y+31;
        
        
        
        naContactList=[[NSMutableArray alloc]init];
        NSMutableArray *ni;
        int i=14;
        tmph=0;
        lbl2 =[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 30)];
        lbl2.layer.cornerRadius=8;
        [uv addSubview:lbl2];
        y=y+5;
        for (wcfVendorContactItem *wi in result.ContractList) {
           
            ni=[[NSMutableArray alloc]init];
            if (wi.Name) {
                [ni addObject:wi.Name];
            }else{
                [ni addObject:@""];
            }
            
            if (wi.phone) {
                [ni addObject:[NSString stringWithFormat:@"Phone: %@", wi.phone]];
            }
            if (wi.Fax) {
                [ni addObject:[NSString stringWithFormat:@"Fax: %@", wi.Fax]];
            }
            if (wi.Mobile) {
                [ni addObject:[NSString stringWithFormat:@"Mobile: %@", wi.Mobile]];
            }
            [ni addObject:wi.Email];
            [naContactList addObject:ni];
            tb =[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, [ni count]*35)];
            tb.delegate=self;
           
            tb.dataSource=self;
            UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            
            tb.rowHeight=35*(font.pointSize/15.0);
            tb.separatorColor=[UIColor clearColor];
            tb.tag=i;
            i=i+1;
//            tb.layer.cornerRadius = 10;
            
            if (i-14==[result.ContractList count]) {
                lbl2 =[[UILabel alloc]initWithFrame:CGRectMake(x, y+([ni count]-1)*35+10, lblwidth, 30)];
                lbl2.layer.cornerRadius=8;
                [uv addSubview:lbl2];
            }
            [uv addSubview:tb];
            tmph=tmph+[ni count]*35+1;
            y = y+[ni count]*35+1;
            
        }
        
        y=y+20;
        
        
    }
    
    
    
    
    //     lbl2.layer.cornerRadius = 10;
    if (result.AssemblyList &&[result.AssemblyList count]>0) {
        lbl=[[UILabel alloc]initWithFrame:CGRectMake(x, y, lblwidth, 21)];
        if ([self.idproject isEqualToString:@"-1"]) {
            lbl.text=@"Cost Code";
        }else{
//            lbl.text=@"Category List";
            lbl.text=@"Assemblies Linked";
        }
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont boldSystemFontOfSize:17.0];
        lbl.textColor= [Mysql getLabelTitleColor];
        [uv addSubview:lbl];
        y = y+31;
        
        tb =[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, [result.AssemblyList count]*44)];
        tb.delegate=self;
        tb.dataSource=self;
        tb.tag=13;
        tb.layer.cornerRadius = 10;
        tb.userInteractionEnabled=NO;
        [uv addSubview:tb];
        y = y+[result.AssemblyList count]*44+15;
        
    }
    
    
    tb =[[UITableView alloc]initWithFrame:CGRectMake(x, y, lblwidth, 44)];
    tb.delegate=self;
    tb.dataSource=self;
    tb.separatorColor=[UIColor clearColor];
//    tb.rowHeight=44;
    UIFont *fontq = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    tb.rowHeight=44*(fontq.pointSize/15.0);
    tb.layer.cornerRadius = 10;
    tb.tag=9;
    [uv addSubview:tb];
    y = y+64;
    
    if (y > uv.frame.size.height+1) {
        uv.contentSize= CGSizeMake(self.view.frame.size.width, y);
    }
    
     [ntabbar setSelectedItem:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 10:
            case 9:
            case 11:
            case 12:
            return 1;
            break;
        case 13:
            return result.AssemblyList.count;
            break;
       
        default:
        {NSMutableArray *na =[naContactList objectAtIndex:tableView.tag-14];
            return [na count];}
            break;
    }
    
}


- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    switch (tableView.tag) {
        case 9:
            if ([_idproject isEqualToString:@"-1"]) {
                 cell.textLabel.text=@"Open POs";
            }else{
             cell.textLabel.text=@"All POs";
            }
           
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            break;
        case 10:
            cell.textLabel.text=[NSString stringWithFormat:@"Phone: %@", result.phone];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            break;
        case 11:
            cell.textLabel.text=[NSString stringWithFormat:@"Mobile: %@", result.Mobile];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            
            break;
        case 12:
            if (result.Email) {
                 cell.textLabel.text=result.Email;
            }else{
             cell.textLabel.text=@"";
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.selectionStyle=UITableViewCellEditingStyleNone;
            }
           
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            break;
        case 13:{
            wcfVendorAssemblyItem *ai =[result.AssemblyList objectAtIndex:indexPath.row];
//            NSLog(@"%@", ai);
            cell.textLabel.text=[NSString stringWithFormat:@"%@ ~ %@",ai.IdAssembly, ai.Name];
           cell.textLabel.font=[UIFont systemFontOfSize:17.0];
             cell.accessoryType=UITableViewCellAccessoryNone;
        }
           break;
//        case 14:{
//            wcfVendorContactItem *ai =[result.ContractList objectAtIndex:indexPath.row];
//            cell.textLabel.text=[NSString stringWithFormat:@"%@ ~ %@",ai.Name, ai.Email];
//            
//        }
//            break;
        default:
        {
            NSMutableArray *na =[naContactList objectAtIndex:tableView.tag-14];
            if (indexPath.row==0) {
                
                cell.accessoryType=UITableViewCellAccessoryNone;
//                cell.userInteractionEnabled=NO;
                cell.selectionStyle=UITableViewCellEditingStyleNone;
               
               
            }
            cell.textLabel.text=[na objectAtIndex:indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        }
         
            
            break;
    }
   
    //    cell.textLabel.font=[UIFont systemFontOfSize:17.0f];
    [cell .imageView setImage:nil];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag>13 && indexPath.row==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    tbview= tableView;
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
    
    NSString* result22 = (NSString*)value;
    if ([result22 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        switch (tbview.tag) {
            case 9:
            {
                if ([_idproject isEqualToString:@"-1"]) {
                    vendorpocials *cl =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"vendorpocials"];
                    cl.idvendor=self.idvendor;
                    cl.managedObjectContext=self.managedObjectContext;
                    [self.navigationController pushViewController:cl animated:YES];
                }else{
                    
                     projectpo *cc =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"projectpo"];
                    
                    cc.idmaster=idmaster;
                   
//                    if ([result.Status isEqualToString:@"Closed"]) {
//                        cc.xtype=1;
//                    }else{
//                        cc.xtype=0;
//                    }
                    cc.idvendor=self.idvendor;
                    cc.idproject=self.idproject;
                    if (aaa) {
                        cc.isfromdevelopment=1;
                    }else{
                    cc.isfromdevelopment=0;
                    }
                    
                    cc.managedObjectContext=self.managedObjectContext;
                    [self.navigationController pushViewController:cc animated:YES];
                }
                
            }
                break;
            case 10:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", result.phone]];
                [[UIApplication sharedApplication] openURL:url];
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                [tbview deselectRowAtIndexPath:indexPath animated:YES];
            }
                break;
            case 11:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", result.Mobile]];
                [[UIApplication sharedApplication] openURL:url];
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                [tbview deselectRowAtIndexPath:indexPath animated:YES];

            }
            case 12:
            {
                if (result.Email) {
                    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", result.Email ];
                    NSURL *url = [NSURL URLWithString:stringURL];
                    [[UIApplication sharedApplication] openURL:url];
                }
               
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                [tbview deselectRowAtIndexPath:indexPath animated:YES];

            }

                break;
                
            default:
            {
               
                NSIndexPath *indexPath = [tbview indexPathForSelectedRow];
                if (indexPath.row==0) {
                    [tbview deselectRowAtIndexPath:indexPath animated:YES];
                    return;
                }else{
                     NSMutableArray *na =[naContactList objectAtIndex:tbview.tag-14];
                    NSString *t=[na objectAtIndex:indexPath.row];
                    if ([[na objectAtIndex:indexPath.row] hasPrefix:@"Fax:"]) {
                        [tbview deselectRowAtIndexPath:indexPath animated:YES];
                        return;
                    }else  if ([[na objectAtIndex:indexPath.row] hasPrefix:@"Phone:"]) {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [t substringFromIndex:7]]];
                        NSLog(@"%@", url);
                        [[UIApplication sharedApplication] openURL:url];
                    }else if([[na objectAtIndex:indexPath.row] hasPrefix:@"Mobile:"]) {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [t substringFromIndex:8]]];
                        NSLog(@"%@", url);
                        [[UIApplication sharedApplication] openURL:url];
                    }else{
                        NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", t ];
                        
                        NSURL *url = [NSURL URLWithString:stringURL];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                   
                }
                [tbview deselectRowAtIndexPath:indexPath animated:YES];
                
               
                
                
            }
                
                break;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
