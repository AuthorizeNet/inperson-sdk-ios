//
//  TestAccountRegistrationRequest.h
//  Anet SDK
//
//  Created by Tejus Chavan on 12/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"
#import "MobileDeviceType.h"

@interface TestAccountRegistrationRequest : AuthNetRequest{
    
	MobileDeviceType *mobileDevice;
}

@property (nonatomic, strong) MobileDeviceType *mobileDevice;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TestAccountRegistrationRequest *) testAccountRegistrationRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;


@end
