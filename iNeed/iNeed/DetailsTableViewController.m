//
//  DetailsTableViewController.m
//  iNeed
//
//  Created by jarthurcs on 2/20/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "PlaceDatabase.h"

@interface DetailsTableViewController ()

@end

@implementation DetailsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.places = [NSMutableArray new];
    self.places = [PlaceDatabase fetchPlacesBySpecificCategory:self.specificCategory];
    
   // [self.places initWithArray:[PlaceDatabase fetchPlacesBySpecificCategory:self.specificCategory]] ;
   
    NSLog(@"%i",[self.places count]);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlacesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    Place *place = (self.places)[indexPath.row];
    cell.textLabel.text = place.name;
    
    //Get the day of the week
    NSDateFormatter* day = [[NSDateFormatter alloc] init];
    [day setDateFormat: @"EEEE"];
    NSString *dayOfWeek=[[day stringFromDate:[NSDate date]]lowercaseString];
    
    if ([dayOfWeek  isEqual: @"monday"]){
        cell.detailTextLabel.text = place.mondayHours;
    }
    else if ([dayOfWeek  isEqual: @"tuesday"]){
        cell.detailTextLabel.text = place.tuesdayHours;
    }
    else if ([dayOfWeek  isEqual: @"wednesday"]){
        cell.detailTextLabel.text = place.wednesdayHours;
    }
    else if ([dayOfWeek  isEqual: @"thursday"]){
        cell.detailTextLabel.text = place.thursdayHours;
    }
    else if ([dayOfWeek  isEqual: @"friday"]){
        cell.detailTextLabel.text = place.fridayHours;
    }
    else if ([dayOfWeek  isEqual: @"saturday"]){
        cell.detailTextLabel.text = place.saturdayHours;
    }
    else if ([dayOfWeek  isEqual: @"sunday"]){
        cell.detailTextLabel.text = place.sundayHours;
    }else{
        NSLog(@"ERROR: The day of the week is not correct");
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
