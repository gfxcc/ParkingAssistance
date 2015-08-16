//
//  CYinterface.m
//  ParkingAssistance
//
//  Created by caoyong on 2/16/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "CYinterface.h"

@implementation CYinterface

//@synthesize tableData, ;



- (id)initWithTitle:(NSString *)title map:(MKMapView *)map {
    
    _map = map;
    _shown = false;
    _alarmSeted = false;
    
    if (self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, InterfaceHigh)]) {
        
        //UIColor *borderColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:189.0/255 alpha:1.0];
        //self.backgroundColor = borderColor;
        
        //_txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, self.frame.size.width - 0, 20)];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, self.frame.size.width, InterfaceHigh - 54)];
        _tableView.rowHeight = CellHigh;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
//        UIColor *backgroundColor = [UIColor colorWithRed:248.0/255 green:245.0/255 blue:239.0/255 alpha:1.0];
//        _tableView.backgroundColor = backgroundColor;
        [self addSubview:_tableView];
        
        
        
        UIToolbar *curBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0,4.0,[UIScreen mainScreen].bounds.size.width,50.0)];
        curBar.clipsToBounds = YES;
        curBar.translucent = false;
        [self addSubview:curBar];
        CALayer *TopBorder = [CALayer layer];
        UIColor *borderColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:189.0/255 alpha:1.0];
        TopBorder.frame = CGRectMake(0.0f, curBar.frame.size.height+4, curBar.frame.size.width, 1.0f);
        TopBorder.backgroundColor = borderColor.CGColor;
        [self.layer addSublayer:TopBorder];
        
        UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 30)];
        UIImage *image = [UIImage imageNamed:@"shield.png"];
        imageHolder.image = image;
        [self addSubview:imageHolder];
        
        _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 250, 40)];
        _txtLabel.text = @"Parking Information & Detail";
        [_txtLabel setFont:[UIFont fontWithName:@"Marlboro" size:22]];
        [self addSubview:_txtLabel];
        
        
        // add shadow
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowPath = shadowPath.CGPath;
        
        //[[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    }
    
    UISwipeGestureRecognizer *gestureRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(fadeMeOut)];
    [gestureRec setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:gestureRec];
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(fadeMeOut)];
    [_map addGestureRecognizer:tapRec];
    
    
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"!!! 01", @"item 02", @"item 03", nil];
    _dataArray_time = [[NSMutableArray alloc] initWithObjects:@"item 01", @"item 02", @"item 03", nil];
    _dataArray_dir = [[NSMutableArray alloc] initWithObjects:@"item 01", @"item 02", @"item 03", nil];
    _dataArray_address = [[NSMutableArray alloc] initWithObjects:@"item 01", @"item 02", @"item 03", nil];
    _notification = [[NSMutableArray alloc] initWithObjects:@"item 01", @"item 02", @"item 03", nil];
    _switchArray = [[NSMutableArray alloc] initWithObjects:[UISwitch alloc], nil];
    [_notification removeAllObjects];
    [_switchArray removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/notification",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *notif = [content componentsSeparatedByString:@"\n"];
    if (notif.count > 1) {
        for (NSInteger i = 0; i != 4; i++) {
            _notification[i] = notif[i];
        }
        _alarmSeted = true;
        
        
        NSString *s = notif[4];
        double num = [s doubleValue];
        _carLocation.latitude = num;
        
        s = notif[5];
        num = [s doubleValue];
        _carLocation.longitude = num;
        
    }
    
    return self;
}

- (void)addRow:(NSString *)direction day:(NSString *)day time:(NSString *)time address:(NSString *)address {
    
    [self.dataArray insertObject:day atIndex:0];
    [self.dataArray_time insertObject:time atIndex:0];
    [self.dataArray_dir insertObject:direction atIndex:0];
    [self.dataArray_address insertObject:address atIndex:0];
    [self.tableView reloadData];

}

