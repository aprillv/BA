//
//  coforapproveupd.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "coforapproveupd.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "coforapproveupd1.h"
#import "Reachability.h"
#import "project.h"
#import "forapprove.h"

@interface coforapproveupd ()<UITabBarDelegate>

@end

@implementation coforapproveupd

@synthesize idnumber, idcia, uv, ntabbar, isfromapprove;

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
	
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    uv.backgroundColor = [Mysql groupTableViewBackgroundColor];
    
    [self getDetail];
}

-(void)viewWillAppear:(BOOL)animated{
    [ntabbar setSelectedItem:nil];
}


-(IBAction)doapprove:(id)sender{
    [self gotonextpage:1];
}

-(IBAction)dodisapprove:(id)sender{
    [self gotonextpage:2];
}

-(IBAction)doacknowledge:(id)sender{
    [self gotonextpage:3];
}

-(void)gotonextpage:(int)xtype3{
    xtype=xtype3;
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
        NSLog(@"%@", error.description);
        
       
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
        coforapproveupd1 *co =[self.storyboard instantiateViewControllerWithIdentifier:@"coforapproveupd1"];
        co.managedObjectContext=self.managedObjectContext;
        co.idco1=self.idnumber;
        co.idcia=self.idcia;
        co.xtype=xtype;
        co.title=self.title;
        co.isfromapprove=self.isfromapprove;
        [self.navigationController pushViewController:co animated:YES];
    }
}


-(void)getDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//        NSLog(@"%@ %@", idnumber, idcia);
        [service xGetCODetailForApprove:self action:@selector(xGetCODetailForApproveHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: idcia xcoid: idnumber EquipmentType: @"3"];
    }
}

- (void) xGetCODetailForApproveHandler: (id) value {
    
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
    
	// Do something with the wcfCODetail* result
    result = (wcfCODetail*)value;
    for (UIView *te in uv.subviews) {
        [te removeFromSuperview];
    }
    int y=10;
    float rowheight=32.0;
    
    UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=[NSString stringWithFormat:@"Project # %@", result.idproject];
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UIView *lbl1;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*4)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=result.Nproject;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, self.view.frame.size.width-30, rowheight-1)];
    if (result.Stage) {
        lbl.text=result.Stage;
    }else{
        lbl.text=@"Schedule Not Started";
        lbl.textColor=[UIColor redColor];
    }
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=result.ProjectStatus;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"C.O. Status: %@", result.Status];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    y=y+20;
    
//    UITableView *ciatbview;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-30, 21)];
    lbl.text=@"Floorplan";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    int rtn =4;
    if (result.Reverseyn ) {
        rtn=rtn+1;
    }
    if (result.Repeated){
        rtn=rtn+1;
    }
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*rtn)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-30, rowheight-1)];
    if (result.IDFloorplan !=nil) {
        lbl.text=[NSString stringWithFormat:@"Plan No. %@", result.IDFloorplan ];
    }else{
        lbl.text=@"Plan No.";
    }
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, self.view.frame.size.width-30, rowheight-1)];
//    if (result.Stage) {
//        lbl.text=result.Stage;
//    }else{
//        lbl.text=@"Schedule Not Started";
//        lbl.textColor=[UIColor redColor];
//    }
    lbl.text=result.PlanName;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, self.view.frame.size.width-30, rowheight-1)];
    if (result.Bedrooms ==nil || result.Baths == nil) {
        lbl.text=@"Beds  / Baths ";
    }else if (result.Bedrooms ==nil ) {
        lbl.text=[NSString stringWithFormat:@"Beds  / Baths %@", result.Baths];
    }else if(result.Baths==nil){
        lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths ", result.Bedrooms];
    }else{
        lbl.text=[NSString stringWithFormat:@"Beds %@ / Baths %@", result.Bedrooms, result.Baths];
    }
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+1, self.view.frame.size.width-30, rowheight-1)];
    if(result.Garage !=nil){
        lbl.text=[NSString stringWithFormat:@"Garage %@", result.Garage];
    }else{
        lbl.text=@"Garage";
    }                       
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    if (result.Reverseyn ) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width-20, rowheight-1)];
        lbl.text=@"Builder Reverse";
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lbl];
        y=y+rowheight-1;
    }
    
    if (result.Repeated){
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y-1, self.view.frame.size.width-20, rowheight-1)];
        lbl.text=@"Repeated Plan";
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lbl];
        y=y+rowheight-1;
    }
    y=y+20;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*3)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Buyer: %@", result.Buyer];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Requested: %@", result.Sales1];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, self.view.frame.size.width-30, rowheight-1)];
    if (result.PM1) {
        lbl.text=[NSString stringWithFormat:@"P.M.: %@", result.PM1];
    }else{
        lbl.text=@"P.M.:";
    }
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    y=y+20;
    
    rtn =[result.OrderDetailList count];
    if (rtn>0) {
//        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rtn*66)];
//        ciatbview.layer.cornerRadius = 10;
//        ciatbview.tag=6;
//        ciatbview.rowHeight=66;
//        ciatbview.dataSource=self;
//        ciatbview.delegate=self;
//        [uv addSubview:ciatbview];                               
//        y=y+rtn*66+20;
        
        UIView *lbl2 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 1)];
        lbl2.layer.cornerRadius=10.0;
        lbl2.backgroundColor = [UIColor whiteColor];
        [uv addSubview:lbl2];
        
        
        

        int fh;
        int i =0;
        for (wcfCOOrderDetail *wd in result.OrderDetailList) {
            i =i+1;
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-30, rowheight-1)];
            lbl.text=wd.Description;
            lbl.numberOfLines=0;
            lbl.font=[UIFont systemFontOfSize:14.0];
            [lbl sizeToFit];
            
            [uv addSubview:lbl];
            fh = lbl.frame.size.height;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+fh+6, self.view.frame.size.width-30, rowheight-1)];
            lbl.text=wd.Btype;
            lbl.numberOfLines=0;
            lbl.textColor=[UIColor darkGrayColor];
            lbl.font=[UIFont systemFontOfSize:13.0];
            [lbl sizeToFit];
            
            [uv addSubview:lbl];
            fh =fh+ lbl.frame.size.height;
            
            
            
            CGRect rc= lbl2.frame;
            rc.size.height=rc.size.height + 14+fh;
            lbl2.frame=rc;
            
            y= y+14+fh;
