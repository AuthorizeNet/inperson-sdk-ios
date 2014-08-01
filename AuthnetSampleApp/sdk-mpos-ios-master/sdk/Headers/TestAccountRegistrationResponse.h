//
//  TestAccountRegistrationResponse.h
//  Anet SDK
//
//  Created by Shankar Gosain on 12/01/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"


/**
 * Response object that has pointers to each of the different objects
 * required in a TestAccountRegistrationResponse transaction.
 *
 */
@interface TestAccountRegistrationResponse : AuthNetResponse{
    NSString *registrationResponeMsg;
    
}

@property (strong, nonatomic) NSString *registrationResponseMsg;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TestAccountRegistrationResponse *) testAccountRegistrationResponse;

/**
 * Class method that takes in NSData and returns a fully parsed
 * TestAccountRegistrationResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed TestAccountRegistrationResponse from parsing the NSData or nil if unable
 * to parse the data.
 */
+ (TestAccountRegistrationResponse *)loadTestAccountRegistrationResponseFromFilename:(NSString *)filename;

// For unit testing.
+ (TestAccountRegistrationResponse *)parseTsetAccountRegistrationResponse:(NSData *)xmlData;


@end
