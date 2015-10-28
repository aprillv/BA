//
//  newSchedule2.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/21/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "newSchedule2.h"

#import "wcfArrayOfProjectSchedule.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "newSchedule2.h"
#import "project.h"
#import "MBProgressHUD.h"
#import "aCell.h"
#import "reschedule.h"

//#import "CustomCell.h"


@interface newSchedule2()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MBProgressHUDDelegate>{
    
    
    wcfArrayOfProjectSchedule * wi;
    wcfProjectSchedule *xidnum;
//    UITableView *tbview;
    wcfArrayOfProjectSchedule *wi2;
    MBProgressHUD *HUD;
//    NSTimer *myTimer;
    int curent;

    NSIndexPath *selIndex;
    UIActionSheet *actionSheet;
    NSDateFormatter *formatter;
    BOOL hasUpdateButton;
    
    int donext;
//    UIButton*  scanQRCodeButton;
}

@end


@implementation newSchedule2

@synthesize xidproject, xidstep, tbview, pdate, ntabbar;

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
    
    [pdate setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    hasUpdateButton = YES;
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi;
    fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
    self.view.backgroundColor=[UIColor whiteColor];

    
	// Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack1];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}

-(void)goBack1{
    for (UIViewController *uiview in self.navigationController.viewControllers) {
        if ([uiview isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:uiview animated:YES];
        }
    }
}
-(void)dorefresh{
    [self getMilestoneItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getMilestoneItem];
}
-(void)getMilestoneItem{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        if ([xidstep isEqualToString:@"-1"]) {
            [service xGetTaskDue:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:xidproject EquipmentType:@"3"];
        }else{
            [service xGetNewSchedule2:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidproject:xidproject xstep:xidstep EquipmentType:@"3"];
        }
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
    
    wi=(wcfArrayOfProjectSchedule *)value;
//    if (uv) {
//        [uv removeFromSuperview];
//    }
    
    int xheight;
    if (self.view.frame.size.height>480) {
        xheight=454;
       
    }else{
        xheight=366;
    }
    
      
//    uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, xheight)];
//    [self.view addSubview:uv];
  
    xheight=0;
    BOOL canupdate=NO;
    hasUpdateButton = NO;
    for (wcfProjectSchedule *event in wi) {
        if (event.Notes!=nil) {
            xheight+=64;
        }else{
            xheight+=54;
        }
        if (!event.DcompleteYN) {
            canupdate=YES;
            hasUpdateButton = YES;
        }
    }
    [tbview reloadData];
    
    
    if (canupdate) {
        CGFloat xh = 0;
        for (wcfProjectSchedule *event in wi) {
            if (event.Notes!=nil) {
                xh += 64;
            }else{
                xh += 54;
            }
        }
        
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setFrame:CGRectMake(10, xh+20, self.view.frame.size.width-20, 44)];
        [loginButton setTitle:@"Update Schedule" forState:UIControlStateNormal];
        [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(doapprove1) forControlEvents:UIControlEventTouchUpInside];
        [tbview addSubview:loginButton];
//        xheight=xheight+74;
        
    }
    
    [ntabbar setSelectedItem:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (indexPath.row == [wi count]) {
        return NO;
    }
     wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
    
    if (!event.DcompleteYN) {
        return YES;
    }else{
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [wi count] ) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        selIndex=indexPath;
        donext=2;
        [self doupdateCheck];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Reschedule";
}



-(void)doapprove1{
    donext=1;
    [self doupdateCheck];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%d", [wi count]);
    if (hasUpdateButton) {
        return [wi count] + 1;
    }else{
        return [wi count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= [wi count] ) {
        return [[UITableViewCell alloc] init];
    }
    wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
    
    static NSString *CellIdentifier = @"CellwcfProjectSchedule";
    
    aCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        cell = [[aCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
//    [cell setEditing:YES animated:YES];
    
  
    
    
//    NSLog(@"%@", event);
    if (!(![xidstep isEqualToString:@"-1"] && indexPath.row==0 && !event.DcompleteYN ) && event.canEdit) {
        UIImageView *imageView;
        if (event.DcompleteYN||event.DcompleteYN2) {
            
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
        }else {
            event. DcompleteYN2=NO;
            imageView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck.png"]];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES; //added based on @John 's comment
        cell.accessoryView = imageView;
    }else{
        cell.accessoryView = nil;
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell .imageView setImage:nil];
        
       
        
//        UISwipeGestureRecognizer * leftSwipe = [[UISwipeGestureRecognizer alloc] init];
//        leftSwipe.direction= UISwipeGestureRecognizerDirectionLeft;
//        [leftSwipe addTarget:self action:@selector(swipedLeft)];
//        [cell addGestureRecognizer:leftSwipe];
//        
//        leftSwipe = [[UISwipeGestureRecognizer alloc] init];
//        leftSwipe.direction= UISwipeGestureRecognizerDirectionRight;
//        [leftSwipe addTarget:self action:@selector(swipedRight)];
//        [cell addGestureRecognizer:leftSwipe];
//        
//
//      scanQRCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        scanQRCodeButton.frame = CGRectMake(200.0f, 10.0f, 80.0f, 30.0f);
//        scanQRCodeButton.backgroundColor = [UIColor redColor];
//        [scanQRCodeButton setTitle:@"Hello" forState:UIControlStateNormal];
////        UITableViewCell *cell= [tbview cellForRowAtIndexPath:selIndex];
//        [cell addSubview:scanQRCodeButton];
////        [scanQRCodeButton setHidden:YES];
//        
    }
    
    cell.textLabel.text=event.Name;
    NSString *nst;
    
    int n =1;
    if (event.Notes !=nil) {
        n= n+1;
        cell.ismore=YES;
        nst=[NSString stringWithFormat:@"%@\n", event.Notes];
    }else{
        cell.ismore=NO;
    nst=@"";
    }
    
    
    
    if (event.DcompleteYN) {
        nst= [NSString stringWithFormat:@"%@%@ %@",nst,event.Dstart, event.Dcomplete];
    }else{
        if (event.DcompleteYN2) {
            //           nst= [NSString stringWithFormat:@"%@%@ To %@",nst,event.Dstart,[Mysql stringFromDate3:[[NSDate alloc]init]]];
            nst= [NSString stringWithFormat:@"%@%@ To %@",nst,event.Dstart,event.DcompleteNew];
        }else{
            nst= [NSString stringWithFormat:@"%@%@",nst, event.Dcomplete];
        }
        
    }
    
    cell.detailTextLabel.numberOfLines=0;
    cell.detailTextLabel.text=nst;
    
    
    [cell .imageView setImage:nil];
    
    return cell;
}
-(IBAction)goBack:(id)sender{
    
    [tbview reloadData];
    [super goBack:nil];

}

-(void)popupscreen{
    
        
    if (!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/YY"];
    }
    
        NSString * str=[formatter stringFromDate:[[NSDate alloc] init] ];
        [self dochangeCheck: str];
        
    
    
}

//-(void)popupscreen{
//    
//    if (!actionSheet) {
//        actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self
//                                         cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Select",@"Cancel", nil];
//        [actionSheet setTag:2];
//        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//        
//        
//        if ([pdate isHidden]) {
//            [pdate removeFromSuperview];
//            [actionSheet addSubview:pdate];
//            [pdate setHidden:NO];
//            [pdate setFrame:CGRectMake(0,0, pdate.frame.size.width, pdate.frame.size.height)];
//            [pdate setMaximumDate:[NSDate date]];
//        }
//        if (self.view.frame.size.height>500) {
//            [actionSheet setFrame:CGRectMake(0, 207, 320, 383)];
//        }else{
//            [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
//        }
//        
//        [[[actionSheet subviews]objectAtIndex:0] setFrame:CGRectMake(20,236, 120, 46)];
//        [[[actionSheet subviews]objectAtIndex:1] setFrame:CGRectMake(180,236, 120, 46)];
//        
//
//    }
//    [pdate setDate:[NSDate date]];
//    [actionSheet showInView:self.view];
//    
//    
//}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
//        @autoreleasepool {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"MM/dd/YY"];
//            NSString * str=[formatter stringFromDate:[pdate date] ];
//            [self dochangeCheck: str];
//        }
        if (!formatter) {
            formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd/YY"];
        }
        
        NSString * str=[formatter stringFromDate:[pdate date] ];
        [self dochangeCheck: str];
    
    }
    
    
}
- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tapLocation = [tapRecognizer locationInView:tbview];
    NSIndexPath *indexPath = [tbview indexPathForRowAtPoint:tapLocation];
   
    
    selIndex=indexPath;
    [self dostep1];
//    [self dochangeCheck:indexPath];
    
}


-(void)dostep1{
    if (selIndex.row==0 && ![xidstep isEqualToString:@"-1"] ) {
        return;
    }
    
    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
    
    if (!event.canEdit) {
        return;
    }
    if (!event.DcompleteYN) {
        if (event. DcompleteYN2) {
            event.DcompleteYN2=NO;
            event.DcompleteNew=@"";
            NSMutableArray *na =[[NSMutableArray alloc]init];
            [na addObject:selIndex];
            [tbview reloadRowsAtIndexPaths:na withRowAnimation: UITableViewRowAnimationFade];
        }else{
           [self popupscreen];
            
//            event.DcompleteYN2=YES;
//            event.DcompleteNew=@"09/03/13";
//            NSMutableArray *na =[[NSMutableArray alloc]init];
//            [na addObject:selIndex];
//            [tbview reloadRowsAtIndexPaths:na withRowAnimation: UITableViewRowAnimationFade];
            
        }
    }
}

-(void)dochangeCheck:(NSString *)dates{
   
    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);

    event.DcompleteYN2=YES;
    event.DcompleteNew=dates;
    NSMutableArray *na =[[NSMutableArray alloc]init];
    [na addObject:selIndex];
    [tbview reloadRowsAtIndexPaths:na withRowAnimation: UITableViewRowAnimationFade];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [wi count]) {
        return 80;
    }
    wcfProjectSchedule *event =[wi objectAtIndex:(indexPath.row)];
    if (event.Notes!=nil) {
       return 64;
    }else{
        return 54;
    }
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
//    [self dochangeCheck:indexPath];
    
    selIndex=indexPath;
    [self dostep1];
