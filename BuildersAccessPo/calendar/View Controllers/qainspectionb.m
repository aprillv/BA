//
//  qainspectionb.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-8.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "qainspectionb.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "userInfo.h"
#import "codisapprove.h"
#import "Reachability.h"
#import "qainspection.h"
#import "selectitem.h"
#import "updItem.h"
#import "calendarqa.h"
#import "project.h"
#import "MBProgressHUD.h"

@interface qainspectionb ()< UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, MBProgressHUDDelegate>{
    NSString *donext;
    MBProgressHUD *HUD;
    NSTimer *myTimer;
    
//    UITabBar *ntabbar;
    UITextField *text1;
    UIButton *txtReason;
    NSMutableArray * pickerArray;
    UIPickerView *ddpicker;
    UITextView *txtNote;
    UITableView *ut;
    
//    UIScrollView *uv;
    UITableView *phone;
    CustomKeyboard *keyboard;
    wcfCalendarQAb *result;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation qainspectionb
@synthesize idnumber,fromtype, uv, ntabbar;

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
        [self dorefresh:item];
    }
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


-(IBAction)dorefresh:(id)sender{
    [self getInfo];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getInfo];
    [ntabbar setSelectedItem:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    ntabbar.delegate = self;
    [ntabbar setItems:itemsArray animated:YES];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
	// Do any additional setup after loading the view.
}


-(void)getInfo{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xGetQAInspection2b:self action:@selector(xGetCalendarEntryHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber EquipmentType: @"3"];

        
    }
    
}
-(void)drawScreen{
    
    CGFloat x=0;
    CGFloat y=10;
    if (self.view.frame.size.height>480) {
        y=y+5;
        x=10;
    }else{
        x=8;
    }
    
    self.title=@"Inspection";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
    
    
    UILabel *lbl;
    float rowheight=32.0;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Project";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    
    
    UIView *lbl1;
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview: lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=result.Nproject;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Inspection";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=result.Inspection;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Assign To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=result.AssignTo;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Status";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=result.Status;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Walk";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=result.Walk;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Penalty";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=result.Penalty;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Points";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=result.Points;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Remark (max 512 chars)";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, self.view.frame.size.width-24, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    txtNote.text=[result.Remark stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    UIButton* loginButton;
    if ([result.BtnAdd isEqualToString:@"1"]) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"Add Inspection Item" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
        y= y+50;
    }
    
    if ([result.Dlist count]>0) {
        wcfCalendarQAbItem * wi = [result.Dlist objectAtIndex:0];
        [result.Dlist removeObjectAtIndex:0];
        if ([wi.NIdnum isEqualToString:@"1"]) {
            text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
            [text1 setBorderStyle:UITextBorderStyleRoundedRect];
            text1.enabled=NO;
            text1.text=@"";
            [uv addSubview: text1];
            
            txtReason=[UIButton buttonWithType: UIButtonTypeCustom];
            [txtReason setFrame:CGRectMake(11, y+1, 298, 28)];
            [txtReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [txtReason addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
            [txtReason setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [txtReason setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
            [txtReason.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [txtReason setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [uv addSubview: txtReason];
            
            pickerArray=  [[NSMutableArray alloc]init];
            [pickerArray addObject:@"Show All"];
            [pickerArray addObject:@"Show Fail Only"];
            [txtReason setTitle:[NSString stringWithFormat:@"       %@", [pickerArray objectAtIndex:1]] forState:UIControlStateNormal];
            
            y=y+30+10;
        }
        ut =[[UITableView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44*[result.Dlist count])];
        ut.layer.cornerRadius = 10;
        ut.tag=7;
        [ut setRowHeight:44];
        ut.delegate = self;
        ut.dataSource = self;
        [uv addSubview:ut];
        
        y=y+44*[result.Dlist count]+20;
    }
    
   
    
    if ([result.BtnFail isEqualToString:@"1"]) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"Inspection > Save & Fail" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doFail) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
        y= y+50;
    }
    
    if ([result.BtnFinish isEqualToString:@"1"]) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"Inspection > Save & Pass" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doFinish) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
        y= y+50;
    }

    
    if ([result.BtnSubmit isEqualToString:@"1"]) {
        loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"Inspection > Ready Re-Submit" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(dosubmit) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:loginButton];
        y= y+50;
    }
    
    y= y+20;
    
    if (y < uv.frame.size.height + 1) {
        y= uv.frame.size.height + 1;
    }
    uv.contentSize=CGSizeMake(self.view.frame.size.width,y);
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
//        NSString *status = [pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]];
        
        NSString *status = [actionSheet1 buttonTitleAtIndex:buttonIndex];
        
        
        if ([status isEqualToString:@"Show Fail Only"]) {
            status=@"1";
            if ([txtReason.currentTitle isEqualToString:@"       Show Fail Only"]) {
                return;
            }
        }else{
            status=@"0";
            if ([txtReason.currentTitle isEqualToString:@"       Show All"]) {
                return;
            }
        }
        
        [txtReason setTitle:[NSString stringWithFormat:@"       %@", [pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]]] forState:UIControlStateNormal];
        
        Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus ==NotReachable) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
            [alert show];
        }else{
            wcfService *service =[wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [service xGetQAInspection2bItemLs:self action:@selector(xGetCalendarEntryHandler1:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xstatus:status EquipmentType: @"3"];
            
        }
    }
}


