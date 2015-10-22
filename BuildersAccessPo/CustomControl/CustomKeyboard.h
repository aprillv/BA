//
//  CustomKeyboard.h
//
//  Created by Kalyan Vishnubhatla on 10/9/12.
//
//

#import <Foundation/Foundation.h>

// Protocol for classes using this
@protocol CustomKeyboardDelegate
- (void)doneClicked;
@optional
- (void)previousClicked;
- (void)nextClicked;
@end

@interface CustomKeyboard : NSObject {
    id<CustomKeyboardDelegate> delegate;
}

@property (nonatomic, strong) id<CustomKeyboardDelegate> delegate;

- (UIToolbar *)getToolbarWithPrevNextDone:(BOOL)prevEnabled :(BOOL)nextEnabled;
- (UIToolbar *)getToolbarWithDone;

@end
