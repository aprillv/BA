/*
	wcfProjectSchedule.h
	The implementation of properties and methods for the wcfProjectSchedule object.
	Generated by SudzC.com
*/
#import "wcfProjectSchedule.h"

@implementation wcfProjectSchedule
	@synthesize Dcomplete = _Dcomplete;
	@synthesize DcompleteYN = _DcompleteYN;
	@synthesize Dstart = _Dstart;
	@synthesize Item = _Item;
	@synthesize MilestoneDstart = _MilestoneDstart;
	@synthesize Name = _Name;
	@synthesize Notes = _Notes;
	@synthesize canEdit = _canEdit;

	- (id) init
	{
		if(self = [super init])
		{
			self.Dcomplete = nil;
			self.Dstart = nil;
			self.Item = nil;
			self.MilestoneDstart = nil;
			self.Name = nil;
			self.Notes = nil;

		}
		return self;
	}

	+ (wcfProjectSchedule*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfProjectSchedule*)[[[wcfProjectSchedule alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Dcomplete = [Soap getNodeValue: node withName: @"Dcomplete"];
			self.DcompleteYN = [[Soap getNodeValue: node withName: @"DcompleteYN"] boolValue];
			self.Dstart = [Soap getNodeValue: node withName: @"Dstart"];
			self.Item = [Soap getNodeValue: node withName: @"Item"];
			self.MilestoneDstart = [Soap getNodeValue: node withName: @"MilestoneDstart"];
			self.Name = [Soap getNodeValue: node withName: @"Name"];
			self.Notes = [Soap getNodeValue: node withName: @"Notes"];
			self.canEdit = [[Soap getNodeValue: node withName: @"canEdit"] boolValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ProjectSchedule"];
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
		if (self.Dcomplete != nil) [s appendFormat: @"<Dcomplete>%@</Dcomplete>", [[self.Dcomplete stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<DcompleteYN>%@</DcompleteYN>", (self.DcompleteYN)?@"true":@"false"];
		if (self.Dstart != nil) [s appendFormat: @"<Dstart>%@</Dstart>", [[self.Dstart stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Item != nil) [s appendFormat: @"<Item>%@</Item>", [[self.Item stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.MilestoneDstart != nil) [s appendFormat: @"<MilestoneDstart>%@</MilestoneDstart>", [[self.MilestoneDstart stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Notes != nil) [s appendFormat: @"<Notes>%@</Notes>", [[self.Notes stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<canEdit>%@</canEdit>", (self.canEdit)?@"true":@"false"];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfProjectSchedule class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Dcomplete != nil) { [self.Dcomplete release]; }
		if(self.Dstart != nil) { [self.Dstart release]; }
		if(self.Item != nil) { [self.Item release]; }
		if(self.MilestoneDstart != nil) { [self.MilestoneDstart release]; }
		if(self.Name != nil) { [self.Name release]; }
		if(self.Notes != nil) { [self.Notes release]; }
		[super dealloc];
	}

@end
