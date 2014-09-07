//
//  LZNavigationBar.h
//
//  Created by Colin Barrett on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * Different types of buttons
 *
 */
typedef enum ButtonType {
	kActionButton,
} BUTTON_TYPE;

@interface LZNavigationBar : UINavigationBar {
    UIImageView *barView;
}

@property (nonatomic, retain) UIImageView *barView;

+ (id)navigationControllerWithRoot:(UIViewController *)rootViewController;
//- (void)setTestBarView;
//- (void)setNormalBarView;
@end


@interface LZBarButtonItem : UIBarButtonItem { }
// Use this instead of -initWithTitle:style:target:action; we will probably also need one for custom back buttons and for done style buttons (or have a parameter of some kind)
// It would be good to avoid directly overriding the initWithTitle:style:target:action method though.
// One thing to remember about UINavigationItem is that "backButtonItem" refers to the the item that will be displayed *when the back button will go to this vc* not what the back button looks like on this screen.
// I recommned just setting leftBarButtonItem on every screen and having the action do a popViewController:animated:.
- (id)initBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (id)initSmallWithTitle:(NSString *)title target:(id)target action:(SEL)action;
// Use this instead of -initWithImage:style:target:action or -initWithBarButtonSystemItem:target:action
- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;
// Use this to create particular buttons with particular graphics
- (id)initWithButtonType:(BUTTON_TYPE)buttonType target:(id)target selector:(SEL)action;
@end