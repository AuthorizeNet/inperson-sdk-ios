//
//  MobileDeviceRegistrationRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"
#import "MobileDeviceType.h"

/**
 * Requst object that has pointers to each of the different objects
 * required in the reporting API mobileDeviceRegistrationRequest transaction.
 * NOTE: Consult Authorize.Net guide for the minimal fields required the transaction.
 */
@interface MobileDeviceRegistrationRequest : AuthNetRequest {

	MobileDeviceType *mobileDevice;
}

@property (nonatomic, strong) MobileDeviceType *mobileDevice;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (MobileDeviceRegistrationRequest *) mobileDeviceRegistrationRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
