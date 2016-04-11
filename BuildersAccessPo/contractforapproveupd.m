//
//  contractforapproveupd.m
//  BuildersAccess
//
//  Created by amy zhao on 13-4-4.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "contractforapproveupd.h"
#import "wcfService.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfContractDepositItem.h"
#import "contractforapproveupd1.h"
#import "InsetsLabel.h"
#import "ViewController.h"
#import "forapprove.h"

@interface contractforapproveupd ()<UITabBarDelegate>{
    int donext;
}

@end

@implementation contractforapproveupd

@synthesize oidcia, ocontractid, uv, ntabbar, subview, xfromtype;

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
    [self getContractEntry];
  }

-(void)getContractEntry{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service=[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xGetContractEntry:self action:@selector(xGetContractEntryHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd ] xidcia:oidcia contractid:ocontractid EquipmentType:@"3"];
    }

}
-(void)xGetContractEntryHandler: (id) value {
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
     result= (wcfContractEntryItem*)value;
    
    [self drawScreen];
}

-(void)drawScreen{

    self.title=[NSString stringWithFormat:@"Contract-%@", result.IDDoc];
    int y=10;
    float rowheight=32.0;
    UILabel *lbl;
    InsetsLabel * lblTitle ;
    UIView *lblView;
    
    if (xfromtype==1) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
        lbl.text=[NSString stringWithFormat:@"Project # %@", result.IDProject];
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+8;
        
        lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight*2)];
        lblView.backgroundColor = [UIColor whiteColor];
        lblView.layer.cornerRadius =10.0;
        [uv addSubview:lblView];
        
        lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+3, self.view.frame.size.width-20, rowheight-3)];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.text=result.NProject;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];
        
        lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y+rowheight, self.view.frame.size.width-20, rowheight-3)];
        lblTitle.backgroundColor=[UIColor clearColor];
        if (result.Stage==nil || [result.Stage isEqualToString:@""]) {
            lblTitle.text=@"Schedule Not Started";
            lblTitle.textColor=[UIColor redColor];
        }else{
            lblTitle.text=result.Stage;
        }
        
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];
        
        y=y+rowheight*2+8;
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
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
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rtn*rowheight)];
        ciatbview.layer.cornerRadius = 10;
        ciatbview.separatorColor=[UIColor clearColor];
        ciatbview.tag=6;
        
        [ciatbview setRowHeight:rowheight];
        ciatbview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [uv addSubview:ciatbview];
        ciatbview.delegate = self;
        ciatbview.dataSource = self;
        y=y+rtn*rowheight+10;
    }
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Contract Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblView.backgroundColor = [UIColor whiteColor];
    lblView.layer.cornerRadius =10.0;
    [uv addSubview:lblView];
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblTitle.text=result.ContractDate;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    if (xfromtype==1) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Sub Division";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+5;
        
        
        lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
        lblView.backgroundColor = [UIColor whiteColor];
        lblView.layer.cornerRadius =10.0;
        [uv addSubview:lblView];
        
        lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
        lblTitle.text=result.SubDivision;
        lblTitle.layer.cornerRadius =10.0;
        lblTitle.font=[UIFont systemFontOfSize:14.0];
        [uv addSubview:lblTitle];
        y=y+40;
    }
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Consultant";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblView.backgroundColor = [UIColor whiteColor];
    lblView.layer.cornerRadius =10.0;
    [uv addSubview:lblView];
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblTitle.text=result.Consultant;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Buyer Name";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblView.backgroundColor = [UIColor whiteColor];
    lblView.layer.cornerRadius =10.0;
    [uv addSubview:lblView];
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblTitle.text=result.Buyer;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Broker Name";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    
    lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblView.backgroundColor = [UIColor whiteColor];
    lblView.layer.cornerRadius =10.0;
    [uv addSubview:lblView];
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblTitle.text=result.Broker;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;

    lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Agent Name";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+5;
    
    lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblView.backgroundColor = [UIColor whiteColor];
    lblView.layer.cornerRadius =10.0;
    [uv addSubview:lblView];
    
    lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lblTitle.text=result.Agent;
    lblTitle.layer.cornerRadius =10.0;
    lblTitle.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lblTitle];
    y=y+40;
    
    
    if (xfromtype==1) {
        if (result.IsShow) {
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Base Price";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.BasePrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"List Price";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.ListPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"A - Sales Price";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.SalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
        }
    }
    
    
    if ([result.SalesList count]>0) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
        lbl.text=@"Items Included In Sales Price";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+5;
        
        wcfContractDepositItem *di;
        for (int i=0; i<[result.SalesList count]; i++) {
            int y1=y;
            di= (wcfContractDepositItem *)[result.SalesList objectAtIndex:i];
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width-40, 21)];
            lbl.text=di.Description;
            lbl.numberOfLines=0;
            lbl.font=[UIFont systemFontOfSize:14.0];
            [lbl sizeToFit];
            y1=y1+lbl.frame.size.height;
            
            UILabel *lbl2;
            UILabel *lbl3;
            BOOL isshow=YES;
            
            if ([di.Price isEqualToString:@"$ 0.00"]) {
                if ([di.BType isEqualToString:@"Notes"]) {
                    isshow=NO;
                    
                    y1=y1+5;
                }else{
                    lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, y1, self.view.frame.size.width-40, 21)];
                    lbl2.text=di.BType;
                    lbl2.numberOfLines=0;
                    lbl2.font=[UIFont systemFontOfSize:14.0];
                    [lbl2 sizeToFit];
                    y1=y1+lbl2.frame.size.height+5;
                }
            }else{
                lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, y1, self.view.frame.size.width-40, 21)];
                lbl2.text=[NSString stringWithFormat:@"%@ %@", di.BType, di.Price];
                lbl2.numberOfLines=0;
                lbl2.font=[UIFont systemFontOfSize:14.0];
                [lbl2 sizeToFit];
                y1=y1+lbl2.frame.size.height+5;
            }
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, y1-y)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            
            [uv addSubview:lbl];
            if (isshow) {
                [uv addSubview:lbl2];
            }
            
            
            y=y1+8;
            
                        
        }
    }
   
    if (xfromtype==1) {
        if (result.IsShow) {
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"B - Total Items Included";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.BSalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            NSArray *firstSplit = [result.C1SalesPrice componentsSeparatedByString:@";"];
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=[NSString stringWithFormat:@"C1 - Broker Percentage %@", [firstSplit objectAtIndex:0] ];
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=[firstSplit objectAtIndex:1];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"C2 - Btsa";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.C2SalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"C3 - Special Financing";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.C3SalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"D - Adjusted Sales Price";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.DSalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            firstSplit = [result.ESalesPrice componentsSeparatedByString:@";"];
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=[NSString stringWithFormat:@"E - # Of Days Closing Date Delayed %@", [firstSplit objectAtIndex:0]];
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=[firstSplit objectAtIndex:1];
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"F - Final Adjusted Sales Price";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.FSalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"G - List Price %";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.GSalesPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Non-Refundable";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.NonRefundable;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Collected";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.Collected;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Balance";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.Balance;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Additional Dep.";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.AdditionalDep;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Final Price";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.FinalPrice;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Lot Cost";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.LotCost;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Administrative Cost";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.AdministrativeCost;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Construction Cost";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.ConstructionCost;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Open PO'S";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.OpenPO;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Gran Total";
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+21+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.GranTotal;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
            lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 21)];
            lbl.text=@"Estimated Gross Profit(Before closing costs/Internal commission)";
            lbl.numberOfLines=0;
            lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
            [lbl sizeToFit];
            lbl.backgroundColor=[UIColor clearColor];
            [uv addSubview:lbl];
            y=y+45+5;
            
            lblView = [[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblView.backgroundColor = [UIColor whiteColor];
            lblView.layer.cornerRadius =10.0;
            [uv addSubview:lblView];
            
            lblTitle  =[[InsetsLabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
            lblTitle.text=result.Estimated;
            lblTitle.layer.cornerRadius =10.0;
            lblTitle.font=[UIFont systemFontOfSize:14.0];
            [uv addSubview:lblTitle];
            y=y+40;
            
        }
    }
    
    if (xfromtype==1) {
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 310, 21)];
        lbl.text=@"Sitemap";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+5;
        
        UIImage *img ;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemapthumb.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub,result.IDProject]];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data!=nil) {
            img =[UIImage imageWithData:data];
            if (img!=nil) {
                float f = (self.view.frame.size.width-20)/img.size.width;
                
                UIImageView *ui =[[UIImageView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, img.size.height*f)];
                ui.image=img;
                
                ui.userInteractionEnabled = YES;
                ui.layer.cornerRadius=10;
                ui.layer.masksToBounds = YES;
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction)];
                tapped.numberOfTapsRequired = 1;
                [ui addGestureRecognizer:tapped];
                y=y+img.size.height*f+20;
                [uv addSubview:ui];
                data=nil;
            }
        }    

    }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, y, 310, 21)];
        lbl.text=@"Sitemap";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+21+5;
    
    ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
    ciatbview.layer.cornerRadius = 10;
    ciatbview.tag=7;
    [uv addSubview:ciatbview];
    ciatbview.delegate = self;
    ciatbview.dataSource = self;
      y=y+44+10;
    }
    UIButton* loginButton;

    if (result.Approve) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"Approve Contract" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doapprove:) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
         y=y+54;
    }
    
   
    if (result.Acknowledge ) {
        
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"PM Acknowledge" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doacknowledge:) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
         y=y+54;
    }
    
    if (result.DisApprove) {
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
    
    
   
    if (y<self.view.frame.size.height-44) {
        y=self.view.frame.size.height-44;
    }
  uv.contentSize=CGSizeMake(self.view.frame.size.width,y+1);
    ntabbar.delegate = self;
    if (xfromtype==1) {
        
        UITabBarItem *firstItem0 ;
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
        UITabBarItem *fi;
        fi =[[UITabBarItem alloc]init];
        UITabBarItem *f2 =[[UITabBarItem alloc]init];
        UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
        NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
        
        [ntabbar setItems:itemsArray animated:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goForApprove) ];
        [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
        [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//        [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
        
    }else{
        UITabBarItem *firstItem0 ;
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
        UITabBarItem *fi;
        fi =[[UITabBarItem alloc]init];
        UITabBarItem *f2 =[[UITabBarItem alloc]init];
        UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
        NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
        
        [ntabbar setItems:itemsArray animated:YES];
//        [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
        [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
        [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//        [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
    }
   
    [ntabbar setSelectedItem:nil];
      
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Project"]) {
        [self goBack:item];
    }else if ([item.title isEqualToString:@"For Approve"]) {
        [self goForApprove];
    }else if ([item.title isEqualToString:@"Refresh"]) {
        [self dorefresh];
    }
}



-(void)goForApprove{
   
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[forapprove class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                
            }
        }
    
}

-(void)dorefresh{
    for (UIView *uw in uv.subviews) {
        [uw removeFromSuperview];
    }
[self getContractEntry];
}
-(IBAction)doacknowledge:(id)sender{
[self gotonextpage:3];
}

-(void)viewWillAppear:(BOOL)animated{
    [ntabbar setSelectedItem:nil];
    for (UIView *uw in uv.subviews) {
        [uw removeFromSuperview];
    }
    [self getContractEntry];
}

-(void)myFunction{
// [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub]]];
//
//    for (UIView *uw in uv.subviews) {
//        if ([uw isKindOfClass:[UIImageView class]]) {
//            ((UIImageView *)uw).image=nil;
//        }
//    }
//     ViewController *si = [ViewController alloc];
     ViewController *si = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/contractsitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub, result.IDProject ];
    si.managedObjectContext=self.managedObjectContext;
    
    [self presentViewController:si animated:YES completion:nil];
    
    }