//    [scanQRCodeButton setHidden:YES];
    
   
    
}

-(void)doupdateCheck{
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
        switch (donext) {
            case 1:
                 [self todoupdate:YES];
                break;
            case 2:
                [self doreschedule];
                break;
            default:
                break;
        }
    

    }
}

-(void)doreschedule{
    wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
    if (selIndex.row!=0 && ![[event.Name substringToIndex:1] isEqualToString:@"*"]) {
        reschedule * re=[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"reschedule"];
        re.xidproject=self.xidproject;
        re.result=nil;
        re.iscriticalpath=NO;
        wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
        //        re.ws=event.Name;
       
        
        re.ws=event;
        //        NSLog(@"%@", re.ws);
        if (!formatter) {
            formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd/yy"];
        }
        
        
        NSDate *destDate= [formatter dateFromString:[event.Dstart substringFromIndex:5]];
        re.idmainstep= [self.xidstep intValue];
        //        re.xrefid=event.Item;
        re.xstartd=destDate;
        [formatter setDateFormat:@"MM/dd/yyyy"];
        re.ws.Dstart=[formatter stringFromDate:destDate];
        [formatter setDateFormat:@"MM/dd/yy"];
        //         NSLog(@"%@", re.ws);
        
        re.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:re animated:YES];
    }else{
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        [service xGetReschedule:self action:@selector(xGetRescheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xidproject:xidproject xidmainstep:event.Item EquipmentType:@"3"];
        
        
    }

}

