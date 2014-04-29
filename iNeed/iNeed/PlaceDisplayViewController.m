//
//  PlaceDisplayViewController.m
//  iNeed
//
//  Created by jarthurcs on 2/25/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "PlaceDisplayViewController.h"
#import "Constants.h"

@interface PlaceDisplayViewController ()

@end

@implementation PlaceDisplayViewController

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
    /*UITextFields:
     Tag: 1 Labels: Hours
     Tag: 2 Displays: AllHours
     Tag: 3 Labels: Location
     Tag: 4 Displays: Location
     Tag: 5 Labels: Phone
     Tag: 6 Displays: Phone
     Tag: 7 Labels: Email
     Tag: 8 Displays: Email
     Tag: 9 Labels: Web
     Tag: 10 Displays: Web
     */
    [super viewDidLoad];
    //self.navigationController.navigationBar.topItem.leftBarButtonItem.title = @"";
    
    //Set background image
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"darkTickBg-01.png"]];
    self.backgroundImageView.frame = self.view.bounds;
    [[self view] addSubview:self.backgroundImageView];
    [self.backgroundImageView.superview sendSubviewToBack:self.backgroundImageView];
    
    
    [self setTitle:self.place.name];
    [self setLabel:2 with:self.place.getAllHoursAsString];
    [self setLabel:4 with:self.place.location];
    [self setLabel:6 with:self.place.phone];
    [self setLabel:8 with:self.place.email];
    [self setLabel:10 with:self.place.webLink];
    
   	// Do any additional setup after loading the view.
}
/*
 * Sets the text of a specific display label.
 * If the information to be displayed on the label is not available,
 * Remove all text from the label and the label explaining its contents.
 */
-(void)setLabel:(int)tag with:(NSString*)element{
    if([element isEqualToString:@""]){
        UITextField *label =(UITextField*)[self.view viewWithTag:(tag-1)];
        label.text = @"";
        UITextField *text =(UITextField*)[self.view viewWithTag:tag];
        text.text = @"";
    }else{
        UITextField *text =(UITextField*)[self.view viewWithTag:tag];
        text.text = element;
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
