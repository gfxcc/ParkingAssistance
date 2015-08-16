//
//  CYinterface.h
//  ParkingAssistance
//
//  Created by caoyong on 2/16/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Inf.h"

#define kTSMessageAnimationDuration 0.3
#define TSMessageViewAlpha 0.95
#define InterfaceHigh 220
#define CellHigh 70


@interface CYinterface : UIView <UITableViewDataSource,UITableViewDelegate> {
    
    @protected
    UILabel *_txtLabel;
    
    MKMapView *_map;
    CLLocationCoordinate2D _carLocation;
    CLLocationCoordinate2D _nowLocation;
    BOOL _alarmSeted;
    BOOL _shown; // for judge the view show or not
}

- (id)initWithTitle:(NSString *)title map:(MKMapView *)map;

- (void)addRow:(NSString *)direction day:(NSString *)day time:(NSString *)time address:(NSString *)address;

- (void)clear;

- (void)show;

- (void)setLocation:(CLLocationCoordinate2D )location;

- (BOOL)showMyCar;

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) NSMutableArray *dataArray_time;
@property(strong, nonatomic) NSMutableArray *dataArray_dir;
@property(strong, nonatomic) NSMutableArray *dataArray_address;
@property(strong, nonatomic) NSMutableArray *switchArray;
@property(strong, nonatomic) NSMutableArray *notification;

@end
