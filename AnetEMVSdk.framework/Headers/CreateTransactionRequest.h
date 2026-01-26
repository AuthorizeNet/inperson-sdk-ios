//
//  CreateTransactionRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 8/17/10.
//  Copyright 2010 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"
#import "TransactionRequestType.h"

#define MAX_CUSTOMER_IP_LENGTH 15

/**
 * The different transaction types
 */
typedef enum AuthNetActions {
	AUTH_ONLY,
	AUTH_CAPTURE,
	PRIOR_AUTH_CAPTURE,
	CAPTURE_ONLY,
	VOID,
	CREDIT,
	UNLINKED_CREDIT,
	ACTION_UNKNOWN
}AUTHNET_ACTION;


/**
 * Requst object that has pointers to each of the different objects
 * required in a AIM transaction.
 * NOTE: Consult AIM Guide for the minimal fields required for each transaction type.
 */
@interface CreateTransactionRequest : AuthNetRequest {
    TransactionRequestType *transactionRequest;
    
	//Transaction Information used for PRIOR_AUTH_CAPTURE, CREDIT, VOID    
    AUTHNET_ACTION transactionType;
}

@property (nonatomic, strong) TransactionRequestType *transactionRequest;
@property (nonatomic) AUTHNET_ACTION transactionType;

/**
 * Creates an autoreleased  object;
 * @return  an autoreleased  object.
 */
+ (CreateTransactionRequest *) createTransactionRequest;

/**
 * Checks that the fields of the request pass validation check.
 */
- (BOOL) isValid;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
