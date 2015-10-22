//
//  Uncompress.m
//  BuildersAccess
//
//  Created by Bin Bob on 7/14/11.
//  Copyright 2011 lovetthomes. All rights reserved.
//
#import "zlib.h"
#import "Mysql.h"
#import "CommonCrypto/CommonDigest.h"
#import "NSString+Color.h"

@implementation Mysql
@synthesize mLogin,mLogin2,mMail,iNum;

+ (NSString *) md5:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIColor *)getLabelTitleColor{
  return   [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
}
+ (UIColor *)groupTableViewBackgroundColor
{
    
  
    
//    __strong static UIImage* tableViewBackgroundImage = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(7.f, 1.f), NO, 0.0);
//        CGContextRef c = UIGraphicsGetCurrentContext();
//        [[UIColor colorWithRed:185/255.f green:192/255.f blue:202/255.f alpha:1.f] setFill];
//        CGContextFillRect(c, CGRectMake(0, 0, 4, 1));
//        [[UIColor colorWithRed:185/255.f green:193/255.f blue:200/255.f alpha:1.f] setFill];
//        CGContextFillRect(c, CGRectMake(4, 0, 1, 1));
//        [[UIColor colorWithRed:192/255.f green:200/255.f blue:207/255.f alpha:1.f] setFill];
//        // [[UIColor colorWithRed:185/255.f green:193/255.f blue:200/255.f alpha:1.f] setFill];
//        CGContextFillRect(c, CGRectMake(5, 0, 2, 1));
//        tableViewBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    });
//    return [UIColor colorWithPatternImage:tableViewBackgroundImage];
//    [[UITabBar appearance] setTintColor:[@"#ccccd1" toColor]];
//    self.navigationController.navigationBar.tintColor = [@"#ccccd1" toColor];
//    [[UISearchBar appearance] setTintColor:[@"#ccccd1" toColor]];
    return [@"#e2e2e4" toColor];
    
//    return [UIColor colorWithWhite:0.99 alpha:0.8];
}
+ (UIColor *) getBlueTextColor{
//    return [@"#007aff" toColor];
//   return [@"#0000ff" toColor];
   return [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
}
+(NSString *)stringreplace:(NSString *)str{
    // / : * ? " < >|
    NSMutableString *phone1 = [str mutableCopy];
    [phone1 replaceOccurrencesOfString:@"\\"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@"/"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@":"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@"*"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@"?"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@""""
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@"<"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@">"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    [phone1 replaceOccurrencesOfString:@"|"
                            withString:@"_"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [phone1 length])];
    return phone1;
    
}


+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yy HH:mm a"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+ (NSString *)stringFromDate2:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
+ (NSString *)stringFromDate3:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    CGSize a =[text sizeWithFont:font];
    
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake((320-a.width)/2, 1, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"MM/dd/yyyy"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
    
}

+ (NSData *) decodeBase64WithString: (NSString *)strBase64 {   
	unsigned long ixtext, lentext;   
	unsigned char ch, input[4], output[3];   
	short i, ixinput;   
	Boolean flignore, flendtext = false;   
	const char *temporary;   
	NSMutableData *result;    
	if (!strBase64)     
		return [NSData data];    
	ixtext = 0;   
	temporary = [strBase64 UTF8String];   
	lentext = [strBase64 length];  
	result = [NSMutableData dataWithCapacity: lentext]; 
	ixinput = 0;   
	while (true) {     
		if (ixtext >= lentext)       
			break;     
		ch = temporary[ixtext++];     
		flignore = false;     
		if ((ch >= 'A') && (ch <= 'Z'))       
			ch = ch - 'A';     
		else if ((ch >= 'a') && (ch <= 'z'))      
			ch = ch - 'a' + 26;     
		else if ((ch >= '0') && (ch <= '9'))      
			ch = ch - '0' + 52;     
		else if (ch == '+')       
			ch = 62;     
		else if (ch == '=')       
			flendtext = true;     
		else if (ch == '/')       
			ch = 63;     
		else      
			flignore = true;       
		if (!flignore) {       
			short ctcharsinput = 3;       
			Boolean flbreak = false;        
			if (flendtext) {          
				if (ixinput == 0)            
					break;                          
				if ((ixinput == 1) || (ixinput == 2))           
					ctcharsinput = 1;          
				else            
					ctcharsinput = 2;           
				ixinput = 3;          
				flbreak = true;       
			}        
			input[ixinput++] = ch;        
			if (ixinput == 4) {         
				ixinput = 0;        
				output[0] = (input[0] << 2) | ((input[1] & 0x30) >> 4);       
				output[1] = ((input[1] & 0x0F) << 4) | ((input[2] & 0x3C) >> 2);       
				output[2] = ((input[2] & 0x03) << 6) | (input[3] & 0x3F);        
				for (i = 0; i < ctcharsinput; i++)         
					[result appendBytes: &output[i] length: 1]; 
			}      
			if (flbreak)       
				break;  
		}
	}   
	return result; 
}

+(BOOL)IsEmail:(NSString *)strEmail {
	NSString *emailPattern=@"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
	NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:emailPattern options:NSRegularExpressionCaseInsensitive error:nil];
	NSUInteger matchCnt=[regex numberOfMatchesInString:strEmail options:0 range:NSMakeRange(0, strEmail.length)];
	if (matchCnt!=0) {
		return YES;
	} else {
		return NO;
	}
}
	
+(NSString *)TrimText:(NSString *)str {
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(Mysql *) sharedSingleton {
	static Mysql *sharedSingleton;
	@synchronized(self) {
		if (!sharedSingleton) {
			sharedSingleton=[[Mysql alloc] init];
		}
		return sharedSingleton;
	}
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(NSString *)Base64Encode:(NSData *)data{
	//Point to start of the data and set buffer sizes
	int inLength = [data length];
	int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
	const char *inputBuffer = [data bytes];
	char *outputBuffer = malloc(outLength);
	outputBuffer[outLength] = 0;
	//64 digit code
	static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	//start the count
	int cycle = 0;
	int inpos = 0;
	int outpos = 0;
	char temp;
	//Pad the last to bytes, the outbuffer must always be a multiple of 4
	outputBuffer[outLength-1] = '=';
	outputBuffer[outLength-2] = '=';
	/* http://en.wikipedia.org/wiki/Base64
	 Text content   M           a           n
	 ASCII          77          97          110
	 8 Bit pattern  01001101    01100001    01101110
	 6 Bit pattern  010011  010110  000101  101110
	 Index          19      22      5       46
	 Base64-encoded T       W       F       u  */
	while (inpos < inLength){
		switch (cycle) {
			case 0:
				outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
				cycle = 1;
				break;
			case 1:
				temp = (inputBuffer[inpos++]&0x03)<<4;
				outputBuffer[outpos] = Encode[temp];
				cycle = 2;
				break;
			case 2:
				outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
				temp = (inputBuffer[inpos++]&0x0F)<<2;
				outputBuffer[outpos] = Encode[temp];
				cycle = 3;
				break;
			case 3:
				outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
				cycle = 4;
				break;
			case 4:
				outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
				cycle = 0;
				break;
			default:
				cycle = 0;
				break;
		}
	}
	NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
	free(outputBuffer);
	return pictemp;
}


@end
