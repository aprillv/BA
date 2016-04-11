//
//  projectContractFiles.h
//  BuildersAccess
//
//  Created by April on 4/11/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

#import "fathercontroller.h"

@interface projectContractFiles : fathercontroller<UITableViewDelegate, UITableViewDataSource,UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITabBar *ntabbar;
@property (nonatomic, retain) NSMutableArray  *fileListresult;
@property (nonatomic, retain) NSMutableArray  *fileListresult2;
@property (nonatomic, strong) UIDocumentInteractionController *docController;
@property(retain, nonatomic) NSString *idproject;
@property(retain, nonatomic) NSString *projectname;
@end
