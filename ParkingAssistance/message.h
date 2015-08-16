//
//  message.h
//  ParkingAssistance
//
//  Created by caoyong on 2/28/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>


#define messageHigh 40
#define toolbarHigh 70
#define kTSMessageAnimationDuration 0.3
#define TSMessageViewAlpha 0.95

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeMessage = 0,
    MessageTypeWarning,
    MessageTypeError,
    MessageTypeSuccess
};

@interface Message : UIView {

    @protected
    /** The displayed title of this message */
    NSString *_title;

    /** The displayed subtitle of this message */
    NSString *subtitle;

    /** The view controller this message is displayed in */
    UIViewController *viewController;

    /** The duration of the displayed message. If it is 0.0, it will automatically be calculated */
    CGFloat duration;
    
    BOOL _shown;
    
    UILabel *_titleLabel;
    
    UIImageView *imageHolder;

}
- (id)initWithTitle:(NSString *)title;

- (void)show;

- (void)setTitle:(NSString *)title;

- (void)warningMode;

- (void)successMode;

- (void)errorMode;

@end


