//
//  AnetEMVDemoUISettings.m
//  AnetEMVDemo
//
//  Created by Senthil Kumar Periyasamy on 7/21/16.
//  Copyright © 2016 Authorize.Net. All rights reserved.
//

#import "AnetEMVDemoUISettings.h"

@implementation AnetEMVDemoUISettings
@synthesize backgroundColor;
@synthesize textFontColor;
@synthesize buttonColor;
@synthesize buttonTextColor;
@synthesize logoImage;
@synthesize bannerBackgroundColor;
@synthesize backgroundImage;

+ (AnetEMVDemoUISettings *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        if (_sharedObject == nil) {
            _sharedObject = [[AnetEMVDemoUISettings alloc] init];
        }
    });
    return _sharedObject;
}

- (void) registerDefaultsFromSettingsBundle {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs synchronize];
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource: @"Settings" ofType: @"bundle"];
    
    if (!settingsBundle) {
        return;
    }   
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent: @"Root.plist"]];
    NSArray *preferences = [settings objectForKey: @"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for (NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        
        if (key) {
            // check if value readable in userDefaults
            id currentObject = [defs objectForKey: key];
            if (currentObject == nil) {
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey: @"DefaultValue"];
                [defaultsToRegister setValue: objectToSet forKey: key];
                NSLog(@"Setting object %@ for key %@", objectToSet, key);
            } else {
                // already readable: don't touch
                NSLog(@"Key %@ is readable (value: %@), nothing written to defaults.", key, currentObject);
            }
        }
    }
    [defs registerDefaults: defaultsToRegister];
    [defs synchronize];
}


-(void) readFromSettingsBundle {
    NSString *udBackgroundColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"background_color_preference"];
    NSString *udBannerColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"banner_color_preference"];
    NSString *udBannerImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"banner_image_preference"];
    NSString *udFontColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"font_color_preference"];
    NSString *udButtonColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"button_background_color_preference"];
    NSString *udButtonTextColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"button_font_color_preference"];
    NSString *udBackgroundImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"background_image_preference"];

    SEL selector = NULL;
    
    if (![udBackgroundColor isEqualToString:@"none"] && udBackgroundColor != NULL) {
        SEL selector = NSSelectorFromString(udBackgroundColor);
        self.backgroundColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udBannerColor isEqualToString:@"none"] && udBannerColor != NULL) {
        selector = NSSelectorFromString(udBannerColor);
        self.bannerBackgroundColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udBannerImage isEqualToString:@"none"] && udBannerImage != NULL) {
        self.logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", udBannerImage]];
    }
    
    if (![udFontColor isEqualToString:@"none"] && udFontColor != NULL) {
        selector = NSSelectorFromString(udFontColor);
        self.textFontColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udButtonColor isEqualToString:@"none"] && udButtonColor != NULL) {
        selector = NSSelectorFromString(udButtonColor);
        self.buttonColor = [UIColor performSelector:selector withObject:nil];
    }

    if (![udButtonTextColor isEqualToString:@"none"] && udButtonTextColor != NULL) {
        selector = NSSelectorFromString(udButtonTextColor);
        self.buttonTextColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udBackgroundImage isEqualToString:@"none"] && udBackgroundImage != NULL) {
        self.backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", udBackgroundImage]];
    }
}

-(UIColor *)getBannerBackgroundColor
{
    return self.bannerBackgroundColor;
}

+ (MFMailComposeViewController *)mailTo:(NSString *)iEmail withSubject:(NSString *)iSubject withBody:(NSString *) iBody fromController:(UIViewController *)iController {
    //put email info here:
    NSString *subject = @"EMV SDK LOGS";
    NSString *body = @"EMV TRANSACTION LOGS";
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = iController;
    [mc setSubject:subject];
    [mc setMessageBody:body isHTML:NO];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"EMV_SDK_Logs.txt"];
    
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    [mc addAttachmentData:fileData mimeType:@"text/plain" fileName:@"EMV_SDK_Logs.txt"];
    return mc;

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
