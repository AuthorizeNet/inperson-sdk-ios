//
//  AnetGetCustomerProfileRequest.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 9/4/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"

@interface AnetGetCustomerProfileRequest : AuthNetRequest

@property (nonatomic, strong) NSString *refID;
@property (nonatomic, strong) NSString *customerProfileId;
@property (nonatomic, strong) NSString *merchantCustomerId;
@property (nonatomic, strong) NSString *email;
@property (atomic, assign) BOOL unmaskExpirationDate;
@property (atomic, assign) BOOL includeIssuerInfo;

+ (AnetGetCustomerProfileRequest *) getRequest;

@end
