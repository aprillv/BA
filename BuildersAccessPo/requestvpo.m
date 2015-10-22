//
//  requestvpo.m
//  BuildersAccess
//
//  Created by amy zhao on 13-7-15.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//
#import "requestvpo.h"
#import "Reachability.h"
#import "wcfService.h"
#import "userInfo.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "forapprove.h"
#import "CustomKeyboard.h"
#import "wcfReasonListItem.h"
#import "viewImage.h"
#import "wcfRequestedPO2Item.h"
#import "MBProgressHUD.h"
#import "requestpoemail.h"
#import "project.h"
#import "development.h"

@interface requestvpo ()<UITextViewDelegate, CustomKeyboardDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate>{
    UIDocumentInteractionController *docController;
    UITextView *txtNote;
    CustomKeyboard* keyboard;
    UIButton *txtDate;
    UIDatePicker *pdate;
    UILabel *lbl10;
    UIButton *txtReason;
    NSMutableArray * pickerArray;
    UIPickerView *ddpicker;
    NSString *donext;
    NSMutableData *_data;
    UIImageView *uview;
    UITableView *ciatbview;
    MBProgressHUD* HUD;
    NSURL *turl;
    NSDateFormatter *formatter;
    
    UIAlertController *sheet;
}

@end

@implementation requestvpo

@synthesize ntabbar, uv, idnum, xcode, fromforapprove;

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
    self.title=[NSString stringWithFormat:@"Request # %@", idnum];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    UITabBarItem *firstItem0;
    if (fromforapprove==1) {
          firstItem0 = [[UITabBarItem alloc]initWithTitle:@"For Approve" image:[UIImage imageNamed:@"home.png"] tag:1];
    }else{
        firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Project" image:[UIImage imageNamed:@"home.png"] tag:1];
    }
  
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
     UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.userInteractionEnabled = YES;
    
//    NSLog(@"%@", [self getFormatFloat:567.1111f]);
//     NSLog(@"%@", [self getFormatFloat:4567.1111f]);
//     NSLog(@"%@", [self getFormatFloat:221234567.1111f]);
//     NSLog(@"%@", [self getFormatFloat:2221234567.1111f]);
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getPo];
    [ntabbar setSelectedItem:nil];
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
        [service xGetRequestedPOForApproveDetail:self action:@selector(xGetPODetailHandler:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum EquipmentType:@"3"];
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
    
    pd=(wcfRequestedPODetail *)value;
    [self drawPage];
}

-(void)drawPage{
    uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    for (UIView *u in uv.subviews) {
        [u removeFromSuperview];
    }
    
    UILabel *lbl;
    int y=10;
    int x=5;
    float rowheight=32.0;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Status";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UIView *lbl1;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 288, rowheight-6)];
    lbl.text=pd.Status;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Vendor";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 288, rowheight-6)];
    lbl.text=pd.Vendor;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
        
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Project";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 288, rowheight-6)];
    lbl.text=pd.Proejct;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtDate=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtDate setFrame:CGRectMake(18, y+4, 270, 21)];
    [txtDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtDate addTarget:self action:@selector(popupscreen:) forControlEvents:UIControlEventTouchDown];
    [txtDate setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtDate setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtDate.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    if ([pd.DeliveryDate isEqualToString:@"01/01/1980"]) {
        [txtDate setTitle:@"" forState:UIControlStateNormal];
    }else{
        [txtDate setTitle:pd.DeliveryDate forState:UIControlStateNormal];
    }
    
    [uv addSubview: txtDate];
    y=y+30+10;

    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Category";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=pd.CostCode;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    

    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Notes";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    UITextField *txtProject= txtProject=[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 105)];
    [txtProject setBorderStyle:UITextBorderStyleRoundedRect];
    txtProject.enabled=NO;
    [uv addSubview:txtProject];
    
    txtNote = [[UITextView alloc]initWithFrame:CGRectMake(12, y+3, 296, 98) ];
    txtNote.layer.cornerRadius=10;
    txtNote.delegate=self;
    txtNote.tag=19;
    txtNote.font=[UIFont systemFontOfSize:17.0];
    keyboard =[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [txtNote setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO : YES]];
//    txtNote.text=pd.Notes;

    if (pd.Notes ==nil) {
        txtNote.text=@"";
    }else{
        txtNote.text=pd.Notes;
        
    }
    
    
    
    [uv addSubview:txtNote];
    
    y=y+120;
    
    
   
    if ([pd.Fs isEqualToString:@"1"]) {
        
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
        lbl.text=@"Attached File";
        lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
        lbl.font=[UIFont systemFontOfSize:17.0];
        lbl.backgroundColor=[UIColor clearColor];
        [uv addSubview:lbl];
        y=y+30;
        
        if ([pd.extension isEqualToString:@"jpg"]||[pd.extension isEqualToString:@"jpeg"]||[pd.extension isEqualToString:@"png"]||[pd.extension isEqualToString:@"bmp"]||[pd.extension isEqualToString:@"gif"]) {
            uview=[[UIImageView alloc]init];
            uview.frame = CGRectMake(10, y, 300, 225);
            y=y+245;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownloadvpo.aspx?email=%@&password=%@&idcia=%@&id=%@&fname=%@", [userInfo getUserName], [userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue], idnum,[NSString stringWithFormat:@"tmp.%@", pd.extension]]];
            
            _data =[[NSMutableData alloc]init];
            NSURLRequest* updateRequest = [NSURLRequest requestWithURL:url];
            
            NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
            
            self.view.userInteractionEnabled=NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            [connection start];
            [uv addSubview:uview];
        }else{
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn1 setFrame:CGRectMake(10, y, 300, 36)];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn1 setTitle:[NSString stringWithFormat:@"View Attached file .%@", pd.extension] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(openFile:) forControlEvents:UIControlEventTouchDown];
            [uv addSubview:btn1];
            y=y+50;
            
        }

    }
    

    
