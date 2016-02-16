//
//  po1.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-23.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "po1.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "InsetsLabel.h"
#import "poemail.h"
#import "emailVendor.h"
#import "assignVendor.h"
#import "forapprove.h"
#import "project.h"
#import "development.h"

@interface po1 ()<UITabBarDelegate>

@end

@implementation po1

@synthesize ntabbar, uv, idpo1, xcode, fromforapprove;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    ntabbar.userInteractionEnabled = YES;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getPo];
  
}
-(void)getPo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetPODetail:self action:@selector(xGetPODetailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid:idpo1 xcode:xcode EquipmentType:@"3"];
    }
    
}
- (void) xGetPODetailHandler: (id) value {
    
	
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
    
    pd=(wcfPODetail *)value;
    [self drawPage];
      [ntabbar setSelectedItem:nil];
}

-(void)drawPage{
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    for (UIView *u in uv.subviews) {
        [u removeFromSuperview];
    }
    
    UILabel *lbl;
    int y=10;
    float rowheight=32.0;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=[NSString stringWithFormat:@"%@ # %@", pd.Doc, pd.IdDoc];
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    NSMutableArray *list1=[[NSMutableArray alloc]init];
    [list1 addObject:[@"Date: " stringByAppendingString:pd.Date]];
    [list1 addObject:[@"Project # " stringByAppendingString:pd.ProjectNumber]];
    [list1 addObject:pd.ProjectName];
    [list1 addObject:[NSString stringWithFormat:@"Vendor # %ld", pd.Idvendor]];
    [list1 addObject:pd.Nvendor];
    [list1 addObject:[NSString stringWithFormat:@"Status: %@", pd.Status]];
    if(pd.Cknumber!=nil){
        [list1 addObject:[NSString stringWithFormat:@"Check # %@ @ %@", pd.Cknumber, pd.Ckdate]];
    }
    
      UIView *lbl1;
    lbl1=[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*[list1 count])];
    lbl1.backgroundColor = [UIColor whiteColor];
    lbl1.layer.cornerRadius =10.0;
    [uv addSubview:lbl1];
    
    InsetsLabel *lblTitle;
    for (NSString *s in list1) {
        lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.text=s;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];
        y=y+rowheight;
    }
    y=y+10;
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Notes";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    
    if (pd.Shipto!=nil){
        if ([pd.Shipto rangeOfString:@";"].location != NSNotFound) {
            NSArray *na =[pd.Shipto componentsSeparatedByString:@";"];
            
           
            
            lbl=[[InsetsLabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, ([na count]*22))];
           
            lbl.font=[UIFont systemFontOfSize:14.0];
            lbl.numberOfLines=0;
            lbl.text=[pd.Shipto stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
//            [lbl sizeToFit];
           
            
            [uv addSubview:lbl];
        }else{
            
            
            
            lbl=[[InsetsLabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
            
             lbl.numberOfLines=0;
           
            lbl.font=[UIFont systemFontOfSize:14.0];
            lbl.text=pd.Shipto;
//             [lbl sizeToFit];
            CGRect f = lbl.frame;
            
            f.size.width=(self.view.frame.size.width-20);
            lbl.frame=f;
            
             [uv addSubview:lbl];
        }
    }else{
      
        lbl1=[[InsetsLabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
         [uv addSubview:lbl1];
    }
   
    y = y+ lbl.frame.size.height+10;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Reason";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
   
    
    lbl1=[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
    lbl1.backgroundColor = [UIColor whiteColor];
    lbl1.layer.cornerRadius =10.0;
    [uv addSubview:lbl1];
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-30, 30)];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.text=pd.Reason;
    [uv addSubview:lbl];
    

    y=y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Detail";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
  
    for (int i=0; i<[pd.OrderDetailList count]; i++) {
        wcfOrderDetail *od =(wcfOrderDetail *)[pd.OrderDetailList objectAtIndex:i];
        
        if(od.Notes!=nil && ![od.Notes isEqualToString:@""]){
            
            lbl1=[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*5)];
            lbl1.backgroundColor = [UIColor whiteColor];
            lbl1.layer.cornerRadius =10.0;
            [uv addSubview:lbl1];
            
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.text=od.Description;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.text=od.Notes;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            if (od.Qty==nil) {
                lblTitle.text=@"QTY";
            }else{
                lblTitle.text=[NSString stringWithFormat:@"QTY %@", od.Qty];
            }
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.text=[NSString stringWithFormat:@"Price %@", od.Price];
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            //[NSString stringWithFormat:@"Amount %@", od.Amount]
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.text=[NSString stringWithFormat:@"Amount %@", od.Amount];
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            y=y+10;
            
            
        }else{
            
            
            lbl1=[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*4)];
            lbl1.backgroundColor = [UIColor whiteColor];
            lbl1.layer.cornerRadius =10.0;
            [uv addSubview:lbl1];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.text=od.Description;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
           
            if (od.Qty==nil) {
                lblTitle.text=@"QTY";
            }else{
                lblTitle.text=[NSString stringWithFormat:@"QTY %@", od.Qty];
            }
            
//            lblTitle.text=[NSString stringWithFormat:@"QTY %@", od.Qty];
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.text=[NSString stringWithFormat:@"Price %@", od.Price];
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            //[NSString stringWithFormat:@"Amount %@", od.Amount]
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.text=[NSString stringWithFormat:@"Amount %@", od.Amount];
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+rowheight;
            
            y=y+10;
        }
    }
    
    lbl1=[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*4)];
    lbl1.backgroundColor = [UIColor whiteColor];
    lbl1.layer.cornerRadius =10.0;
    [uv addSubview:lbl1];
    
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.text=[NSString stringWithFormat:@"Non Taxable %@", pd.Nontaxable];
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+rowheight;
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.text=[NSString stringWithFormat:@"Taxable %@", pd.Taxable];
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+rowheight;
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.text=[NSString stringWithFormat:@"Tax %@", [pd.Tax stringByReplacingOccurrencesOfString:@":" withString:@": "]];
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+rowheight;
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.text=[NSString stringWithFormat:@"Total %@", pd.Total];
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+rowheight+10;
    
    if (fromforapprove==1) {
        if ([pd.Status isEqualToString:@"Turn In"]) {
            
            
            
             UIButton *loginButton ;
            if (pd.Hold) {
              
                loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
                [loginButton setTitle:@"Hold" forState:UIControlStateNormal];
                [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
                [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [loginButton addTarget:self action:@selector(dohold:) forControlEvents:UIControlEventTouchUpInside];
                [uv addSubview:loginButton];
                y=y+54;
                
            }
           
          
            if ([pd.ApprovePayment isEqualToString:@"1"]) {
//                firstItem= [[UITabBarItem alloc]initWithTitle:@"Approve" image:[UIImage imageNamed:@"approve.png"] tag:1];
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
//                secondItem= [[UITabBarItem alloc]initWithTitle:@"Disapprove" image:[UIImage imageNamed:@"disapprove.png"] tag:3];
                loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
                [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
                [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
                [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
                [uv addSubview:loginButton];
                y=y+54;
            }

//            NSArray *itemsArray =[NSArray arrayWithObjects:  firstItem, firstItem0,secondItem, nil];
//            [ntabbar setItems:itemsArray animated:YES];
//            if ([pd.ApprovePayment isEqualToString:@"1"]) {
//                [[ntabbar.items objectAtIndex:0]setAction:@selector(doapprove:)];
//            }
//            if (pd.Hold) {
//                [[ntabbar.items objectAtIndex:1]setAction:@selector(dohold:)];
//            }
//            if ([pd.Disapprove isEqualToString:@"1"]) {
//                [[ntabbar.items objectAtIndex:2]setAction:@selector(dodisapprove:)];
//            }
            
            UITabBarItem *firstItem0;
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
            UITabBarItem *fi =[[UITabBarItem alloc]init];
            UITabBarItem *f2 =[[UITabBarItem alloc]init];
            UITabBarItem *f3 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:1];
            
            NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, f3, nil];
            [ntabbar setItems:itemsArray animated:YES];
            ntabbar.delegate = self;
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
            [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
            [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//            [[ntabbar.items objectAtIndex:3]setAction:@selector(doRefresh:) ];
            
        }else if([pd.Status isEqualToString:@"For Approve"] || ([pd.Status isEqualToString:@"Hold"])){
            
            UIButton *loginButton ;
            if (pd.ApprovePayment) {
                
                
                //                firstItem= [[UITabBarItem alloc]initWithTitle:@"Approve" image:[UIImage imageNamed:@"approve.png"] tag:1];
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
                //                secondItem= [[UITabBarItem alloc]initWithTitle:@"Disapprove" image:[UIImage imageNamed:@"disapprove.png"] tag:3];
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
            
            
            UITabBarItem *firstItem0;
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
            UITabBarItem *fi =[[UITabBarItem alloc]init];
            UITabBarItem *f2 =[[UITabBarItem alloc]init];
            UITabBarItem *f3 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:1];
            
            NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, f3, nil];
            ntabbar.delegate = self;
            [ntabbar setItems:itemsArray animated:YES];
//            [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
            [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
            [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//            [[ntabbar.items objectAtIndex:3]setAction:@selector(doRefresh:) ];
           
        }
    }else{
        UIButton* loginButton;
        if (pd.CanEmail && ![pd.Status isEqualToString:@"Paid"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Email Vendor" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        
        if([pd.AssignVendor intValue]>0){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            if(pd.Idvendor>0){
                [loginButton setTitle:@"Re-Assign Vendor" forState:UIControlStateNormal];
            }else{
                [loginButton setTitle:@"Assign Vendor" forState:UIControlStateNormal];
            }
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        
        //    if(pd.BudgetComparison!=nil && [pd.BudgetComparison isEqualToString:@"1"]){
        //        [rtnlist addObject:@"Budget Comparison"];
        //    }
        
        if(pd.Release!=nil && [pd.Release isEqualToString:@"1"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Release" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
        }
        if([pd.ForApprove isEqualToString:@"1"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Release" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        
        if(pd.Hold){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Hold" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
        }
        
        if(pd.ApprovePayment !=nil && [pd.ApprovePayment isEqualToString:@"1"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Approve For Payment" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
        }
        
        if(pd.PartialPayment !=nil && [pd.PartialPayment isEqualToString:@"1"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Partial Payment" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        
        if(pd.PrintCheck!=nil && [pd.PrintCheck isEqualToString:@"1"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Print Check" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        
        if(pd.Disapprove !=nil && [pd.Disapprove isEqualToString:@"1"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Disapprove" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
            
        }
        
        if (pd.ReOpen!=nil && [pd.ReOpen isEqualToString:@"1"]) {
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Re-Open" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
        }
        
        if(pd.Void!=nil && [pd.Void isEqualToString:@"1"]){
            loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
            [loginButton setTitle:@"Void" forState:UIControlStateNormal];
            [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:loginButton];
            y=y+54;
        }
        UITabBarItem *firstItem0;
        if (fromforapprove==2) {
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"Development" image:[UIImage imageNamed:@"home.png"] tag:1];
        }else if (fromforapprove==3){
            firstItem0= [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
        }else{
         firstItem0= [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
        }
        UITabBarItem *fi =[[UITabBarItem alloc]init];
        UITabBarItem *f2 =[[UITabBarItem alloc]init];
        UITabBarItem *f3 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:1];
        
        NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, f3, nil];
        [ntabbar setItems:itemsArray animated:YES];
        ntabbar.delegate = self;
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
        [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
        [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//        [[ntabbar.items objectAtIndex:3]setAction:@selector(doRefresh:) ];
    }
    
    
    uv.contentSize=CGSizeMake(self.view.frame.size.width,y+1);
    [ntabbar setSelectedItem:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Project"] || [item.title isEqualToString:@"For Approve"] || [item.title isEqualToString:@"Development"]) {
        [self goback1: item];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self doRefresh: item];
    }
}



-(IBAction)doRefresh:(id)sender{
    [self getPo];
    
}

-(IBAction)goback1:(id)sender{
    if (fromforapprove==4) {
        [self gohome:nil];
    }else{
        for (UIViewController *temp in self.navigationController.viewControllers) {
           
                if ([temp isKindOfClass:[development class]] || [temp isKindOfClass:[project class]] ||[temp isKindOfClass:[forapprove class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            
            
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 11:
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                    [self gotoEmailScreen:7];
            }
            break;
            
        case 1:
            //Approve for Payment
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                
                    {
                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        HUD.labelText=@"Updating...";
                        HUD.dimBackground = YES;
                        HUD.delegate = self;
                        [HUD show:YES];
                        [self updpostatus:@"1" andpartail:@""];
                    }
                    break;
                
            }
            break;
            
        case 3:
            //Print Check
            switch (buttonIndex) {
                case 0:
                    break;
                default:
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Updating...";
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    [self updpostatus:@"2" andpartail:@""];
                }
                    break;
                    
                                    
            }
            break;
            
        case 4:
            //Partial Payment
            
        {
            NSString  *spartial;
            
            switch (buttonIndex) {
                case 1:
                    spartial = @"25";
                    break;
                case 2:
                    spartial = @"50";
                    break;
                case 3:
                    spartial = @"75";
                    break;
                case 4:
                    spartial = @"90";
                    break;
                default:
                    spartial = @"";
                    break;
            }
            if (![spartial isEqualToString:@""]) {
                {
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.labelText=@"Updating...";
                    HUD.dimBackground = YES;
                    HUD.delegate = self;
                    [HUD show:YES];
                    [self updpostatus:@"9" andpartail:spartial];
                }
                break;
            }
            
        }
            break;
        case 5:
            [self.navigationController popViewControllerAnimated:YES];
        default:
            break;
    }
}

-(void)updpostatus: (NSString *)xtype2 andpartail:(NSString *)partail{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [HUD hide:YES];
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service = [wcfService service];
        
        [service xUpdateUserPurchaseOrder:self action:@selector(doapprovea:) xemail:[userInfo getUserName]  xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xpoid:idpo1 xtype:xtype2 update:@"" vendorid:@"" delivery:pd.Delivery xlgsel:partail xcode:xcode EquipmentType:@"3"];
    }

    
}
-(IBAction)doapprovea: (BOOL) value {
    [HUD hide:YES];
	if(!value){
        UIAlertView *alert =[self getErrorAlert:@"Update failed, please try it again later"];
        alert.tag=5;
        [alert show];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)dohold:(id)sender{
    [self gotoEmailScreen:10];

}
-(IBAction)doapprove:(id)sender{
     xtype=1;
    [self autoUpd];
    
}

-(IBAction)dodisapprove:(id)sender{
    xtype=2;
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        if (xtype==1) {
            
            
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure you want to approve?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];
        }else{
            [self gotoEmailScreen:3];
        }
    }
    
    
}

//@"Email Vendor"

-(IBAction)doupdate1:(UIButton *)sender {
    kv= sender.titleLabel.text;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xisupdate_iphone:self action:@selector(xisupdate_iphoneHandler5:) version:version];
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
    
    NSString* result2 = (NSString*)value;
    if ([result2 isEqualToString:@"1"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{

        if ([kv isEqualToString:@"Email Vendor"]) {
            emailVendor *LoginS=[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"emailVendor"];
            LoginS.managedObjectContext=self.managedObjectContext;
            LoginS.pd=pd;
            LoginS.fromforapprove=self.fromforapprove;
            LoginS.poid=self.idpo1;
            LoginS.title=kv;
            [self.navigationController pushViewController:LoginS animated:YES];
        }else if([kv isEqualToString:@"Print Check"]){
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure you want to Print Check?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
            alert.tag = 3;
            [alert show];
        }else if([kv isEqualToString:@"Release"]){
            [self gotoEmailScreen:4];
        }else if([kv isEqualToString:@"Void"]){
            if(pd.MTakeOff && [pd.Void isEqualToString:@"1"]){
                UIAlertView *alert = nil;
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"Takeoff purchase order. Are you sure you want to continue?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"OK", nil];
                alert.tag = 11;
                [alert show];
                
            }else{
                [self gotoEmailScreen:7];
            }
            
        }else if([kv isEqualToString:@"Re-Open"]){
            [self gotoEmailScreen:6];
        
        }else if([kv isEqualToString:@"Approve For Payment"]){
            [self doapprove:nil];
        }else if([kv isEqualToString:@"Partial Payment"]){
            if ([pd.Total length]<3) {
                UIAlertView *alert=[self getErrorAlert:@"Total cannot be empty!"];
                [alert show];
                return;
            }
            float lblTotal;
            UIAlertView *alert;
            if ([pd.Total rangeOfString:@"("].location == NSNotFound) {
                lblTotal=[[pd.Total substringFromIndex:2] floatValue];
                NSString *tmp1 = [@"25%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.25] stringValue]];
                NSString *tmp2 = [@"50%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.5] stringValue]];
                NSString *tmp3 = [@"75%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.75] stringValue]];
                NSString *tmp4 = [@"90%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.90] stringValue]];
                NSString *tmp5 = [@"100%  = $" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal] stringValue]];
                alert = [[UIAlertView alloc] initWithTitle:@"Select" message:nil
                                                  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:tmp1,tmp2,tmp3,tmp4,tmp5, nil];
            }else{
                NSString *a = [pd.Total stringByReplacingOccurrencesOfString:@"(" withString:@""];
                a =[a stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                lblTotal=[[a substringFromIndex:2] floatValue];
                NSString *tmp1 = [[@"25%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.25] stringValue]]stringByAppendingString:@")"];
                NSString *tmp2 = [[@"50%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.50] stringValue]]stringByAppendingString:@")"];
                NSString *tmp3 = [[@"75%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.75] stringValue]]stringByAppendingString:@")"];
                NSString *tmp4 = [[@"90%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal*0.90] stringValue]]stringByAppendingString:@")"];
                NSString *tmp5 = [[@"100%  = $(" stringByAppendingString:[[NSNumber numberWithFloat:lblTotal] stringValue]]stringByAppendingString:@")"];
                alert = [[UIAlertView alloc] initWithTitle:@"Select" message:nil
                                                  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:tmp1,tmp2,tmp3,tmp4,tmp5, nil];
            }
            alert.tag = 4;
            [alert show];
            return;

            //  [rtnlist addObject:@"Re-Assign Vendor"];
      
            //[rtnlist addObject:@"Assign Vendor"];
        }else if([kv isEqualToString:@"Re-Assign Vendor"] || [kv isEqualToString:@"Assign Vendor"]){
            assignVendor *next =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"assignVendor"];
            next.managedObjectContext=self.managedObjectContext;
            next.xpocode=self.xcode;
            next.xpoid=self.idpo1;
            next.xidproject=pd.ProjectNumber;
            next.xidcostcode=pd.Idcostcode;
            next.xshipto=pd.Shipto;
            next.xdelivery=pd.Delivery;
            next.fromforapprove=self.fromforapprove;
            [self.navigationController pushViewController:next animated:YES];
        }
    }
}

-(void) gotoEmailScreen:(int)xtype1{
    poemail *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"poemail"];
    LoginS.managedObjectContext=self.managedObjectContext;
    LoginS.idpo1=self.idpo1;
    LoginS.xmcode=self.xcode;
    
    LoginS.idvendor=[NSString stringWithFormat:@"%ld", pd.Idvendor];
    LoginS.fromforapprove=self.fromforapprove;
    LoginS.xtype=xtype1;
    [self.navigationController pushViewController:LoginS animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
