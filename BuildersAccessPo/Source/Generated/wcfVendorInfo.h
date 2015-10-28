/*
	wcfVendorInfo.h
	The interface definition of properties and methods for the wcfVendorInfo object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
@class wcfArrayOfVendorAssemblyItem;
@class wcfArrayOfVendorContactItem;

@interface wcfVendorInfo : SoapObject
{
	NSMutableArray* _AssemblyList;
	NSMutableArray* _ContractList;
	NSString* _Email;
	NSString* _Fax;
	NSString* _Idnumber;
	NSString* _Mobile;
	NSString* _Name;
	NSString* _cname;
	NSString* _phone;
	
}
		
	@property (retain, nonatomic) NSMutableArray* AssemblyList;
	@property (retain, nonatomic) NSMutableArray* ContractList;
	@property (retain, nonatomic) NSString* Email;
	@property (retain, nonatomic) NSString* Fax;
	@property (retain, nonatomic) NSString* Idnumber;
	@property (retain, nonatomic) NSString* Mobile;
	@property (retain, nonatomic) NSString* Name;
	@property (retain, nonatomic) NSString* cname;
	@property (retain, nonatomic) NSString* phone;

	+ (wcfVendorInfo*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end