//    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
//    lbl.text=@"Total";
//    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
//    lbl.font=[UIFont systemFontOfSize:17.0];
//    lbl.backgroundColor=[UIColor clearColor];
//    [uv addSubview:lbl];
//    y=y+30;
//    
//    txtTotal= [[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
//    txtTotal.font=[UIFont systemFontOfSize:14.0];
//    txtTotal.text=pd.Total;
//    txtTotal.delegate=self;
//    txtTotal.enabled=NO;
//    [txtTotal setBorderStyle:UITextBorderStyleRoundedRect];
//    [uv addSubview:txtTotal];
//     y=y+rowheight+x;
    
//        if (ciatbview ==nil) {
//            NSLog(@"%@", pd.PO2Ls);
//            if (self.view.frame.size.height>480) {
//                ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, 70*[pd.PO2Ls count]+70)];
//                
//            }else{
//                ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, 70*[pd.PO2Ls count]+70)];
//               
//            }
//            uv.backgroundColor=[Mysql groupTableViewBackgroundColor];
//            ciatbview.layer.cornerRadius = 10;
//            ciatbview.tag = 2;
//            ciatbview.rowHeight=70;
//            [uv addSubview: ciatbview];
//            ciatbview.delegate = self;
//            ciatbview.dataSource = self;
//        }else{
//            
//            [ciatbview reloadData];
//            [uv addSubview: ciatbview];
//        }
//        y=y+70*[pd.PO2Ls count]+90;
    UITextField *textField;
    int i =0;
    int xtag=20;
    for (wcfRequestedPO2Item *pi in pd.PO2Ls) {
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight*3)];
        lbl1.layer.cornerRadius=10.0;
        lbl1.backgroundColor = [UIColor whiteColor];
        [uv addSubview:lbl1];
        
        y = y+3;
        lbl= [[UILabel alloc] initWithFrame: CGRectMake( 15, y, 250, 21)];
        lbl.text= [NSString stringWithFormat:@"%@ ~ %@", pi.Part, pi.Des];;
        [uv addSubview: lbl];
        
        y=y+30;
        
        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 15, y, 45, 21)];
        lbl.text=@"Unit: ";
        [uv addSubview: lbl];
        
        lbl= [[UILabel alloc] initWithFrame: CGRectMake( 50, y, 250, 21)];
        lbl.text=pi.Unit;
        [uv addSubview: lbl];
        
        //        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 125, 30, 75, 21)];
        //        lbl.text=@"Amount: ";
        //        [self.contentView addSubview: lbl];
        
        //        lblamount= [[UILabel alloc] initWithFrame: CGRectMake( 200, 30, 95, 21)];
        //        [self.contentView addSubview: lblamount];
        
        y=y+30;
        
        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 15, y, 45, 21)];
        lbl.text=@"Qty: ";
        [uv addSubview: lbl];
        
        textField=[[UITextField alloc]initWithFrame:CGRectMake(50, y-4, 90, 30)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        //        [textField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
        textField.tag=xtag+i*2;
        textField.text=pi.Quantity;
        textField.delegate=self;
        textField.keyboardType =UIKeyboardTypeDecimalPad;
        //        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [uv addSubview: textField];
        pi.FixPrice=YES;
        if ([pd.PO2Ls count]==1) {
            if (!pi.FixPrice) {
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
            }else{
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
            }
        }else{
            if (i==0) {
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
            }else if(i == [pd.PO2Ls  count]-1){
                if (!pi.FixPrice) {
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
                }else{
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                }
            }else{
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                
            }
        }
        
        
        lbl = [[UILabel alloc] initWithFrame: CGRectMake( 145, y, 55, 21)];
        lbl.text=@"Price: ";
        [uv addSubview: lbl];
        
        textField=[[UITextField alloc]initWithFrame:CGRectMake(200, y-4, 90, 30)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.text=pi.Price;
        
        textField.tag=xtag+i*2+1;
//        NSLog(@"%@", pi.FixPrice);
        if (!pi.FixPrice) {
            [textField setEnabled:NO];
        }else{
            textField.delegate=self;
            textField.keyboardType =UIKeyboardTypeDecimalPad;
            if ([pd.PO2Ls count]==1) {
                
                [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
                
            }else{
                if (i==0) {
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                }else if(i == [pd.PO2Ls  count]-1){
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :NO]];
                }else{
                    [textField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:YES :YES]];
                    
                }
            }
            
            
        }
        //        [textField2 addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [uv addSubview: textField];
        
        y= y+40;
        i=i+1;
        
    }
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    y = y+3;
    lbl10= [[UILabel alloc] initWithFrame: CGRectMake( 15, y, 250, 21)];
    lbl10.text= [NSString stringWithFormat:@"Total: %@", pd.Total];
    [uv addSubview: lbl10];
    
    y=y+30;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Reason";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:17.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+30;
    
    text1 =[[UITextField alloc]initWithFrame:CGRectMake(10, y, 300, 30)];
    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
    text1.enabled=NO;
    text1.text=@"";
    [uv addSubview: text1];
    
    txtReason=[UIButton buttonWithType: UIButtonTypeCustom];
    [txtReason setFrame:CGRectMake(18, y+4, 270, 21)];
    [txtReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [txtReason addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
    [txtReason setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [txtReason setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
    [txtReason.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [uv addSubview: txtReason];
    y=y+30+10;
    
    [self getReason];
    
    
    if ([pd.BtnApprove isEqualToString:@"1"]) {
        UIButton * btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdate setFrame:CGRectMake(10, y, 300, 44)];
        [btnUpdate setTitle:@"Acknowledge" forState:UIControlStateNormal];
        [btnUpdate.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnUpdate setBackgroundImage:[UIImage imageNamed:@"greenButton.png"] forState:UIControlStateNormal];
        [btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnUpdate addTarget:self action:@selector(doUpdate1) forControlEvents:UIControlEventTouchUpInside];
//        btnUpdate.enabled=NO;
        [uv addSubview:btnUpdate];
        y= y+50;
    }
    
    
    
    if ([pd.BtnDisapprove isEqualToString:@"1"]) {
        UIButton * btnUpdate1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdate1 setFrame:CGRectMake(10, y, 300, 44)];
        [btnUpdate1 setTitle:@"Disapprove" forState:UIControlStateNormal];
        [btnUpdate1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnUpdate1 setBackgroundImage:[UIImage imageNamed:@"yButton.png"] forState:UIControlStateNormal];
        [btnUpdate1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnUpdate1 addTarget:self action:@selector(doUpdate2) forControlEvents:UIControlEventTouchUpInside];
      
              [uv addSubview:btnUpdate1];
              y= y+50;
        
        }

    if ([pd.BtnHold isEqualToString:@"1"]) {
        UIButton * btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnUpdate setFrame:CGRectMake(10, y, 300, 44)];
        [btnUpdate setTitle:@"Hold" forState:UIControlStateNormal];
        [btnUpdate.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [btnUpdate setBackgroundImage:[UIImage imageNamed:@"grayButton.png"] forState:UIControlStateNormal];
        [btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnUpdate addTarget:self action:@selector(doUpdate4) forControlEvents:UIControlEventTouchUpInside];
        //        btnUpdate.enabled=NO;
        [uv addSubview:btnUpdate];
        y= y+50;
    }

    
              if ([pd.BtnVoid isEqualToString:@"1"]) {
                  UIButton * btnUpdate2 = [UIButton buttonWithType:UIButtonTypeCustom];
                  [btnUpdate2 setFrame:CGRectMake(10, y, 300, 44)];
                  [btnUpdate2 setTitle:@"Void" forState:UIControlStateNormal];
                  [btnUpdate2.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
                  [btnUpdate2 setBackgroundImage:[UIImage imageNamed:@"redButton.png"] forState:UIControlStateNormal];
                   [btnUpdate2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                   [btnUpdate2 addTarget:self action:@selector(doUpdate3) forControlEvents:UIControlEventTouchUpInside];
                   [uv addSubview:btnUpdate2];
                   y= y+50;
                   
                   }

    uv.contentSize=CGSizeMake(320.0,y+1);
    ntabbar.delegate =self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goback1:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:3]setAction:@selector(doRefresh:) ];
    [ntabbar setSelectedItem:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goback1:item];
    }else if(item.tag == 2){
        [self doRefresh:item];
    }
}


-(IBAction)openFile:(id)sender{
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownloadvpo.aspx?email=%@&password=%@&idcia=%@&id=%@&fname=%@", [userInfo getUserName], [userInfo getUserPwd], [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue], idnum,[NSString stringWithFormat:@"tmp.%@", pd.extension]]];
    turl=url;
    _data =[[NSMutableData alloc]init];
    NSURLRequest* updateRequest = [NSURLRequest requestWithURL:url];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:updateRequest  delegate:self];
    
    self.view.userInteractionEnabled=NO;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Downloading...";
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    
    [connection start];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [pd.PO2Ls count]+1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if (indexPath.row==[pd.PO2Ls count]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Total: %@", pd.Total];
       
        cell.detailTextLabel.text=@"  ";

    }else{
        wcfRequestedPO2Item *kv1 =[pd.PO2Ls objectAtIndex:(indexPath.row)];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ ~ %@", kv1.Part, kv1.Des];
        [cell.detailTextLabel setNumberOfLines:0];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"Quantity: %@\nPrice: %@", kv1.Quantity, kv1.Price];
        

    }
        
    
    [cell .imageView setImage:nil];
    return cell;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if ([pd.extension isEqualToString:@"jpg"]||[pd.extension isEqualToString:@"jpeg"]||[pd.extension isEqualToString:@"png"]||[pd.extension isEqualToString:@"bmp"]||[pd.extension isEqualToString:@"gif"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.view.userInteractionEnabled=YES;
        UIImage *img=[UIImage imageWithData:_data];
        if (img!=nil) {
//                    float f = 300/img.size.width;
            
            float f = uview.frame.size.height/img.size.height;
            
            CGRect r = uview.frame;
            r.size.width=img.size.width*f;
            if (r.size.width>300) {
                r.size.width=300;
            }
//            r.origin.y=(r.origin.y+(225-r.size.height)/2);
            uview.frame=r;
            
            uview.image=img;
            uview.userInteractionEnabled = YES;
            uview.layer.cornerRadius=10;
            uview.layer.masksToBounds = YES;
            UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
            tapped.numberOfTapsRequired = 1;
            [uview addGestureRecognizer:tapped];
            
        }
    }else{
        NSString *fname =[NSString stringWithFormat:@"a.%@", pd.extension];
        [_data writeToFile:[self GetTempPath:fname] atomically:NO];
        
        BOOL exist = [self isExistsFile:[self GetTempPath:fname]];
         self.view.userInteractionEnabled=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        if (exist) {
            [HUD hide:YES];
            [HUD removeFromSuperViewOnHide];
            NSString *filePath = [self GetTempPath:fname];
            NSURL *URL = [NSURL fileURLWithPath:filePath];
            [self openDocumentInteractionController:URL];
        }
    }
}

