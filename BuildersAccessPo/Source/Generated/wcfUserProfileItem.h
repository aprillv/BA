/*
	wcfUserProfileItem.h
	The interface definition of properties and methods for the wcfUserProfileItem object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfUserProfileItem : SoapObject
{
	NSString* _Fax;
	NSString* _Mobile;
	NSString* _Name;
	NSString* _Phone;
	NSString* _Photo;
	NSString* _Title;
	
}
		
	@property (retain, nonatomic) NSString* Fax;
	@property (retain, nonatomic) NSString* Mobile;
	@property (retain, nonatomic) NSString* Name;
	@property (retain, nonatomic) NSString* Phone;
	@property (retain, nonatomic) NSString* Photo;
	@property (retain, nonatomic) NSString* Title;

	+ (wcfUserProfileItem*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
