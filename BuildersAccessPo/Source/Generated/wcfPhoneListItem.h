/*
	wcfPhoneListItem.h
	The interface definition of properties and methods for the wcfPhoneListItem object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfPhoneListItem : SoapObject
{
	NSString* _Email;
	NSString* _Fax;
	NSString* _Mobile;
	NSString* _Name;
	NSString* _Office;
	NSString* _Photo;
	NSString* _Title;
	
}
		
	@property (retain, nonatomic) NSString* Email;
	@property (retain, nonatomic) NSString* Fax;
	@property (retain, nonatomic) NSString* Mobile;
	@property (retain, nonatomic) NSString* Name;
	@property (retain, nonatomic) NSString* Office;
	@property (retain, nonatomic) NSString* Photo;
	@property (retain, nonatomic) NSString* Title;

	+ (wcfPhoneListItem*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