-(BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
}

-(NSString *)GetTempPath:(NSString*)filename{
    NSString *tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingPathComponent:filename];
}
- (void)openDocumentInteractionController:(NSURL *)fileURL{
    docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    docController.delegate = self;
    BOOL isValid = [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    if(!isValid){
        
        // There is no app to handle this file
        NSString *deviceType = [UIDevice currentDevice].localizedModel;
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?",
                                                                         @"Your %@ doesn't seem to have any other Apps installed that can open this document. Would you like to use safari to open it?"), deviceType];
        
        // Display alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No suitable Apps installed", @"No suitable App installed")
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue", nil];
        alert.delegate=self;
        alert.tag=10;
        [alert show];
    }
}

-(IBAction)myFunction :(id) sender
{
    viewImage * vi =[viewImage alloc];
    vi.managedObjectContext=self.managedObjectContext;
    vi.img=uview.image;
    [self.navigationController presentViewController:vi animated:YES completion:nil];
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

-(void)doUpdate1{


    if ([txtReason.currentTitle isEqualToString:[pickerArray objectAtIndex:0]]) {
                UIAlertView *alert = [self getErrorAlert: @"Please select a Reason."];
                [alert show];
        
                return;
    }
donext=@"1";
    [self autoUpd];
}

-(void)doUpdate2{
    donext=@"2";
    [self autoUpd];
}

-(void)doUpdate3{
    donext=@"3";
    [self autoUpd];
}

-(void)doUpdate4{
    donext=@"4";
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
        
        NSString *ns=@"";
        float tt=0.0;
        for (wcfRequestedPO2Item *pi in pd.PO2Ls) {
            
            float amt;
            amt=[pi.Quantity floatValue]*[pi.Price floatValue];
            
            
            if ([ns isEqualToString:@""]) {
                ns=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",  pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue], pi.UPC, pi.Des];
            }else{
                ns=[NSString stringWithFormat:@"%@;%@,%@,%@,%@,%@,%@", ns, pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue], pi.UPC, pi.Des];
            }
            
            if (pi.hastax) {
                tt+=amt*(1+[pd.Taxrate floatValue]/100);
            }else{
                tt+=amt;
            }
            
            
            
        }
      
      if([donext isEqualToString:@"1"]){
          
//          [service xAprroveRequestedPO:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum reason:txtReason.currentTitle xtotal:[NSString stringWithFormat:@"%.4f", tt] xdate:txtDate.currentTitle xnotes:txtNote.text xstr:ns EquipmentType:@"3"];
          
          requestpoemail *re = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"requestpoemail"];
          re.managedObjectContext=self.managedObjectContext;
          re.xxnotes=txtNote.text;
          re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
          re.xxstr=ns;
          re.xxdate=txtDate.currentTitle;
          re.xxreason=txtReason.currentTitle;
          re.idnum=self.idnum;
          re.xtype=0;
          re.fromforapprove=self.fromforapprove;
          re.aemail=pd.RequestedBy;
          [self.navigationController pushViewController:re animated:YES];
          
            // save & fail
//            UIAlertView *alert = nil;
//          NSString *str;
//          
//          str =@"Are you sure you want to approve this payment?";
//          alert = [[UIAlertView alloc]
//                   initWithTitle:@"BuildersAccess"
//                   message:str
//                   delegate:self
//                   cancelButtonTitle:@"Cancel"
//                   otherButtonTitles:@"OK", nil];
//          alert.tag = 1;
//          [alert show];
          
          
        }else if([donext isEqualToString:@"2"]){
            requestpoemail *re = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"requestpoemail"];
            re.managedObjectContext=self.managedObjectContext;
            re.idnum=self.idnum;
            re.xtype=1;
           re.xxnotes=txtNote.text;
            re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
            re.xxstr=ns;
            re.xxdate=txtDate.currentTitle;
            re.xxreason=txtReason.currentTitle;
             re.fromforapprove=self.fromforapprove;
            re.aemail=pd.RequestedBy;
            [self.navigationController pushViewController:re animated:YES];
            // save & finish
