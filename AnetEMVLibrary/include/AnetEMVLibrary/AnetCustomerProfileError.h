//
//  AnetCustomerProfileError.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/6/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AnetEMVError;

typedef NS_ENUM (NSInteger, ANETCustomerProfileStatusCode) {
    ANETCustomerProfileSuccess = 1,
    ANETCustomerProfileConnectionError,
    ANETCustomerProfileFailed,
    ANETEMVTransactionFailed,
    ANETConsentDenied

};
@interface AnetCustomerProfileError : NSError

@property (nonatomic, assign) ANETCustomerProfileStatusCode statusCode;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) AnetEMVError *transactionError;

- (instancetype)initWithStatusCode:(ANETCustomerProfileStatusCode)iStatusCode
                       andMessage:(NSString *)iMessage;
@end
