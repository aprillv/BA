//
//  kirbytitledetail.m
//  BuildersAccess
//
//  Created by amy zhao on 13-6-3.
//  Copyright (c) 2013年 eloveit. All rights reserved.
//

#import "kirbytitledetail.h"
#import "Mysql.h"
#import <QuartzCore/QuartzCore.h>
#import "wcfService.h"
#import "userInfo.h"
#import "Reachability.h"

@interface kirbytitledetail ()<UITabBarDelegate>

@end

@implementation kirbytitledetail
@synthesize idnumber;

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
    //
    
    CGFloat screenWidth = view.frame.size.width;
    CGFloat screenHieight = view.frame.size.height;
    
    ntabbar=[[UITabBar alloc]initWithFrame:CGRectMake(0, screenHieight-30, screenWidth, 50)];
    
    [view addSubview:ntabbar];
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:1];
    
    UITabBarItem *fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    //
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
//    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
//    [[ntabbar.items objectAtIndex:3] setAction:@selector(dorefresh:)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
}

-(IBAction)dorefresh:(id)sender{
    [self getInfo];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1) {
        [self gohome:item];
    }else if(item.tag == 2){
        [self dorefresh: item];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
        
    [self getInfo];
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
        [service xGetCalendarEntry:self action:@selector(xGetCalendarEntryHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xidnumber: idnumber EquipmentType: @"3"];
        
    }

}
-(void)drawScreen{
    
    int x=0;
    int y=10;
    if (self.view.frame.size.height>480) {
        y=y+5;
        x=10;
    }else{
        x=8;
    }
    
    self.title=@"Calendar Event";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    if (uv) {
        [uv removeFromSuperview];
    }
     uv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-113)];
    
    
    
    [self.view addSubview:uv];
    
    
    UILabel *lbl;
    float rowheight=32.0;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Subject";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    UIView *lbl1;
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=result.Subject;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
        
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Location";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=result.Location;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Date";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=result.TDate;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
        
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Start Time";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=result.StartTime;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"End Time";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=result.EndTime;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Contact Name";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 300, rowheight-6)];
    lbl.text=result.ContactName;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Phone";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
//    txtPhone=[[UITextField alloc]initWithFrame:CGRectMake(20, y, 280, 30)];
//    [txtPhone setBorderStyle:UITextBorderStyleRoundedRect];
//    txtPhone.delegate=self;
//    txtPhone.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [uv addSubview: txtPhone];
//    
    
  
   
    if (result.Phone) {
        phone=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, rowheight)];
        phone.layer.cornerRadius = 10;
        phone.tag=5;
        [phone setRowHeight:rowheight];
        phone.delegate = self;
        phone.dataSource = self;
        [uv addSubview:phone];
    }else{
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
        lbl1.layer.cornerRadius=10.0;
        lbl1.backgroundColor = [UIColor whiteColor];
        [uv addSubview:lbl1];
    }
     y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Mobile";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    if (result.Mobile) {
        Mobile=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, rowheight)];
        Mobile.layer.cornerRadius = 10;
        Mobile.tag=6;
        [Mobile setRowHeight:rowheight];
        Mobile.delegate = self;
        Mobile.dataSource = self;
        [uv addSubview:Mobile];
       
    }else{
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
        lbl1.layer.cornerRadius=10.0;
        lbl1.backgroundColor = [UIColor whiteColor];
        [uv addSubview:lbl1];
       
    }
    
    y=y+rowheight+x;
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, 300, 21)];
    lbl.text=@"Email";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
   
    if(result.Email){
        Email=[[UITableView alloc] initWithFrame:CGRectMake(10, y, 300, rowheight)];
        Email.layer.cornerRadius = 10;
        Email.tag=7;
        [Email setRowHeight:rowheight];
        Email.delegate = self;
        Email.dataSource = self;
        [uv addSubview:Email];
        
    }else{
        lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight)];
        lbl1.layer.cornerRadius=10.0;
        lbl1.backgroundColor = [UIColor whiteColor];
        [uv addSubview:lbl1];
        
    }
    
    y=y+rowheight+x;
       
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(20, y, 300, 21)];
    lbl.text=@"Notes";
    lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    lbl.backgroundColor=[UIColor clearColor];
    [uv addSubview:lbl];
    y=y+21+x;
    
    lbl1 =[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, rowheight*3)];
    lbl1.layer.cornerRadius=10.0;
    lbl1.backgroundColor = [UIColor whiteColor];
    [uv addSubview:lbl1];
    
    lbl =[[UILabel alloc]initWithFrame:CGRectMake(18, y+4, 284, rowheight*2+20)];
    lbl.text=result.Notes;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.numberOfLines=0;
    [lbl sizeToFit];
    [uv addSubview:lbl];
    y=y+rowheight+x;
    

    uv.contentSize=CGSizeMake(320.0,y+80);
    
        
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
    
    result = (wcfCalendarEntryItem*)value;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;    }
    
    if(tableView.tag==5){
        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =result.Phone;
        [cell .imageView setImage:nil];
        
    }else if(tableView.tag==6){
        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =result.Mobile;
        [cell .imageView setImage:nil];
    }else if(tableView.tag==7){

        cell.textLabel.font=[UIFont systemFontOfSize:17.0];
        cell.textLabel.text =result.Email;
        [cell .imageView setImage:nil];
        
    }
    
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag==5) {
        [self calloffice];
    }else if(tableView.tag==6){
        [self calmobile];
    }else{
        [self sendEmail];
    }
}

-(void)calloffice{
    if (phone !=nil) {
        NSMutableString *phone1 = [result.Phone mutableCopy];
        [phone1 replaceOccurrencesOfString:@" "
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@"("
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@")"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone1]];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIAlertView *a=[self getErrorAlert:@"There is no Office Phone Number to call"];
        [a show];
    }

}

-(void)calmobile{
    if (Mobile !=nil) {
        NSMutableString *phone1 = [result.Mobile mutableCopy];
        [phone1 replaceOccurrencesOfString:@" "
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@"("
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        [phone1 replaceOccurrencesOfString:@")"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [phone1 length])];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone1]];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIAlertView *a=[self getErrorAlert:@"There is no Office Mobile Number to call"];
        [a show];
    }

}

-(void)sendEmail{
    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", result.Email ];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


@end
