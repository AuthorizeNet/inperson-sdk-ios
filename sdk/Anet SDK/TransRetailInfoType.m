//
//  TransRetailInfoType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TransRetailInfoType.h"
#import "NSString+stringWithXMLTag.h"


@implementation TransRetailInfoType

@synthesize marketType;
@synthesize deviceType;

+ (TransRetailInfoType *) transRetailInfoType {
    TransRetailInfoType *t = [[TransRetailInfoType alloc] init];
    return t;
}

- (id) init {
    self = [super init];
    if (self) {
        self.marketType = nil;
        self.deviceType = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"TransRetailInfoType.marketType = %@"
                        @"TransRetailInfoType.deviceType = %@",
                        self.marketType,
                        self.deviceType];
    return output;
}

- (NSString *)stringOfXMLRequest {
    NSString *s = [NSString stringWithFormat:@""
                   @"%@"    //marketType
                   @"%@",    //deviceType
                   [NSString stringWithXMLTag:@"marketType" andValue:self.marketType],
                   [NSString stringWithXMLTag:@"deviceType" andValue:self.deviceType]];
    return s;
}

@end