- (void)clear {
//    [_dataArray removeAllObjects];
//    //[_dataArray removeLastObject];
//
    [self.dataArray removeAllObjects];
    [self.dataArray_time removeAllObjects];
    [self.dataArray_dir removeAllObjects];
    [self.dataArray_address removeAllObjects];
    [self.switchArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark TableView delegate

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.yourTextField.delegate = self;
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(60, 2, 200, 30)];
    //[day setFont:[UIFont fontWithName:@"Pamela want a Bike to Ride" size:(20)]];
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 200, 40)];
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, CellHigh)];
    UIImage *image = [UIImage imageNamed:@"W.png"];
    
    if ([[self.dataArray_dir objectAtIndex:indexPath.row]isEqualToString:@"North"]) {
        image = [UIImage imageNamed:@"N.png"];
    } else if ([[self.dataArray_dir objectAtIndex:indexPath.row]isEqualToString:@"South"]) {
        image = [UIImage imageNamed:@"S.png"];
    } else if ([[self.dataArray_dir objectAtIndex:indexPath.row]isEqualToString:@"East"]) {
        image = [UIImage imageNamed:@"E.png"];
    } else if ([[self.dataArray_dir objectAtIndex:indexPath.row]isEqualToString:@"West"]) {
        image = [UIImage imageNamed:@"W.png"];
    } else if ([[self.dataArray_dir objectAtIndex:indexPath.row]isEqualToString:@"Both"]) {
        image = [UIImage imageNamed:@"B.png"];
    }
    
    imageHolder.image = image;
    [cell addSubview:imageHolder];
    [cell addSubview:day];
    [cell addSubview:time];
    day.text = [self.dataArray objectAtIndex:indexPath.row];
    time.text = [self.dataArray_time objectAtIndex:indexPath.row];
    
//    UIColor *backgroundColor = [UIColor colorWithRed:248.0/255 green:245.0/255 blue:239.0/255 alpha:1.0];
//    cell.backgroundColor = backgroundColor;
    
    UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    cell.accessoryView = switchBtn;
    switchBtn.tag = indexPath.row;
    [switchBtn addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    if (_notification.count < 1) { //if no _notification return
        return cell;
    }
    
    if ([[_dataArray objectAtIndex:indexPath.row]isEqualToString:_notification[0]]
        && [[_dataArray_time objectAtIndex:indexPath.row]isEqualToString:_notification[1]]
        && [[_dataArray_dir objectAtIndex:indexPath.row]isEqualToString:_notification[2]]
        && [[_dataArray_address objectAtIndex:indexPath.row]isEqualToString:_notification[3]]) {
        
        [switchBtn setOn:YES animated:NO];
    }
    
    [_switchArray insertObject:switchBtn atIndex:indexPath.row];
    
    return cell;
}


