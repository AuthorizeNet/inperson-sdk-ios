//
//  ExtendedAmountType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import "ExtendedAmountType.h"
#import "NSString+stringWithXMLTag.h"
#import "NSString+stringValueOfXMLElement.h"


@implementation ExtendedAmountType

@synthesize amount;
@synthesize name;
@synthesize amountDescription;

+ (ExtendedAmountType *)extendedAmountType {
    ExtendedAmountType *e = [[ExtendedAmountType alloc] init];
    return e;
}

- (id) init {
    self = [super init];
    if (self) {
        self.amount = nil;
        self.name = nil;
        self.amountDescription = nil;
    }
    return self;
}

- (NSString *) description {
    NSString * s = [NSString stringWithFormat:@""
					"ExtendedAmountType.amount = %@\n"
					"ExtendedAmountType.name = %@\n"
					"ExtendedAmountType.amountDescription = %@\n",
					self.amount,
					self.name,
                    self.amountDescription];
	
	return s;
}



- (NSString *)stringOfXMLRequest {
    NSString *s = [NSString stringWithFormat:@""
                   @"%@"       //amount
                   @"%@"       //name
                   @"%@",       //amountDescription
                   [NSString stringWithXMLTag:@"amount" andValue:self.amount],
                   [NSString stringWithXMLTag:@"name" andValue:self.name],
                   [NSString stringWithXMLTag:@"description" andValue:self.amountDescription]];
    return s;
    
}


+ (ExtendedAmountType *)buildExtendedAmountType:(GDataXMLElement *)element {
	ExtendedAmountType *a = [ExtendedAmountType extendedAmountType];
	
	a.amount = [NSString stringValueOfXMLElement:element withName:@"amount"];
	a.name = [NSString stringValueOfXMLElement:element withName:@"name"];
	a.amountDescription = [NSString stringValueOfXMLElement:element withName:@"description"];
	
	return a;
}

@end
