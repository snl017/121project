//
//  DetailsTableViewController.m
//  iNeed
//
//  Created by jarthurcs on 2/20/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "PlaceDatabase.h"
#import "PlaceDisplayViewController.h"

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
    [self setTitle:self.specificCategory];
    
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
    NSString *toDisplay = @"Today ";
    
    if ([dayOfWeek  isEqual: @"monday"]){
        toDisplay= [toDisplay stringByAppendingString: place.mondayHours.hoursToDisplayString];
    }
    else if ([dayOfWeek  isEqual: @"tuesday"]){
        toDisplay= [toDisplay stringByAppendingString: place.tuesdayHours.hoursToDisplayString];
    }
    else if ([dayOfWeek  isEqual: @"wednesday"]){
        toDisplay= [toDisplay stringByAppendingString: place.wednesdayHours.hoursToDisplayString];
    }
    else if ([dayOfWeek  isEqual: @"thursday"]){
        toDisplay= [toDisplay stringByAppendingString: place.thursdayHours.hoursToDisplayString];
    }
    else if ([dayOfWeek  isEqual: @"friday"]){
        toDisplay= [toDisplay stringByAppendingString: place.fridayHours.hoursToDisplayString];
    }
    else if ([dayOfWeek  isEqual: @"saturday"]){
        toDisplay= [toDisplay stringByAppendingString: place.saturdayHours.hoursToDisplayString];
    }
    else if ([dayOfWeek  isEqual: @"sunday"]){
        toDisplay= [toDisplay stringByAppendingString: place.sundayHours.hoursToDisplayString];
    }else{
        NSLog(@"ERROR: The day of the week is not correct");
    }
    cell.detailTextLabel.text = toDisplay;
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
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    PlaceDisplayViewController *destination = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Place *place = (self.places)[path.row];
    //Set the place of the PlaceDisplay to the place the user's selected
    destination.place = place;
    
}



@end
