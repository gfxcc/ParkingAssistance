//
//  DetailForPreViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 3/9/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "DetailForPreViewController.h"

@interface DetailForPreViewController ()

@end

@implementation DetailForPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSString * t = self.navigationController.title;
    
    if ([self.title isEqualToString:@"Parking Log"]) {
        
    
        UIImageView *parkinglog1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parkinglog1.PNG"]];
        [parkinglog1 setFrame:CGRectMake(0, 0, self.mmScrollPresenter.frame.size.width, self.mmScrollPresenter.frame.size.height)];
    
        UIImageView *parkinglog2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parkinglog2.PNG"]];
        [parkinglog2 setFrame:CGRectMake(0, 0, self.mmScrollPresenter.frame.size.width, self.mmScrollPresenter.frame.size.height)];
    
        MMScrollPage *firstPage = [[MMScrollPage alloc] init];
        firstPage.titleLabel.text = @"Map with all parking log";
        firstPage.detailLabel.text = @"Color of pin means the time your parked. More red means more recent.";
        [firstPage.backgroundView addSubview:parkinglog1];
        firstPage.titleBackgroundColor = [UIColor colorWithRed:67/255.0f green:89/255.0f blue:149/255.0f alpha:1.0];
    
        MMScrollPage *secondPage = [[MMScrollPage alloc] init];
        secondPage.titleLabel.text = @"Parking log list";
        secondPage.detailLabel.text = @"Tap the cell to see detail";
        [secondPage.backgroundView addSubview:parkinglog2];
        secondPage.titleBackgroundColor = [UIColor colorWithRed:67/255.0f green:89/255.0f blue:149/255.0f alpha:1.0];
    
        [self.mmScrollPresenter setupViewsWithArray:@[firstPage, secondPage]];
        
    } else if ([self.title isEqualToString:@"Notification"]) {
        UIImageView *notification1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification1.PNG"]];
        [notification1 setFrame:CGRectMake(0, 0, self.mmScrollPresenter.frame.size.width, self.mmScrollPresenter.frame.size.height)];
        
        UIImageView *notification2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification2.PNG"]];
        [notification2 setFrame:CGRectMake(0, 0, self.mmScrollPresenter.frame.size.width, self.mmScrollPresenter.frame.size.height)];
        
        UIImageView *notification3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification3.PNG"]];
        [notification3 setFrame:CGRectMake(0, 0, self.mmScrollPresenter.frame.size.width, self.mmScrollPresenter.frame.size.height)];
        
        UIImageView *notification4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification4.PNG"]];
        [notification4 setFrame:CGRectMake(0, 0, self.mmScrollPresenter.frame.size.width, self.mmScrollPresenter.frame.size.height)];
        
        MMScrollPage *firstPage = [[MMScrollPage alloc] init];
        firstPage.titleLabel.text = @"Notification on lock screen";
        firstPage.detailLabel.text = @"";
        [firstPage.backgroundView addSubview:notification1];
        firstPage.titleBackgroundColor = [UIColor colorWithRed:119/255.0f green:92/255.0f blue:166/255.0f alpha:0.5];
        
        MMScrollPage *secondPage = [[MMScrollPage alloc] init];
        secondPage.titleLabel.text = @"Set a notification for your park";
        secondPage.detailLabel.text = @"";
        [secondPage.backgroundView addSubview:notification2];
        secondPage.titleBackgroundColor = [UIColor colorWithRed:67/255.0f green:89/255.0f blue:149/255.0f alpha:1.0];
        
        MMScrollPage *thirdPage = [[MMScrollPage alloc] init];
        thirdPage.titleLabel.text = @"You can cancel the notification";
        thirdPage.detailLabel.text = @"If you set a new notification, the old one will be canceled automatic";
        [thirdPage.backgroundView addSubview:notification3];
        thirdPage.titleBackgroundColor = [UIColor colorWithRed:67/255.0f green:89/255.0f blue:149/255.0f alpha:1.0];
        
        MMScrollPage *fourthPage = [[MMScrollPage alloc] init];
        fourthPage.titleLabel.text = @"Set the time interval for\n your notification";
        fourthPage.detailLabel.text = @"";
        [fourthPage.backgroundView addSubview:notification4];
        fourthPage.titleBackgroundColor = [UIColor colorWithRed:67/255.0f green:89/255.0f blue:149/255.0f alpha:1.0];
        
        [self.mmScrollPresenter setupViewsWithArray:@[firstPage, secondPage, thirdPage, fourthPage]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
