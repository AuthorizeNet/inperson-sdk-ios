//
//  MobileDevice.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MobileDeviceType : NSObject {
	NSString *mobileDeviceId;
	NSString *mobileDescription;
	NSString *phoneNumber;
  NSString *devicePlatform;
}

@property (nonatomic, strong) NSString *mobileDeviceId;
@property (nonatomic, strong) NSString *mobileDescription;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *devicePlatform;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (MobileDeviceType *) mobileDevice;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
