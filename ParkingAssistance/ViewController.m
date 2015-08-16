//
//  ViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 2/8/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *pointAnnotation_save;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    findCar = false;
    _pointAnnotation_save = nil;
    
    messageCenter = [[Message alloc]initWithTitle:@"Message"];
    
    [self.view addSubview:messageCenter];
    
    UIToolbar *curBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0,0.0,[UIScreen mainScreen].bounds.size.width,toolbarHigh)];
    [self.view addSubview:curBar];
    curBar.translucent = true;

    
    
    CALayer *TopBorder = [CALayer layer];
    UIColor *borderColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:189.0/255 alpha:1.0];
    TopBorder.frame = CGRectMake(0.0f, curBar.frame.size.height, curBar.frame.size.width, 1.0f);
    TopBorder.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder];
    [self.view bringSubviewToFront:_parkInf];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(290, 45);
    activityIndicator.transform = CGAffineTransformMakeScale(1.25, 1.25);
    activityIndicator.hidesWhenStopped = YES;
    
    [activityIndicator startAnimating];
    
    [self.view bringSubviewToFront:_navButton];
    [self.view bringSubviewToFront:_findMyCar];
    [self.view addSubview:activityIndicator];
    
    
    //catch longPress
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//long press 0.5second reaction longPress function
    lpress.allowableMovement = 10.0;
    [_mapView addGestureRecognizer:lpress];//m_mapView is MKMapView
    
    
    _mapView.mapType = MKMapTypeStandard;
    
    self.locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        _mapView.mapType = MKMapTypeStandard;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    
    parkinginf = [[CYinterface alloc]initWithTitle:@"Upload Succeeded" map:_mapView];
    [self.view addSubview:parkinginf];
    
//    MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
//    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:curBar.items];
//    [items insertObject:buttonItem atIndex:0];
//    [curBar setItems:items];

    [self.view bringSubviewToFront:_settingButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Snapshot"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    //NSInteger i = _mapView.annotations.count;
    if(_mapView.annotations.count != 1)
        return;
    [self setInfValue];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// analyze parking information after updata location inf
- (void) analyze {
    
    //parkinginf = [[CYinterface alloc]initWithTitle:@"Upload Succeeded" map:_mapView];
    [parkinginf clear];
    
    //self.parkInf.text = @"";
    int blockindex = 0;
    // locate block
    if ([address isEqualToString:@""]) {
        return;
    }
    
    for(;![[address substringWithRange:NSMakeRange(blockindex, 1)] isEqualToString:@" "];blockindex++)
    {
        //NSString *tt = [address substringWithRange:NSMakeRange(blockindex, 1)];
        if (blockindex == address.length - 1) {
            _parkInf.text = @"Location Fail! Try Again";
            return;
        }
    }
    NSString *addressNum = [address substringToIndex:blockindex];
    NSString *addressSt = [address substringFromIndex:blockindex+1];
    
    NSString *textTmp = self.parkInf.text;
    textTmp = [NSString stringWithFormat:@"%@\n%@\n%@",textTmp,addressNum,addressSt];
    //self.parkInf.text = textTmp;
    //read inf
    NSArray* lines = [self readfile];
    
    //search from inf
    for(int index=0;index!=lines.count;index++)
    {
        NSArray *detail = [lines[index] componentsSeparatedByString:@"\t"];
        
        //begin match
        if([detail[0] isEqualToString:addressSt])
        {
            if([self judgeNum:addressNum infNum:detail[5]])
            {
                if(/*[direction isEqualToString:detail[1]]||[direction isEqualToString:@"all"]*/ true)//judge navigation
                {
                    NSString *textTmp = self.parkInf.text;
                    
                    NSString *newinf = [NSString stringWithFormat:@"%@\t%@\t%@\t%@\t%@",detail[0],detail[1],detail[2],detail[3],detail[5]];
                    textTmp = [NSString stringWithFormat:@"%@\n%@",textTmp,newinf];
                    //_parkInf.text = textTmp;
                    
                    [parkinginf addRow:detail[1] day:detail[2] time:detail[3] address:detail[0]];

                }
            }
        }
    }
    [activityIndicator stopAnimating];
    [parkinginf setLocation:location];
    [parkinginf show];
}






// set values in inf when page load
- (void) setInfValue {
    CLLocationCoordinate2D destCoordinate=_mapView.userLocation.coordinate;
    location = destCoordinate;
    CLLocation *currLocation =[[CLLocation alloc] initWithLatitude:destCoordinate.latitude longitude:destCoordinate.longitude];
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        destCoordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                  destCoordinate.longitude]);
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        currLocation.coordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                           currLocation.coordinate.longitude]);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           
                           extern NSString *address;
                           
                           address = [addressDictionary
                                      objectForKey:(NSString *)kABPersonAddressStreetKey];
                           address = address == nil ? @"": address;
                           
                           
                           extern NSString *state;
                           state = [addressDictionary
                                    objectForKey:(NSString *)kABPersonAddressStateKey];
                           state = state == nil ? @"": state;
                           
                           extern NSString *city;
                           city = [addressDictionary
                                   objectForKey:(NSString *)kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           
                           //sSelf.streetInf.text = [NSString stringWithFormat:@"%@ \t%@ \t%@",state, address,city];
                           NSLog(@"~~~~~%@ \t%@ \t%@",state, address,city);
                           [self analyze];
                           _mapView.userLocation.title = address;
                           
                       }
                   }];
}


