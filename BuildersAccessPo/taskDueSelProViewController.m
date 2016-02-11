//
//  taskDueSelProViewController.m
//  BuildersAccess
//
//  Created by April on 10/30/15.
//  Copyright © 2015 eloveit. All rights reserved.
//

#import "taskDueSelProViewController.h"
#import "cl_project.h"
#import "cl_sync.h"
#import "userInfo.h"
#import "newSchedule2.h"



@interface taskDueSelProViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *projectTable;

@end

@implementation taskDueSelProViewController{
    NSArray *rtnlist;
    NSArray *rtnlist1;
}

@synthesize projectTable, searchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPojectls];
    // Do any additional setup after loading the view.
}

- (void)getPojectls
{
    cl_project *mp=[[cl_project alloc]init];
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    mp.managedObjectContext=self.managedObjectContext;
    
    NSString *str;
    NSString *lastsync;
    cl_sync *ms =[[cl_sync alloc]init];
    ms.managedObjectContext=self.managedObjectContext;
    
//    switch (xatype) {
//        case 1:
//            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"1"];
//            str=[NSString stringWithFormat:@"idcia ='%d' and status='Development'", [userInfo getCiaId]];
//            break;
//        case 2:
            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"2"];
            str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed' and status<>'Sold' and isactive='1'", [userInfo getCiaId]];
//            break;
//        case 3:
//            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"3"];
//            str=[NSString stringWithFormat:@"idcia ='%d' and status<>'Development' and status<>'Closed'  and isactive='0' ", [userInfo getCiaId]];
//            break;
//            
//        default:
//            lastsync=[ms getLastSync:[[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] :@"4"];
//            str=[NSString stringWithFormat:@"idcia ='%d' and status='Closed'", [userInfo getCiaId]];
//            break;
//    }
    
    rtnlist = [mp getProjectList:str];
    
    rtnlist1=rtnlist;
    
    
    
//    UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(90, 12, self.view.frame.size.width-20, 40)];
//    lbl.text=[NSString stringWithFormat:@"Last Sync\n%@", lastsync];
//    lbl.textAlignment=NSTextAlignmentCenter;
//    lbl.textColor=[UIColor lightGrayColor];
//    lbl.tag=14;
//    lbl.numberOfLines=0;
//    [lbl sizeToFit];
//    //    lbl.textColor= [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f];
//    lbl.font=[UIFont boldSystemFontOfSize:10.0];
//    lbl.backgroundColor=[UIColor clearColor];
//    [ntabbar addSubview:lbl];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
    //    cl_project *mp =[[cl_project alloc]init];
    //    mp.managedObjectContext=self.managedObjectContext;
    //
    //
    //    rtnlist=[mp getProjectList:[self getSearchCondition]];
    //
    //    [tbview reloadData];
    
    NSString *str;
    
    //kv.Original, kv.Reschedule
    str=[NSString stringWithFormat:@"name like [c]'*%@*' or planname like [c]'*%@*' or idnumber like [c]'%@*' or status like [c]'*%@*'", searchText, searchText, searchText,searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
    rtnlist=[[rtnlist1 filteredArrayUsingPredicate:predicate] mutableCopy];
    [projectTable reloadData];
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [searchBar1 resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [rtnlist count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    
    //    NSLog(@"%@ %@", [kv valueForKey:@"idnumber"], [kv valueForKey:@"status"]);
    cell.textLabel.text = [kv valueForKey:@"name"];
    //    cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0];
    if ([[kv valueForKey:@"status"] isEqualToString:@"Development"]) {
        cell.detailTextLabel.text=@"Development";
    }else{
        if([kv valueForKey:@"planname"]==nil){
            [cell.detailTextLabel setNumberOfLines:0];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"\n%@", [kv valueForKey:@"status"]];
        }else{
            [cell.detailTextLabel setNumberOfLines:0];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", [kv valueForKey:@"planname"], [kv valueForKey:@"status"]];
        }
        
    }
    
    
    
    
    [cell .imageView setImage:nil];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSEntityDescription *kv =[rtnlist objectAtIndex:(indexPath.row)];
    NSString *xidproject = [kv valueForKey:@"idnumber"];
    if (![xidproject isEqualToString:self.delegate.xidproject]) {
        self.delegate.xidproject = [kv valueForKey:@"idnumber"];
        self.delegate.title = [kv valueForKey:@"name"];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate viewWillAppear:YES];
    }
   
    
}


@end
