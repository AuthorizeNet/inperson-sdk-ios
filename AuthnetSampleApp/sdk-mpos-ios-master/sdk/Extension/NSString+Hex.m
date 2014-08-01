//
//  NSString+Hex.m
//  MobileMerchant
//
//  Created by MMA on 2/21/13.
// Implementation for category on string.
// Rajesh T
//

#import "NSString+Hex.h"

@implementation NSString (Hex)

/**
 Returns NSString from Hex.
 */
+ (NSString *) stringFromHex:(NSString *)str
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}

/**
 Converts a String to Hex.
 */
+ (NSString *) stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

/**
 Returns byte Array from Hex value passed in as String.
 */
+ (NSArray *) byteArrayFromHex:(NSString *)str
{
    NSMutableArray *stackedArray = [NSMutableArray array];
    for (int idx=0; idx+2<=str.length;idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [str substringWithRange:range];
        [stackedArray addObject:hexStr];
    }
    return stackedArray;
}

/**
 Returns int from Hex String.
 */
+ (int) hexValue:(NSString *)str {
	int n = 0;
	sscanf([str UTF8String], "%x", &n);
	return n;
}

@end