// function to respond longPress
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        return;
    }
    
    if(_pointAnnotation_save) {
        return;
    }
    findCar = false;
    [activityIndicator startAnimating];
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    pointAnnotation = nil;
    pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = touchMapCoordinate;
    pointAnnotation.title = [NSString stringWithFormat:@"%@",city];
    [_mapView addAnnotation:pointAnnotation];
    _pointAnnotation_save = pointAnnotation;

    
    CLLocationCoordinate2D destCoordinate=pointAnnotation.coordinate;
    location = destCoordinate;
    
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        destCoordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                  destCoordinate.longitude]);
    
    CLLocation *currLocation =[[CLLocation alloc] initWithLatitude:destCoordinate.latitude longitude:destCoordinate.longitude];
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        currLocation.coordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                           currLocation.coordinate.longitude]);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           
                           extern NSString *address;
                           
                           address = [addressDictionary
                                      objectForKey:(NSString *)kABPersonAddressStreetKey];
                           address = address == nil ? @"": address;
                           
                           extern NSString *state;
                           state = [addressDictionary
                                    objectForKey:(NSString *)kABPersonAddressStateKey];
                           state = state == nil ? @"": state;
                           
                           extern NSString *city;
                           city = [addressDictionary
                                   objectForKey:(NSString *)kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           
                           //sSelf.streetInf.text = [NSString stringWithFormat:@"%@ \t%@ \t%@",state, address,city];
                           NSLog(@"%@ \t%@ \t%@",state, address,city);
                           [self analyze];
                           pointAnnotation.title = address;
                       }
                   }];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //UIImage *btnImage = [UIImage imageNamed:@"navigation-2.png"];
    //[_navButton setImage:btnImage forState:UIControlStateNormal];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];//导航栏右边回到当前位置的按钮可用
        return nil;
    }
    
    
    if (findCar) {
        MKAnnotationView *pinView = nil;
        if(annotation != _mapView.userLocation)
        {
            static NSString *defaultPinID = @"mycar";
            pinView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
            if ( pinView == nil )
                pinView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:defaultPinID];
            
            //pinView.pinColor = MKPinAnnotationColorGreen;
            pinView.canShowCallout = YES;
            //pinView.animatesDrop = YES;
            pinView.image = [UIImage imageNamed:@"caricon.png"];    //as suggested by Squatch

        }
        else {
            //[_mapView.userLocation setTitle:@"I am here"];
        }
        return pinView;
    }
    

    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView* customPinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!customPinView) {
        customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        
        //customPinView.pinColor = MKPinAnnotationColorRe;//设置大头针的颜色
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.draggable = YES;//可以拖动
        //添加tips上的按钮
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
    }else{
        customPinView.annotation = annotation;
    }
    
    return customPinView;
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    if (!findCar) {
        return;
    }
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame = endFrame; }];
    }
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    [activityIndicator startAnimating];
    switch (newState) {
        case MKAnnotationViewDragStateStarting: {
            NSLog(@"拿起");
            //CLLocationCoordinate2D destCoordinate=view.annotation.coordinate;
            return;
        }
        case MKAnnotationViewDragStateDragging: {
            NSLog(@"开始拖拽");
            return;
        }
        case MKAnnotationViewDragStateEnding: {
            NSLog(@"放下,并将大头针");
            CLLocationCoordinate2D destCoordinate=view.annotation.coordinate;
            location = destCoordinate;
            
            NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                                destCoordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                          destCoordinate.longitude]);
            
            CLLocation *currLocation =[[CLLocation alloc] initWithLatitude:destCoordinate.latitude longitude:destCoordinate.longitude];
            NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                                currLocation.coordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                                   currLocation.coordinate.longitude]);
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:currLocation
                           completionHandler:^(NSArray *placemarks, NSError *error) {
                               
                               if ([placemarks count] > 0) {
                                   
                                   CLPlacemark *placemark = placemarks[0];
                                   
                                   NSDictionary *addressDictionary =  placemark.addressDictionary;
                                   
                                   extern NSString *address;
                                   
                                   address = [addressDictionary
                                              objectForKey:(NSString *)kABPersonAddressStreetKey];
                                   address = address == nil ? @"": address;
                                   
                                   extern NSString *state;
                                   state = [addressDictionary
                                            objectForKey:(NSString *)kABPersonAddressStateKey];
                                   state = state == nil ? @"": state;
                                   
                                   extern NSString *city;
                                   city = [addressDictionary
                                           objectForKey:(NSString *)kABPersonAddressCityKey];
                                   city = city == nil ? @"": city;
                                   
                                   //sSelf.streetInf.text = [NSString stringWithFormat:@"%@ \t%@ \t%@",state, address,city];
                                   NSLog(@"%@ \t%@ \t%@",state, address,city);
                               }
                               [self analyze];
                               //MKAnnotationView *pointAnnotation = view.annotation;
                               _pointAnnotation_save.title = address;
                               
                           }];
            
            //[self analyze];
            
            return;
        }
        default:
            [activityIndicator stopAnimating];
            return;
    }
}


