//
//  LogoutRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/7/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

/**
 * Requst object that has pointers to each of the different objects
 * required in a logout request.
 * NOTE: Consult Authorize.Net guide for the minimal fields required for the logout request..
 */
@interface LogoutRequest : AuthNetRequest {
}

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (LogoutRequest *) logoutRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
