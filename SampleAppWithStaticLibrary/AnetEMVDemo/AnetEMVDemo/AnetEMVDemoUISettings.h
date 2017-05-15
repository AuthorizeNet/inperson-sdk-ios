//
//  AnetEMVDemoUISettings.h
//  AnetEMVDemo
//
//  Created by Senthil Kumar Periyasamy on 7/21/16.
//  Copyright © 2016 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AnetEMVDemoUISettings : NSObject <MFMailComposeViewControllerDelegate>
/*!
 backgroundColor
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/*!
 textFontColor
 */
@property (nonatomic, strong) UIColor *textFontColor;
/*!
 buttonColor
 */
@property (nonatomic, strong) UIColor *buttonColor;
/*!
 buttonTextColor
 */
@property (nonatomic, strong) UIColor *buttonTextColor;
/*!
 logoImage
 */
@property (nonatomic, strong) UIImage *logoImage;
/*!
 bannerBackgroundColor
 */
@property (nonatomic, strong) UIColor *bannerBackgroundColor;
/*!
 backgroundImage
 */
@property (nonatomic, strong) UIImage *backgroundImage;

- (UIColor *)getBannerBackgroundColor;
- (void) registerDefaultsFromSettingsBundle;
- (void) readFromSettingsBundle;
/*!
 Returns singleton UISettingsBundle object
 */
+ (AnetEMVDemoUISettings *) sharedInstance;
+ (MFMailComposeViewController *)mailTo:(NSString *)iEmail withSubject:(NSString *)iSubject withBody:(NSString *) iBody fromController:(UIViewController *)iController;
@end
