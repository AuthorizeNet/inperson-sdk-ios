//
//  FingerPrintObjectType.m
//  Anet SDK
//
//  Created by Authorize.Net on 25/06/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "FingerPrintObjectType.h"
#import "NSString+stringWithXMLTag.h"

//@interface FingerPrintObjectType ()
//
//@property (nonatomic, strong) NSString *hashValue;
//@property (nonatomic, assign) NSInteger sequenceNumber;
//@property (nonatomic, assign) NSTimeInterval timeStamp;
//
//@end

@implementation FingerPrintObjectType

@synthesize hashValue;
@synthesize sequenceNumber;
@synthesize timeStamp;


+ (id) fingerPrintObjectType {
	FingerPrintObjectType *fp = [[FingerPrintObjectType alloc] init];
	return fp;
}

- (id) init {
    self = [super init];
	if (self) {
		hashValue = nil;
		sequenceNumber = 0;
        
        NSDate *now = [NSDate date];
        long long nowAsLong = [now timeIntervalSince1970];
		timeStamp = nowAsLong;
	}
	return self;
}



- (NSString *) stringOfXMLRequest
{
    NSString *s = nil;
    
    if ([self.hashValue length] != 0) {
        s = [NSString stringWithFormat:@""
             @"<fingerPrint>"
             @"%@"
             @"%@"
             @"%@"	//cardCode
             @"</fingerPrint>",
             [NSString stringWithXMLTag:@"hashValue" andValue: self.hashValue],
             [NSString stringWithXMLTag:@"sequence" andValue:[NSString stringWithFormat:@"%d",self.sequenceNumber]],
             [NSString stringWithXMLTag:@"timestamp" andValue:[NSString stringWithFormat:@"%lld",self.timeStamp]]];
    } 	return s;
}

- (NSString *)description {
	NSString *output = [NSString stringWithFormat:@""
						"FingerPrintType.secretKey = %@\n"
						"FingerPrintType.sequenceNumber = %d\n"
						"FingerPrintType.timeStamp = %lld",
						self.hashValue,
						self.sequenceNumber,
						self.timeStamp];
	return output;
}



@end
