//
//  CCAuthenticationType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCAuthenticationType : NSObject {

    NSString *authenticationIndicator;
    NSString *cardholderAuthenticationValue;
}

@property (nonatomic, strong) NSString *authenticationIndicator;
@property (nonatomic, strong) NSString *cardholderAuthenticationValue;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (CCAuthenticationType *) ccAuthenticationType;
@end
