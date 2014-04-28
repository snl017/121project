//
//  iNeedAppDelegate.h
//  iNeed
//
//  Created by jarthurcs on 2/18/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDatabase.h"
#import "Constants.h"
#import "Place.h"
#import "Hours.h"



@interface iNeedAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//METHODS
//This is the tester function that just makes sure the database queries are working.
- (void)testDatabase;



@end
