//
//  AuthNetUnitTests.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 8/25/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 1

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

/**
 * AuthNetUnitTests. Unit tests for the SDK.  To run
 * the unit test, set target of the XCode project to UnitTests and build.
 */
@class CreateTransactionRequest;

@interface AuthNetUnitTests : SenTestCase {
}

#if USE_APPLICATION_UNIT_TEST
//- (void) testAppDelegate;       // simple test on application
#else
- (void) testMath;              // simple standalone test
#endif

@end