- (void)changeSwitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        _alarmSeted = true;
        NSInteger index = [(UISwitch *)sender tag];
        [_notification removeAllObjects];
        
        for (NSInteger i = 0; i != _switchArray.count; i++) {
            if (i == index) {
                continue;
            }
            [_switchArray[i] setOn:NO animated:YES];
        }
        
        
        //begin analyze time
        
        NSString *date = [_dataArray objectAtIndex:index];
        NSString *time = [_dataArray_time objectAtIndex:index];
        NSInteger day;
        if ([date isEqualToString:@"Monday"]) {
            day = 2;
        }   else if ([date isEqualToString:@"Tuesday"]) {
            day = 3;
        }   else if ([date isEqualToString:@"Wednesday"]) {
            day = 4;
        }   else if ([date isEqualToString:@"Thursday"]) {
            day = 5;
        }   else if ([date isEqualToString:@"Friday"]) {
            day = 6;
        }   else if ([date isEqualToString:@"Monday through Friday"])
        {
            return;
        }
        NSArray *time_detail = [time componentsSeparatedByString:@" "];
        NSArray *hour_array = [time_detail[0] componentsSeparatedByString:@":"];
        NSInteger hour = [hour_array[0] intValue]; // get hour data
        if ([time_detail[1] isEqualToString:@"p.m."]) {
            hour += 12;
        }
        //start to analyze notificationTime and set new hour and minute
        NSArray *paths_ = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory_ = [paths_ objectAtIndex:0];
        NSString *fileName_ = [NSString stringWithFormat:@"%@/notificationTime",
                              documentsDirectory_];
        NSString *content_ = [[NSString alloc] initWithContentsOfFile:fileName_
                                                        usedEncoding:nil
                                                               error:nil];
        NSArray *chosenTime = [content_ componentsSeparatedByString:@"\n"];
        NSInteger beforeDay = 0;
        NSInteger beforeHour = 0;
        NSInteger newMinute = 0;
        if ([chosenTime[1] intValue] != 0) {
            newMinute = 60 - [chosenTime[1] intValue];
            beforeHour = 1;
        }
        if (hour <= ([chosenTime[0] intValue] + beforeHour)) {
            hour = hour + 24 -([chosenTime[0] intValue] + beforeHour);
            beforeDay = 1;
        } else {
            hour = hour - ([chosenTime[0] intValue] + beforeHour);
        }
        
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *date_now = [NSDate date];
        NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date_now];
        NSInteger todayWeekday = [weekdayComponents weekday];
        
        NSInteger moveDays=day - todayWeekday - beforeDay;
        if (moveDays<0) {
            moveDays+=7;
        }
        
        // if day is today
        NSCalendar *calendarr = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *componentss = [calendarr components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date_now];
        
        if (moveDays == 0 && [componentss hour] > hour) {
            moveDays += 7;
        }
        
        NSDateComponents *components = [NSDateComponents new];
        components.day=moveDays;
        
        NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDate* newDate = [calendar dateByAddingComponents:components toDate:date_now options:0];
        NSDate *d = [calendar dateBySettingHour:hour minute:newMinute second:0 ofDate:newDate options:0];
        
        NSLog(@"%@",newDate);
        NSLog(@"%@",d);
        
        localNotification.fireDate = d;//[NSDate dateWithTimeIntervalSinceNow:7];
        localNotification.alertBody = [NSString stringWithFormat:@"%@\t%@",[_dataArray objectAtIndex:index],[_dataArray_time objectAtIndex:index]];//@"Hello world!";
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        //[formatter setTimeStyle:NSDateFormatterLongStyle];
        NSString *dateSelected =[formatter stringFromDate:d];
        
        //send message
        [messageCenter setTitle:[NSString stringWithFormat:@"Set alarm at %@",dateSelected]];
        [messageCenter successMode];
        [messageCenter show];
        
        [_notification insertObject:[_dataArray_address objectAtIndex:index] atIndex:0];
        [_notification insertObject:[_dataArray_dir objectAtIndex:index] atIndex:0];
        [_notification insertObject:[_dataArray_time objectAtIndex:index] atIndex:0];
        [_notification insertObject:[_dataArray objectAtIndex:index] atIndex:0];
        

        NSString *result = _notification[0];
        for (NSInteger i = 1; i != _notification.count; i++) {
            result = [NSString stringWithFormat:@"%@\n%@",result,_notification[i]];
        }
        
        result = [NSString stringWithFormat:@"%@\n%f\n%f",result,_nowLocation.latitude,_nowLocation.longitude];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/notification",
                              documentsDirectory];
        [result writeToFile:fileName
                  atomically:NO
                    encoding:NSUTF8StringEncoding
                       error:nil];
        
        //add new parking locatin to Parking log
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm:ss"];
        
        NSDate *now = [[NSDate alloc] init];
        
        NSString *theDate = [dateFormat stringFromDate:now];
        NSString *theTime = [timeFormat stringFromDate:now];
        
        
        paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        fileName = [NSString stringWithFormat:@"%@/parkingLog",
                              documentsDirectory];
        NSString *existedLog = [[NSString alloc] initWithContentsOfFile:fileName
                                                        usedEncoding:nil
                                                               error:nil];
        NSString *firstlog = [existedLog componentsSeparatedByString:@"\n"][0];
        bool noLog = firstlog.length < 5 ? true : false;// true mean no log, false mean has log
        
        NSString *log = [NSString stringWithFormat:@"%@\t%@\t%f\t%f\t%@\t%@",address,city,location.latitude,location.longitude,theDate,theTime];
        NSString *newContent;
        if (noLog) {
            newContent = log;
        } else {
            newContent = [NSString stringWithFormat:@"%@\n%@",log,existedLog];
        }
        NSError *err = nil;
        [newContent writeToFile:fileName
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error:&err];
        
        //create MKMapSnapshotter for the map
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        
        CLLocationCoordinate2D locationForRegion;
        for (id<MKAnnotation>annotation in _map.annotations) {
            if (_map.annotations.count > 1 && (annotation.coordinate.latitude == _map.userLocation.coordinate.latitude &&
                                               annotation.coordinate.longitude == _map.userLocation.coordinate.longitude)) {
                continue;
            }
            locationForRegion = annotation.coordinate;
        }
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationForRegion, 700, 700);
        options.region = viewRegion;
        options.scale = [UIScreen mainScreen].scale;
        options.size = CGSizeMake(320, 200);
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        
        [snapshotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            
            // get the image associated with the snapshot
            
            UIImage *image = snapshot.image;
            
            // Get the size of the final image
            
            CGRect finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            // Get a standard annotation view pin. Clearly, Apple assumes that we'll only want to draw standard annotation pins!
            
            MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
            UIImage *pinImage = pin.image;
            
            // ok, let's start to create our final image
            
            UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
            
            // first, draw the image from the snapshotter
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
            // now, let's iterate through the annotations and draw them, too
            
            for (id<MKAnnotation>annotation in _map.annotations) {
                if (_map.annotations.count > 1 && (annotation.coordinate.latitude == _map.userLocation.coordinate.latitude &&
                                                   annotation.coordinate.longitude == _map.userLocation.coordinate.longitude)) {
                    continue;
                }
                
                CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
                if (CGRectContainsPoint(finalImageRect, point)) { // this is too conservative, but you get the idea
                    CGPoint pinCenterOffset = pin.centerOffset;
                    point.x -= pin.bounds.size.width / 2.0;
                    point.y -= pin.bounds.size.height / 2.0;
                    point.x += pinCenterOffset.x;
                    point.y += pinCenterOffset.y;
                    
                    [pinImage drawAtPoint:point];
                }
            }
            
            // grab the final image
            
            UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // and save it
            NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fileName = [NSString stringWithFormat:@"%@/Snapshot/%@-%@.png",documentsDirectory,theDate,theTime];
            NSData *data = UIImagePNGRepresentation(finalImage);
            [data writeToFile:fileName atomically:YES];
        }];
        
 
    } else{
        NSLog(@"Switch is OFF");
        
        for (NSInteger i = 0; i != _switchArray.count; i++) {
            if ([_switchArray[i] isOn]) {
                return;
            }
        }
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [_notification removeAllObjects];
        
        //empty file log
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/notification",
                              documentsDirectory];
        [@"" writeToFile:fileName
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error:nil];
        _alarmSeted = false;
        [messageCenter setTitle:@"Cancel alarm"];
        [messageCenter warningMode];
        [messageCenter show];
    }
}