- (void)showDetails:(UIButton*)sender
{
    
    //MKPointAnnotation *annotation = _mapView.annotations.firstObject;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 700, 700);
    [_mapView setRegion:viewRegion animated:YES];
    
    //
    CLLocationCoordinate2D destCoordinate=pointAnnotation.coordinate;
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        destCoordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                  destCoordinate.longitude]);
    
    CLLocation *currLocation =[[CLLocation alloc] initWithLatitude:destCoordinate.latitude longitude:destCoordinate.longitude];
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        currLocation.coordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                           currLocation.coordinate.longitude]);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           
                           extern NSString *address;
                           
                           address = [addressDictionary
                                      objectForKey:(NSString *)kABPersonAddressStreetKey];
                           address = address == nil ? @"": address;
                           
                           extern NSString *state;
                           state = [addressDictionary
                                    objectForKey:(NSString *)kABPersonAddressStateKey];
                           state = state == nil ? @"": state;
                           
                           extern NSString *city;
                           city = [addressDictionary
                                   objectForKey:(NSString *)kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           
                           //sSelf.streetInf.text = [NSString stringWithFormat:@"%@ \t%@ \t%@",state, address,city];
                           NSLog(@"%@ \t%@ \t%@",state, address,city);
                           [self analyze];
                           pointAnnotation.title = address;
                       }
                   }];
    [parkinginf show];
}

- (IBAction)addAlarm:(id)sender {
    
    [messageCenter show];
}

