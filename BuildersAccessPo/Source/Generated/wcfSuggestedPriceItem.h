/*
	wcfSuggestedPriceItem.h
	The interface definition of properties and methods for the wcfSuggestedPriceItem object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfSuggestedPriceItem : SoapObject
{
	NSString* _Comment;
	NSString* _CounterPrice;
	NSString* _Email;
	NSString* _FormulaPrice;
	NSString* _IDSub;
	NSString* _Idnumber;
	NSString* _Idproject;
	NSString* _Nproject;
	NSString* _SQFT;
	NSString* _Suggested;
	
}
		
	@property (retain, nonatomic) NSString* Comment;
	@property (retain, nonatomic) NSString* CounterPrice;
	@property (retain, nonatomic) NSString* Email;
	@property (retain, nonatomic) NSString* FormulaPrice;
	@property (retain, nonatomic) NSString* IDSub;
	@property (retain, nonatomic) NSString* Idnumber;
	@property (retain, nonatomic) NSString* Idproject;
	@property (retain, nonatomic) NSString* Nproject;
	@property (retain, nonatomic) NSString* SQFT;
	@property (retain, nonatomic) NSString* Suggested;

	+ (wcfSuggestedPriceItem*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