//            UIAlertView *alert = nil;
//            alert = [[UIAlertView alloc]
//                     initWithTitle:@"BuildersAccess"
//                     message:@"Are you sure you want to disapprove?"
//                     delegate:self
//                     cancelButtonTitle:@"Cancel"
//                     otherButtonTitles:@"OK", nil];
//            alert.tag = 2;
//            [alert show];
        }else if([donext isEqualToString:@"3"]){
            requestpoemail *re = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"requestpoemail"];
            re.managedObjectContext=self.managedObjectContext;
            re.idnum=self.idnum;
            re.xtype=2;
          re.xxnotes=txtNote.text;
            re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
            re.xxstr=ns;
            re.xxdate=txtDate.currentTitle;
            re.xxreason=txtReason.currentTitle;
            re.aemail=pd.RequestedBy;
            re.fromforapprove=self.fromforapprove;
            [self.navigationController pushViewController:re animated:YES];
            // save & finish
//            UIAlertView *alert = nil;
//            alert = [[UIAlertView alloc]
//                     initWithTitle:@"BuildersAccess"
//                     message:@"Are you sure you want to void?"
//                     delegate:self
//                     cancelButtonTitle:@"Cancel"
//                     otherButtonTitles:@"OK", nil];
//            alert.tag = 3;
//            [alert show];
        }else if([donext isEqualToString:@"4"]){
            requestpoemail *re = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"requestpoemail"];
            re.managedObjectContext=self.managedObjectContext;
            re.idnum=self.idnum;
            re.xtype=3;
            re.xxnotes=txtNote.text;
            re.xxtotle=[NSString stringWithFormat:@"%.4f", tt];
            re.xxstr=ns;
            re.xxdate=txtDate.currentTitle;
            re.xxreason=txtReason.currentTitle;
            re.aemail=pd.RequestedBy;
            re.fromforapprove=self.fromforapprove;
            [self.navigationController pushViewController:re animated:YES];
        }
        
    }
    
    
}

