//
//  NSString+Hex.h
//  MobileMerchant
//
//  Created by MMA on 2/21/13.
//Category for Converting String to Hex and Vice-versa
// Rajesh T
//

#import <Foundation/Foundation.h>

/** 
 Category on NString with Hex methods.
 */
@interface NSString (Hex)

/**  
 Returns NSString from given hex input.
 */
+ (NSString *) stringFromHex:(NSString *)str;

/** Returns Byte Array from hex Input.
*/
+ (NSArray *) byteArrayFromHex:(NSString *)str;

/** 
 Converts a given NSString into Hex.
 */
+ (NSString *) stringToHex:(NSString *)str;

/** 
 Returns an int from Hex value.
 */
+(int) hexValue:(NSString *)str;


@end
