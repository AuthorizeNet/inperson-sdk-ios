//
//  AnetProfileDemoUISettings.m
//  AnetEMVDemo
//
//  Created by Manjappa, Chinthan on 10/9/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import "AnetProfileDemoUISettings.h"

@implementation AnetProfileDemoUISettings
@synthesize backgroundColor;
@synthesize submitButtonBGColor;
@synthesize submitButtonTextColor;
@synthesize cancelButtonBGColor;
@synthesize cancelButtonTextColor;
@synthesize titleTextColor;

+ (AnetProfileDemoUISettings *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        if (_sharedObject == nil) {
            _sharedObject = [[AnetProfileDemoUISettings alloc] init];
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
    NSArray *preferences = [settings valueForKey: @"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for (NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification valueForKey:@"Key"];
        
        if (key) {
            // check if value readable in userDefaults
            id currentObject = [defs valueForKey: key];
            if (currentObject == nil) {
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification valueForKey: @"DefaultValue"];
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
    NSString *udBackgroundColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"profile_bgcolor_preference"];
    NSString *udSubmitBGColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"submit_bgcolor_preference"];
    NSString *udSubmitTextColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"submit_color_preference"];
    NSString *udCancelBGColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"cancel_bgcolor_preference"];
    NSString *udCancelTextColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"cancel_color_preference"];
    NSString *udTitleTextColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"title_color_preference"];
    NSString *udTextFieldBorderColor = [[NSUserDefaults standardUserDefaults] valueForKey:@"borderTextfield_color_preference"];
    
    SEL selector = NULL;
    
    if (![udBackgroundColor isEqualToString:@"none"] && udBackgroundColor != NULL) {
        SEL selector = NSSelectorFromString(udBackgroundColor);
        self.backgroundColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udSubmitBGColor isEqualToString:@"none"] && udSubmitBGColor != NULL) {
        selector = NSSelectorFromString(udSubmitBGColor);
        self.submitButtonBGColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udSubmitTextColor isEqualToString:@"none"] && udSubmitTextColor != NULL) {
        selector = NSSelectorFromString(udSubmitTextColor);
        self.submitButtonTextColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udCancelBGColor isEqualToString:@"none"] && udCancelBGColor != NULL) {
        selector = NSSelectorFromString(udCancelBGColor);
        self.cancelButtonBGColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udCancelTextColor isEqualToString:@"none"] && udCancelTextColor != NULL) {
        selector = NSSelectorFromString(udCancelTextColor);
        self.cancelButtonTextColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udTitleTextColor isEqualToString:@"none"] && udTitleTextColor != NULL) {
        selector = NSSelectorFromString(udTitleTextColor);
        self.titleTextColor = [UIColor performSelector:selector withObject:nil];
    }
    
    if (![udTextFieldBorderColor isEqualToString:@"none"] && udTextFieldBorderColor != NULL) {
        selector = NSSelectorFromString(udTextFieldBorderColor);
        self.textFieldBorderColor = [UIColor performSelector:selector withObject:nil];
    }
    
//    if (![udBackgroundImage isEqualToString:@"none"] && udBackgroundImage != NULL) {
//        self.backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", udBackgroundImage]];
//    }
}

-(UIColor *)getBannerBackgroundColor
{
    return self.backgroundColor;
}

+ (MFMailComposeViewController *)mailTo:(NSString *)iEmail withSubject:(NSString *)iSubject withBody:(NSString *) iBody fromController:(UIViewController *)iController {
    
    if ([MFMailComposeViewController canSendMail]) {
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
    } else {
        return nil;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
