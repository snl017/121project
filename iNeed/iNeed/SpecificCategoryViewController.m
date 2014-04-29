//
//  SpecificCategoryViewController.m
//  iNeed
//
//  Created by jarthurcs on 4/1/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "SpecificCategoryViewController.h"
#import "Constants.h"
#import "DetailsTableViewController.h"

@interface SpecificCategoryViewController ()

@end

@implementation SpecificCategoryViewController

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
    
    //Set background image
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shorterClock1136.png"]];
    self.backgroundImageView.frame = self.view.bounds;
    [[self view] addSubview:self.backgroundImageView];
    [self.backgroundImageView.superview sendSubviewToBack:self.backgroundImageView];

    
    //Set the title to be the broad category
    [self setTitle:self.category];
    
    //Set the two buttons for the specific categories to be the specific categories
    //they should be as specified by the broad category
    if ([self.category isEqualToString:FoodBroad]){
        [self setLabel:1 with: DiningHallNarrow];
        [self setLabel:2 with: EateryGroceryNarrow];
    }else if ([self.category isEqualToString: ResourceCentersOfficesBroad]){
        [self setLabel:1 with: AcademicRCNarrow];
        [self setLabel:2 with: NonAcademicRCNarrow];
    }else if ([self.category isEqualToString: LivingOnCampusBroad]){
        [self setLabel:1 with: ServicesNarrow];
        [self setLabel:2 with: StoresNarrow];
    }
    
	// Do any additional setup after loading the view.
}

//A method to set the label of a button given a tag and a label element
-(void)setLabel:(int)tag with:(NSString*)element{
    UIButton *button =(UIButton*)[self.view viewWithTag:tag];
    [button setTitle:element forState:UIControlStateNormal];
    [button setTitle:element forState:UIControlStateSelected];
}
    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailsTableViewController *placesViewController = [segue destinationViewController];
    //button we've pressed
    UIButton *button = nil;
    if ([[segue identifier]isEqualToString:@"seg1"]){
        button = (UIButton*)[self.view viewWithTag:1];
    }
    else{
        button = (UIButton*)[self.view viewWithTag:2];
    }
    //Set the specific category we're looking for to the name
    //(a specific category) of the button the user pressed
    NSString *buttonLabel = button.currentTitle;
    placesViewController.specificCategory = buttonLabel;
    
}


@end
