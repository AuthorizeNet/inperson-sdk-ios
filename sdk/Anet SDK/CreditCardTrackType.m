//
//  CreditCardTrackType.m
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "CreditCardTrackType.h"
#import "NSString+stringWithXMLTag.h"


@implementation CreditCardTrackType

@synthesize track1;
@synthesize track2;

+ (CreditCardTrackType *) creditCardTrackType {
    CreditCardTrackType *c = [[CreditCardTrackType alloc] init];
    return c;
}

- (id) init {
    self = [super init];
    if (self) {
        self.track1 = nil;
        self.track2 = nil;
    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"CreditCardTrackType.track1 = %@"
                        @"CreditCardTrackType.track2 = %@",
                        self.track1,
                        self.track2];
    return output;
}

- (NSString *) stringOfXMLRequest {
    NSString *s = [NSString stringWithFormat:@""
                   @"<trackData>"
                        @"%@"       //track1
                        @"%@"       //track2
                   @"</trackData>",
                   [NSString stringWithXMLTag:@"track1" andValue:self.track1],
                   [NSString stringWithXMLTag:@"track2" andValue:self.track2]];
    return s;
}
@end
