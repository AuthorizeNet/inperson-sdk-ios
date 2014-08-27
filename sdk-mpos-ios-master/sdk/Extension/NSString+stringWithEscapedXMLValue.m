//
//  NSString+stringWithEscapedXMLValue.m
//  ANMobilePaymentLib
//
//  Created by Shiun Hwang on 6/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSString+stringWithEscapedXMLValue.h"


@implementation NSString (stringWithEscapedXMLValue)


+ (NSString *) stringWithEscapedXMLValue:(NSString *)value {
    NSArray *specialCharacters = [NSArray arrayWithObjects:@"&", @"\"",@"'", @"<", @">", nil];
    NSArray *escapedCharacters = [NSArray arrayWithObjects:@"&amp;", @"&quot;", @"&apos;", @"&lt;", @"&gt;", nil];
    
    for (int index = 0; index < [specialCharacters count]; index++) {
        value = [value stringByReplacingOccurrencesOfString:[specialCharacters objectAtIndex:index] withString:[escapedCharacters objectAtIndex:index]];
    }
    return [NSString stringWithString:value];
}

@end
