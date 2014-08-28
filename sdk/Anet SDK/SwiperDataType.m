//
//  SwiperDataType.m
//  ANMobilePaymentLib
//
//  Created by Rajesh T on 1/29/13.
//
//

#import "SwiperDataType.h"

@implementation SwiperDataType

@synthesize deviceDescription;
@synthesize encryptedValue;
@synthesize encryptionType;

+ (SwiperDataType *) swiperDataType {
    SwiperDataType *b = [[SwiperDataType alloc] init];
    return b;
}

- (id) init {
    self = [super init];
    if (self) {
        //Initialize fields here
        self.deviceDescription = nil;
        self.encryptedValue = nil;
        self.encryptionType = nil;

    }
    return self;
}

- (NSString *) description {
    NSString *output = [NSString stringWithFormat:@""
                        @"SwiperDataType.deviceDescription = %@"
                        @"SwiperDataType.encryptedValue = %@"
                        @"SwiperDataType.encryptionType= %@",
                        self.deviceDescription,
                        self.encryptedValue,
                        self.encryptionType];
    return output;
}

- (NSString *) stringOfXMLRequest {
    NSString *s = [NSString stringWithFormat:@""
                   @"<encryptedTrackData>"
                   @"<FormOfPayment>"
                   @"<Value>"
                   @"<Encoding>Hex</Encoding>"
                   @"<EncryptionAlgorithm>"
                   @"%@"
                   @"</EncryptionAlgorithm>"
                   @"<Scheme>"
                   @"<DUKPT>"
                   @"<Operation>DECRYPT</Operation>"
                   @"<Mode>"
                  // @"<PIN>text</PIN>"
                   @"<Data>Data</Data>"
                   @"</Mode>"
                   @"<DeviceInfo>"
                   @"<Description>"
                   @"%@"  // Descrition for swiper data
                   @"</Description>"
                   @"</DeviceInfo>"
                   @"<EncryptedData>"
                   @"<Value>"
                   @"%@"       //EncryptedValue
                   @"</Value>"
                   @"</EncryptedData>"
                   @"</DUKPT>"
                   @"</Scheme>"
                   @"</Value>"
                   @"</FormOfPayment>"
                   @"</encryptedTrackData>",
                   self.encryptionType,
                   self.deviceDescription,
                   self.encryptedValue];
    return s;
}


@end
