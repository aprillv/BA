//
//  addItem.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-9.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "addItem.h"
#import "wcfService.h"
#import "Reachability.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomKeyboard.h"
#import "viewImage.h"
#import "calendarqa.h"
#import "MBProgressHUD.h"
#import "project.h"
#import "qainspectionb.h"
#import "MBProgressHUD.h"

@interface addItem()<CustomKeyboardDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate, MBProgressHUDDelegate>{
    UITextView *txtNote;
    CustomKeyboard *keyboard;
    NSString *donext;
    UIImageView *uview;
    
    int imgy;
    bool ishaveimg;
    
    UIButton *btnAddPic;
    UIButton *btnFail;
    UIButton *btnFinish;
    UIImage* scaledImage;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;
@end

@implementation addItem

@synthesize idnumber, isshow, category, fromtype, uv, ntabbar;

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
//        [self dorefresh:item];
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
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh:)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    ishaveimg=NO;
    int x=0;
    int y=10;
    if (self.view.frame.size.height>480) {
        y=y+5;
        x=10;
    }else{
        x=8;
    }
//    uv.backgroundColor = [UIColor redColor];
    self.title=@"Inspection";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
    
    UILabel *lbl;
    float rowheight=32.0;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Category";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UIView *lbl1;
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, self.view.frame.size.width-20, rowheight-6)];
    lbl.text=category;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Notes (max 512 chars)";
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
    txtNote.delegate=self;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithDone]];
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    imgy=y;
    
    uview =[[UIImageView alloc]init];
    [uv addSubview:uview];
    
    btnAddPic = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddPic setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
    [btnAddPic setTitle:@"Attatch Picture" forState:UIControlStateNormal];
    [btnAddPic.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnAddPic setBackgroundImage:[[UIImage imageNamed:@"yButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [btnAddPic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAddPic addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:btnAddPic];
        y= y+50;
    
    
    
    if ([isshow isEqualToString:@"1"]) {
        btnFail = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFail setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [btnFail setTitle:@"Item > Save & Fail" forState:UIControlStateNormal];
        [btnFail.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnFail setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [btnFail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnFail addTarget:self action:@selector(doFail) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:btnFail];
        y= y+50;

        btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFinish setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
        [btnFinish setTitle:@"Item > Save & Pass" forState:UIControlStateNormal];
        [btnFinish.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnFinish setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnFinish addTarget:self action:@selector(doFinish) forControlEvents:UIControlEventTouchUpInside];
        [uv addSubview:btnFinish];
//        y= y+50;
    }

    if (y < uv.frame.size.height + 1) {
        y= uv.frame.size.height + 1;
    }
    uv.contentSize=CGSizeMake(self.view.frame.size.width,y);

    
	// Do any additional setup after loading the view.
}

-(void)addPic{
    donext=@"1";
    [self autoUpd];
}

-(void)doFail{
    donext=@"2";
    [self autoUpd];
}

-(void)doFinish{
    donext=@"3";
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
        }else if([donext isEqualToString:@"2"]){
            // save & fail
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"Are you sure this item fails?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
            alert.tag = 2;
            [alert show];
            
            
        }else if([donext isEqualToString:@"3"]){
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
        }
        
    }
    
    
}

- (void) xisupdate_iphoneHandler2: (id) value {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [HUD hide:YES];
    [HUD removeFromSuperview];
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
                [service xQaCalendarInspection2bAddWithImg:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text photoBase64String:strphotodata EquipmentType:@"3"];
            }else{
                [service xQaCalendarInspection2bAdd:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text EquipmentType:@"3"];
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
                [service xQaCalendarInspection2bAddPassWithImg:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text photoBase64String:strphotodata EquipmentType:@"3"];
                
            }else{
                [service xQaCalendarInspection2bAddPass:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject1chk1:idnumber reason:category xnotes:txtNote.text EquipmentType:@"3"];
            }
            
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
    uview.frame=CGRectMake(10, imgy, self.view.frame.size.width-20, 225);
    uview.userInteractionEnabled = YES;
    uview.layer.cornerRadius=10;
    uview.layer.masksToBounds = YES;
    
    int y1 = imgy+250;
    btnAddPic.frame=CGRectMake(10, y1, self.view.frame.size.width-20, 44);
    y1=y1+50;
    
    if (btnFail) {
        btnFail.frame=CGRectMake(10, y1, self.view.frame.size.width-20, 44);
        y1=y1+50;
        
        btnFinish.frame=CGRectMake(10, y1, self.view.frame.size.width-20, 44);
        y1=y1+50;
    }
    uv.contentSize=CGSizeMake(self.view.frame.size.width, y1+20);
    
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
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-140) animated:YES];
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
