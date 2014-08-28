//
//  stringForRFC3339DateTimeString.m
//  MobileMerchant
//
//  Created by Shiun Hwang on 5/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSString+stringForRFC3339DateTimeString.h"

@interface NSString (private)
+ (NSString *)normalizeRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;
@end

@implementation NSString (stringForRFC3339DateTimeString)

+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString dateStyle:(NSDateFormatterStyle)dStyle timeStyle:(NSDateFormatterStyle)tStyle
// Returns a user-visible date time string that corresponds to the 
// specified RFC 3339 date time string. Note that this does not handle 
// all possible RFC 3339 date time strings, just one of the most common 
// styles.
{
    NSString *          userVisibleDateTimeString;
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
    NSDateFormatter *   userVisibleDateFormatter;
    
    userVisibleDateTimeString = nil;
    
    // Convert the RFC 3339 date time string to an NSDate.
    
    rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    assert(rfc3339DateFormatter != nil);
    
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    assert(enUSPOSIXLocale != nil);
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    rfc3339DateTimeString = [NSString normalizeRFC3339DateTimeString:rfc3339DateTimeString];
    date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    if (date != nil) {
        
        // Convert the NSDate to a user-visible date string.
        
        userVisibleDateFormatter = [[NSDateFormatter alloc] init];
        assert(userVisibleDateFormatter != nil);
        
        [userVisibleDateFormatter setDateStyle:dStyle];
        [userVisibleDateFormatter setTimeStyle:tStyle];
        
        userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}

+ (NSString *)normalizeRFC3339DateTimeString:(NSString *)rfc3339DateTimeString
// Because of the possible presence and absence of the fractional seconds in
// the returned UTC time string, this method will remove the fractional seconds.
// The fractional second starts with '.'.
{
    NSArray *parts = [rfc3339DateTimeString componentsSeparatedByString:@"."];
    NSMutableString *result = nil;
    if ([parts count] == 2) {
        result = [NSMutableString stringWithString:[parts objectAtIndex:0]];
        [result appendString:@"Z"];
    } else if ([parts count] == 1) {
        result = [NSMutableString stringWithString:rfc3339DateTimeString];
    }
    return result;
}
@end
