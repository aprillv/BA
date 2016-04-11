//
//  qaInspector.m
//  BuildersAccess
//
//  Created by roberto ramirez on 8/20/13.
//  Copyright (c) 2013 eloveit. All rights reserved.
//

#import "qaInspector.h"
#import "Mysql.h"
#import "userInfo.h"
#import "Reachability.h"
#import "wcfService.h"
#import <QuartzCore/QuartzCore.h>
#import "qaInspector2.h"

@interface qaInspector ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *rtnlist;
    wcfArrayOfQAInspect * wi;
    wcfQAInspect *tbtable;
}

@property (weak, nonatomic) IBOutlet UIScrollView *uv;
@property (weak, nonatomic) IBOutlet UITabBar *ntabbar;

@end

@implementation qaInspector;
@synthesize xyear, uv, ntabbar;


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
        [self goBack: item];
    }else if(item.tag == 2){
        [self dorefresh];
    }
}



-(void)dorefresh{
[self getInspector];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    self.title=@"Inspector";
    
    UITabBarItem *firstItem0 ;
    firstItem0 = [[UITabBarItem alloc]initWithTitle:@"Calendar" image:[UIImage imageNamed:@"home.png"] tag:1];
    UITabBarItem *fi;
    fi =[[UITabBarItem alloc]init];
    UITabBarItem *f2 =[[UITabBarItem alloc]init];
    UITabBarItem *firstItem2 = [[UITabBarItem alloc]initWithTitle:@"Refresh" image:[UIImage imageNamed:@"refresh3.png"] tag:2];
    NSArray *itemsArray =[NSArray arrayWithObjects: firstItem0, fi, f2, firstItem2, nil];
    
    [ntabbar setItems:itemsArray animated:YES];
    ntabbar.delegate = self;
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(goBack:) ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3]setAction:@selector(dorefresh)];
    self.view.backgroundColor=[Mysql groupTableViewBackgroundColor];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self getInspector];
}
-(void)getInspector{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        wcfService *service =[wcfService service];
        [service xGetInspectorByYear:self action:@selector(xisupdate_iphoneHandler5:) xemail:[userInfo getUserName] xpassword:[userInfo getUserPwd] xidcia:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] xyear:xyear EquipmentType:@"3"];
        // Do any additional setup after loading the view.
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
    
    wi=(wcfArrayOfQAInspect *)value;
    
     
    
    UITableView *tbview;
    
    NSString *month=@"";
    
    
    UILabel *lbl;
    int x =5;
    int y =10;
   
    NSMutableArray * tt;
    int j =0;
    if ([wi count]>0) {
        NSMutableArray *_montharry= [[NSMutableArray alloc]init];
        [_montharry addObject:@"January"];
        [_montharry addObject:@"February"];
        [_montharry addObject:@"March"];
        [_montharry addObject:@"April"];
        [_montharry addObject:@"May"];
        [_montharry addObject:@"June"];
        [_montharry addObject:@"July"];
        [_montharry addObject:@"August"];
        [_montharry addObject:@"September"];
        [_montharry addObject:@"October"];
        [_montharry addObject:@"November"];
        [_montharry addObject:@"December"];
        
        rtnlist=[[NSMutableArray alloc]init];
        for (int i=0; i< [wi count]; i++) {
            wcfQAInspect *fp=[wi objectAtIndex:i];
            if (![fp.Month isEqualToString: month]) {
                month=fp.Month;
                
                
                if (tt!=nil) {
                    [rtnlist addObject:tt];
                    tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, [tt count]*44)];
//                    tbview.layer.cornerRadius = 10;
                    tbview.delegate = self;
                    tbview.tag=j++;
                    tbview.dataSource = self;
                    [uv addSubview:tbview];
                    y= y+[tt count]*44+15;
                }
                lbl =[[UILabel alloc]initWithFrame:CGRectMake(15, y, self.view.frame.size.width-20, 21)];
                lbl.text=[NSString stringWithFormat:@"%@ 2013", [_montharry objectAtIndex:[month intValue]-1]];
                lbl.textColor= [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
                lbl.font=[UIFont boldSystemFontOfSize:17.0];
                lbl.backgroundColor=[UIColor clearColor];
                [uv addSubview:lbl];
                y=y+21+x;
                tt= [[NSMutableArray alloc]init];
                [tt addObject:fp];
            }else{
                [tt addObject:fp];
            }

                      
        }
        [rtnlist addObject:tt];
        tbview=[[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, [tt count]*44)];
