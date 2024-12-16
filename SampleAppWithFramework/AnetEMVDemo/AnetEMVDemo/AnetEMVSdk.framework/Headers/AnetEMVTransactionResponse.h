//
//  AnetEMVTransactionResponse.h
//  AnetEMVSdk
//
//  Created by Pankaj Taneja on 10/26/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"
#import "Messages.h"
#import "GDataXMLNode.h"
#import "SplitTenderPayment.h"
#import "UserField.h"
#import "Error.h"
#import "AnetEMVResponse.h"

@interface AnetEMVTransactionResponse : AuthNetResponse {
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
    AnetEMVResponse *emvResponse;
    NSMutableArray *errors;
    SplitTenderPayment *splitTenderPayment;
    NSMutableArray *userFields;
    NSString *customerSignature;
    BOOL isTransactionSuccessful;
}

@property (nonatomic, strong) NSString *sessionToken;
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
@property (nonatomic, strong) NSString *entryMode;
@property (nonatomic, strong) NSString *splitTenderId;
@property (nonatomic, strong) Messages *messages;
@property (nonatomic, strong) AnetEMVResponse *emvResponse;
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, strong) SplitTenderPayment *splitTenderPayment;
@property (nonatomic, strong) NSMutableArray *userFields;
@property (nonatomic, strong) NSString *customerSignature;
@property (atomic, assign) BOOL isTransactionSuccessful;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetEMVTransactionResponse *) transactionResponse;

/**
 * TransactionResponse from parsing the XML response indexed by GDataXMLElement
 * @return TransactionResponse autorelease instance of the parser generated object.
 */
+ (AnetEMVTransactionResponse *) buildTransactionResponse:(NSData *)xmlData;
+ (AnetEMVTransactionResponse *)loadResponseFromFilename:(NSString *)filename;
@end
