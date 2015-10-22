//
//  Uncompress.h
//  BuildersAccess
//
//  Created by Bin Bob on 7/14/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mysql : NSObject {
	bool            mLogin;
	bool            mLogin2;
	bool            mMail;
	int             iNum;
}

@property (nonatomic, assign) bool  mLogin;
@property (nonatomic, assign) bool  mLogin2;
@property (nonatomic, assign) bool  mMail;
@property (nonatomic, assign) int   iNum;
+(Mysql *) sharedSingleton;
+(UIColor *)getLabelTitleColor;
+ (NSString *) md5:(NSString *)str;
+ (UIColor *) getBlueTextColor;
- (UIImage *) createImageWithColor: (UIColor *) color;
+(BOOL)IsEmail:(NSString *)strEmail;
+(NSString *)TrimText:(NSString *)str;
+(NSData *)decodeBase64WithString:(NSString *)strBase64;

+ (NSString *)stringFromDate:(NSDate *)date;

- (NSDate *)dateFromString:(NSString *)dateString;
- (NSString *)stringFromDate:(NSDate *)date;

-(NSString *)Base64Encode:(NSData *)data;
- (BOOL)isPureInt:(NSString*)string;

-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image;

+ (UIColor *)groupTableViewBackgroundColor;

+(NSString *)stringreplace:(NSString *)str;

+ (NSString *)stringFromDate2:(NSDate *)date;
+ (NSString *)stringFromDate3:(NSDate *)date;
@end
