//
//  userInfo.h
//  BuildersAccess
//
//  Created by amy zhao on 12-12-7.
//  Copyright (c) 2012年 april. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfo : NSObject

+(void)setUserName:(NSString *)name andPwd:(NSString *)pwd;
+(void)initCiaInfo:(int )_ciaid andNm:(NSString *)ciaNm;

+(NSString *)getUserName;
+(NSString *)getUserPwd;
+(NSString *)getCiaName;
+(NSString *)getUserNameService;
+(void)inituserNameServer:(NSString *)uname;
+(int)getCiaId;
@end
