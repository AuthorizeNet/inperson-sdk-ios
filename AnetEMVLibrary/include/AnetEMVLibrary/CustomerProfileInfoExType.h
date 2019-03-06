//
//  CustomerProfileInfoExType.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/3/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface CustomerProfileInfoExType : NSObject

@property (nonatomic, strong) NSString *merchantCustomerId;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *customerProfileId;

@property (nonatomic, strong) NSString *profileType;


- (NSString *)stringOfXMLRequest;

+ (CustomerProfileInfoExType *) buildCustomerProfile:(GDataXMLElement *)element;

@end
