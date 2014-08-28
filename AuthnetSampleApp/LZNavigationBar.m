//
//  LZNavigationBar.m
//
//  Created by Colin Barrett on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LZNavigationBar.h"

#define FLOAT_COLOR_VALUE(n) (n)/255.0
#define kNavigationButtonFont [UIFont boldSystemFontOfSize:12.0]
#define kNavigationButtonPadding 25.0
#define kNavigationBackButtonPadding 25.0

@implementation LZNavigationBar

@synthesize barView;

+ (id)navigationControllerWithRoot:(UIViewController *)rootViewController
{
    UINavigationController *nc = [[[NSBundle mainBundle] loadNibNamed:@"LZNavigationController" owner:nil options:nil] objectAtIndex:0];
    if (rootViewController) {
        nc.viewControllers = [NSArray arrayWithObject:rootViewController];
        [nc.navigationBar setTintColor:[UIColor colorWithRed:FLOAT_COLOR_VALUE(45) green:FLOAT_COLOR_VALUE(80) blue:FLOAT_COLOR_VALUE(123) alpha:1]];

    }
    return nc;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
      {
            barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_bar"]]; // should be exactly 44px tall
        }
        [barView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:barView];
        [self setTintColor:[UIColor colorWithRed:FLOAT_COLOR_VALUE(45) green:FLOAT_COLOR_VALUE(80) blue:FLOAT_COLOR_VALUE(123) alpha:1]]; // or to whatever color best approximates the look of the buttons. Just fudge it.
    }
    return self;
}

//-(void)setTestBarView
//{
//    
//    [barView removeFromSuperview];
//    barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow_header_bar"]]; // should be exactly 44px tall
//    [barView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [self addSubview:barView];
//}
//
////Set The NavBar image to normal.
//-(void)setNormalBarView
//{
//    [barView removeFromSuperview];
//    barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_bar"]]; // should be exactly 44px tall
//    [barView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [self addSubview:barView];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self sendSubviewToBack:barView];
    [barView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)drawRect:(CGRect)rect
{
    // empty to stop UINB from drawing.
}

- (void)setBarView:(UIImageView *)newBarView {
    [barView removeFromSuperview];
    barView = newBarView;
    [self addSubview:barView];
}

@end

@implementation LZBarButtonItem

- (id)initBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *strechableButtonNormal = [[UIImage imageNamed:@"btn_back_A"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    UIImage *strechableButtonHighlighted = [[UIImage imageNamed:@"btn_back_B"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [button setBackgroundImage:strechableButtonNormal forState:UIControlStateNormal];
    [button setBackgroundImage:strechableButtonHighlighted forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // Add a small bit of text buffer so that text isn't uneven with arrowed button
    [button setTitle:[NSString stringWithFormat:@"  %@", title] forState:UIControlStateNormal];
    [[button titleLabel] setFont:kNavigationButtonFont];
    [[button titleLabel] setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, -1.0)];
    [button setAccessibilityLabel:title];
    
    // Set frame
    CGSize constSize = { 80.0f, 30.0f };
	CGSize textSize = [title sizeWithFont:kNavigationButtonFont constrainedToSize:constSize lineBreakMode:NSLineBreakByClipping];
    
    if (textSize.width + kNavigationBackButtonPadding < 71) {
        button.frame = CGRectMake(0, 0, 71, 30);
    } else {
        button.frame = CGRectMake(0, 0, textSize.width + kNavigationBackButtonPadding, 30);
    }

    return [self initWithCustomView:button];
}

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *strechableButtonNormal = [[UIImage imageNamed:@"btn_A"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    UIImage *strechableButtonHighlighted = [[UIImage imageNamed:@"btn_B"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [button setBackgroundImage:strechableButtonNormal forState:UIControlStateNormal];
    [button setBackgroundImage:strechableButtonHighlighted forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [[button titleLabel] setFont:kNavigationButtonFont];
    [[button titleLabel] setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, -1.0)];
    [button setAccessibilityLabel:title];
    
    // Set frame
    CGSize constSize = { 80.0f, 30.0f };
	CGSize textSize = [title sizeWithFont:kNavigationButtonFont constrainedToSize:constSize lineBreakMode:NSLineBreakByClipping];
	button.frame = CGRectMake(0, 0, textSize.width + kNavigationButtonPadding, 30);
    
    return [self initWithCustomView:button];
}

- (id)initSmallWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *strechableButtonNormal = [[UIImage imageNamed:@"sm_btn_A"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    UIImage *strechableButtonHighlighted = [[UIImage imageNamed:@"sm_btn_B"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [button setBackgroundImage:strechableButtonNormal forState:UIControlStateNormal];
    [button setBackgroundImage:strechableButtonHighlighted forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [[button titleLabel] setFont:kNavigationButtonFont];
    [[button titleLabel] setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, -1.0)];
    [button setAccessibilityLabel:title];
    
    // Set frame
    CGSize constSize = { 80.0f, 25.0f };
	CGSize textSize = [title sizeWithFont:kNavigationButtonFont constrainedToSize:constSize lineBreakMode:NSLineBreakByClipping];
	button.frame = CGRectMake(0, 0, textSize.width + kNavigationButtonPadding, 25);
    
    return [self initWithCustomView:button];
}

- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_A"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_B"] forState:UIControlStateHighlighted];
    // set highlighted image for UIControlStateHighlighted or other states
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];

    return [self initWithCustomView:button];
}

- (id)initWithButtonType:(BUTTON_TYPE)buttonType target:(id)target selector:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    switch (buttonType) {
        case kActionButton:
            [button setBackgroundImage:[UIImage imageNamed:@"more_A"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"more_B"] forState:UIControlStateHighlighted];
            [button setFrame:CGRectMake(0,0,46,30)];
            break;
            
        default:
            break;
    }
    // set highlighted image for UIControlStateHighlighted or other states
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}
@end

