//
//  AnetProfileDemoUISettings.h
//  AnetEMVDemo
//
//  Created by Manjappa, Chinthan on 10/9/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface AnetProfileDemoUISettings : NSObject <MFMailComposeViewControllerDelegate>

/*!
backgroundColor
*/
@property (nonatomic, strong) UIColor *backgroundColor;
/*!
 textFontColor
 */
@property (nonatomic, strong) UIColor *submitButtonBGColor;
/*!
 buttonColor
 */
@property (nonatomic, strong) UIColor *submitButtonTextColor;
/*!
 buttonTextColor
 */
@property (nonatomic, strong) UIColor *cancelButtonBGColor;
/*!
 buttonTextColor
 */
@property (nonatomic, strong) UIColor *cancelButtonTextColor;
/*!
 buttonTextColor
 */
@property (nonatomic, strong) UIColor *titleTextColor;
/*!
 buttonTextColor
 */
@property (nonatomic, strong) UIColor *textFieldBorderColor;

- (UIColor *)getBannerBackgroundColor;
- (void) registerDefaultsFromSettingsBundle;
- (void) readFromSettingsBundle;
/*!
 Returns singleton UISettingsBundle object
 */
+ (AnetProfileDemoUISettings *) sharedInstance;
+ (MFMailComposeViewController *)mailTo:(NSString *)iEmail withSubject:(NSString *)iSubject withBody:(NSString *) iBody fromController:(UIViewController *)iController;
@end