- (IBAction)findMyCar:(id)sender {
    
    findCar =true;
    if(![parkinginf showMyCar]) {// if show car fail, turn off the car mode
        findCar = false;
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/parkingLog",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *log = [content componentsSeparatedByString:@"\n"];
    NSArray *inf = [log[0] componentsSeparatedByString:@"\t"];
    [messageCenter setTitle:[NSString stringWithFormat:@"Parking time:%@\t%@",inf[4],inf[5]]];
    [messageCenter successMode];
    [messageCenter show];
}

#pragma mark -
#pragma mark Tools function

- (BOOL)judgeNum: (NSString*)locNum infNum:(NSString*)infNum{
    
    NSString *errinf = @"^^^";
    if([infNum isEqualToString:@"all"])
    {
        return true;
    }
    else
    {
        if(![infNum isEqualToString:@"!#!"])
        {
            //locate #
            int sepindex = 0;
            for(;![[infNum substringWithRange:NSMakeRange(sepindex, 1)] isEqualToString:@"#"];sepindex++)
            {
                //
            }
            int min = [[infNum substringToIndex:sepindex] intValue];
            int max = [[infNum substringFromIndex:sepindex+1] intValue];
            
            if (max < min) {
                int temp = max;
                max = min;
                min = temp;
            }
            
            if(locNum.length<=4)
            {
                NSString *judgeInf = [NSString stringWithFormat:@"Analyse Inf num: loc:%@  \n File Inf:%@-%@",locNum,[infNum substringToIndex:sepindex],[infNum substringFromIndex:sepindex+1]];
                //locNum is a num
                if([locNum intValue]>=min&&[locNum intValue]<=max)
                {
                    //updata message
                    
                    NSString *textTmp = self.parkInf.text;
                    textTmp = [NSString stringWithFormat:@"%@\n%@",textTmp,judgeInf];
                    //self.parkInf.text = textTmp;
                    return true;
                }
                errinf = judgeInf;
            }
            else
            {
                //locNum is a scope
                //
                //analyse locNum
                int locindex = 0;
                for(;![[locNum substringWithRange:NSMakeRange(locindex,1)] isEqualToString:@"–"];locindex++)
                {
                    NSString *tempt = [locNum substringWithRange:NSMakeRange(locindex,1)];
                    /*
                    if (locindex == locNum.length-1) {
                        //serious!!
                        locindex = 0;
                        for(;![[locNum substringWithRange:NSMakeRange(locindex,1)] isEqualToString:@"–"];locindex++) {
                            tempt = [locNum substringWithRange:NSMakeRange(locindex,1)];
                            //bool t = [tempt isEqualToString:@"–"];
                     
                            int tt = [tempt intValue];
                            //int ttt;
                            tt ++;
                     
                            int intvalue = [tempt intValue];
                            if ([![tempt isEqualToString:@"0"]] && intvalue == 0) {
                                break;
                            }
                        }
                    }*/
                    int intvalue = [tempt intValue];
                    if (![tempt isEqualToString:@"0"] && intvalue == 0) {
                        break;
                    }
                }
                int locmin = [[locNum substringToIndex:locindex] intValue];
                int locmax = [[locNum substringFromIndex:locindex+1] intValue];
                if (locmax < locmin) {
                    int temp = locmin;
                    locmin = locmax;
                    locmax = temp;
                }
                
                NSString *judgeInf = [NSString stringWithFormat:@"Analyse Inf scope: loc:%@-%@  \n File Inf:%@-%@",[locNum substringToIndex:locindex],[locNum substringFromIndex:locindex+1],[infNum substringToIndex:sepindex],[infNum substringFromIndex:sepindex+1]];
                if(min<=locmin && max>=locmax)
                {
                    //updata message
                    
                    NSString *textTmp = self.parkInf.text;
                    textTmp = [NSString stringWithFormat:@"%@\n%@",textTmp,judgeInf];
                    //self.parkInf.text = textTmp;
                    return true;
                }
                errinf = judgeInf;
            }
        }
    }
    
    return false;
}


- (IBAction)navButtonClick:(id)sender {

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 1000, 1000);
    [_mapView setRegion:viewRegion animated:YES];
    
    [self setInfValue];
}

//
- (NSArray*)readfile{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ParkingInf" ofType:@""];
    NSArray *lines;
    lines = [[NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:nil]
             componentsSeparatedByString:@"\n"];
    return lines;
    
}

@end