//        tbview.layer.cornerRadius = 10;
        tbview.delegate = self;
        tbview.tag=j++;
        tbview.dataSource = self;
        [uv addSubview:tbview];
        y= y+[tt count]*44+20;
        
    }
    
    if (y<uv.frame.size.height+1) {
        y=uv.frame.size.height+1;
    }
      uv.contentSize=CGSizeMake(self.view.frame.size.width, y);
    [ntabbar setSelectedItem:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[rtnlist objectAtIndex:tableView.tag] count];
}




- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    wcfQAInspect *event =[[rtnlist objectAtIndex:tableView.tag] objectAtIndex:(indexPath.row)];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", event.Name, event.Cnt];
//    cell.textLabel.font=[UIFont systemFontOfSize:17.0];
      [[cell textLabel]setBackgroundColor:[UIColor clearColor]];
    UIView *myView = [[UIView alloc] init];
    
    
    
    
    if ([event.Color isEqualToString:@"Yellow"]) {
        myView.backgroundColor = [UIColor colorWithRed:218.0/256 green:165.0/256 blue:32.0/256 alpha:1.0];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else if([event.Color isEqualToString:@"Orange"]){
        //            myView.backgroundColor = [UIColor colorWithRed:255.0/256 green:204.0/256 blue:0.0 alpha:1.0];
        myView.backgroundColor=[UIColor orangeColor];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
        //        }else if([event.Color isEqualToString:@"Red"]){
        //            myView.backgroundColor = [UIColor redColor];
        //            [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else if([event.Color isEqualToString:@"Green"]){
        myView.backgroundColor = [UIColor colorWithRed:50.0/256 green:205.0/256 blue:50.0/256 alpha:1.0];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
        //        }else if([event.Color isEqualToString:@"Blue"]){
        //            myView.backgroundColor = [UIColor blueColor];
        //            [[cell textLabel]setTextColor:[UIColor blackColor]];
        //        }else if([event.Color isEqualToString:@"Purple"]){
        //            myView.backgroundColor = [UIColor purpleColor];
        //            [[cell textLabel]setTextColor:[UIColor blackColor]];
        //        }else if([event.Color isEqualToString:@"Pink"]){
        //            myView.backgroundColor = [UIColor colorWithRed:253.0/256 green:215.0/256 blue:228.0/256 alpha:1.0];
        //            [[cell textLabel]setTextColor:[UIColor blackColor]];
    }else if([event.Color isEqualToString:@"Brown"]){
        //255 192 203
        myView.backgroundColor = [UIColor brownColor];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else if([event.Color isEqualToString:@"Gray"]){
        //255 192 203
        myView.backgroundColor = [UIColor grayColor];
        [[cell textLabel]setTextColor:[UIColor whiteColor]];
    }else{
        myView.backgroundColor = [UIColor whiteColor];
        [[cell textLabel]setTextColor:[UIColor blackColor]];
    }
    
    cell.backgroundView = myView;
    
    [cell .imageView setImage:nil];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tbtable=[[rtnlist objectAtIndex:tableView.tag]objectAtIndex:indexPath.row];
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
         qaInspector2 *q2 =[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"qaInspector2"];
        q2.xyear=self.xyear;
        q2.xmonth=tbtable.Month;
        q2.xqaemail=tbtable.Email;
        NSMutableArray *_montharry= [[NSMutableArray alloc]init];
        [_montharry addObject:@"January"];
        [_montharry addObject:@"February"];
        [_montharry addObject:@"March"];
        [_montharry addObject:@"April"];
        [_montharry addObject:@"May"];
        [_montharry addObject:@"June"];
        [_montharry addObject:@"July"];
        [_montharry addObject:@"August"];
        [_montharry addObject:@"September"];
        [_montharry addObject:@"October"];
        [_montharry addObject:@"November"];
        [_montharry addObject:@"December"];
        q2.title=[NSString stringWithFormat:@"%@ %@", [_montharry objectAtIndex:[tbtable.Month intValue]-1], xyear];
        q2.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:q2 animated:YES];
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
