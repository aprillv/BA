//
//  ciaList.m
//  BuildersAccess
//
//  Created by amy zhao on 12-12-8.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import "ciaList.h"
#import "userInfo.h"
#import "wcfService.h"
#import "wcfKeyValueItem.h"
#import "wcfArrayOfKeyValueItem.h"
#import "Mysql.h"
#import "oneRowCell.h"
#import "projectls.h"
#import "Xpin.h"
#import "AGAlertViewWithProgressbar.h"
#import "wcfProjectListItem.h"
#import "cl_cia.h"
#import "cl_project.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "cl_sync.h"
#import "phonelist.h"
#import "cl_phone.h"

@interface ciaList (){
    AGAlertViewWithProgressbar *alertViewWithProgressbar;
}
@end

int currentpage, pageno;

@implementation ciaList

@synthesize ciaListresult, islocked, ntabbar, searchtxt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
    // Do any additional setup after loading the view from its nib.
   islocked=0;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    
    ntabbar.userInteractionEnabled = YES;
     [[ntabbar.items objectAtIndex:3]setImage:[UIImage imageNamed:@"refresh1.png"] ];
     [[ntabbar.items objectAtIndex:3]setTitle:@"Sync" ];
    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshCiaList:)];
   
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
     [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
    
    searchtxt.delegate=self;
    [searchtxt setInputAccessoryView:[self getToolbarWithPrevNextDone]];
    [self getcialist];
}




- (UIToolbar *)getToolbarWithPrevNextDone
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    UISegmentedControl *tabNavigation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    tabNavigation.segmentedControlStyle = UISegmentedControlStyleBar;
    [tabNavigation setEnabled:NO forSegmentAtIndex:0];
    [tabNavigation setEnabled:NO forSegmentAtIndex:1];
    tabNavigation.momentary = NO;
    UIBarButtonItem *barSegment = [[UIBarButtonItem alloc] initWithCustomView:tabNavigation];
    
    [itemsArray addObject:barSegment];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];
    
    toolbar.items = itemsArray;
    return toolbar;
}


- (void)userClickedDone:(id)sender {
    [searchtxt resignFirstResponder];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
    cl_cia *mp =[[cl_cia alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    NSString *str =[NSString stringWithFormat:@"(cianame like [c]'*%@*') or (ciaid like [c]'%@*')", searchtxt.text, searchtxt.text] ;
        
    ciaListresult=[mp getCiaListWithStr:str];
    
    UITableView *tbview=(UITableView *)[self.view viewWithTag:2];
    
    [tbview reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchtxt resignFirstResponder];
}

-(void)getcialist{
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    ciaListresult =[mcia getCiaList];
   
    
    UIScrollView *sv = (UIScrollView *)[self.view viewWithTag:1];
    sv.backgroundColor=[Mysql groupTableViewBackgroundColor];
    UITableView *ciatbview;
    
    
    
    if (self.view.frame.size.height>480) {
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 305+87)];
        sv.contentSize=CGSizeMake(320.0,326+87);
    }else{
        ciatbview=[[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 305)];
        sv.contentSize=CGSizeMake(320.0,326);
    }
    
     ciatbview.layer.cornerRadius = 10;
    ciatbview.tag=2;
    [sv addSubview:ciatbview];
    ciatbview.delegate = self;
    ciatbview.dataSource = self;
    
    
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.ciaListresult count]; // or self.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    
    NSEntityDescription *cia =[ciaListresult objectAtIndex:indexPath.row];
    NSString *idnm = [cia valueForKey:@"ciaid"];    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ~ %@", idnm, [cia valueForKey:@"cianame"]];
    cell.textLabel.font=[UIFont systemFontOfSize:17.0];
    
    [cell .imageView setImage:nil];
    return cell;

    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchtxt resignFirstResponder];
   NSEntityDescription *cia =[ciaListresult objectAtIndex:indexPath.row];
   [userInfo initCiaInfo:[[cia valueForKey:@"ciaid"]integerValue] andNm:[cia valueForKey:@"cianame"]];

    if ([self.title isEqualToString:@"Phone List"]) {
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        if ([mp isFirttimeToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"5"]) {
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"This is the first time, we will sync Phone List with your device, this will take some time, Are you sure you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 2;
            [alert show];
        }else{
            [self gotoNextPage];
            
        }
    }else{
        cl_sync *mp =[[cl_sync alloc]init];
        mp.managedObjectContext=self.managedObjectContext;

        if ([mp isFirttimeToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1"]) {
            UIAlertView *alert = nil;
            alert = [[UIAlertView alloc]
                     initWithTitle:@"BuildersAccess"
                     message:@"This is the first time, we will sync all projects with your device, this will take some time, Are you sure you want to continue?"
                     delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Continue", nil];
            alert.tag = 0;
            [alert show];
        }else{
            [self gotoNextPage];
            
        }
    }
    
}

-(IBAction)refreshCiaList:(id)sender{
   UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"BuildersAccess"
                                      message:@"We will sync all companies with your device, this will take some time, Are you sure you want to continue?"
                                     delegate:self
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:@"Continue", nil];
    alert.tag = 1;
    [alert show];
    
}

