//
//  DecimalKeypadView.h
//  Decimal Entry Test
//
//  Created by Colin Barrett on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol DecimalKeypadViewDelegate;

@interface DecimalKeypadView : UIView {
    UIView *contentView;
    NSDecimalNumber *number;
    UIButton *leftBottomButton;
    SystemSoundID soundID;
}

// Designated initalizer -- this view is only meant to be put in nibs. (Although it would be easy to modify it to be instantiated in code.)
// When you add the view to the nib, it should be 216 pixels high.
- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)setCancelTransactionButton;
- (void)setNextButton;
- (void)setTabButton;
- (void)setPeriodButton;

@property (nonatomic, retain, readonly) NSDecimalNumber *number;
@property (nonatomic, assign) IBOutlet id <DecimalKeypadViewDelegate> delegate;
@property (nonatomic, retain, readonly) IBOutlet UIButton *leftBottomButton;
@property (nonatomic, strong, readonly) IBOutlet UILabel *leftBottomTitle;

// For Interface Builder
@property (nonatomic, retain) IBOutlet UIView *contentView;
- (IBAction)keyPressed:(id)sender;
@end

@protocol DecimalKeypadViewDelegate
@required
- (void)keypad:(DecimalKeypadView *)keypad keyPressed:(NSString *)string;
@end