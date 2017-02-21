//
//  dowloadproject.m
//  BuildersAccess
//
//  Created by roberto ramirez on 2/27/14.
//  Copyright (c) 2014 eloveit. All rights reserved.
//

#import "dowloadproject.h"
#import "wcfService.h"
#import "userInfo.h"
#import "cl_project.h"
#import "cl_sync.h"
#import "AppDelegate.h"


@implementation dowloadproject{
    int page;
    wcfService* service;
    int pcout;
    int xtype;
}

@synthesize delegate;

-(id)initDownloadWithPageNo:(int)pageno andxtype:(int)xtype2{
    
    
    if (self=[self init]) {
        
    }
    page=pageno;
    xtype=xtype2;
    
    return self;
    
}

-(BOOL)isConcurrent{
    return YES;
}

-(void)start{
    
    service = [wcfService service];
    [self geta];
    
    while(service!= nil) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
//    NSLog(@"%d", [userInfo getCiaId]);
    
    
    
}

-(void)geta{
    
    
    
    [service xSearchProject:self action:@selector(xSearchProjectSyncHandler:) xemail: [userInfo getUserName] xpassword: [userInfo getUserPwd] xidcia: [[NSNumber numberWithInt:[userInfo getCiaId]] stringValue] xtype:xtype currentPage:page  EquipmentType: @"3"];
}

- (void) xSearchProjectSyncHandler: (id) value {
    
    // Handle errors
	if([value isKindOfClass:[NSError class]]) {
       NSLog(@"ccc");
        [self.delegate doexception];
        NSError *error = value;
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    // Handle faults
    if([value isKindOfClass:[SoapFault class]]) {
        NSLog(@"dddd");
        SoapFault *sf =value;
        
        NSLog(@"%@", [sf description]);
        return;
    }
    NSMutableArray* result = (NSMutableArray*)value;
    
    wcfProjectListItem *kv;
    if ([result count]>0) {
        kv = (wcfProjectListItem *)[result objectAtIndex:0];
        pcout=kv.TotalPage;
        
        if (page+5<=pcout) {
            [[self delegate] finishone: result andPageNo:page];
            page=page+5;
            [self geta];
        }else{
            
            service=nil;
           
            [self cancel];
            [[self delegate] finishone: result andPageNo:page];
            
        }
        
    }else{
        service=nil;
        [self cancel];
        [[self delegate] finishone:nil andPageNo:page];
        
    }
    
}



@end