- (void) vGetCiaListHandler: (id) value {
    // Handle errors
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if([value isKindOfClass:[NSError class]]) {
		UIAlertView *alert=[self getErrorAlert:value];
        [alert show];
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		UIAlertView *alert=[self getErrorAlert:value];
        [alert show];
		return;
	}
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray *result1 = (NSMutableArray*)value;
    
    if([result1 isKindOfClass:[wcfArrayOfKeyValueItem class]]){
        cl_cia *mcia = [[cl_cia alloc]init];
        mcia.managedObjectContext=self.managedObjectContext;
        [mcia deletaAll];
        [mcia addToCia:result1];
    }
    
    alertViewWithProgressbar.progress= 100;
    [alertViewWithProgressbar hide];
    
    cl_cia *mcia =[[cl_cia alloc]init];
    mcia.managedObjectContext=self.managedObjectContext;
    ciaListresult =[mcia getCiaList];
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms updSync:@"0" :@"0" :[[NSDate alloc] init]];
    
    UITableView *ut = (UITableView *)[self.view viewWithTag:2];
    [ut reloadData];
    [ntabbar setSelectedItem:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 0) {
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self getProjectList:1];
            }
               break;
                
		}
		return;
	}else if(alertView .tag==1){
    //sync cialist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                searchtxt.text=@"";
                [self doSyncCialist];
            }
            break;
        }
    }else if(alertView .tag==2){
        //sync phonelist
        switch (buttonIndex) {
			case 0:
				break;
			default:{
                [self doSyncPhoneList];
            }
                break;
        }
    }

}

-(void)doSyncPhoneList{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"There is no available network!"];
        [alert show];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Phone List..." delegate:self otherButtonTitles:nil];
        
        [alertViewWithProgressbar show];
        
        [service xGetPhoneList:self action:@selector(xGetPhoneListHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]]stringValue] EquipmentType: @"3"];
    }

}

-(void)doSyncCialist{
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
        UIAlertView *alert=[self getErrorAlert:@"There is no available network!"];
        [alert show];
        [ntabbar setSelectedItem:nil];
    }else{
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Company..." delegate:self otherButtonTitles:nil];
        
        [alertViewWithProgressbar show];
        [service xGetCiaList:self action:@selector(vGetCiaListHandler:) xemail: [userInfo getUserName] xpassword: [[userInfo getUserPwd] copy] EquipmentType:@"3"];
    }

}

- (void) xGetPhoneListHandler: (id) value {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
	cl_phone *mp =[[cl_phone alloc]init];
    mp.managedObjectContext=self.managedObjectContext;
    [mp addToPhone:result];
    
    alertViewWithProgressbar.progress=100;
    
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]]stringValue]  :@"5" :[[NSDate alloc]init]];
    
     [alertViewWithProgressbar hide];
    [self gotoNextPage];
    
}


-(void)getProjectList:(int)xpageNo {
    
    currentpage=xpageNo;
    Reachability* curReach  = [Reachability reachabilityWithHostName: @"ws.buildersaccess.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus ==NotReachable) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alert=[self getErrorAlert:@"There is not available network!"];
        [alert show];
    }else{
        if (xpageNo==1) {
            alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Synchronizing Projects..." delegate:self otherButtonTitles:nil];
            
            [alertViewWithProgressbar show];
            islocked=1;
        }else{
            alertViewWithProgressbar.progress= (currentpage*100/pageno);
            
        }
        wcfService* service = [wcfService service];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [service xSearchProject:self action:@selector(xSearchProjectHandler:) xemail:[userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue]  xtype: 0 currentPage: xpageNo EquipmentType: @"3"];
    }
    
    
}

- (void) xSearchProjectHandler: (id) value {
    // Handle errors
	if([value isKindOfClass:[NSError class]]) {
		UIAlertView *alert=[self getErrorAlert:value];
        [alert show];
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		UIAlertView *alert=[self getErrorAlert:value];
        [alert show];
		return;
	}
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    if([result isKindOfClass:[wcfArrayOfProjectListItem class]]){
        
        wcfProjectListItem *kv = (wcfProjectListItem *)[result objectAtIndex:0];
        pageno=kv.TotalPage;
        [result removeObjectAtIndex:0];
        cl_project *mp=[[cl_project alloc]init];
        mp.managedObjectContext=self.managedObjectContext;
        [mp addToProject:result];
        
        if (currentpage < pageno) {
            
            currentpage=currentpage+1;
            [self getProjectList:currentpage];
        }else{
            alertViewWithProgressbar.progress = islocked;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [alertViewWithProgressbar hide];
            
            cl_sync *ms =[[cl_sync alloc]init];
            ms.managedObjectContext=self.managedObjectContext;
            
            
               [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1" :[[NSDate alloc] init]];
           
               [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2" :[[NSDate alloc] init]];
          
                [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3" :[[NSDate alloc] init]];
            
                 [ms addToSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4" :[[NSDate alloc] init]];
            
            
           
            
            
           
            
            
            if (self.islocked==2) {
                if (![[self unlockPasscode] isEqualToString:@"0"] && ![[self unlockPasscode] isEqualToString:@"1"]) {
                    
                    [self.navigationItem setHidesBackButton:NO];
                    
                    [self enterPasscode:nil];
                }else{
                     [self gotoNextPage];                }
                
            }else{
                [self gotoNextPage];
                
            }
        }
    }
}

-(void)gotoNextPage{
    if([self.title isEqualToString:@"Phone List" ]){
        phonelist *pl =[self .storyboard instantiateViewControllerWithIdentifier:@"phonelist"];
        pl.managedObjectContext=self.managedObjectContext;
        pl.title=self.title;
        
        [self.navigationController pushViewController:pl animated:YES];
    }else {
        projectls *LoginS=[self.storyboard instantiateViewControllerWithIdentifier:@"projectls"];
        LoginS.managedObjectContext=self.managedObjectContext;
        
        LoginS.title=self.title;
        
        self.islocked=0;
        [self.navigationController pushViewController:LoginS animated:YES];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller {
    if (islocked==2) {
        [self dismissViewControllerAnimated:YES completion:^() {
            
             [self gotoNextPage];
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
