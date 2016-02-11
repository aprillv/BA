//
//  bustoutdetail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-29.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "bustoutdetail.h"
#import "Mysql.h"
#import "wcfService.h"
#import "userInfo.h"
#import "cl_reason.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
//#import "project.h"
#import "bustoutupg.h"
#import "forapprove.h"

@interface bustoutdetail ()<UITabBarDelegate>{
    UIButton *dd1;
    UIButton *txtDate;
    UITextView *txtNote;
    UITextField *txtTotal;
    UIButton* loginButton1;
    UIButton* loginButton2;
    wcfBustOutItem *pd;
    UIImageView  *imageView;
    UIImage *myphoto;
    UIButton *btn1;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

int hy;
@implementation bustoutdetail

@synthesize xidproject, xidbustout, uv, ntabbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad{
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    [super viewDidLoad];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self getPoDetail];
}
-(void)getPoDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetBustOutDetailForApprove:self action:@selector(xGetPendingVpoDetailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xid:xidbustout EquipmentType:@"3"];
    }
}

-(void)xGetPendingVpoDetailHandler:(id)value{
    
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
    
    pd =(wcfBustOutItem*)value;
    self.title=[NSString stringWithFormat:@"Bust Out - %@", pd.Iddoc];
    [self drawpage];
    [ntabbar setSelectedItem:nil];
    
}

-(void)drawpage{
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    int y=10;
    UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Termination Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    UIView *lbl1;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Refdate;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Contract Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.ContractRefdate;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Non-Refundable";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Nonrefundable;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Approve by";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Appr_by;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Project";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Nproject;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Sub Division";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Subdividion;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Buyer Name";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Client;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Stage @ Contract";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Stage;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;

    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Project Manager";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.PM1;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Consultant";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+26;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 32)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y+4, self.view.frame.size.width-20, 24)];
    lbl.text=pd.Sales1;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+37;
    
    
    
    
    UIButton *loginButton;
    if ([pd.Approve isEqualToString:@"1"]) {
        
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"Approve" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
        y=y+54;
        
    }
    if ([pd.Disapprove isEqualToString:@"1"]) {
       
        
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
    
    uv.contentSize=CGSizeMake(self.view.frame.size.width,y);
//    uv.backgroundColor = [UIColor redColor];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:item];
    }else if(item.tag == 2){
        [self refreshPrject:item];
    }
}

-(IBAction)goback1:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

-(IBAction)refreshPrject:(id)sender{
[self getPoDetail];
}

-(IBAction)doapprove:(id)sender{
    bustoutupg *pa =[self.storyboard instantiateViewControllerWithIdentifier:@"bustoutupg"];
    pa.managedObjectContext=self.managedObjectContext;
    pa.xidnum=pd.Idnumber;
    pa.xidproject=pd.idproject;
    pa.xtype=1;
    
    
    
    
    pa.title=[NSString stringWithFormat:@"Project # %@ ~ %@", pd.idproject, pd.Nproject];
    [self.navigationController pushViewController:pa animated:YES];
}

-(IBAction)dodisapprove:(id)sender{
    bustoutupg *pa =[[bustoutupg alloc]init];
    pa.managedObjectContext=self.managedObjectContext;
    pa.xidnum=pd.Idnumber;
    pa.xidproject=pd.idproject;
    pa.xtype=2;
     pa.title=[NSString stringWithFormat:@"Project # %@ ~ %@", pd.idproject, pd.Nproject];
    [self.navigationController pushViewController:pa animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
