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
    
    //Set all labels with variables
    UILabel *labelOne = (UILabel *)[self.view viewWithTag:1];
    UILabel *labelTwo = (UILabel *)[self.view viewWithTag:2];
    UILabel *labelThree = (UILabel *)[self.view viewWithTag:3];
    UILabel *labelFour = (UILabel *)[self.view viewWithTag:4];
    UILabel *labelFive = (UILabel *)[self.view viewWithTag:5];
    UILabel *labelSix = (UILabel *)[self.view viewWithTag:6];
    UILabel *labelSeven = (UILabel *)[self.view viewWithTag:7];
    UILabel *labelEight = (UILabel *)[self.view viewWithTag:8];
    UILabel *labelNine = (UILabel *)[self.view viewWithTag:9];
    UILabel *labelTen = (UILabel *)[self.view viewWithTag:10];
    
    [self setLabel:2 with:self.place.getAllHoursAsString];
    [self setLabel:4 with:self.place.location];
    [self setLabel:6 with:self.place.phone];
    [self setLabel:8 with:self.place.email];
    [self setLabel:10 with:self.place.webLink];
    
    //Loop: set the label sizes
    NSMutableArray *labelArray = [[NSMutableArray alloc] init];
    [labelArray addObject:labelOne];
    [labelArray addObject:labelTwo];
    [labelArray addObject:labelThree];
    [labelArray addObject:labelFour];
    [labelArray addObject:labelFive];
    [labelArray addObject:labelSix];
    [labelArray addObject:labelSeven];
    [labelArray addObject:labelEight];
    [labelArray addObject:labelNine];
    [labelArray addObject:labelTen];
    
    //Constant offset
    CGFloat betweenSpace = 10;
    
    //Loop through array and set all the labels
    for (NSInteger i = 0; i < 10; i++) {
        UILabel *fitLabel = (UILabel *)[labelArray objectAtIndex:i];
        [fitLabel sizeToFit];
    }
    
    for (NSInteger i = 1; i < 10; i++) {
        UILabel *fitLabel = (UILabel *)[labelArray objectAtIndex:i];
        UILabel *prevLabel = (UILabel *)[labelArray objectAtIndex:i-1];
        
        CGRect fitFrame  = fitLabel.frame;
        fitFrame.origin.y = prevLabel.frame.origin.y + prevLabel.frame.size.height;
        [fitLabel setFrame:fitFrame];
        
    }
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