- (void) xGetCalendarEntryHandler1: (id) value {
    
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
    
    NSMutableArray *rttt = (NSMutableArray*)value;
    if ([rttt count]>0) {
        int y = ut.frame.origin.y;
        int y1 =0;
         
        wcfCalendarQAbItem * wi = [rttt objectAtIndex:0];
        [rttt removeObjectAtIndex:0];
        y1=([rttt count]-[result.Dlist count])*44;
        if ([wi.NIdnum isEqualToString:@"1"]) {
           
            result.Dlist=rttt;
            
        }else{
            [text1 removeFromSuperview];
            [txtReason removeFromSuperview];
            result.Dlist=rttt;
            y=y-40;
            y1=y1-40;
        }
        
        
       
        [ut removeFromSuperview];
        ut =[[UITableView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44*[result.Dlist count])];
        ut.layer.cornerRadius = 10;
        ut.tag=7;
        [ut setRowHeight:44];
        ut.delegate = self;
        ut.dataSource = self;
        [uv addSubview:ut];
         y=y+44*[result.Dlist count]+20;
        
        CGRect f;
        for (UIButton *ub in uv.subviews) {
            if ([ub isKindOfClass:[UIButton class]]) {
                if (ub !=txtReason) {
                    f=ub.frame;
                    f.origin.y=f.origin.y+y1;
                    ub.frame=f;
                }
            }
        }
        
         uv.contentSize=CGSizeMake(self.view.frame.size.width,uv.contentSize.height+y1);
        
    }
    
}
-(IBAction)popupscreen2:(id)sender{
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
    alert.tag = 1;
    [alert addButtonWithTitle:@"Cancel"];
    for( NSString *title in pickerArray)  {
        [alert addButtonWithTitle:title];
    }
    
    [alert showInView:self.view];
    
}



-(void)doFinish{
    donext=@"2";
   
    [self autoUpd];
    
}

-(void)dosubmit{
    donext=@"5";
    [self autoUpd];
}

-(void)doFail{
    donext=@"3";
    [self autoUpd];
}


