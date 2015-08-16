//
//  AboutDeveloperViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 3/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AboutDeveloperViewController.h"

@interface AboutDeveloperViewController ()

@end

@implementation AboutDeveloperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:246.0/255 alpha:1.0];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(BoundLeft, 50, [UIScreen mainScreen].bounds.size.width - (BoundLeft * 2), 400)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.text = @"ParkingAssistance developed by gfxcc.\nThis guy is lazy. He left nothing.";
    [self.view addSubview:label];
    
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