-(void)getReason{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"We are temporarily unable to connect to BuildersAccess, please check your internet connection and try again. Thanks for your patience."];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [service xgetRequestedPoReason:self action:@selector(xGetPODetailHandler1:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] EquipmentType:@"3"];
    }
    
}
- (void) xGetPODetailHandler1: (id) value {
    
	
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

    pickerArray=  [[NSMutableArray alloc]init];
    for (wcfReasonListItem *wi in value) {
        [pickerArray addObject:[NSString stringWithFormat:@"%@ - %@", wi.IDNumber, wi.Name ]];
    }
    if ([pickerArray count]>0) {
         [txtReason setTitle:[pickerArray objectAtIndex:0] forState:UIControlStateNormal];
    }
   
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-140) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textView.frame.origin.y-54) animated:YES];    }
	return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    
    if ([pd.Fs isEqualToString:@"1"]) {
        if (self.view.frame.size.height>500) {
            [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-210) animated:YES];
        }else{
            [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-4) animated:YES];    }

    }else{
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-90) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,textField.frame.origin.y-124) animated:YES];    }
    }
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)theTextField{
    int xtag = (theTextField.tag-20);
    if (xtag %2==1) {
        if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
            float a = [theTextField.text floatValue];
            if (a==0.0f) {
                UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
                [alert show];
                [theTextField becomeFirstResponder];
            }else{
                
                wcfRequestedPO2Item *pi =[pd.PO2Ls objectAtIndex:(xtag-1)/2];
                
                if ([pi.Price floatValue]<a) {
                    theTextField.text=pi.Price;
                }else{
                    
                  
                    pd.Total= [pd.Total stringByReplacingOccurrencesOfString:@"," withString:@""];
                    float tot = [pd.Total floatValue];
                    if (pi.hastax) {
                        tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                        pi.Price=theTextField.text;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                    }else{
                        tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue];
                         pi.Price=theTextField.text;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue];
                    }
                    pd.Total= [self getFormatFloat:tot];
                    lbl10.text= [NSString stringWithFormat:@"Total: %@",pd.Total ];
                    
                }
                
               
            }
        }
        
        
    }else{
        if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
            float a = [theTextField.text floatValue];
            if (a==0.0f) {
                UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
                [alert show];
                [theTextField becomeFirstResponder];
            }else{
                
                wcfRequestedPO2Item *pi =[pd.PO2Ls objectAtIndex:(xtag)/2];
                
                if ([pi.Quantity floatValue]<a) {
                    theTextField.text=pi.Quantity;
                }else{
                    
                   pd.Total= [pd.Total stringByReplacingOccurrencesOfString:@"," withString:@""];
                    float tot = [pd.Total floatValue];
                    if (pi.hastax) {
                          tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                        pi.Quantity=theTextField.text;;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue]*([pd.Taxrate floatValue]/100+1);
                    }else{
                        tot = tot-[pi.Quantity floatValue]*[pi.Price floatValue];
                        pi.Quantity=theTextField.text;;
                        tot =tot+[pi.Quantity floatValue]*[pi.Price floatValue];
                    }
                    pd.Total= [self getFormatFloat:tot];
                    lbl10.text= [NSString stringWithFormat:@"Total: %@",pd.Total ];
                }
            }
        }
    }
    
}