- (void) xGetRescheduleHandler: (id) value {
    
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
    
    
    wcfArrayOfKeyValueItem* result2 = (wcfArrayOfKeyValueItem*)value;
    if ([result2 count]>0) {
        
        
        wcfKeyValueItem *ki =[result2 objectAtIndex:0];
        if ([ki.Key isEqualToString:@"-2"]) {
            UIAlertView *alert = [self getErrorAlert: ki.Value];
            [alert show];
            return;
            
        }else{
    
    wcfKeyValueItem *ki2=[result2 objectAtIndex:1];
    if ([ki.Key isEqualToString:@"-1"]) {
        UIAlertView *alert = [self getErrorAlert2: [NSString stringWithFormat:@"%@\n%@ %@",[ki.Value stringByReplacingOccurrencesOfString:@";" withString:@" "], ki2.Key, ki2.Value]];
        [alert show];
        return;

    }else{
        reschedule * re=[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"reschedule"];
        re.xidproject=self.xidproject;
        re.result=result2;
        re.iscriticalpath=YES;
        wcfProjectSchedule *event=((wcfProjectSchedule *)[wi objectAtIndex:selIndex.row]);
//        re.ws=event.Name;
       
        re.ws=event;
//        NSLog(@"%@", re.ws);
        if (!formatter) {
            formatter = [[NSDateFormatter alloc]init];
           [formatter setDateFormat:@"MM/dd/yy"];
        }
        
        
        NSDate *destDate= [formatter dateFromString:[event.Dstart substringFromIndex:5]];
        re.idmainstep= [self.xidstep intValue];
//        re.xrefid=event.Item;
        re.xstartd=destDate;
         [formatter setDateFormat:@"MM/dd/yyyy"];
        re.ws.Dstart=[formatter stringFromDate:destDate];
         [formatter setDateFormat:@"MM/dd/yy"];
//         NSLog(@"%@", re.ws);
        
        re.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:re animated:YES];
   
    }
        }
    }
}

