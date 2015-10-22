//
//  projectaddc.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-23.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "projectaddc.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>

@interface projectaddc ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@property (weak, nonatomic) IBOutlet UIScrollView *uv;

@end

@implementation projectaddc

@synthesize idproject, ntabbar, uv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [self goBack:item];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= @"Addendum C";
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]init];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3] setEnabled:NO ];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
	// Do any additional setup after loading the view.
    [self getDetail];
    
}

-(void)getDetail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetProjectAddendumc:self action:@selector(xGetProjectAddendumcHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:idproject EquipmentType:@"3"];
    }
}

-(void)xGetProjectAddendumcHandler:(id)value{

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
     int y=10;
    
    UILabel  *lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Description";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    float h;
    for (NSString *desc in value) {
       
        h=32.0f;
        
        UILabel * lblTitle;
        
        lblTitle  =[[UILabel alloc] initWithFrame:CGRectMake(20, y+5, 285, 94)];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.text=desc;
        lblTitle.numberOfLines=0;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [lblTitle sizeToFit];
        
        if (h < lblTitle.frame.size.height+10) {
            h = lblTitle.frame.size.height+10;
        }
        UIView * lblTitle2  =[[UIView alloc] initWithFrame:CGRectMake(10, y, 300, h)];
        lblTitle2.layer.cornerRadius =10.0;
        lblTitle2.backgroundColor = [UIColor whiteColor];
        [uv addSubview:lblTitle2];
        [uv addSubview:lblTitle];
        
        
        y = y + h+10;
        
    }
    
    if (self.view.frame.size.height>480) {
        
        if (y<460.0) {
            y=460.0;
        }
    }else{
        if (y<380.0) {
            y=380.0;
        }
        
    }
    uv.contentSize=CGSizeMake(320.0,y);

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
