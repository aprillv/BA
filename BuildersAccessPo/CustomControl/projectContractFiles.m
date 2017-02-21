//
//  projectContractFiles.m
//  BuildersAccess
//
//  Created by April on 4/11/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

#import "projectContractFiles.h"
#import "wcfService.h"
#import "wcfProjectFile.h"
#import "userInfo.h"
#import "MBProgressHUD.h"

@implementation projectContractFiles{
    MBProgressHUD *HUD;
}

@synthesize idproject, projectname, docController,  searchBar, ntabbar;
#pragma mark - TableView Methods


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[self getbackButton]];
    
    
    // Do any additional setup after loading the view from its nib.
//    islocked=0;
    [[ntabbar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"home.png"] ];
    [[ntabbar.items objectAtIndex:0]setTitle:@"Home" ];
    ntabbar.delegate =  self;
    //    [[ntabbar.items objectAtIndex:0]setAction:@selector(gohome:) ];
    
    ntabbar.userInteractionEnabled = YES;
//    [[ntabbar.items objectAtIndex:3]setImage:nil];
//    [[[ntabbar.items objectAtIndex:3]setTitle:nil];
//      [[ntabbar.items objectAtIndex:3]setEnabled:NO ];
    //    [[ntabbar.items objectAtIndex:3] setAction:@selector(refreshCiaList:)];
//    
    
    [[ntabbar.items objectAtIndex:1]setImage:nil ];
    [[ntabbar.items objectAtIndex:1]setTitle:nil ];
    [[ntabbar.items objectAtIndex:1]setEnabled:NO ];
    [[ntabbar.items objectAtIndex:2]setImage:nil ];
    [[ntabbar.items objectAtIndex:2]setTitle:nil ];
    [[ntabbar.items objectAtIndex:2]setEnabled:NO ];
     [[ntabbar.items objectAtIndex:3]setImage:nil ];
     [[ntabbar.items objectAtIndex:3]setTitle:nil ];
     [[ntabbar.items objectAtIndex:3]setEnabled:NO ];
    
     self.fileListresult2 = _fileListresult;
//    searchBar.delegate=self;
//    keyboard=[[CustomKeyboard alloc]init];
//    keyboard.delegate=self;
//    [searchtxt setInputAccessoryView:[keyboard getToolbarWithDone]];
//    [self getcialist];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"Home"]) {
        [self gohome:item];
//    }else if([item.title isEqualToString:@"Sync"]){
//        [self refreshCiaList:item];
    }
}

- (void)doneClicked{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    [searchtxt resignFirstResponder];
    
//    cl_cia *mp =[[cl_cia alloc]init];
//    mp.managedObjectContext=self.managedObjectContext;
    NSString *str =[NSString stringWithFormat:@"(FName like [c]'*%@*')", self.searchBar.text] ;
//     NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
//    self.fileListresult = [[self.fileListresult2 filterUsingPredicate:<#(nonnull NSPredicate *)#>];
    
                           NSPredicate *predicate = [NSPredicate predicateWithFormat: str];
                           self.fileListresult=[[self.fileListresult2 filteredArrayUsingPredicate:predicate] mutableCopy];

                           
    [self.tableView reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.fileListresult count]; // or self.items.count;
    
}

- (BAUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    BAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BAUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    wcfProjectFile *cia =[self.fileListresult objectAtIndex:indexPath.row];
//    NSString *idnm = [cia valueForKey:@"ciaid"];
    cell.textLabel.text = cia.FName;
    [cell .imageView setImage:nil];
    return cell;
    
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    cl_cia *mcia =[[cl_cia alloc]init];
//    mcia.managedObjectContext=self.managedObjectContext;
//    fileListresult =[mcia getCiaList];
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    wcfProjectFile *item = [self.fileListresult objectAtIndex: indexPath.row];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText=@"Download Project's Contract File...";
    HUD.dimBackground = YES;
//    HUD.delegate = self;
    [HUD show:YES];
    //                alertViewWithProgressbar = [[AGAlertViewWithProgressbar alloc] initWithTitle:@"BuildersAccess" message:@"Download Project File..." delegate:self otherButtonTitles:nil];
    
    //                [alertViewWithProgressbar show];
    NSString *str;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    NSString *url1 = [NSString stringWithFormat:@"http://ws.buildersaccess.com/wsdownload.aspx?id=%@-%@&fs=%@&fname%@", item.ID, [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue], item.FSize, [item.FName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    wcfService* service = [wcfService service];
    str=[[NSString stringWithFormat:@"%@ ~ %@", idproject, projectname]stringByAddingPercentEscapesUsingEncoding:
         NSASCIIStringEncoding];
    
    NSString* escapedUrlString =
    [[NSString stringWithFormat:@"<view> %@", item.FName] stringByAddingPercentEscapesUsingEncoding:
     NSASCIIStringEncoding];
    
    [service xAddUserLog:self action:@selector(xAddUserLogHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] logscreen: @"Project File" keyname: str filename: escapedUrlString EquipmentType: @"3"];
    
    NSURL *url = [NSURL URLWithString:url1];
    [self downloadFile: url];
//    [self autoUpd];
}



-(void) downloadFile:(NSURL *)url
{
    //    NSURL * url = [NSURL URLWithString:@"https://s3.amazonaws.com/hayageek/downloads/SimpleBackgroundFetch.zip"];
    
    //    let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
    //    dispatch_async(dispatch_get_global_queue(qos, 0)) {
    //        let imageData = NSData(contentsOfURL: url)
    //        dispatch_async(dispatch_get_main_queue()){
    //            if url == self.imageURL{
    //                if imageData != nil{
    //                    self.image = UIImage(data: imageData!)
    //                }else{
    //                    self.image = nil
    //                }
    //            }
    //
    //        }
    //    }
    
    //    id qos = [QOS_CLASS_USER_INITIATED rawValue];
    NSString *pdfname = @"tmp.pdf";
    dispatch_async((dispatch_get_global_queue(0, 0)), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [data writeToFile:[self GetTempPath:pdfname] atomically:NO];
            
            BOOL exist = [self isExistsFile:[self GetTempPath:pdfname]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (exist) {
                HUD.progress=1;
                [HUD hide];
                
                NSString *filePath = [self GetTempPath:pdfname];
                NSURL *URL = [NSURL fileURLWithPath:filePath];
                [self openDocumentInteractionController:URL];
            }
            
        });
    });
    
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

-(NSString *)GetTempPath:(NSString*)filename{
    NSString *tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingPathComponent:filename];
}


-(BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
}


@end
