/*
	wcfContractItem.h
	The implementation of properties and methods for the wcfContractItem object.
	Generated by SudzC.com
*/
#import "wcfContractItem.h"

@implementation wcfContractItem
	@synthesize Client = _Client;
	@synthesize ContractDate = _ContractDate;
	@synthesize ContractId = _ContractId;
	@synthesize IDCia = _IDCia;
	@synthesize IDDoc = _IDDoc;
	@synthesize ProjectId = _ProjectId;
	@synthesize ProjectName = _ProjectName;

	- (id) init
	{
		if(self = [super init])
		{
			self.Client = nil;
			self.ContractDate = nil;
			self.ContractId = nil;
			self.IDCia = nil;
			self.IDDoc = nil;
			self.ProjectId = nil;
			self.ProjectName = nil;

		}
		return self;
	}

	+ (wcfContractItem*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfContractItem*)[[[wcfContractItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Client = [Soap getNodeValue: node withName: @"Client"];
			self.ContractDate = [Soap getNodeValue: node withName: @"ContractDate"];
			self.ContractId = [Soap getNodeValue: node withName: @"ContractId"];
			self.IDCia = [Soap getNodeValue: node withName: @"IDCia"];
			self.IDDoc = [Soap getNodeValue: node withName: @"IDDoc"];
			self.ProjectId = [Soap getNodeValue: node withName: @"ProjectId"];
			self.ProjectName = [Soap getNodeValue: node withName: @"ProjectName"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ContractItem"];
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
		if (self.Client != nil) [s appendFormat: @"<Client>%@</Client>", [[self.Client stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ContractDate != nil) [s appendFormat: @"<ContractDate>%@</ContractDate>", [[self.ContractDate stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ContractId != nil) [s appendFormat: @"<ContractId>%@</ContractId>", [[self.ContractId stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.IDCia != nil) [s appendFormat: @"<IDCia>%@</IDCia>", [[self.IDCia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.IDDoc != nil) [s appendFormat: @"<IDDoc>%@</IDDoc>", [[self.IDDoc stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ProjectId != nil) [s appendFormat: @"<ProjectId>%@</ProjectId>", [[self.ProjectId stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ProjectName != nil) [s appendFormat: @"<ProjectName>%@</ProjectName>", [[self.ProjectName stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfContractItem class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Client != nil) { [self.Client release]; }
		if(self.ContractDate != nil) { [self.ContractDate release]; }
		if(self.ContractId != nil) { [self.ContractId release]; }
		if(self.IDCia != nil) { [self.IDCia release]; }
		if(self.IDDoc != nil) { [self.IDDoc release]; }
		if(self.ProjectId != nil) { [self.ProjectId release]; }
		if(self.ProjectName != nil) { [self.ProjectName release]; }
		[super dealloc];
	}

@end
