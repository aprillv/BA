//
//  newpoqtyls.m
//  BuildersAccess
//
//  Created by amy zhao on 13-5-20.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "newpoqtyls.h"
#import "Mysql.h"
#import "wcfService.h"
#import "userInfo.h"
#import "cl_reason.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "project.h"
#import "development.h"
#import "CustomKeyboard.h"
#import "MBProgressHUD.h"

@interface newpoqtyls ()<UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate, CustomKeyboardDelegate, UITextViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    CustomKeyboard *keyboard;
    UIButton *dd1;
    NSMutableArray * pickerArray;
    UIPickerView *ddpicker;
    UIDatePicker *pdate;
    UIButton *txtDate;
    UITextView *txtNote;
    UITextField *txtTotal;
    MBProgressHUD* HUD;
    UIImage *myphoto;
    UIButton *btn1;
    UIButton* loginButton;
    UIImageView  *imageView;
    UIAlertController *sheet;
}
@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

int y;
@implementation newpoqtyls

@synthesize xnvendor, xidreason, xnreason, xidproject, xidvendor, uv, ntabbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)doAttatch:(id)sender{
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:nil
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"New Photo",@"Choose from Library", nil];
    alert.tag = 1;
    [alert show];
}

- (BOOL)textFieldShouldReturn:(id)sender
{
	[sender resignFirstResponder];
    UIScrollView *uv1=uv;
    if (self.view.frame.size.height>500) {
        [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [uv1 setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
	return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,40) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,120) animated:YES];
    }
	return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    
    if (self.view.frame.size.height>500) {
        
        if (sender == txtTotal) {
            [uv setContentOffset:CGPointMake(0,115) animated:YES];
        }
    }else{
        if (sender == txtTotal) {
            [uv setContentOffset:CGPointMake(0,210) animated:YES];
        }
    }
	return YES;
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[project class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Submit VPO";
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]init];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setEnabled:NO ];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    
    UILabel *lbl;
    
    y=10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Email To";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField * text1;
    text1=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
    [dd1 setFrame:CGRectMake(20, y+4, 270, 21)];
    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    
    [uv addSubview:dd1];
    y=y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Delivery Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtDate setFrame:CGRectMake(15, y+4, 270, 21)];
    [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
    [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtDate.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [txtDate setTitle:[Mysql stringFromDate2:[NSDate date]] forState:UIControlStateNormal];
    [uv addSubview: txtDate];
    y=y+30+10;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Notes (255 char)";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, self.view.frame.size.width-24, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    txtNote.delegate=self;
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :YES]];
    [uv addSubview:txtNote];
    y=y+110;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
    lbl.text=@"Total $";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    txtTotal=[[UITextField alloc]initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 30)];
    [txtTotal setBorderStyle:UITextBorderStyleRoundedRect];
    [txtTotal addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    txtTotal.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtTotal.delegate=self;
    [uv addSubview: txtTotal];
    y=y+30+20;
    
    
    
    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
    [btn1 setTitle:@"Attatch Picture" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(doAttatch:) forControlEvents:UIControlEventTouchDown];
    [uv addSubview:btn1];
    y=y+50;
    
    loginButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
    
    [loginButton setTitle:@"Submit" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doupdate1:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:loginButton];
    
    y=y+60;
    
    uv.contentSize=CGSizeMake(self.view.frame.size.width,y);
    [txtTotal setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
    
    [self getEmail];
	// Do any additional setup after loading the view.
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

-(void)getEmail{
    
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [service xGetNewPoVendorEmail:self action:@selector(xGetNewPoVendorEmailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidvendor:xidvendor EquipmentType:@"3"];
    }
    
}


-(void)xGetNewPoVendorEmailHandler: (id) value {
    // Handle errors
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    pickerArray = value;
    
    if ([pickerArray count]>0) {
        [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
        
        [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    }else{
        [dd1 setTitle:@"Email Not Found" forState:UIControlStateNormal];
    }
    
    
    
    
}


-(IBAction)doupdate1:(id)sender{
    //    wcfpoDesItem *pi;
    //    for (int i=1; i<[result1 count]+1; i++) {
    //        pi=[result1 objectAtIndex:(i-1)];
    //        cell =[ciatbview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    //        for (UITextField *uf in cell.subviews) {
    //            if ([uf isKindOfClass:[UITextField class]]) {
    //                if ([uf.text isEqualToString:@""]) {
    //                    pi.Qty=@"0";
    //                    [uf resignFirstResponder];
    //                }else if (![self isNumeric:uf.text]) {
    //                    UIAlertView *alert = [self getErrorAlert: @"Quantity must be a Number."];
    //                    [alert show];
    //                    [uf becomeFirstResponder];
    //                    return;
    //
    //                }else{
    //                    pi.Qty=uf.text;
    //                    [uf resignFirstResponder];
    //                }
    //            }
    //        }
    //    }
    
    
    
    NSString *tnote = [txtNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tnote isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please input Notes."];
        [alert show];
        [txtNote becomeFirstResponder];
        return;
    }
    
    //    NSString *tqty =[txtQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //    if ([tqty isEqualToString:@""]) {
    //        UIAlertView *alert = [self getErrorAlert: @"Please input Quantity."];
    //        [alert show];
    //        [txtQty becomeFirstResponder];
    //        return;
    //    }
    
    NSString *ttotal =[txtTotal.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([ttotal isEqualToString:@""]) {
        UIAlertView *alert = [self getErrorAlert: @"Please input Total."];
        [alert show];
        [txtTotal becomeFirstResponder];
        return;
    }
    
    //    if (![self isNumeric:tqty]) {
    //
    //        UIAlertView *alert = [self getErrorAlert: @"Quantity must be a number."];
    //        [alert show];
    //        [txtQty setText:@"1"];
    //        return;
    //
    //    }
    
    
    if (![self isNumeric:ttotal]) {
        
        UIAlertView *alert = [self getErrorAlert: @"Total must be a number."];
        [alert show];
        [txtTotal setText:@""];
        return;
    }
    
    UIAlertView *alert = nil;
    alert = [[UIAlertView alloc]
             initWithTitle:@"BuildersAccess"
             message:@"Are you sure you want to save?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"OK", nil];
    alert.tag = 2;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2){
        switch (buttonIndex) {
			case 0:
				break;
			default:
				[self dosubmit];
				break;
		}
    }else if(alertView.tag==1){
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
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(scaleImage:) toTarget:self withObject:image];
    
}

- (UIImage *)scaleImage:(UIImage *)image

{
    float h = image.size.height;
    float w = image.size.width;
    float y1;
    
    float scaleSize;
    scaleSize=600/h;
    h=600;
//    y1=0;
    w=w*scaleSize;
//    x=(800-w)/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    y1=y;
    y=y-120;
    
    if (imageView) {
        imageView.image=nil;
        imageView=nil;
        [imageView removeFromSuperview];
    }
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0,y,w*0.375,225)];
    imageView.layer.cornerRadius=10.0f;
    
    imageView.layer.masksToBounds = YES;
    y=y+235;
    imageView.image = image;
    [btn1 setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
    y=y+50;
    [loginButton setFrame:CGRectMake(10, y, self.view.frame.size.width-20, 44)];
    y=y+60;
    //    isChange=YES;
    myphoto=scaledImage;
    [uv addSubview:imageView];
    
    uv.contentSize=CGSizeMake(self.view.frame.size.width,y);
    y=y1;
    //    [ciatbview reloadData];
    //    [ntabbar setSelectedItem:nil];
    return image;
    
}


-(void)dosubmit{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Submiting...";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    NSString *tnote = [txtNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //    NSString *tqty =[txtQty.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *ttotal =[txtTotal.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *temail;
    if ([pickerArray count]==0) {
        temail=@"";
    }else{
        temail =dd1.titleLabel.text;
    }
    
    NSString *tdate =txtDate.titleLabel.text;
    
    wcfService *service=[wcfService service];
    if (myphoto) {
        NSData *photoData=UIImageJPEGRepresentation(myphoto, 1.0);
        Mysql *mysql =[[Mysql alloc]init];
        NSString * strphotodata = [mysql Base64Encode:photoData];
//        UIAlertView *alert=[self getErrorAlert:@"1"];
//        [alert show];
        [service xNewVPOWithPhoto:self action:@selector(xNewVPOHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:xidproject xidvendor:xidvendor xnvendor:xnvendor xidreason:xidreason xnreason:xnreason toemail:temail delivery:tdate notes:tnote total:ttotal photoBase64String:strphotodata EquipmentType:@"3"];
    }else{
        [service xNewVPO:self action:@selector(xNewVPOHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidproject:xidproject xidvendor:xidvendor xnvendor:xnvendor xidreason:xidreason xnreason:xnreason toemail:temail delivery:tdate notes:tnote quantity:@"1" total:ttotal EquipmentType:@"3"];
    }
    
    
    
}


- (void) xNewVPOHandler: (id) value {
    
    [HUD hide:YES];
    
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
    
    
	// Do something with the NSString* result
    NSString* result = (NSString*)value;
	if ([result isEqualToString:@"1"]) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[project class]] || [temp isKindOfClass:[development class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
            
        }
    }else{
        UIAlertView *alert = [self getErrorAlert: @"Submit unsuccessfully."];
        [alert show];
    }
    
}




-(BOOL) isNumeric:(NSString *)s
{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}

- (void)nextClicked{
    [txtTotal becomeFirstResponder];
}

- (void)previousClicked{
    [txtNote becomeFirstResponder];
}

- (void)doneClicked{
    [uv setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtNote resignFirstResponder];
    
    [txtTotal resignFirstResponder];
}

//- (void)doneClicked{
//    [uv setContentOffset:CGPointMake(0,0) animated:YES];
//
////    BAUITableViewCell * cell;
////    for (int i=1; i<[result1 count]+1; i++) {
////        cell =[ciatbview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
////        for (UITextField *uf in cell.subviews) {
////            if ([uf isKindOfClass:[UITextField class]]) {
////                [uf resignFirstResponder];
////            }
////        }
////    }
//}


-(IBAction)popupscreen:(id)sender{
    
    [txtNote resignFirstResponder];
    
    if (!sheet) {
        sheet = [UIAlertController alertControllerWithTitle:@"Select Date" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        
        CGFloat aWidth =self.view.frame.size.width;
        CGFloat CONTENT_HEIGHT = 400;
        //
        [sheet.view setBounds:CGRectMake(0, 0, aWidth, CONTENT_HEIGHT)];
        
        UIToolbar *toolbar = [[UIToolbar alloc]
                              initWithFrame:CGRectMake(10, 44, self.view.frame.size.width-40, 44)];
        [toolbar setItems:@[
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerSheetCancel)],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerSheetDone)]
                            ]];
        
        
        if (pdate ==nil) {
            pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 170)];
            pdate.datePickerMode=UIDatePickerModeDate;
            Mysql *msql=[[Mysql alloc]init];
            if (txtDate.titleLabel.text) {
                [pdate setDate:[msql dateFromString:txtDate.titleLabel.text]];
            }else{
                [pdate setDate:[[NSDate alloc]init]];
            }
        }
        [sheet.view addSubview:toolbar];
        [sheet.view addSubview:pdate];
    }
    
    [self.parentViewController presentViewController:sheet animated:YES completion:nil];
}

-(void)pickerSheetCancel{
    [sheet dismissViewControllerAnimated:YES completion:nil];
}

-(void)pickerSheetDone{
    [sheet dismissViewControllerAnimated:YES completion:nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
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

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet1.tag==1) {
        NSString *str = [actionSheet1 buttonTitleAtIndex:buttonIndex];
        if (![str isEqualToString:@"Cancel"]) {
            [dd1 setTitle:str forState:UIControlStateNormal];
        }
        
    }
    
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
