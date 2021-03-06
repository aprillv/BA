/*
	wcfArrayOfVpoListItem.h
	The implementation of properties and methods for the wcfArrayOfVpoListItem array.
	Generated by SudzC.com
*/
#import "wcfArrayOfVpoListItem.h"

#import "wcfVpoListItem.h"
@implementation wcfArrayOfVpoListItem

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[wcfArrayOfVpoListItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				wcfVpoListItem* value = [[wcfVpoListItem newWithNode: child] object];
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
			[s appendString: [item serialize: @"VpoListItem"]];
		}
		return s;
	}

- (NSMutableArray*) toMutableArray
{
    NSMutableArray* s = [[NSMutableArray alloc]init];
    for(wcfVpoListItem *item in self) {
        [s addObject:item];
    }
    return s;
}

@end
