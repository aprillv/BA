//
//  updItem.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-10.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "updItem.h"
#import "wcfService.h"
#import "Reachability.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomKeyboard.h"
#import "viewImage.h"
#import "wcfCalendarQAbItemDetail.h"
#import "ViewController.h"
#import "calendarqa.h"
#import "project.h"
#import "qainspectionb.h"

@interface updItem()<CustomKeyboardDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate, MBProgressHUDDelegate>{
    
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    NSString *donext;
    UIImageView *uview;
    wcfCalendarQAbItemDetail *wi;
    int imgy;
    bool ishaveimg;
    NSMutableData *_data;
    UIButton *btnAddPic;
    UIButton *btnUpdate;
    UIButton *btnPass;
    UIButton *btnReady;
    UIImage* scaledImage;
    MBProgressHUD *HUD;
    UIActivityIndicatorView *_spinner;
}
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@end

@implementation updItem

@synthesize idnumber, isshow, category, itemId, xstatus, fromtype,ntabbar, uv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag==1) {
        [self goBack1:item];
    }else if(item.tag == 2){
//        [self dorefresh:];
    }
}

-(IBAction)myFunction1:(id)sender{
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub]]];
    //
    
    //    ViewController *si = [[ViewController alloc] init];
    //    si.xurl=[NSString stringWithFormat:@"http://ws.buildersaccess.com/sitemap.aspx?email=%@&password=%@&idcia=%@&projectid=%@&projectid2=%@", [userInfo getUserName], [userInfo getUserPwd], result.IDCia, result.IDSub, result.IDProject ];
    //    si.managedObjectContext=self.managedObjectContext;
    //
    //    [self presentViewController:si animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh:)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    ishaveimg=NO;
