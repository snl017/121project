//
//  PlaceDisplayViewController.m
//  iNeed
//
//  Created by jarthurcs on 2/25/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "PlaceDisplayViewController.h"

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
    [super viewDidLoad];
    [self setTitle:self.place.name];
    UITextField *hoursText =(UITextField*)[self.view viewWithTag:1];
    hoursText.text = self.place.allHours;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
