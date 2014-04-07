//
//  HighLevelViewController.m
//  iNeed
//
//  Created by jarthurcs on 4/1/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "HighLevelViewController.h"
#import "SpecificCategoryViewController.h"
#import "Constants.h"
#import "DetailsTableViewController.h"

@interface HighLevelViewController ()

@end

@implementation HighLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //If the user has clicked safety/health, go straight to listing all of the places in safetyHealth's narrow category
    if([[segue identifier]isEqualToString:SafetyHealth]){
        DetailsTableViewController *placesViewController = [segue destinationViewController];
        placesViewController.specificCategory = SafetyHealth;
        
    }
    else if (![[segue identifier]isEqualToString:@"Update"]){
        // Get the new view controller using [segue destinationViewController].
        SpecificCategoryViewController *specificCatView =[segue destinationViewController];
        // Pass the broad category the user's clicked to the new view controller.
        //Note that the segue is named identically to the button the user clicks.
        specificCatView.category = [segue identifier];
    }
    
}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)sender
{
}

@end
