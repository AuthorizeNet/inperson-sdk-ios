//
//  DecimalKeypadView.m
//  Decimal Entry Test
//
//  Created by Colin Barrett on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DecimalKeypadView.h"

#define FLOAT_COLOR_VALUE(n) (n)/255.0

@interface DecimalKeypadView ()
@property (nonatomic, retain, readwrite) NSDecimalNumber *number;
@end

@implementation DecimalKeypadView
@synthesize leftBottomButton;
@synthesize leftBottomTitle;

static NSDecimalNumberHandler *decimalNumberHandler;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        static dispatch_once_t decimalNumberHandlerOnce;
        dispatch_once(&decimalNumberHandlerOnce, ^ {
            // NSRoundDown ensures that we truncate
            // Scale of 2 means it will only be precise for 2 decimal points
            // This gives us the truncating and currency behavior we want for free. Woot!
            decimalNumberHandler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
        });
        
        number = [NSDecimalNumber zero];

        [[NSBundle mainBundle] loadNibNamed:@"DecimalKeypadView" owner:self options:nil];
        [self addSubview:contentView];
        
        // Bottom Title label is only used for "Create Transaction"
        // because it supports multiline
        [self.leftBottomTitle setText:@""];
        [self.leftBottomTitle setHidden:YES];
        
        // Get input sound
//        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"];
//        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);        
    }
    return self;
}


@synthesize number, delegate;
@synthesize contentView;

// Simplified keyPress Method just returns the string.
- (IBAction)keyPressed:(id)sender
{
    NSString *text;
    
    if (sender == self.leftBottomButton && ![self.leftBottomTitle isHidden])
    {
        text = [self.leftBottomTitle text];
    }
    else
    {
        text = [sender currentTitle];
    }
    [[self delegate] keypad:self keyPressed:text];
    //AudioServicesPlaySystemSound(soundID);
}


- (void)setCancelTransactionButton {
    UIImage *normalImage = [UIImage imageNamed:@"keypad_light.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"keypad_select.png"];
    [self.leftBottomButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.leftBottomButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self.leftBottomButton setTitle:@"" forState:UIControlStateNormal];
    [self.leftBottomButton setTitle:@"" forState:UIControlStateSelected];
    self.leftBottomTitle.text = NSLocalizedString(@"Cancel Key", nil);
    self.leftBottomTitle.font = [UIFont boldSystemFontOfSize:14];
    self.leftBottomTitle.numberOfLines = 2;
    self.leftBottomTitle.textAlignment = NSTextAlignmentCenter;
    self.leftBottomTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.leftBottomTitle.textColor = [UIColor colorWithRed:FLOAT_COLOR_VALUE(102) green:FLOAT_COLOR_VALUE(102) blue:FLOAT_COLOR_VALUE(102) alpha:1.0];
    self.leftBottomButton.enabled = YES;
    [self.leftBottomTitle setHidden: NO];
}

- (void)setNextButton {
    UIImage *normalImage = [UIImage imageNamed:@"keypad_light.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"keypad_select.png"];
    [self.leftBottomButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.leftBottomButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self.leftBottomButton setTitle:NSLocalizedString(@"Next Key", nil) forState:UIControlStateNormal];
    [self.leftBottomButton setTitle:NSLocalizedString(@"Next Key", nil) forState:UIControlStateSelected];
    self.leftBottomButton.titleLabel.numberOfLines = 1;
    self.leftBottomButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.leftBottomButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.leftBottomButton setTitleColor:[UIColor colorWithRed:FLOAT_COLOR_VALUE(51) green:FLOAT_COLOR_VALUE(51) blue:FLOAT_COLOR_VALUE(51) alpha:1.0] forState:UIControlStateNormal];
    self.leftBottomButton.enabled = YES;
    [self.leftBottomTitle setHidden: YES];
}

- (void)setTabButton {
    UIImage *normalImage = [UIImage imageNamed:@"keypad_light.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"keypad_select.png"];
    [self.leftBottomButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.leftBottomButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self.leftBottomButton setTitle:NSLocalizedString(@"Tab Key", nil) forState:UIControlStateNormal];
    [self.leftBottomButton setTitle:NSLocalizedString(@"Tab Key", nil) forState:UIControlStateSelected];
    self.leftBottomButton.titleLabel.numberOfLines = 1;
    self.leftBottomButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.leftBottomButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.leftBottomButton setTitleColor:[UIColor colorWithRed:FLOAT_COLOR_VALUE(51) green:FLOAT_COLOR_VALUE(51) blue:FLOAT_COLOR_VALUE(51) alpha:1.0] forState:UIControlStateNormal];
    self.leftBottomButton.enabled = YES;
    [self.leftBottomTitle setHidden: YES];
}

- (void)setPeriodButton {
    UIImage *normalImage = [UIImage imageNamed:@"keypad_light.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"keypad_select.png"];
    [self.leftBottomButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.leftBottomButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self.leftBottomButton setTitle:@"." forState:UIControlStateNormal];
    [self.leftBottomButton setTitle:@"." forState:UIControlStateSelected];
    self.leftBottomButton.titleLabel.numberOfLines = 1;
    self.leftBottomButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.leftBottomButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.leftBottomButton setTitleColor:[UIColor colorWithRed:FLOAT_COLOR_VALUE(51) green:FLOAT_COLOR_VALUE(51) blue:FLOAT_COLOR_VALUE(51) alpha:1.0] forState:UIControlStateNormal];
    self.leftBottomButton.enabled = YES;
    [self.leftBottomTitle setHidden: YES];
}
@end
