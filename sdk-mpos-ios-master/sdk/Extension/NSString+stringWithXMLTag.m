//
//  NSString+stringWithXMLTag.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSString+stringWithXMLTag.h"
#import "NSString+stringWithEscapedXMLValue.h"

@implementation NSString (stringWithXMLTag)

+ (NSString *)stringWithXMLTag:(NSString *)t andValue:(NSString *)v {
	if (v == nil) {
		return @"";
    }
	else { 
        v = [NSString stringWithEscapedXMLValue:v];
		return [NSString stringWithFormat:@"<%@>%@</%@>", t, v, t];
    }
}

@end
