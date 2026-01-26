//
//  TestAccountCaptchaRequest.h
//  Anet SDK
//
//  Created by Qian Wang on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

/**
 * Requst object that has pointers to each of the different objects
 * required in a logout request.
 * NOTE: Consult Authorize.Net guide for the minimal fields required for the logout request..
 */
@interface TestAccountCaptchaRequest : AuthNetRequest {
}

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TestAccountCaptchaRequest *) testAccountCaptchaRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
