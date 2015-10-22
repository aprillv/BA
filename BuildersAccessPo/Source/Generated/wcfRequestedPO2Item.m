/*
	wcfRequestedPO2Item.h
	The implementation of properties and methods for the wcfRequestedPO2Item object.
	Generated by SudzC.com
*/
#import "wcfRequestedPO2Item.h"

@implementation wcfRequestedPO2Item
	@synthesize Des = _Des;
	@synthesize FixPrice = _FixPrice;
	@synthesize Part = _Part;
	@synthesize Price = _Price;
	@synthesize Quantity = _Quantity;
	@synthesize UPC = _UPC;
	@synthesize Unit = _Unit;
	@synthesize hastax = _hastax;

	- (id) init
	{
		if(self = [super init])
		{
			self.Des = nil;
			self.Part = nil;
			self.Price = nil;
			self.Quantity = nil;
			self.UPC = nil;
			self.Unit = nil;

		}
		return self;
	}

	+ (wcfRequestedPO2Item*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfRequestedPO2Item*)[[[wcfRequestedPO2Item alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Des = [Soap getNodeValue: node withName: @"Des"];
			self.FixPrice = [[Soap getNodeValue: node withName: @"FixPrice"] boolValue];
			self.Part = [Soap getNodeValue: node withName: @"Part"];
			self.Price = [Soap getNodeValue: node withName: @"Price"];
			self.Quantity = [Soap getNodeValue: node withName: @"Quantity"];
			self.UPC = [Soap getNodeValue: node withName: @"UPC"];
			self.Unit = [Soap getNodeValue: node withName: @"Unit"];
			self.hastax = [[Soap getNodeValue: node withName: @"hastax"] boolValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"RequestedPO2Item"];
	}
  
	- (NSMutableString*) serialize: (NSString*) nodeName
	{
		NSMutableString* s = [NSMutableString string];
		[s appendFormat: @"<%@", nodeName];
		[s appendString: [self serializeAttributes]];
		[s appendString: @">"];
		[s appendString: [self serializeElements]];
		[s appendFormat: @"</%@>", nodeName];
		return s;
	}
	
	- (NSMutableString*) serializeElements
	{
		NSMutableString* s = [super serializeElements];
		if (self.Des != nil) [s appendFormat: @"<Des>%@</Des>", [[self.Des stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<FixPrice>%@</FixPrice>", (self.FixPrice)?@"true":@"false"];
		if (self.Part != nil) [s appendFormat: @"<Part>%@</Part>", [[self.Part stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Price != nil) [s appendFormat: @"<Price>%@</Price>", [[self.Price stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Quantity != nil) [s appendFormat: @"<Quantity>%@</Quantity>", [[self.Quantity stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.UPC != nil) [s appendFormat: @"<UPC>%@</UPC>", [[self.UPC stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Unit != nil) [s appendFormat: @"<Unit>%@</Unit>", [[self.Unit stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<hastax>%@</hastax>", (self.hastax)?@"true":@"false"];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfRequestedPO2Item class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Des != nil) { [self.Des release]; }
		if(self.Part != nil) { [self.Part release]; }
		if(self.Price != nil) { [self.Price release]; }
		if(self.Quantity != nil) { [self.Quantity release]; }
		if(self.UPC != nil) { [self.UPC release]; }
		if(self.Unit != nil) { [self.Unit release]; }
		[super dealloc];
	}

@end
