//
//  SettingType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingType : NSObject {
	NSString *name;
	NSString *value;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (SettingType *) settingType;

/**
 * Validate that fields are valid in terms of length and acceptable values.
 * @return BOOL returns whether values are valid.
 */
- (BOOL) isValid;
/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
