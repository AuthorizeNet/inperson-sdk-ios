//
//  NameAndAddressType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/22/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NameAndAddressType.h"
#import "NSString+stringWithXMLTag.h"
#import "NSString+stringValueOfXMLElement.h"

@implementation NameAndAddressType

@synthesize firstName;
@synthesize lastName;
@synthesize company;
@synthesize address;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize country;

+ (NameAndAddressType *) nameAndAddressType {
    NameAndAddressType *n = [[NameAndAddressType alloc] init];
    return n;
}

- (id) init {
    self = [super init];
    if (self) {
        self.firstName = nil;
        self.lastName = nil;
        self.company = nil;
        self.address = nil;
        self.city = nil;
        self.state = nil;
        self.zip = nil;
        self.country = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"NameAndAddressType.firstName = %@\n"
                        @"NameAndAddressType.lastName = %@\n"
                        @"NameAndAddressType.company = %@\n"                        
                        @"NameAndAddressType.address = %@\n"                        
                        @"NameAndAddressType.city = %@\n"                        
                        @"NameAndAddressType.state = %@\n"                        
                        @"NameAndAddressType.zip = %@\n"                        
                        @"NameAndAddressType.country = %@\n",                        
                        self.firstName,
                        self.lastName,
                        self.company,
                        self.address,
                        self.city,
                        self.state,
                        self.zip,
                        self.country];
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
                   @"%@",
                   [NSString stringWithXMLTag:@"firstName" andValue:self.firstName],
                   [NSString stringWithXMLTag:@"lastName" andValue:self.lastName],
                   [NSString stringWithXMLTag:@"company" andValue:self.company],
                   [NSString stringWithXMLTag:@"address" andValue:self.address],
                   [NSString stringWithXMLTag:@"city" andValue:self.city],
                   [NSString stringWithXMLTag:@"state" andValue:self.state],
                   [NSString stringWithXMLTag:@"zip" andValue:self.zip],
                   [NSString stringWithXMLTag:@"country" andValue:self.country]];
    
	return s;
}


+ (NameAndAddressType *) buildNameAndAddressType:(GDataXMLElement *)element {
    NameAndAddressType *n = [NameAndAddressType nameAndAddressType];
    n.firstName = [NSString stringValueOfXMLElement:element withName:@"firstName"];
    n.lastName = [NSString stringValueOfXMLElement:element withName:@"lastName"];
    n.company = [NSString stringValueOfXMLElement:element withName:@"company"];
    n.address = [NSString stringValueOfXMLElement:element withName:@"address"];
    n.city = [NSString stringValueOfXMLElement:element withName:@"city"];
    n.state = [NSString stringValueOfXMLElement:element withName:@"state"];
    n.zip = [NSString stringValueOfXMLElement:element withName:@"zip"];
    n.country = [NSString stringValueOfXMLElement:element withName:@"country"];
    return n;
}


@end
