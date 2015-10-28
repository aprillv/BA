/*
	wcfUserCOEmail.h
	The interface definition of properties and methods for the wcfUserCOEmail object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfUserCOEmail : SoapObject
{
	NSString* _Email;
	NSString* _Emailcontent;
	NSString* _IdDoc;
	NSString* _IdProject;
	NSString* _NProject;
	NSString* _Result;
	NSString* _ToEmail;
	NSString* _Toemailcc;
	
}
		
	@property (retain, nonatomic) NSString* Email;
	@property (retain, nonatomic) NSString* Emailcontent;
	@property (retain, nonatomic) NSString* IdDoc;
	@property (retain, nonatomic) NSString* IdProject;
	@property (retain, nonatomic) NSString* NProject;
	@property (retain, nonatomic) NSString* Result;
	@property (retain, nonatomic) NSString* ToEmail;
	@property (retain, nonatomic) NSString* Toemailcc;

	+ (wcfUserCOEmail*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end