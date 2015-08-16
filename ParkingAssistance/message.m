//
//  message.m
//  ParkingAssistance
//
//  Created by caoyong on 2/28/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "message.h"

@implementation Message

- (id)initWithTitle:(NSString *)title {
    
    _title = title;
    
    _shown = false;
    
    if (self = [super initWithFrame:CGRectMake(0, toolbarHigh - messageHigh, [UIScreen mainScreen].bounds.size.width, messageHigh)]) {
        self.backgroundColor = [UIColor colorWithRed:137.0/255 green:213.0/255 blue:124.0/255 alpha:1.0];
        //NotificationBackgroundSuccessIcon@2x.png
        imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 20)];
        UIImage *image = [UIImage imageNamed:@"NotificationBackgroundSuccessIcon@2x.png"];
        imageHolder.image = image;
        //[self addSubview:imageHolder];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 250, 20)];
        _titleLabel.text = _title;
        _titleLabel.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        //titleLabel.font = ;
        [self addSubview:_titleLabel];
        
        
    }
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(fadeMeOut)];
    [self addGestureRecognizer:tapRec];

    
    self.hidden = true;
    return self;
}

- (void)warningMode {
    
    self.backgroundColor = [UIColor colorWithRed:222.0/255 green:203.0/255 blue:88.0/255 alpha:1.0];
    UIImage *image = [UIImage imageNamed:@"NotificationBackgroundWarningIcon@2x.png"];
    imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(15, 1, 7, 37)];
    [imageHolder setImage:image];
    [self sendSubviewToBack:imageHolder];
}

- (void)successMode {
    self.backgroundColor = [UIColor colorWithRed:137.0/255 green:213.0/255 blue:124.0/255 alpha:1.0];
    UIImage *image = [UIImage imageNamed:@"NotificationBackgroundSuccessIcon@2x.png"];
    imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 20)];
    imageHolder.image = image;
}

- (void)errorMode {
    self.backgroundColor = [UIColor colorWithRed:225.0/255 green:87.0/255 blue:92.0/255 alpha:1.0];
    UIImage *image = [UIImage imageNamed:@"NotificationBackgroundErrorIcon@2x.png"];
    imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 34, 36)];
    imageHolder.image = image;
}

- (void)show {
    self.hidden = false;
    _shown = true;
    CGPoint toPoint;
    toPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/2,toolbarHigh + self.bounds.size.height/2);
    //[UIScreen mainScreen].bounds.size.height - (self.frame.size.height/2)
    dispatch_block_t animationBlock = ^{
        self.center = toPoint;
    };
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:animationBlock
                     completion:nil];
    [self performSelector:@selector(fadeMeOut) withObject:nil afterDelay:5.0f];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)fadeMeOut
{
    if (!_shown) {
        return;
    }
    [self performSelectorOnMainThread:@selector(fadeOutNotification:) withObject:self waitUntilDone:NO];
}

- (void)fadeOutNotification:(UIView *)currentView
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fadeOutNotification:)
                                               object:currentView];
    
    CGPoint fadeOutToPoint;
    
    
    fadeOutToPoint = CGPointMake(self.center.x,toolbarHigh - self.bounds.size.height/2);
    [UIView animateWithDuration:kTSMessageAnimationDuration animations:^
     {
         self.center = fadeOutToPoint;
         
     } completion:^(BOOL finished)
     {
         //[currentView removeFromSuperview];
         _shown = false;
     }];
    [self performSelector:@selector(hidden) withObject:nil afterDelay:kTSMessageAnimationDuration];
}

- (void)hidden {
    self.hidden = true;
}
@end
