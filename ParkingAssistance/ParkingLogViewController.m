//
//  ParkingLogViewController.m
//  ParkingAssistance
//
//  Created by caoyong on 3/6/15.
//  Copyright (c) 2015 caoyong. All rights reserved.
//

#import "ParkingLogViewController.h"

//static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *cDetailID = @"detailCell"; // the cell containing the date picker
static NSString *cCommonCell = @"commonCell";     // the remaining cells at the end

@interface ParkingLogViewController ()

@property (strong, nonatomic) NSMutableArray *parkingLog;
@property (strong, nonatomic) NSIndexPath *detailIndexPath;

@end

@implementation ParkingLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
    [button setImage:pin.image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(parkingMap)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, pin.image.size.width * 0.7, pin.image.size.height * 0.7)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 50, 20)];
//    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
//    [label setText:@"test"];
//    label.textAlignment = UITextAlignmentCenter;
//    [label setTextColor:[UIColor whiteColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [button addSubview:label];
    
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    UIBarButtonItem *map = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:clear, map, nil];
    
    _detailIndexPath = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/parkingLog",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                       usedEncoding:nil
                                                              error:nil];
    if (![content isEqualToString:@""]) {
        _parkingLog =[[NSMutableArray alloc] initWithArray:[content componentsSeparatedByString:@"\n"]];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([self hasInlineDetail])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = _parkingLog.count;
        return ++numRows;
    }
    return _parkingLog.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ([self indexPathHasDetail:indexPath] ? 200 : _tableView.rowHeight);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    NSString *cellID = cCommonCell;
    
    if ([self indexPathHasDetail:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = cDetailID;     // the current/opened date picker cell
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDetail])
    {
        before = _detailIndexPath.row < indexPath.row;
    }
    
    NSInteger index = indexPath.row;
    if ([cellID isEqualToString:cCommonCell]) {

        if (before) {
            index --;
        }
        NSArray *inf = [_parkingLog[index] componentsSeparatedByString:@"\t"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",inf[4],inf[5]];
    } else {

        index = indexPath.row - 1;

        NSArray *inf = [_parkingLog[index] componentsSeparatedByString:@"\t"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/Snapshot/%@-%@.png",documentsDirectory,inf[4],inf[5]];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:fileName];
        UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        imageHolder.image = image;

        [cell addSubview:imageHolder];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if ([cCommonCell isEqualToString:cell.reuseIdentifier])
    {
        [self displayInlineDetailForRowAtIndexPath:indexPath];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)displayInlineDetailForRowAtIndexPath:(NSIndexPath *)indexPath {
    //display the image inline with tableview
    [_tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDetail])
    {
        before = _detailIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (_detailIndexPath.row - 1 == indexPath.row);
    
    // remove any detail cell if it exists
    if ([self hasInlineDetail])
    {
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_detailIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        _detailIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDetailForSelectedIndexPath:indexPathToReveal];
        _detailIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_parkingLog removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    }
}
#pragma mark -
#pragma mark function for detail in tabelView

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasDetail:(NSIndexPath *)indexPath
{
    return ([self hasInlineDetail] && _detailIndexPath.row == indexPath.row);
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDetailForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasDetailForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [_tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [_tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasDetailForIndexPath:(NSIndexPath *)indexPath
{
    //BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    if (checkDatePickerCell.reuseIdentifier == cDetailID) {
        return true;
    } else {
        return false;
    }
}

- (BOOL)hasInlineDetail
{
    return (_detailIndexPath != nil);
}

#pragma mark -
#pragma mark function

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/parkingLog",
                          documentsDirectory];
    NSString *newContent;//
    if (_parkingLog.count == 0) {
        newContent = @"";
    } else {
        newContent = _parkingLog[0];
        for (NSInteger i = 1; i != _parkingLog.count; i++) {
            newContent = [NSString stringWithFormat:@"%@\n%@",newContent,_parkingLog[i]];
        }
    }
    [newContent writeToFile:fileName
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:nil];

}

- (void)parkingMap {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewUITestViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"parkingMap"];
    
    NewUITestViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NewUITestViewController.title = @"Parking Map";
    [self.navigationController pushViewController:NewUITestViewController animated:YES];
}

- (void)clear {
    
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Confirm" message: @"Do you really want to delete all data?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [updateAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        //give deletion code here
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/parkingLog",
                              documentsDirectory];
        [@"" writeToFile:fileName
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
        [_parkingLog removeAllObjects];
        _detailIndexPath = nil;
        [_tableView reloadData];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *directory = [NSString stringWithFormat:@"%@/Snapshot/",documentsDirectory];
        NSError *error = nil;
        for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", directory, file] error:&error];
            if (!success || error) {
                // it failed.
            }
        }
    }
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
