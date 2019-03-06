//
//  AnetUpdateCustomerProfileRequest.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 7/31/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerProfileInfoExType.h"
#import "AuthNetRequest.h"
#import "GDataXMLNode.h"

@interface AnetUpdateCustomerProfileRequest: AuthNetRequest
 
@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) CustomerProfileInfoExType *profile;


/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AnetUpdateCustomerProfileRequest *) transactionRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *)stringOfXMLRequest;

@end


