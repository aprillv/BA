/*
	wcfArrayOfProjectListItem.h
	The implementation of properties and methods for the wcfArrayOfProjectListItem array.
	Generated by SudzC.com
*/
#import "wcfArrayOfProjectListItem.h"

#import "wcfProjectListItem.h"
@implementation wcfArrayOfProjectListItem

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[wcfArrayOfProjectListItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				wcfProjectListItem* value = [[wcfProjectListItem newWithNode: child] object];
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
			[s appendString: [item serialize: @"ProjectListItem"]];
		}
		return s;
	}

- (NSMutableArray*) toMutableArray{
    
    NSMutableArray* s = [[NSMutableArray alloc]init];
    for(wcfProjectListItem *item in self) {
        [s addObject:item];
    }
    return s;
}
@end