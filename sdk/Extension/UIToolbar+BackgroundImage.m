//
//  UIToolbar+BackgroundImage.m
//  MobileMerchant
//
//  Created by Mangesh on 11/02/14.
//
//

#import "UIToolbar+BackgroundImage.h"

@implementation UIToolbar (BackgroundImage)

-(void)setToolbarBack:(NSString*)bgFilename toolbar:(UIToolbar*)toolbar {
    // Add Custom Toolbar
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgFilename]];
    iv.frame = CGRectMake(0, 0, toolbar.frame.size.width, toolbar.frame.size.height);
    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // Add the tab bar controller's view to the window and display.
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 5)
        [toolbar insertSubview:iv atIndex:1]; // iOS5 atIndex:1
    else
        [toolbar insertSubview:iv atIndex:0]; // iOS4 atIndex:0
    toolbar.backgroundColor = [UIColor clearColor];
}

@end
