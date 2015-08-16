//
//  SettingViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 3/5/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (strong, nonatomic) UITableViewCell *appComments;
@property (strong, nonatomic) UITableViewCell *locationReporte;
@property (strong, nonatomic) UITableViewCell *parkingLog;
@property (strong, nonatomic) UITableViewCell *additionalFunctions;
@property (strong, nonatomic) UITableViewCell *notificationTime;
@property (strong, nonatomic) UITableViewCell *aboutDeveloper;
@property (strong, nonatomic) UITableViewCell *rateThisApp;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _appComments = [[UITableViewCell alloc]init];
    _locationReporte = [[UITableViewCell alloc]init];
    _parkingLog = [[UITableViewCell alloc]init];;
    _additionalFunctions = [[UITableViewCell alloc]init];
    _notificationTime = [[UITableViewCell alloc]init];
    _aboutDeveloper = [[UITableViewCell alloc]init];
    _rateThisApp = [[UITableViewCell alloc]init];
    
    _appComments.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _locationReporte.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _parkingLog.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _additionalFunctions.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _notificationTime.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _aboutDeveloper.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _rateThisApp.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    _appComments.textLabel.text = @"App comments";
    _locationReporte.textLabel.text = @"Location error reporte";
    _parkingLog.textLabel.text = @"Parking log";
    _additionalFunctions.textLabel.text = @"Additional functions";
    _notificationTime.textLabel.text = @"Notification time & Support area";
    _aboutDeveloper.textLabel.text = @"About developer";
    _rateThisApp.textLabel.text = @"Rate this app";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}
#pragma mark -
#pragma mark TableView delegate

// Return the number of sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 4;
}

// Return the event when tap on the cell
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: return [self AppComments];
                case 1: return [self LocationReporte];
            }
        case 1:
            switch (indexPath.row) {
                case 0: return [self AdditionalFunctions];
                case 1: return [self ParkingLog];
                case 2: return [self NotificationTime];
            }
        case 2:
            switch (indexPath.row) {
                case 0: return [self AboutDeveloper];
                case 1: return [self RateThisApp];
            }
    }
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return self.appComments;  // section 0, row 0 is the first name
            case 1: return self.locationReporte;   // section 0, row 1 is the last name
        }
        case 1:
            switch(indexPath.row)
        {
            case 0: return self.additionalFunctions;      // section 1, row 0 is the share option
            case 1: return self.parkingLog;
            case 2: return self.notificationTime;
        }
        case 2:
            switch(indexPath.row)
        {
            case 0: return self.aboutDeveloper;
            case 1: return self.rateThisApp;
        }
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch(section)
    {
        case 0:  return 2;  // section 0 has 2 rows
        case 1:  return 3;  // section 1 has 1 row
        case 2:  return 2;
        default: return 0;
    };
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0: return @"Report";
        case 1: return @"General";
        case 2: return @"Gfxcc";
        case 3: return Version;
    }
    return nil;
}

#pragma mark -
#pragma mark mail delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark reaction funcion to cell

- (void)AppComments {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"ParkingAssistance comment"];
    [controller setToRecipients:[[NSArray alloc] initWithObjects:@"yong_stevens@outlook.com", nil]];
    //if (controller) [self presentModalViewController:controller animated:YES];
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    //[controller release];
}

- (void)LocationReporte {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"ParkingAssistance Location ERROR!!!"];
    [controller setMessageBody:[NSString stringWithFormat:@"Last Data :\n %@\t%@\n%f\t%f\n\nERROR :\n",address,city,location.latitude,location.longitude] isHTML:NO];
    [controller setToRecipients:[[NSArray alloc] initWithObjects:@"yong_stevens@outlook.com", nil]];
    //if (controller) [self presentModalViewController:controller animated:YES];
    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)ParkingLog {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewUITestViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"parkinglog"];
    
    NewUITestViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NewUITestViewController.title = @"Parking Log";
    [self.navigationController pushViewController:NewUITestViewController animated:YES];
}

- (void)AdditionalFunctions {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewUITestViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"additionalFunctions"];
    
    NewUITestViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NewUITestViewController.title = @"Additional";
    [self.navigationController pushViewController:NewUITestViewController animated:YES];
}

- (void)NotificationTime {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewUITestViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"notificationTime"];
    
    NewUITestViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NewUITestViewController.title = @"Notification Time";
    [self.navigationController pushViewController:NewUITestViewController animated:YES];

}

- (void)AboutDeveloper {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewUITestViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"aboutDeveloper"];
    
    NewUITestViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NewUITestViewController.title = @"Developer";
    [self.navigationController pushViewController:NewUITestViewController animated:YES];
}

- (void)RateThisApp {
    
}


#pragma mark -
#pragma mark navigation
- (void)done {
    
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"Present Modal View");
    }];
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