-(NSString *) getFormatFloat: (float) fnum{
    NSString *str = [NSString stringWithFormat:@"%.4f", fnum];
  
    int count = [str length];
    if (count>8) {
        for(int i =9; i<=count; i=i+3)
        {
            //        NSLog(@"%d %@ - %@",i, [str substringToIndex:(count-i+1)], [str substringFromIndex:(count-i+1)]);
            str=[NSString stringWithFormat:@"%@,%@",[str substringToIndex:(count-i+1)],  [str substringFromIndex:(count-i+1)] ];
        }
    }
    
    
    return str;
}
- (void)nextClicked{
    if([txtNote isFirstResponder]){
        UITextField *f=(UITextField *)[uv viewWithTag:20];
        [f becomeFirstResponder];
    }else{
    UITextField *f = [self getFirstResponser];
    UITextField *theTextField=f;
    if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
        float a = [theTextField.text floatValue];
        if (a==0.0f) {
            UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
            [alert show];
            [f becomeFirstResponder];
            if (f.frame.origin.y-100>0) {
                
                [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
            }
            
            return;
        }else{
           
                int tindex;
                wcfRequestedPO2Item *pi ;
                if (f.tag % 2==1) {
                    tindex=(f.tag-21)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Price floatValue]<a) {
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
//                        
//                        return;
                        f.text=pi.Price;
                    }
                }else{
                    tindex=(f.tag-20)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Quantity floatValue]<a) {
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
//                        
//                        return;
                        f.text=pi.Quantity;
                    }
                    
                }
        
        }
    }
    
    f=(UITextField *)[uv viewWithTag:(f.tag+1)];
    
    if (f.enabled) {
        [f becomeFirstResponder];
    }else{
        f=(UITextField *)[uv viewWithTag:(f.tag+1)];
        
        [f becomeFirstResponder];
    }
    }
}