//    int x=0;
//    int y=10;
//    if (self.view.frame.size.height>480) {
//        y=y+5;
//        x=10;
//    }else{
//        x=8;
//    }
    
    self.title=@"Inspection";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    [self getDetail];
    
    
    
    
	// Do any additional setup after loading the view.
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
        [service xGetQaCalendarInspection2bItem:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xidnumber:itemId EquipmentType:@"3"];
        // Do any additional setup after loading the view.
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
    
    wi=(wcfCalendarQAbItemDetail *)value;
    
    
    
    UILabel *lbl;
    float rowheight=32.0;
    int x =5;
    int y =10;
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Category";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    
   UIView * lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=wi.Category;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Notes (max 512 chars)";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, 296, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.delegate=self;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    txtNote.text=wi.Notes;
    [uv addSubview:txtNote];
    
    y=y+120;
    
    imgy=y;
    
    uview =[[UIImageView alloc]init];
    [uv addSubview:uview];
    
    
    
    if ([wi.Fs isEqualToString:@"1"]) {
        uview.frame = CGRectMake(10, y, 300, 225);
        y=y+245;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownloadqa.aspx?email=%@&password=%@&idcia=%@&id=%@&fname=%@", [userInfo getUserName], [userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue], itemId,@"tmp"]];
        
        _data =[[NSMutableData alloc]init];
        NSURLRequest* updateRequest = [NSURLRequest requestWithURL:url];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.hidesWhenStopped = YES;
        [_spinner setBackgroundColor:[UIColor blackColor]];
        _spinner.center = CGPointMake(140,
                                      y+100);
        self.view.userInteractionEnabled=NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [_spinner startAnimating];
        [connection start];
    }
    
    if (!xstatus) {
        if ([wi.btn4 isEqualToString:@"0"]) {
            if ([wi.btn1 isEqualToString:@"1"] || [wi.btn3 isEqualToString:@"1"]){
                btnAddPic = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnAddPic setFrame:CGRectMake(10, y, 300, 44)];
                if ([wi.Fs isEqualToString:@"1"]) {
                    [btnAddPic setTitle:@"Re - Attatch Picture" forState:UIControlStateNormal];
                }else{
                    [btnAddPic setTitle:@"Attatch Picture" forState:UIControlStateNormal];
                }
                
                [btnAddPic.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
                [btnAddPic setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [btnAddPic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnAddPic addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
                [uv addSubview:btnAddPic];
                y= y+50;
                
                if ([wi.btn1 isEqualToString:@"1"] ) {
                    btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnUpdate setFrame:CGRectMake(10, y, 300, 44)];
                    [btnUpdate setTitle:[NSString stringWithFormat:@"Item > %@", wi.btn1name] forState:UIControlStateNormal];
                    [btnUpdate.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
                    if ([wi.btn1name isEqualToString:@"Update"]) {
                        [btnUpdate setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                    }else{
                        [btnUpdate setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                    }
                    
                    [btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btnUpdate addTarget:self action:@selector(doUpdate) forControlEvents:UIControlEventTouchUpInside];
                    [uv addSubview:btnUpdate];
                    y= y+50;
                    
                    
                }
                
                if ([wi.btn3 isEqualToString:@"1"]) {
                    btnPass = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnPass setFrame:CGRectMake(10, y, 300, 44)];
                    [btnPass setTitle:@"Item > Save & Pass" forState:UIControlStateNormal];
                    [btnPass.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
                    [btnPass setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                    [btnPass setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btnPass addTarget:self action:@selector(doPass) forControlEvents:UIControlEventTouchUpInside];
                    [uv addSubview:btnPass];
                    y= y+50;
                }
            }else{
                txtNote.userInteractionEnabled=NO;
            }
            
            
            
            
        }else{
            btnReady = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnReady setFrame:CGRectMake(10, y, 300, 44)];
            [btnReady setTitle:@"Item > Ready" forState:UIControlStateNormal];
            [btnReady.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [btnReady setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [btnReady setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnReady addTarget:self action:@selector(doReady) forControlEvents:UIControlEventTouchUpInside];
            [uv addSubview:btnReady];
            y= y+50;
            
        }
    }
    
    
    if (y<self.view.frame.size.height-43) {
        y=self.view.frame.size.height-43;
    }
    uv.contentSize=CGSizeMake(320, y);
}



-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.view.userInteractionEnabled=YES;
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
    UIImage *img=[UIImage imageWithData:_data];
    
    
    if (img!=nil) {
        //        float f = 300/img.size.width;
        
        
        uview.image=img;
        scaledImage=img;
        uview.userInteractionEnabled = YES;
        uview.layer.cornerRadius=10;
        uview.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
        tapped.numberOfTapsRequired = 1;
        [uview addGestureRecognizer:tapped];
        
    }
    
    
    
}


-(void) doUpdate{
    donext=@"4";
    [self autoUpd];
}



-(void)doPass{
    donext=@"2";
    [self autoUpd];
}

-(void)doReady{
    donext=@"3";
    [self autoUpd];
}

-(void)addPic{
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
        NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
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
        if ([donext isEqualToString:@"1"]) {
            // attatch picture
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:nil
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"New Photo",@"Choose from Library", nil];
            alert.tag = 1;
            [alert show];
        }else if([donext isEqualToString:@"4"]){
            // save & fail
            UIAlertView *alert = nil;
            if([wi.btn1name isEqualToString:@"Update"]){
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"Are you sure you want to save?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"OK", nil];
            }else{
                alert = [[UIAlertView alloc]
                         initWithTitle:@"BuildersAccess"
                         message:@"Are you sure this item fails?"
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"OK", nil];
            }
           
            alert.tag = 2;
            [alert show];
            
            
        }else if([donext isEqualToString:@"2"]){
            // save & finish
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure this item pass?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
            alert.tag = 3;
            [alert show];
        }else if([donext isEqualToString:@"3"]){
            // save & finish
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure this item is ready for inspection?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
            alert.tag = 4;
            [alert show];
        }
        
    }
    
    
}

- (void) xisupdate_iphoneHandler2: (id) value {
    [HUD hide:YES];
    [HUD removeFromSuperview];
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
    
    NSString *rtn =(NSString *)value;
    if ([rtn isEqualToString:@"1"]) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[qainspectionb class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }

    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1){
	    switch (buttonIndex) {
            case 2:
            {
                UIImagePickerController *p = [[UIImagePickerController alloc]init];
                p.delegate=self;
                p.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:p animated:YES completion:nil];
            }
				break;
                
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *p = [[UIImagePickerController alloc]init];
                    p.delegate=self;
                    p.sourceType=UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:p animated:YES completion:nil];
                    
                    
                }else{
                    [[self getErrorAlert:@"There is no camera available."] show];
                }
                
                
            }
		}
	}else if(alertView.tag==2){
        if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            if (ishaveimg) {
                
                UIGraphicsBeginImageContext(CGSizeMake(800, 600));
                [scaledImage drawInRect:CGRectMake(0, 0, 800, 600)];
                scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSData *photoData=UIImageJPEGRepresentation(scaledImage, 1.0);
                Mysql *mysql =[[Mysql alloc]init];
                NSString * strphotodata = [mysql Base64Encode:photoData];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Updating...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                [service xQaCalendarInspection2bUpdWithImg:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber:itemId xnotes:txtNote.text photoBase64String:strphotodata EquipmentType:@"3"];
            }else{
                [service xQaCalendarInspection2bUpd:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber:itemId xnotes:txtNote.text EquipmentType:@"3"];
            }
            
        }
    }else if(alertView.tag==3){
        if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            if (ishaveimg) {
                
                UIGraphicsBeginImageContext(CGSizeMake(800, 600));
                [scaledImage drawInRect:CGRectMake(0, 0, 800, 600)];
                scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSData *photoData=UIImageJPEGRepresentation(scaledImage, 1.0);
                Mysql *mysql =[[Mysql alloc]init];
                NSString * strphotodata = [mysql Base64Encode:photoData];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.labelText=@"Updating...";
                HUD.dimBackground = YES;
                HUD.delegate = self;
                [HUD show:YES];
                [service xQaCalendarInspection2bBtn3WithImg:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber:itemId photoBase64String:strphotodata xnotes:txtNote.text EquipmentType:@"3"];
            }else{
                [service xQaCalendarInspection2bBtn3:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber:itemId xnotes:txtNote.text EquipmentType:@"3"];
            }
            
        }
    }else if(alertView.tag==4){
        if (buttonIndex==1) {
            wcfService* service = [wcfService service];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            //            if (ishaveimg) {
            //
            //                UIGraphicsBeginImageContext(CGSizeMake(800, 600));
            //                [scaledImage drawInRect:CGRectMake(0, 0, 800, 600)];
            //                scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            //                UIGraphicsEndImageContext();
            //
            //                NSData *photoData=UIImageJPEGRepresentation(scaledImage, 1.0);
            //                Mysql *mysql =[[Mysql alloc]init];
            //                NSString * strphotodata = [mysql Base64Encode:photoData];
            //
            //                [service xQaCalendarInspection2bAddWithImg:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text photoBase64String:strphotodata EquipmentType:@"3"];
            //            }else{
            [service xQaCalendarInspection2bBtn4:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber:itemId xnotes:txtNote.text EquipmentType:@"3"];
            //            }
            
        }
    }
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    
}


