/*
	wcfArrayOfPOListItem.h
	The implementation of properties and methods for the wcfArrayOfPOListItem array.
	Generated by SudzC.com
*/
#import "wcfArrayOfPOListItem.h"

#import "wcfPOListItem.h"
@implementation wcfArrayOfPOListItem

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[wcfArrayOfPOListItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				wcfPOListItem* value = [[wcfPOListItem newWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"POListItem"]];
		}
		return s;
	}

- (NSMutableArray*) toMutableArray
{
    NSMutableArray* s = [[NSMutableArray alloc]init];
    for(wcfPOListItem *item in self) {
        [s addObject:item];
    }
    return s;
}

@end