-(UITextField *)getFirstResponser{
    UITextField *firstResponder1;
    
    UITextField *firstResponder;
    for (  int i =0;i <[pd.PO2Ls count]*2; i++)
    {
        firstResponder=(UITextField *)[uv viewWithTag:(20+i)];
        if ([firstResponder isFirstResponder])
        {
            firstResponder1=firstResponder;
            break;
        }
        
        
        
    }
    
    return  firstResponder1;
}

- (void)previousClicked{
    
        UITextField *f = [self getFirstResponser];
        
        UITextField *theTextField=f;
        if (theTextField.text && ![theTextField.text isEqualToString:@""]) {
            
            float a = [theTextField.text floatValue];
            if (a==0.0f) {
                UIAlertView *alert=[self getErrorAlert:@"Please input a valid number."];
                [alert show];
                [f becomeFirstResponder];
                if (f.frame.origin.y-100>0) {
                    
                    [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
                }
                
                return;
            }else {
                int tindex;
                wcfRequestedPO2Item *pi ;
                if (f.tag % 2==1) {
                    tindex=(f.tag-21)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Price floatValue]<a) {
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
//                        
//                        return;
                        f.text=pi.Price;
                    }
                }else{
                    tindex=(f.tag-20)/2;
                    pi=[pd.PO2Ls objectAtIndex:tindex];
                    if ([pi.Quantity floatValue]<a) {
//                        UIAlertView *alert=[self getErrorAlert:@"The number you input is more than before."];
//                        [alert show];
//                        [f becomeFirstResponder];
//                        if (f.frame.origin.y-100>0) {
//                            
//                            [uv setContentOffset:CGPointMake(0, f.frame.origin.y-120) animated:YES];
//                        }
//                        
//                        return;
                        f.text=pi.Quantity;
                    }

                }
               
            
                
            }
        }
        f=(UITextField *)[uv viewWithTag:(f.tag-1)];
        if (f.enabled) {
            [f becomeFirstResponder];
        }else{
            f=(UITextField *)[uv viewWithTag:(f.tag-1)];
            [f becomeFirstResponder];
        }
    
    
    
   
}

- (void)doneClicked{
//    [uv setContentOffset:CGPointMake(0,0) animated:YES];
  
    [txtNote resignFirstResponder];
     UITextField *f = [self getFirstResponser];
    [f resignFirstResponder];
    
}