- (UIImage *)scaleImage:(UIImage *)image

{
//    float h = image.size.height;
//    float w = image.size.width;
//    float x, y;
    
//    float scaleSize;
//    scaleSize=120/h;
//    h=120;
//    y=0;
//    w=w*scaleSize;
//    x=(160-w)/2;
    uview.frame=CGRectMake(10, imgy, 300, 225);
    uview.userInteractionEnabled = YES;
    uview.layer.cornerRadius=10;
    uview.layer.masksToBounds = YES;
    
    int y1 = imgy+250;
    btnAddPic.frame=CGRectMake(10, y1, 300, 44);
    y1=y1+50;
    
    if ([wi.btn4 isEqualToString:@"0"]) {
        btnUpdate.frame=CGRectMake(10, y1, 300, 44);
        y1=y1+50;
        
        btnPass.frame=CGRectMake(10, y1, 300, 44);
        y1=y1+50;
    }
    uv.contentSize=CGSizeMake(320, y1+20);
    
    uview.image=image;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
    tapped.numberOfTapsRequired = 1;
    [uview addGestureRecognizer:tapped];
    
    
    //    UIGraphicsBeginImageContext(CGSizeMake(800, 600));
    //    [image drawInRect:CGRectMake(0, 0, 800, 600)];
    //    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    scaledImage=image;
    [btnAddPic setTitle:@"Re - Attatch Picture" forState:UIControlStateNormal];
    [ntabbar setSelectedItem:nil];
    ishaveimg=YES;
    
    return image;
    
}

-(IBAction)myFunction :(id) sender
{
    viewImage * vi =[viewImage alloc];
    vi.managedObjectContext=self.managedObjectContext;
    vi.img=scaledImage;
    [self.navigationController presentViewController:vi animated:YES completion:nil];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
//        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-140) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-54) animated:YES];    }
	return YES;
}


- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
    [txtNote resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
