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
 backgroundColor
 */
@property (nonatomic, assign) UIColor *backgroundColor;
/*!
 textFontColor
 */
@property (nonatomic, assign) UIColor *textFontColor;
/*!
 buttonColor
 */
@property (nonatomic, assign) UIColor *buttonColor;
/*!
 buttonTextColor
 */
@property (nonatomic, assign) UIColor *buttonTextColor;
/*!
 logoImage
 */
@property (nonatomic, strong) UIImage *logoImage;
/*!
 bannerBackgroundColor
 */
@property (nonatomic, assign) UIColor *bannerBackgroundColor;

@end
