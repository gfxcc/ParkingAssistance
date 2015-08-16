//
//  SettingViewController.h
//  ParkingAssistance
//
//  Created by caoyong on 3/5/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)AppComments;
- (void)LocationReporte;
- (void)ParkingLog;
- (void)AdditionalFunctions;
- (void)NotificationTime;
- (void)AboutDeveloper;
- (void)RateThisApp;

@end
