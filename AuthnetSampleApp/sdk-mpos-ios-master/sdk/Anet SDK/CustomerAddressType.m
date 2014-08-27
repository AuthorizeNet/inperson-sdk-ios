//
//  CustomerAddressType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/22/11.
//  Copyright 2011 none. All rights reserved.
//

#import "CustomerAddressType.h"
#import "NSString+stringWithXMLTag.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation CustomerAddressType

@synthesize phoneNumber;
@synthesize faxNumber;

+ (CustomerAddressType *) customerAddressType {
    CustomerAddressType *c = [[CustomerAddressType alloc] init];
    return c;
}

- (id) init {
    self = [super init];
    if (self) {
        self.phoneNumber = nil;
        self.faxNumber = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"CustomerAddressType.firstName = %@\n"
                        @"CustomerAddressType.lastName = %@\n"
                        @"CustomerAddressType.company = %@\n"
                        @"CustomerAddressType.address = %@\n"
                        @"CustomerAddressType.city = %@\n"
                        @"CustomerAddressType.state = %@\n"
                        @"CustomerAddressType.zip = %@\n"
                        @"CustomerAddressType.country = %@\n"
                        @"CustomerAddressType.phoneNumber = %@\n"
                        @"CustomerAddressType.faxNumber = %@\n",
                        self.firstName,
                        self.lastName,
                        self.address,
                        self.city,
                        self.company,
                        self.state,
                        self.zip,
                        self.country,
                        self.phoneNumber,
                        self.faxNumber];
    return output;
}

- (NSString *) stringOfXMLRequest 
{
	NSString *s = [NSString stringWithFormat:@""
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@"
                   @"%@",
                   [NSString stringWithXMLTag:@"firstName" andValue:self.firstName],
                   [NSString stringWithXMLTag:@"lastName" andValue:self.lastName],
                   [NSString stringWithXMLTag:@"company" andValue:self.company],
                   [NSString stringWithXMLTag:@"address" andValue:self.address],
                   [NSString stringWithXMLTag:@"city" andValue:self.city],
                   [NSString stringWithXMLTag:@"state" andValue:self.state],
                   [NSString stringWithXMLTag:@"zip" andValue:self.zip],
                   [NSString stringWithXMLTag:@"country" andValue:self.country],
                   [NSString stringWithXMLTag:@"phoneNumber" andValue:self.phoneNumber],
                   [NSString stringWithXMLTag:@"faxNumber" andValue:self.faxNumber]];
    
	return s;
}


+ (CustomerAddressType *)buildCustomerAddressType:(GDataXMLElement *)element {
    CustomerAddressType *c = [CustomerAddressType customerAddressType];
    
    c.firstName = [NSString stringValueOfXMLElement:element withName:@"firstName"];
    c.lastName = [NSString stringValueOfXMLElement:element withName:@"lastName"];
    c.company = [NSString stringValueOfXMLElement:element withName:@"company"];
    c.address = [NSString stringValueOfXMLElement:element withName:@"address"];
    c.city = [NSString stringValueOfXMLElement:element withName:@"city"];
    c.state = [NSString stringValueOfXMLElement:element withName:@"state"];
    c.zip = [NSString stringValueOfXMLElement:element withName:@"zip"];
    c.country = [NSString stringValueOfXMLElement:element withName:@"country"];
    c.phoneNumber = [NSString stringValueOfXMLElement:element withName:@"phoneNumber"];
    c.faxNumber = [NSString stringValueOfXMLElement:element withName:@"faxNumber"];
    return c;
}

@end