-(IBAction)popupscreen:(id)sender{
    
    [txtNote resignFirstResponder];
    
    if (self.view.frame.size.height>500) {
        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-180) animated:YES];
    }else{
        [uv setContentOffset:CGPointMake(0,txtDate.frame.origin.y-90) animated:YES];
    }
    
    
    
    
    if (!sheet) {
        sheet = [UIAlertController alertControllerWithTitle:@"Select Date" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        
        CGFloat aWidth =320;
        CGFloat CONTENT_HEIGHT = 400;
        //
        [sheet.view setBounds:CGRectMake(0, 0, aWidth, CONTENT_HEIGHT)];
        
        UIToolbar *toolbar = [[UIToolbar alloc]
                              initWithFrame:CGRectMake(10, 44, 280, 44)];
        [toolbar setItems:@[
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerSheetCancel)],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerSheetDone)]
                            ]];
        
        
        if (pdate ==nil) {
            pdate=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 88, 320, 170)];
            pdate.datePickerMode=UIDatePickerModeDate;
            Mysql *msql=[[Mysql alloc]init];
            if (![txtDate.currentTitle isEqualToString:@""]) {
                [pdate setDate:[msql dateFromString:txtDate.currentTitle]];
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
    
    if (!formatter) {
            formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd/YYYY"];
        }
        [txtDate setTitle:[formatter stringFromDate:[pdate date]] forState:UIControlStateNormal];
    
    [uv setContentOffset:CGPointMake(0,0) animated:YES];
}

-(IBAction)doRefresh:(id)sender{
    [self getPo];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet1.tag==2) {
        
        
    }  else{
        NSString *str = [actionSheet1 buttonTitleAtIndex:buttonIndex];
        if (![str isEqualToString:@"Cancel"]) {
            [txtReason setTitle:str forState:UIControlStateNormal];
        }
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

-(IBAction)goback1:(id)sender{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[forapprove class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        
        }else  if ([temp isKindOfClass:[project class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }else  if ([temp isKindOfClass:[development class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	 if(alertView.tag==1){
        if (buttonIndex==1) {
//            wcfService* service = [wcfService service];
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.labelText=@"Updating...";
            HUD.dimBackground = YES;
            HUD.delegate = self;
            [HUD show:YES];
//            NSLog(@"%@ %@ %@ %@", idnum, txtReason.currentTitle,pd.Total , txtDate.currentTitle);
            
            
//            NSLog(@"%@", pd.PO2Ls);
            UITextField *f1=[self getFirstResponser];
            [f1 resignFirstResponder];
            NSString *ns=@"";
            float tt=0.0;
            for (wcfRequestedPO2Item *pi in pd.PO2Ls) {
                
                float amt;
                amt=[pi.Quantity floatValue]*[pi.Price floatValue];
                
                
                if ([ns isEqualToString:@""]) {
                    ns=[NSString stringWithFormat:@"%@,%@,%@,%@",  pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue]];
                }else{
                    ns=[NSString stringWithFormat:@"%@;%@,%@,%@,%@", ns, pi.Part, pi.Quantity, pi.Price, [[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.4f",                                                amt] doubleValue]]stringValue]];
                }
                
                if (pi.hastax) {
                     tt+=amt*(1+[pd.Taxrate floatValue]/100);
                }else{
                    tt+=amt; 
                }
                
               
                
            }
            
////            NSLog(@"%@ \n %@", ns, pd.PO2Ls);
//            [service xAprroveRequestedPO:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum reason:txtReason.currentTitle xtotal:[NSString stringWithFormat:@"%.4f", tt] xdate:txtDate.currentTitle xnotes:txtNote.text xstr:ns EquipmentType:@"3"];
////            NSLog(@"%@ %@", ns , [NSString stringWithFormat:@"%.4f", tt]);
            
        }
    }else if(alertView.tag==2){
        if (buttonIndex==1) {
//            wcfService* service = [wcfService service];
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"Updating...";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
//            
//                [service xDisAprroveRequestedPO:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum EquipmentType:@"3"];
            
            
        }
    }else if(alertView.tag==3){
        if (buttonIndex==1) {
//            wcfService* service = [wcfService service];
//            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            [self.navigationController.view addSubview:HUD];
//            HUD.labelText=@"Updating...";
//            HUD.dimBackground = YES;
//            HUD.delegate = self;
//            [HUD show:YES];
//             [service xVoidRequestedPO:self action:@selector(xisupdate_iphoneHandler2:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnum:idnum EquipmentType:@"3"];
//            }
        }
    }else if (alertView.tag==10) {
        self.view.userInteractionEnabled=YES;
        
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:turl];
        }
       
    }
    
}

- (void) xisupdate_iphoneHandler2: (id) value {
   
    [HUD hide:YES];
    [HUD removeFromSuperViewOnHide];
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
        [self goback1:nil];
    }else if ([rtn isEqualToString:@"2"]) {
        UIAlertView *alert=[self getErrorAlert:@"Send email fail."];
        [alert show];
        [self goback1:nil];
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
