//
//  AuthNetResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/30/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANetApiResponse.h"
/**
 * Server or Application error during transaction
 * 
 */
typedef enum AuthNetFailures {
	NO_ERROR,
	SERVER_ERROR,
	TRANSACTION_ERROR,
	CONNECTION_ERROR,
    NO_CONNECTION_ERROR,
}AUTHNET_FAILURE;

@interface AuthNetResponse : NSObject {
	AUTHNET_FAILURE errorType;
	NSString *responseReasonText;
	ANetApiResponse *anetApiResponse;
}

@property (nonatomic) AUTHNET_FAILURE errorType;
@property (nonatomic, strong) NSString *responseReasonText;
@property (nonatomic, strong) ANetApiResponse *anetApiResponse;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AuthNetResponse *) authNetResponse;

@end