-(void)addItem{
    donext=@"1";
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
    
    NSString* result4 = (NSString*)value;
    if ([result4 isEqualToString:@"1"]) {        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Download_InstallLink]];
        
    }else{
        if ([donext isEqualToString:@"1"]) {
            selectitem *s = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"selectitem"];
            s.managedObjectContext = self.managedObjectContext;
            s.idnumber = self.idnumber;
            s.fromtype = fromtype;
            [self.navigationController pushViewController:s animated:YES];
        }else if([donext isEqualToString:@"3"]){
            if ([result.Dlist count]==0) {
                UIAlertView *alert = [self getErrorAlert: @"Please add at least one item to the list."];
                [alert show];
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc]
                                       initWithTitle:@"BuildersAccess"
                                       message:[NSString stringWithFormat:@"Are you sure %@ fail?", result.Inspection]
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
                alert.tag=3;
                [alert show];
            }
        }else if([donext isEqualToString:@"2"]){
            if ([result.Dlist count]==0) {
                UIAlertView *alert = [self getErrorAlert: @"Please add at least one item to the list."];
                [alert show];
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc]
                                       initWithTitle:@"BuildersAccess"
                                       message:[NSString stringWithFormat:@"Are you sure %@ pass and finish?", result.Inspection]
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
                alert.tag=2;
                [alert show];
            }
        }else if([donext isEqualToString:@"5"]){
            UIAlertView * alert = [[UIAlertView alloc]
                                   initWithTitle:@"BuildersAccess"
                                   message:[NSString stringWithFormat:@"Are you sure %@ is ready for Re-Inspection?", result.Inspection]
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"OK", nil];
            alert.tag=5;
            [alert show];
        }else if([donext isEqualToString:@"4"]){
            NSIndexPath *indexPath = [ut indexPathForSelectedRow];
           
            [ut deselectRowAtIndexPath:indexPath animated:YES];
             wcfCalendarQAbItem *item = [result.Dlist objectAtIndex:indexPath.row];
            updItem *ui =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"updItem"];
            if ([result.Status isEqualToString:@"Finish"]) {
                ui.xstatus=YES;
            }else{
                ui.xstatus=NO;
            }
            ui.managedObjectContext=self.managedObjectContext;
            ui.itemId=item.NIdnum;
            ui.idnumber=self.idnumber;
            ui.fromtype=fromtype;
            [self.navigationController pushViewController:ui animated:YES];
        
        }
        
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 2){
	    if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"Updating...";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
            self.view.userInteractionEnabled=NO;
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//            [alertViewWithProgressbar show];
//            alertViewWithProgressbar.progress=1;
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Sending Email to Queue...";
            
            HUD.progress=0.01;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
            [service xUpdQASaveAndFinish:self action:@selector(xisupdate_iphoneHandler3:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xnotes:txtNote.text EquipmentType:@"3"];
        }
    }else if (alertView.tag == 3){
	    if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"Updating...";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
             self.view.userInteractionEnabled=NO;
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//            [alertViewWithProgressbar show];
//            alertViewWithProgressbar.progress=1;
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Sending Email to Queue...";
            
            HUD.progress=0.01;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
            
            [service xUpdQASaveAndFail:self action:@selector(xisupdate_iphoneHandler3:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xnotes:txtNote.text EquipmentType:@"3"];
        }
    }else if (alertView.tag == 5){
	    if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"Updating...";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
             self.view.userInteractionEnabled=NO;
//            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//            [alertViewWithProgressbar show];
//            alertViewWithProgressbar.progress=1;
            
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Sending Email to Queue...";
            
            HUD.progress=0.01;
            [HUD layoutSubviews];
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
            
            [service xUpdQAResubmit:self action:@selector(xisupdate_iphoneHandler3:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnumber xnotes:txtNote.text EquipmentType:@"3"];
        }
    }

}



- (void) xisupdate_iphoneHandler3: (id) value {
  
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        SoapFault *sf =value;
        NSLog(@"%@", [sf description]);
        UIAlertView *alert = [self getErrorAlert: value];
        [alert show];
        return;
    }
    
    NSString* result4 = (NSString*)value;
    if ([result4 isEqualToString:@"1"]) {
        
        HUD.progress=1;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(targetMethod)
                                                 userInfo:nil
                                                  repeats:YES];
        
        
    }else{
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        
        
        UIAlertView *alert =[self getErrorAlert:  @"Update fail."];
        [alert show];
       
    }
	
    
}

-(void)targetMethod{
    [myTimer invalidate];
    
    self.view.userInteractionEnabled=YES;
    [HUD hide];
    
    [self goBack1:nil];
}


