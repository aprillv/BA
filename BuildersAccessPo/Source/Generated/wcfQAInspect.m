/*
	wcfQAInspect.h
	The implementation of properties and methods for the wcfQAInspect object.
	Generated by SudzC.com
*/
#import "wcfQAInspect.h"

@implementation wcfQAInspect
	@synthesize Cnt = _Cnt;
	@synthesize Color = _Color;
	@synthesize Email = _Email;
	@synthesize Month = _Month;
	@synthesize Name = _Name;

	- (id) init
	{
		if(self = [super init])
		{
			self.Cnt = nil;
			self.Color = nil;
			self.Email = nil;
			self.Month = nil;
			self.Name = nil;

		}
		return self;
	}

	+ (wcfQAInspect*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfQAInspect*)[[[wcfQAInspect alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Cnt = [Soap getNodeValue: node withName: @"Cnt"];
			self.Color = [Soap getNodeValue: node withName: @"Color"];
			self.Email = [Soap getNodeValue: node withName: @"Email"];
			self.Month = [Soap getNodeValue: node withName: @"Month"];
			self.Name = [Soap getNodeValue: node withName: @"Name"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"QAInspect"];
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
		if (self.Cnt != nil) [s appendFormat: @"<Cnt>%@</Cnt>", [[self.Cnt stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Color != nil) [s appendFormat: @"<Color>%@</Color>", [[self.Color stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Email != nil) [s appendFormat: @"<Email>%@</Email>", [[self.Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Month != nil) [s appendFormat: @"<Month>%@</Month>", [[self.Month stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfQAInspect class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Cnt != nil) { [self.Cnt release]; }
		if(self.Color != nil) { [self.Color release]; }
		if(self.Email != nil) { [self.Email release]; }
		if(self.Month != nil) { [self.Month release]; }
		if(self.Name != nil) { [self.Name release]; }
		[super dealloc];
	}

@end
