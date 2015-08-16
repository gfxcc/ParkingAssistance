//
//  NotificationTimeViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 3/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "NotificationTimeViewController.h"

@interface NotificationTimeViewController ()

@property (strong, nonatomic) UIDatePicker *datepicker;
@property (strong, nonatomic) UITableViewCell *hoboken;
@property (strong, nonatomic) UITableViewCell *heights;
@property (strong, nonatomic) UITableViewCell *iWant;

@end

@implementation NotificationTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/notificationTime",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    NSArray *chosenTime = [content componentsSeparatedByString:@"\n"];
    _datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                 self.navigationController.navigationBar.frame.size.height,
                                                                 [UIScreen mainScreen].bounds.size.width,
                                                                 ([UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height) / 3)];
    _datepicker.datePickerMode = UIDatePickerModeCountDownTimer;
    _datepicker.minuteInterval = 15;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:[chosenTime[0] intValue]];
    [comps setMinute:[chosenTime[1] intValue]];
    NSDate *defaultTime = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    [_datepicker setDate:defaultTime animated:NO];
    [self.view addSubview:_datepicker];
    
    //
    
    CALayer *TopBorder = [CALayer layer];
    UIColor *borderColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:204.0/255 alpha:1.0];
    TopBorder.frame = CGRectMake(0.0f, _datepicker.frame.origin.y + _datepicker.frame.size.height, _datepicker.frame.size.width, 1.0f);
    TopBorder.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder];
    
    //uitableview
    _hoboken = [[UITableViewCell alloc] init];
    _heights = [[UITableViewCell alloc] init];
    _iWant = [[UITableViewCell alloc] init];
    
    _hoboken.selectionStyle = UITableViewCellSelectionStyleNone; // unselectable but not highlight
    [_heights setUserInteractionEnabled:NO];                     // unselectable     and highlight
    
    //_hoboken.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //_heights.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _iWant.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    _hoboken.textLabel.text = @"Hoboken NJ";
    _heights.textLabel.text = @"Heights Coming soon...";
    //_heights.textLabel.textColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:204.0/255 alpha:1.0];
    _iWant.textLabel.text = @"I WANR :";
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _datepicker.frame.size.height + _datepicker.frame.origin.y + 1, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _datepicker.frame.origin.y - _datepicker.frame.size.height - 1)];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    
    
}

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return _hoboken;  // section 0, row 0 is the first name
            case 1: return _heights;   // section 0, row 1 is the last name
            case 2: return _iWant;
        }
    }
    return nil;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 2: return [self iWantf];
                    
            }
    }
}

- (void)iWantf {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"ParkingAssistance support area"];
    [controller setToRecipients:[[NSArray alloc] initWithObjects:@"yong_stevens@outlook.com", nil]];
    //if (controller) [self presentModalViewController:controller animated:YES];
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    NSDate *chosen = [_datepicker date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:chosen];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSString *result = [NSString stringWithFormat:@"%ld\n%ld",(long)hour,(long)minute];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/notificationTime",
                          documentsDirectory];
    
    //save content to the documents directory
    [result writeToFile:fileName
             atomically:NO
               encoding:NSUTF8StringEncoding
                  error:nil];
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
