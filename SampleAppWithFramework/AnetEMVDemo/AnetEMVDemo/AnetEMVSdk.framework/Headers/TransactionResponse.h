//
//  TransactionResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/17/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
#import "GDataXMLNode.h"
#import "SplitTenderPayment.h"
#import "UserField.h"
#import "Error.h"

@interface TransactionResponse : NSObject {

	NSString *responseCode;
	NSString *authCode;
	NSString *avsResultCode;
	NSString *cvvResultCode;
	NSString *cavvResultCode;
	NSString *transId;
	NSString *refTransID;
	NSString *transHash;
	NSString *testRequest;
	NSString *accountNumber;
	NSString *accountType;
    NSString *splitTenderId;
	Messages *messages;
	NSMutableArray *errors;
	SplitTenderPayment *splitTenderPayment;
	NSMutableArray *userFields;
}

@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *avsResultCode;
@property (nonatomic, strong) NSString *cvvResultCode;
@property (nonatomic, strong) NSString *cavvResultCode;
@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *refTransID;
@property (nonatomic, strong) NSString *transHash;
@property (nonatomic, strong) NSString *testRequest;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *splitTenderId;
@property (nonatomic, strong) Messages *messages;
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, strong) SplitTenderPayment *splitTenderPayment;
@property (nonatomic, strong) NSMutableArray *userFields;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (TransactionResponse *) transactionResponse;

/**
 * TransactionResponse from parsing the XML response indexed by GDataXMLElement
 * @return TransactionResponse autorelease instance of the parser generated object.
 */
+ (TransactionResponse *) buildTransactionResponse:(GDataXMLElement *)element;
@end