-(UIAlertView *)getErrorAlert2:(NSString *)str{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:str
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
    NSArray *subViewArray = alertView.subviews;
    for(int x=0;x<[subViewArray count];x++){
        if([[[subViewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]])
        {
            UILabel *label = [subViewArray objectAtIndex:x];
            if (![label.text isEqualToString:@"Error"]) {
                label.textAlignment = NSTextAlignmentLeft;
            }
            
        }
        
    }

    
    return alertView;
}

-(void)todoupdate:(BOOL)tocheck{
    wi2=[[wcfArrayOfProjectSchedule alloc]init];
    int nstep=1;
    if ([xidstep isEqualToString:@"-1"]) {
        nstep=0;
    }
    for (int i=nstep; i<[wi count]; i++) {
        wcfProjectSchedule *ws =[wi objectAtIndex:i];
       
        
        if (!ws.DcompleteYN && ws.DcompleteYN2 && ws.canEdit) {
//            Mysql *ms =[[Mysql alloc]init];
//            NSLog(@"%@", ws.MilestoneDstart);
            if ([[formatter dateFromString:ws.DcompleteNew] compare:[formatter dateFromString:ws.MilestoneDstart]]==NSOrderedAscending) {
                UIAlertView *alert=[self getErrorAlert:@"Finish date can not be less than main step start date. Please re-schedule the main step in order to assign this date."];
                [alert show];
                return;
            }
            if ([[formatter dateFromString:ws.DcompleteNew] compare:[formatter dateFromString:[ws.Dstart substringFromIndex:5]]]==NSOrderedAscending && tocheck) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"BuildersAccess"
                                      message:@"Finish date is less than start date.\nAre you sure you want to continue?"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"OK", nil];
                alert.tag = 1;
                [alert show];
                return;
            }else{
                [wi2 addObject:ws];
            }
            
        }
    }
    
    [self doapprove];
    
}

-(void)doapprove{
    
    if ([wi2 count]>0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"BuildersAccess"
                              message:@"Are you sure you want to save?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        alert.tag = 0;
        [alert show];
        
        
    }else{
        UIAlertView *alert=[self getErrorAlert:@"There is nothing to update."];
        [alert show];
    }

    
    
}

