/*
	wcfCOOrderDetail.h
	The interface definition of properties and methods for the wcfCOOrderDetail object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfCOOrderDetail : SoapObject
{
	NSString* _Btype;
	NSString* _Description;
	NSString* _HasColor;
	
}
		
	@property (retain, nonatomic) NSString* Btype;
	@property (retain, nonatomic) NSString* Description;
	@property (retain, nonatomic) NSString* HasColor;

	+ (wcfCOOrderDetail*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
