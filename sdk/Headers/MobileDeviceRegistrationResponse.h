//
//  MobileDeviceRegistrationResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"


/**
 * Response object that has pointers to each of the different objects
 * required in a MobileDeviceRegistrationResponse transaction.
 * NOTE: Consult Authorize.Net Guide for the minimal fields required for each transaction type.
 */
@interface MobileDeviceRegistrationResponse : AuthNetResponse {
}

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (MobileDeviceRegistrationResponse *) mobileDeviceRegistrationResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * MobileDeviceRegistrationResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed MobileDeviceRegistrationResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (MobileDeviceRegistrationResponse *)loadMobileDeviceRegistrationResponseFromFilename:(NSString *)filename;

// For unit testing.
+ (MobileDeviceRegistrationResponse *)parseMobileDeviceRegistrationResponse:(NSData *)xmlData;
@end