-(void)doapprove2{
    curent=0;
    self.view.userInteractionEnabled=NO;
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.labelText=@"Updating Schedule...";
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    [HUD show:YES];
    
//    alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Sending Email to Queue..." delegate:self otherButtonTitles:nil];
//    
//    [alertViewWithProgressbar show];
//    alertViewWithProgressbar.progress=1;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Sending Email to Queue...";
    
    HUD.progress=0.01;
    [HUD layoutSubviews];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    [self doUpdateSchedule];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0){
	    switch (buttonIndex) {
			case 0:
				break;
			default:
                [self doapprove2];
				
				break;
		}
    }else if (alertView.tag == 1){
        switch (buttonIndex) {
			case 0:
				break;
			default:
				[self todoupdate:NO];
				break;
		}
    }
}

-(void)doUpdateSchedule{
    if (curent < [wi2 count]) {
        wcfService* service = [wcfService service];
        wcfProjectSchedule *ws = [wi2 objectAtIndex:curent];
        //        NSLog(@"%@, %@, %@", xidproject, ws.Item, [ ws.Dcomplete substringFromIndex:16]);
        
        HUD.progress=curent*1.0/[wi2 count];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xCompleteSchedule:self action:@selector(doxCompleteScheduleHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[NSString stringWithFormat:@"%d", [userInfo getCiaId]] xprojectid:xidproject refid:ws.Item completeDate:ws.DcompleteNew EquipmentType:@"5"];
    }else{
//        [HUD hide:YES];
//        [HUD removeFromSuperViewOnHide];
        HUD.progress=1.0;
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        [self goBack1];
    }
}
- (void) doxCompleteScheduleHandler: (id) value {
    
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
    wcfProjectScheduleComplete  *pc =(wcfProjectScheduleComplete *)value;
    //    NSLog(@"%@", pc);
    if ([pc.Flag isEqualToString:@"0"]) {
        
        curent+=1;
        [self doUpdateSchedule];
    }else if ([pc.Flag isEqualToString:@"2"]) {
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        NSString *nst = @"The following step has to be completed before";
        
         nst=[NSString stringWithFormat:@"%@ %@\n",nst, ((wcfProjectSchedule *)[pc.ScheduleList objectAtIndex:0]).Name ];
        [pc.ScheduleList removeObjectAtIndex:0];
        for (wcfProjectSchedule *psd in pc.ScheduleList) {
            nst=[NSString stringWithFormat:@"%@\n%@",nst, psd.Name ];
        }
        UIAlertView *alert = [self getErrorAlert1: nst];
        [alert show];
         [self getMilestoneItem];
        return;
        
    }else if([pc.Flag isEqualToString:@"3"]){
        self.view.userInteractionEnabled=YES;
        [HUD hide];
        NSString *nst =@"Finish date can not be less than main step start date. Please re-schedule the main step in order to assign this date.";
        for (wcfProjectSchedule *psd in pc.ScheduleList) {
            nst=[NSString stringWithFormat:@"%@\n%@",nst, psd.Name ];
        }
        
//        [tbview selectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] animated:YES scrollPosition:0];
        UIAlertView *alert = [self getErrorAlert1: nst];
        [alert show];
         [self getMilestoneItem];
        return;
    }else{
        self.view.userInteractionEnabled=YES;
        [HUD hide];
         [self getMilestoneItem];
        UIAlertView *alert = [self getErrorAlert: @"Something wrong happened."];
        [alert show];
    }
}
-(UIAlertView *)getErrorAlert1:(NSString *)str{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:str
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
    NSArray *subViewArray = alertView.subviews;
    for(int x=0;x<[subViewArray count];x++){
        if([[[subViewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]])
        {
            UILabel *label = [subViewArray objectAtIndex:x];
            if (![label.text isEqualToString:@"Error"]) {
                label.textAlignment = NSTextAlignmentLeft;
            }
            
        }
        
    }
    
    return alertView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
