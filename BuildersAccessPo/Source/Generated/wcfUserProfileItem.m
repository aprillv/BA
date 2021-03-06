/*
	wcfUserProfileItem.h
	The implementation of properties and methods for the wcfUserProfileItem object.
	Generated by SudzC.com
*/
#import "wcfUserProfileItem.h"

@implementation wcfUserProfileItem
	@synthesize Fax = _Fax;
	@synthesize Mobile = _Mobile;
	@synthesize Name = _Name;
	@synthesize Phone = _Phone;
	@synthesize Photo = _Photo;
	@synthesize Title = _Title;

	- (id) init
	{
		if(self = [super init])
		{
			self.Fax = nil;
			self.Mobile = nil;
			self.Name = nil;
			self.Phone = nil;
			self.Photo = nil;
			self.Title = nil;

		}
		return self;
	}

	+ (wcfUserProfileItem*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfUserProfileItem*)[[[wcfUserProfileItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Fax = [Soap getNodeValue: node withName: @"Fax"];
			self.Mobile = [Soap getNodeValue: node withName: @"Mobile"];
			self.Name = [Soap getNodeValue: node withName: @"Name"];
			self.Phone = [Soap getNodeValue: node withName: @"Phone"];
			self.Photo = [Soap getNodeValue: node withName: @"Photo"];
			self.Title = [Soap getNodeValue: node withName: @"Title"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"UserProfileItem"];
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
		if (self.Fax != nil) [s appendFormat: @"<Fax>%@</Fax>", [[self.Fax stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Mobile != nil) [s appendFormat: @"<Mobile>%@</Mobile>", [[self.Mobile stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Phone != nil) [s appendFormat: @"<Phone>%@</Phone>", [[self.Phone stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Photo != nil) [s appendFormat: @"<Photo>%@</Photo>", [[self.Photo stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Title != nil) [s appendFormat: @"<Title>%@</Title>", [[self.Title stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfUserProfileItem class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Fax != nil) { [self.Fax release]; }
		if(self.Mobile != nil) { [self.Mobile release]; }
		if(self.Name != nil) { [self.Name release]; }
		if(self.Phone != nil) { [self.Phone release]; }
		if(self.Photo != nil) { [self.Photo release]; }
		if(self.Title != nil) { [self.Title release]; }
		[super dealloc];
	}

@end
