//
//  ParkingMapViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 3/9/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "ParkingMapViewController.h"
#import "ZSPinAnnotation.h"
#import "ZSAnnotation.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ParkingMapViewController ()

@property (strong, nonatomic) NSMutableArray *parkingLog;

@end

@implementation ParkingMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _parkingLog = nil;
    _map.delegate = self;
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/parkingLog",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
//    //40.745913	-74.032440
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.745913, -74.032440), 1400, 1400);
//    [_map setRegion:viewRegion animated:YES];
    
    // Array
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    
    // Create some annotations
    ZSAnnotation *annotation = nil;
    
    if (![content isEqualToString:@""]) {
        _parkingLog =[[NSMutableArray alloc] initWithArray:[content componentsSeparatedByString:@"\n"]];
    }
    
    NSInteger count = _parkingLog.count;
    if (count == 0) {
        return;
    }
    double dif = 255 / count;
    
    for (NSInteger i = 0; i != _parkingLog.count; i++) {
        NSArray *inf = [_parkingLog[i] componentsSeparatedByString:@"\t"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([inf[2] doubleValue], [inf[3] doubleValue]);
        annotation = [[ZSAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.type = ZSPinAnnotationTypeTag;
        annotation.color = RGB(255, dif * i, dif * i);
        annotation.title = [NSString stringWithFormat:@"%@\t%@",inf[4],inf[5]];
        
        [annotationArray addObject:annotation];
    }
    
    _map.visibleMapRect = [self makeMapRectWithAnnotations:annotationArray];
    [_map addAnnotations:annotationArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // Don't mess with user location
    if(![annotation isKindOfClass:[ZSAnnotation class]])
        return nil;
    
    ZSAnnotation *a = (ZSAnnotation *)annotation;
    static NSString *defaultPinID = @"StandardIdentifier";
    
    // Create the ZSPinAnnotation object and reuse it
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)[_map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil){
        pinView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    // Set the type of pin to draw and the color
    pinView.annotationType = ZSPinAnnotationTypeTagStroke;
    pinView.annotationColor = a.color;
    pinView.canShowCallout = YES;
    
    
    return pinView;
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:1.5
                         animations:^{ annView.frame = endFrame; }];
    }
}


//40.757211	-74.029640    40.735376	-74.030373
- (MKMapRect)makeMapRectWithAnnotations:(NSArray *)annotations {
    
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    return flyTo;
    
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