-(IBAction)doapprove:(id)sender{
    [self gotonextpage:1];
}

-(IBAction)dodisapprove:(id)sender{
    [self gotonextpage:2];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    donext=2;
    [self doupdatecheck];
}
-(void)gotonextpage:(int)xtype3{
    xtype=xtype3;
    donext=1;
    [self doupdatecheck];
}

-(void)doupdatecheck{
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
        
                
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        if (donext==1) {
             contractforapproveupd1 *cp =[self.storyboard instantiateViewControllerWithIdentifier:@"contractforapproveupd1"];
        cp.managedObjectContext=self.managedObjectContext;
        cp.idcia=result.IDCia;
        cp.title=self.title;
        cp.idcontract1=result.IDNumber;
        cp.idproject=result.IDProject;
        cp.projectname=result.NProject;
            cp.xfromtype=self.xfromtype;
        cp.xtype=xtype;
        [self.navigationController pushViewController:cp animated:YES];
        }else{
            [self myFunction];
        }
       
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==6) {
        int rtn =4;
        if (result.Reverseyn ) {
            rtn=rtn+1;
        }
        if (result.Repeated){
            rtn=rtn+1;
        }
        
        return rtn;
    }else{
        return 1;
    }
    
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
       
        
        if (tableView.tag==6) {
            cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 32)];
            CGRect rect = CGRectMake(10, 0, 295, 32);
            UILabel * label= [[UILabel alloc]initWithFrame:rect];
            label.textAlignment=NSTextAlignmentLeft;
            label.font=[UIFont systemFontOfSize:14.0];
            
            switch (indexPath.row){
                case 0:{
                    if (result.IDFloorplan !=nil) {
                        label.text=[NSString stringWithFormat:@"Plan No. %@", result.IDFloorplan ];
                    }else{
                        label.text=@"Plan No.";
                    }
                }
                    
                    break;
                case 1:{
                    
                    if (result.PlanName==nil) {
                        label.text=@"n / a";
                        label.textColor=[UIColor redColor];
                    }else{
                        label.text=result.PlanName;
                    }
                    
                }
                    break;
                case 2:{
                    if (result.Bedrooms ==nil || result.Baths == nil) {
                        label.text=@"Beds  / Baths ";
                    }else if (result.Bedrooms ==nil ) {
                        label.text=[NSString stringWithFormat:@"Beds  / Baths %@", result.Baths];
                    }else if(result.Baths==nil){
                        label.text=[NSString stringWithFormat:@"Beds %@ / Baths ", result.Bedrooms];
                    }else{
                        label.text=[NSString stringWithFormat:@"Beds %@ / Baths %@", result.Bedrooms, result.Baths];
                    }                        }
                    break;
                case 3:{
                    if(result.Garage !=nil){
                        label.text=[NSString stringWithFormat:@"Garage %@", result.Garage];
                    }else{
                        label.text=@"Garage";
                    }                        }
                    
                    break;
                case 4:
                    if (result.Reverseyn ) {
                        
                        label.text=@"Builder Reverse";
                        
                    }else if (result.Repeated){
                        label.text=@"Repeated Plan";
                        
                    }
                    break;
                default:
                    label.text=@"Repeated Plan";
                    break;
            }
            [cell.contentView addSubview:label];
            cell.userInteractionEnabled = NO;
            
        }else{
           cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.text=@"View Sitemap";
            cell.textLabel.font=[UIFont systemFontOfSize:14.0];
            
        }
       

        
    }

     [cell .imageView setImage:nil];
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
