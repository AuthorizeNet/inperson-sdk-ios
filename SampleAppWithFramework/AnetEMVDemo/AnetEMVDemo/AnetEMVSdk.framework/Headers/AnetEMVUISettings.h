//
//  AnetEMVUISettings.h
//  AnetEMVSdk
//
//  Created by Senthil Kumar Periyasamy on 7/13/16.
//  Copyright © 2016 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnetEMVUISettings : NSObject

/*!
 Returns singleton AnetEMVUISettings object
 */
+ (AnetEMVUISettings *)sharedUISettings;

/*!
 backgroundColor: Container view back ground color on all screens.
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/*!
 backgroundImage: Container view background image
 */
@property (nonatomic, strong) UIImage *backgroundImage;
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
 logoImage: Top/Title bar background image
 */
@property (nonatomic, strong) UIImage *logoImage;
/*!
 bannerBackgroundColor: Top/Title bar background color
 */
@property (nonatomic, strong) UIColor *bannerBackgroundColor;

/*!
 signature screen background image
 */
@property (nonatomic, strong) UIImage *signatureScreenBackgroundImage;

/*!
 signature pad background image
 */
@property (nonatomic, strong) UIImage *signaturePadBackgroundImage;

/*!
 signature pad border color
 */
@property (nonatomic, strong) UIColor *signaturePadBorderColor;

/*!
 signature pad border width
 */
@property (nonatomic, assign) CGFloat signaturePadBorderWidth;

/*!
 signature pad corner radius
 */
@property (nonatomic, assign) CGFloat signaturePadCornerRadius;


@end
