//
//  multiSearch.m
//  BuildersAccess
//
//  Created by roberto ramirez on 9/23/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "multiSearch.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomKeyboard.h"
#import "multiSearchRslt.h"
#import "Reachability.h"
#import "wcfService.h"
//#import "NSString+Color.h"
#import "baControl.h"
#import "developmentVendorLs.h"
//#import "mastercialist.h"
#import "userInfo.h"

@interface multiSearch() <CustomKeyboardDelegate>

@end

@implementation multiSearch{
    UITabBar* ntabbar;
    UIScrollView *sv;
    UITextField *usernameField;
    CustomKeyboard *keyboard;
    int donext;
//    UIButton *dd1;
//    UIPickerView *ddpicker;
//    NSMutableArray *pickerArray;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view = view;
    
    CGFloat screenWidth = view.frame.size.width;
    CGFloat screenHieight = view.frame.size.height;
    
    ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, screenHieight-29, screenWidth, 49)];
//    
//    if (view.frame.size.height>480) {
//        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 370+84, 320, 50)];
//    }else{
//        ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, 366, 320, 50)];
//    }
    [view addSubview:ntabbar];
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
       UITabBarItem *     fi =[[UITabBarItem alloc]init];
   
    
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]init];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:3]setEnabled:NO ];
    
//    if (self.view.frame.size.height>480) {
        sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHieight - 59)];
        sv.contentSize=CGSizeMake(screenWidth, screenHieight - 58);
//    }else{
//        sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 366)];
//        sv.contentSize=CGSizeMake(320, 367);
//    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sv];
   
   
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self goBack:item];
    }
}
-(void)doneClicked{
    [usernameField resignFirstResponder];
}

-(IBAction)textFieldDoneEditing:(UITextField *)sender{
    [self dosearch:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int y=10;
    int x =5;
    donext=0;
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    UILabel *lbl;
   
    if ([self.title isEqualToString:@"Project Multi Search"]) {
         lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 280, 42)];
         lbl.text=@"Search by project number, name or plan name";
         lbl.numberOfLines=0;
    }else{
        lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 280, 25)];
    lbl.text=@"Search by vendor name";
    }
   
   
    [sv addSubview:lbl];
    y=y+lbl.frame.size.height+x;
    
    usernameField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
    [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    [usernameField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        usernameField.returnKeyType=UIReturnKeySearch;
    
    keyboard=[[CustomKeyboard alloc]init];
    keyboard.delegate=self;
    [usernameField setInputAccessoryView:[keyboard getToolbarWithPrevNextDone:NO :NO]];
    
    [sv addSubview: usernameField];
    y=y+30+x+10;
    
    
//    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 280, 21)];
//    lbl.text=@"Filter By";
//    [sv addSubview:lbl];
//    y=y+lbl.frame.size.height+x;
//    
//    UITextField * text1;
//    text1=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
//    
//    [text1 setBorderStyle:UITextBorderStyleRoundedRect];
//    text1.enabled=NO;
//    text1.text=@"";
//    [sv addSubview: text1];
    
//    dd1=[UIButton buttonWithType: UIButtonTypeCustom];
//    [dd1 setFrame:CGRectMake(25, y+4, 270, 21)];
//    [dd1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [dd1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [dd1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 23)];
//    [dd1.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    [dd1 setTitle:@"Projects" forState:UIControlStateNormal];
//    pickerArray =[[NSMutableArray alloc]init];
//    [pickerArray addObject:@"Projects"];
//    [pickerArray addObject:@"Vendors"];
// [dd1 addTarget:self action:@selector(popupscreen2:) forControlEvents:UIControlEventTouchDown];
//    y=y+30+x+10;
//    [sv addSubview:dd1];
   
    //    [btn1.layer setBackgroundColor:[UIColor redColor].CGColor];
    UIButton *btn1 =[baControl getGrayButton];
    [btn1 setFrame:CGRectMake(20, y, 280, 44)];
    [btn1 setTitle:@"Search" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(dosearch:) forControlEvents:UIControlEventTouchDown];
    [sv addSubview:btn1];
    
    //    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [btn1 setFrame:CGRectMake(200, y, 100, 36)];
    //    [btn1 setTitle:@"Sign Up" forState:UIControlStateNormal];
    //    [btn1 addTarget:self action:@selector(SingUpOnclick:) forControlEvents:UIControlEventTouchDown];
    //    [sv addSubview:btn1];
    
    y=y+50+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(30, y, 260, 147)];
    lbl.font=[UIFont systemFontOfSize:13.0];
    if ([self.title hasPrefix:@"Project"]) {
        lbl.text=@"* Notes: You can use any combination of keywords to find your projects, but search will only return the first 100 records that match your criteria. \n\nA minimum of 4 characters are required to search.";
    }else{
        lbl.text=@"* Notes: You can use any combination of keywords to find your vendors, but search will only return the first 100 records that match your criteria. \n\nA minimum of 4 characters are required to search.";
    }
   
    lbl.numberOfLines=0;
    [lbl sizeToFit];
    [sv addSubview:lbl];
    
	// Do any additional setup after loading the view.
}




//-(IBAction)popupscreen2:(id)sender{
//    [usernameField resignFirstResponder];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self
//                                                    cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Select",@"Cancel", nil];
//    [actionSheet setTag:1];
//    
//    if (ddpicker ==nil) {
//        ddpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//        ddpicker.showsSelectionIndicator = YES;
//        ddpicker.delegate = self;
//        ddpicker.dataSource = self;
//    }
//    
//    [actionSheet addSubview:ddpicker];
//    
//    //    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    // show from our table view (pops up in the middle of the table)
//    
//    int y=0;
//    if (self.view.frame.size.height>480) {
//        y=80;
//    }
//    
//    [actionSheet setFrame:CGRectMake(0, 177+y, 320, 383)];
//    [actionSheet showInView:self.view];
//    
//}

//-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//        if (buttonIndex == 0) {
//            [dd1 setTitle:[pickerArray objectAtIndex: [ddpicker selectedRowInComponent:0]] forState:UIControlStateNormal];
//        }
//    
//    
//    
//}


//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 1;
//}
//
//-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    return [pickerArray count];
//}
//-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return [pickerArray objectAtIndex:row];
//}



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
            {
                multiSearchRslt *mr =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"multiSearchRslt"];
                mr.managedObjectContext=self.managedObjectContext;
                mr.keyWord=[usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [self.navigationController pushViewController:mr animated:YES];
            }
                break;
            case 2:
            {
                developmentVendorLs *mr =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"developmentVendorLs"];
                mr.managedObjectContext=self.managedObjectContext;
                mr.searchkey=[usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                mr.idproject=@"-1";
                mr.idmaster=[NSString stringWithFormat:@"%d", [userInfo getCiaId]];
                [self.navigationController pushViewController:mr animated:YES];
            }
                break;
            default:
                break;
        }

        
        
        
    }
}


-(IBAction)dosearch:(id)sender{
    if ([usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length<4) {
      
        
        UIAlertView *alert =[self getErrorAlert:@"A minimum of 4 characters are required to search."];
        [alert show];
        [usernameField becomeFirstResponder];
        return;
    }
    [usernameField resignFirstResponder];
//    NSLog(self.title);
    if ([self.title hasPrefix:@"Project"]) {
        donext=1;
    }else if([self.title hasPrefix:@"Vendor"]){
        donext=2;
    }else{
        donext=1;
    }
    [self doupdateCheck];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