- (void)reload {
    [_tableView reloadData];
}

- (void)fadeMeOut {
    if (!_shown) {
        return;
    }
    [self performSelectorOnMainThread:@selector(fadeOutNotification:) withObject:self waitUntilDone:NO];
}

- (void)fadeOutNotification:(UIView *)currentView {

    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fadeOutNotification:)
                                               object:currentView];
    
    CGPoint fadeOutToPoint;
    
    
    fadeOutToPoint = CGPointMake(self.center.x,[UIScreen mainScreen].bounds.size.height + (self.frame.size.height/2));
    [UIView animateWithDuration:kTSMessageAnimationDuration animations:^
     {
         self.center = fadeOutToPoint;

     } completion:^(BOOL finished)
     {
         //[currentView removeFromSuperview];
         _shown = false;
     }];
}

- (BOOL)showMyCar {
    
    if (!_alarmSeted) {
        // need message;
        [messageCenter setTitle:@"No record"];
        [messageCenter errorMode];
        [messageCenter show];
        return false;
    }
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = _carLocation;
    pointAnnotation.title = [NSString stringWithFormat:@"Last Parking :%@",_notification[3]];
    
    [_map addAnnotation:pointAnnotation];
    return true;
}


- (void)show {

    _txtLabel.text = address;
    
    CGPoint toPoint;
    toPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height - (self.frame.size.height/2));
    //[UIScreen mainScreen].bounds.size.height - (self.frame.size.height/2)
    dispatch_block_t animationBlock = ^{
        self.center = toPoint;
    };
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:animationBlock
                     completion:nil];
    _shown = true;
}

- (void)setLocation:(CLLocationCoordinate2D )location {

    _nowLocation = location;
}

@end
