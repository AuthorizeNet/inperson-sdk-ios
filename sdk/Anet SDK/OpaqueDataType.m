//
//  OpaqueDataType.m
//  Anet SDK
//
//  Created by Authorize.Net on 25/06/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "OpaqueDataType.h"
#import "NSString+stringWithXMLTag.h"

@implementation OpaqueDataType

@synthesize dataDescriptor;
@synthesize dataValue;


+ (id) opaqueDataType {
	OpaqueDataType *fp = [[OpaqueDataType alloc] init];
	return fp;
}

- (id) init {
    self = [super init];
	if (self) {
		dataDescriptor = nil;
		dataValue = nil;
	}
	return self;
}



- (NSString *) stringOfXMLRequest
{
    NSString *s = nil;
            s = [NSString stringWithFormat:@"<opaqueData>"
             @"%@"
             @"%@"
             @"</opaqueData>",
             [NSString stringWithXMLTag:@"dataDescriptor" andValue: self.dataDescriptor],
             [NSString stringWithXMLTag:@"dataValue" andValue:self.dataValue]];
    
    return s;
}

- (NSString *)description {
	NSString *output = [NSString stringWithFormat:@""
						"opaqueDataType.dataDescriptor = %@\n"
						"opaqueDataType.dataValue = %@\n",
						self.dataDescriptor,
						self.dataValue];
	return output;
}

@end
