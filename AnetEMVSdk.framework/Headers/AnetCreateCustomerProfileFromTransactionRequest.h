//
//  AnetCreateCustomerProfileFromTransactionRequest.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 7/27/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerProfileBaseType.h"
#import "AuthNetRequest.h"

@interface AnetCreateCustomerProfileFromTransactionRequest : AuthNetRequest 

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *transactionkey;
@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) CustomerProfileBaseType *customer;
@property (nonatomic, strong) NSString *transactionProfileId;
@property (nonatomic, strong) NSString *profileType;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetCreateCustomerProfileFromTransactionRequest *) transactionRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *)stringOfXMLRequest;

@end
