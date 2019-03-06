//
//  AnetCustomerProfileUISettings.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 9/28/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnetCustomerProfileUISettings : NSObject

/*!
 Returns singleton AnetEMVUISettings object
 */
+ (AnetCustomerProfileUISettings *)sharedUISettings;

/*!
 backgroundColor: Container view back ground color on all screens.
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/*!
 backgroundImage: Container view background image
 */
@property (nonatomic, strong) UIImage *backgroundImage;
/*!
 titleFontColor
 */
@property (nonatomic, strong) UIColor *titleFontColor;
/*!
 submitButtonColor
 */
@property (nonatomic, strong) UIColor *submitButtonColor;
/*!
 submitButtonTextColor
 */
@property (nonatomic, strong) UIColor *submitButtonTextColor;
/*!
 cancelButtonTextColor
 */
@property (nonatomic, strong) UIColor *cancelButtonTextColor;
/*!
 cancelButtonColor
 */
@property (nonatomic, strong) UIColor *cancelButtonColor;
/*!
 textFieldBorderColor
 */
@property (nonatomic, strong) UIColor *textFieldBorderColor;

/*!
 textFieldBorderColor
 */
@property (nonatomic, strong) UIColor *textFieldTextColor;

/*!
 pageTitle
 */
@property (nonatomic, strong) NSString *pageTitle;
/*!
 pageTitleColor
 */
@property (nonatomic, strong) UIColor *pageTitleColor;

@end