- (void)doneClicked{
    [txtNote resignFirstResponder];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-170) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-84) animated:YES];    }
	return YES;
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
    
    result = (wcfCalendarQAb*)value;
    //    txtSubject.text=result.Subject;
    //    if (result.Location ==nil) {
    //        result.Location=@"";
    //    }
    //    if (result.DailyCharge==nil) {
    //        result.DailyCharge=@"";
    //    }
    //    txtLocation.text=result.Location;
    //    [txtDate setTitle:result.TDate forState:UIControlStateNormal];
    //    result.StartTime=  [result.StartTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //    result.EndTime=  [result.EndTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //    [txtStart setTitle:result.StartTime forState:UIControlStateNormal];
    //
    //    [txtEnd setTitle:result.EndTime forState:UIControlStateNormal];
    //
    //    [txtContractNm setText: result.ContactName];
    //    if (![result.Phone isEqualToString:@"(null)"]) {
    //        [txtPhone setText:result.Phone];
    //    }
    //
    //    txtMobile.text= result.Mobile;
    //    txtemail.text=result.Email;
    //    txtNote.text=result.Notes;
    //    if (xmtype==2) {
    //        txtcharge.text=result.Notes;
    //    }
    [self drawScreen];
    [ntabbar setSelectedItem:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    wcfCalendarQAbItem *item = [result.Dlist objectAtIndex:indexPath.row];
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        if ([item.NIdnum isEqualToString:@"0"]) {
                        cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor=[UIColor lightGrayColor];
           
            cell.userInteractionEnabled=NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }else{
          cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            
        }
        
    }
    
    if ([item.NIdnum isEqualToString:@"0"]) {
        cell.textLabel.text =item.Des;
       
        [cell .imageView setImage:nil];
    }else{
        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        
       
        
      
        if ([item.Fs isEqualToString:@"1"]) {
            if (item.Des==nil) {
                cell.textLabel.text =[NSString stringWithFormat:@"%@ ~", item.Item];
            }else{
                cell.textLabel.text =[NSString stringWithFormat:@"%@ ~ %@", item.Item, item.Des];
            }
            cell.detailTextLabel.text=item.Status;
            [cell .imageView setImage:[UIImage imageNamed:@"fs.png"]];
            cell.imageView.tag = indexPath.row;
        }else{
            if (item.Des==nil) {
                cell.textLabel.text =[NSString stringWithFormat:@"      %@ ~", item.Item];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"      %@", item.Status];
            }else{
                  cell.detailTextLabel.text=[NSString stringWithFormat:@"      %@", item.Status];
                cell.textLabel.text =[NSString stringWithFormat:@"     %@ ~ %@", item.Item, item.Des];
            }
            [cell .imageView setImage:nil];
        }
        
    }

    
//    NSEntityDescription *cia =[ciaListresult objectAtIndex:indexPath.row];
//    NSString *idnm = [cia valueForKey:@"ciaid"];
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ ~ %@", idnm, [cia valueForKey:@"cianame"]];
//    cell.textLabel.font=[UIFont systemFontOfSize:17.0];
//    
//    [cell .imageView setImage:nil];
//    
    
    
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    donext =@"4";
    [self autoUpd];
//    if (tableView.tag==5) {
//        [self calloffice];
//    }else if(tableView.tag==6){
//        [self calmobile];
//    }else{
//        [self sendEmail];
//    }
}

//-(void)calloffice{
//    if (phone !=nil) {
//        NSMutableString *phone1 = [result.Phone mutableCopy];
//        [phone1 replaceOccurrencesOfString:@" "
//                                withString:@""
//                                   options:NSLiteralSearch
//                                     range:NSMakeRange(0, [phone1 length])];
//        [phone1 replaceOccurrencesOfString:@"("
//                                withString:@""
//                                   options:NSLiteralSearch
//                                     range:NSMakeRange(0, [phone1 length])];
//        [phone1 replaceOccurrencesOfString:@")"
//                                withString:@""
//                                   options:NSLiteralSearch
//                                     range:NSMakeRange(0, [phone1 length])];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone1]];
//        [[UIApplication sharedApplication] openURL:url];
//    }else{
//        UIAlertView *a=[self getErrorAlert:@"There is no Office Phone Number to call"];
//        [a show];
//    }
//    
//}
//
//-(void)calmobile{
//    if (Mobile !=nil) {
//        NSMutableString *phone1 = [result.Mobile mutableCopy];
//        [phone1 replaceOccurrencesOfString:@" "
//                                withString:@""
//                                   options:NSLiteralSearch
//                                     range:NSMakeRange(0, [phone1 length])];
//        [phone1 replaceOccurrencesOfString:@"("
//                                withString:@""
//                                   options:NSLiteralSearch
//                                     range:NSMakeRange(0, [phone1 length])];
//        [phone1 replaceOccurrencesOfString:@")"
//                                withString:@""
//                                   options:NSLiteralSearch
//                                     range:NSMakeRange(0, [phone1 length])];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone1]];
//        [[UIApplication sharedApplication] openURL:url];
//    }else{
//        UIAlertView *a=[self getErrorAlert:@"There is no Office Mobile Number to call"];
//        [a show];
//    }
//    
//}
//
//-(void)sendEmail{
//    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", result.Email ];
//    NSURL *url = [NSURL URLWithString:stringURL];
//    [[UIApplication sharedApplication] openURL:url];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [result.Dlist count];
}

@end