//            y=y+20;
        }
 
    }
    
    y=y+20;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*3)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Asking %@", result.Asking];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+3, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"Increase Asking %@", result.Increase];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+2, self.view.frame.size.width-30, rowheight-1)];
    lbl.text=[NSString stringWithFormat:@"New Price %@", result.Newprice];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight;
    y=y+20;
    
  
    
    ntabbar.delegate = self;
    
    if (isfromapprove) {
        UIButton* loginButton;
        
        if ([result.ApproveOrder isEqualToString:@"1"]) {
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Approve Order" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
             y=y+54;
        }
        
       
        if ([result.Acknowledge isEqualToString:@"1"]) {
            
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Acknowledge" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doacknowledge:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
             y=y+54;
        }
        
       
        
        if ([result.Disapprove isEqualToString:@"1"]) {
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(dodisapprove:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
             y=y+54;
        }
        
       
                
       
        
        UITabBarItem *firstItem0 ;
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
        UITabBarItem *fi;
        fi =[[UITabBarItem alloc]init];
        UITabBarItem *f2 =[[UITabBarItem alloc]init];
        UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
        NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
        
        [ntabbar setItems:itemsArray animated:YES];
        
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
        [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
        [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//        [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
       
    }else{
        UITabBarItem *firstItem0;
        firstItem0= [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
        UITabBarItem *fi =[[UITabBarItem alloc]init];
        UITabBarItem *f2 =[[UITabBarItem alloc]init];
        UITabBarItem *f3 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
        NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, f3, nil];
        [ntabbar setItems:itemsArray animated:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
        [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
        [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//         [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];

    }
      uv.contentSize=CGSizeMake(self.view.frame.size.width,y+1);
    [ntabbar setSelectedItem:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Project"] || [item.title isEqualToString:@"For Approve"]) {
        [self goback1:item];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self dorefresh];
    }
}

-(void)dorefresh{
    [self getDetail];
}
-(IBAction)goback1:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[project class]] || [temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int rtn;
    switch (tableView.tag) {
       
        case 6:
            rtn=[result.OrderDetailList count];
            break;
        
        default:
            rtn=4;
            break;
    }
    return rtn;
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
       if (tableView.tag ==6) {
            wcfCOOrderDetail *w =[result.OrderDetailList objectAtIndex:indexPath.row];
            cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
           cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            if ([w.HasColor isEqualToString:@"1"]) {
               cell.textLabel.textColor=[UIColor greenColor];
                cell.detailTextLabel.textColor=[UIColor greenColor];
                
            }
            cell.textLabel.font=[UIFont systemFontOfSize:14.0];
            cell.textLabel.text=w.Description;
           cell.textLabel.numberOfLines=0;
           
             cell.detailTextLabel.font=[UIFont systemFontOfSize:13.0];
            cell.detailTextLabel.text=w.Btype;
             cell.userInteractionEnabled = NO;
            
            cell.accessoryType=UITableViewCellAccessoryNone;
            [cell .imageView setImage:nil];

       }}
    
    return cell;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
