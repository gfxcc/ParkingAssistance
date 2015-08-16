//
//  AdditionalFunctionsViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 3/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "AdditionalFunctionsViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface AdditionalFunctionsViewController ()

@property (strong, nonatomic) UITableViewCell *payHalfYear;

@end

@implementation AdditionalFunctionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    
    UIButton *parkingLog = [UIButton buttonWithType:UIButtonTypeSystem];
    [parkingLog setFrame:CGRectMake(70, 140, [UIScreen mainScreen].bounds.size.width - 40, 40)];

    UIButton *notification = [UIButton buttonWithType:UIButtonTypeSystem];
    [notification setFrame:CGRectMake(70, 200, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    title.text = @"Update to ParkingAssistance Premium";
    [parkingLog setTitle:@"Parking log with image" forState:UIControlStateNormal];
    [notification setTitle:@"Set notification for parking"forState:UIControlStateNormal];

    
//    title.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:246.0/255 alpha:1.0];
//    parkingLog.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:246.0/255 alpha:1.0];
//    notification.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:246.0/255 alpha:1.0];
    
    [title setFont:[UIFont fontWithName:@"Marlboro" size:22]];
    parkingLog.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    notification.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    //23 131 245
    [parkingLog setTitleColor:RGB(23, 131, 245) forState:UIControlStateNormal ];
    [notification setTitleColor:RGB(23, 131, 245) forState:UIControlStateNormal ];
    
    parkingLog.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    notification.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [parkingLog addTarget:self action:@selector(detailForParkingLog) forControlEvents:UIControlEventTouchUpInside];
    [notification addTarget:self action:@selector(deatilForNotfication) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageHolder_a = [[UIImageView alloc] initWithFrame:CGRectMake(30, 150, 20, 20)];
    UIImageView *imageHolder_b = [[UIImageView alloc] initWithFrame:CGRectMake(30, 210, 20, 20)];
    UIImage *image = [UIImage imageNamed:@"arrow right.png"];
    imageHolder_a.image = image;
    imageHolder_b.image = image;
    
    [self.view addSubview:title];
    [self.view addSubview:parkingLog];
    [self.view addSubview:notification];
    [self.view addSubview:imageHolder_a];
    [self.view addSubview:imageHolder_b];
    
    //add middle grey line
    CALayer *TopBorder = [CALayer layer];
    UIColor *borderColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:189.0/255 alpha:1.0];
    TopBorder.frame = CGRectMake(0.0f, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width, 50.0f);
    TopBorder.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder];
    
    //add status for premium
    UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 , [UIScreen mainScreen].bounds.size.width, 50)];
    [status setFont:[UIFont systemFontOfSize:22]];
    status.text = @"You are not subscribed";
    [status setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:status];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 + 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2)];
    
    _payHalfYear = [[UITableViewCell alloc]init];
    _payHalfYear.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _payHalfYear.textLabel.text = @"Subscribe for 6 Months         $1.99";
    
    tableView.delegate = self;
    tableView.dataSource = self;
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
    
    return 1;
}

// Return the event when tap on the cell
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: return [self payForHalfYear];
            }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return self.payHalfYear;  // section 0, row 0 is the first name
        }
    }
    return nil;
}

//
- (void)detailForParkingLog {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewUITestViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailforpre"];
    
    NewUITestViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NewUITestViewController.title = @"Parking Log";
    [self.navigationController pushViewController:NewUITestViewController animated:YES];
}

//
- (void)deatilForNotfication {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewUITestViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailforpre"];
    
    NewUITestViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NewUITestViewController.title = @"Notification";
    [self.navigationController pushViewController:NewUITestViewController animated:YES];
}
                    
                    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)payForHalfYear {
    
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
