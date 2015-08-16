//
//  ViewController.h
//  ParkingAssistance
//
//  Created by caoyong on 2/8/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import "Inf.h"
#import "CYinterface.h"
#import "message.h"

#define Version @"Version 1.1.1";
#define toolbarHigh 70

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *parkInf;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UIButton *findMyCar;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;


@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;

//@property (strong, nonatomic) UITableViewCell *customCell;

@end

UIActivityIndicatorView *activityIndicator;
CYinterface *parkinginf;
MKPointAnnotation *pointAnnotation;
BOOL findCar;

