//
//  iNeedTests.m
//  iNeedTests
//
//  Created by jarthurcs on 2/18/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlaceDatabase.h"
#import "Place.h"
#import "Hours.h"
#import "Constants.h"

@interface iNeedTests : XCTestCase

@end

@implementation iNeedTests

- (void)setUp
{
    [super setUp];
    [PlaceDatabase createEditableCopyOfDatabaseIfNeeded];
    [PlaceDatabase initDatabase];
    //Create some test Hours
    Hours *h1 = [[Hours alloc] initWithOneString:@"0100-0200"];
    Hours *h2 = [[Hours alloc] initWithOneString:@"0200-0300"];
    Hours *h3 = [[Hours alloc] initWithOneString:@"0300-0400"];
    Hours *h4 = [[Hours alloc] initWithOneString:@"0400-0500"];
    Hours *closed = [[Hours alloc]initAsClosedAllDay];
    
    //Create a test place
    Place *testPlace = [[Place alloc] initWithSchool:@"testSchool" andName:@"testName" andLocation:@"testLocation" andMondayHours:h1 andTuesdayHours:h1 andWednesdayHours:h2 andThursdayHours:h3 andFridayHours:h4 andSaturdayHours:closed andSundayHours:closed andPhoneString:@"123-456-7890" andEmailString:@"testEmail" andLinkString:@"testLink" andExtraInfo:@"testExtra"];
    Place *inTestSpecific = [[Place alloc]initWithSchool:None andName:@"inTestSpecific" andLocation:None andMondayHours:h1 andTuesdayHours:h1 andWednesdayHours:h1 andThursdayHours:h1 andFridayHours:h1 andSaturdayHours:h1 andSundayHours:h1 andPhoneString:None andEmailString:None andLinkString:None andExtraInfo:None];
    Place *inTestBroad = [[Place alloc]initWithSchool:None andName:@"inTestBroad" andLocation:None andMondayHours:h1 andTuesdayHours:h1 andWednesdayHours:h1 andThursdayHours:h1 andFridayHours:h1 andSaturdayHours:h1 andSundayHours:h1 andPhoneString:None andEmailString:None andLinkString:None andExtraInfo:None];
    
    
    //Save test place to database
    [PlaceDatabase saveItemWithPlace:testPlace andSpecificCategory:@"testSpecific" andBroadCategory:@"testBroad"];
    [PlaceDatabase saveItemWithPlace:inTestSpecific andSpecificCategory:@"testSpecific" andBroadCategory:None];
    [PlaceDatabase saveItemWithPlace:inTestBroad andSpecificCategory:None andBroadCategory:@"testBroad"];
}
//Ensure that we are inputting a data point
-(void)testInputToDatabase{
    XCTAssertNotNil([PlaceDatabase fetchAllPlaces]);
}
//Ensure that the delete works in the tearDown method of the tests
-(void)testDeleteByName{
    XCTAssertTrue([[PlaceDatabase fetchPlacesByName:@"testName" ] count]==1, @"d");
}

//test the place class
- (void)testPlaceClassInit{
    Hours *h1 = [[Hours alloc] initWithOneString:@"0100-0200"];
    Place *place = [[Place alloc]initWithSchool:@"placeSchool" andName:@"placeName" andLocation:@"placeLocation" andMondayHours:h1 andTuesdayHours:h1 andWednesdayHours:h1 andThursdayHours:h1 andFridayHours:h1 andSaturdayHours:h1 andSundayHours:h1 andPhoneString:@"phone" andEmailString:@"email" andLinkString:@"link" andExtraInfo:@"extras"];
    XCTAssertEqualObjects(place.school, @"placeSchool", @"d");
    XCTAssertEqualObjects(place.name, @"placeName", @"d");
    XCTAssertEqualObjects(place.location, @"placeLocation", @"d");
    XCTAssertEqualObjects(place.phone, @"phone", @"d");
    XCTAssertEqualObjects(place.email, @"email", @"d");
    XCTAssertEqualObjects(place.webLink, @"link", @"d");
    XCTAssertEqualObjects(place.extraInfo, @"extras", @"d");
}

//test the allHours method
- (void)testAllHoursMethod{
    Place *test = [[PlaceDatabase fetchPlacesByName:@"testName"] objectAtIndex:0];
    NSArray *hours = [test getAllHours];
    XCTAssertEqualObjects([hours objectAtIndex:0], @"Mon-Tue 1:00 am - 2:00 am", @"d");
    XCTAssertEqualObjects([hours objectAtIndex:1], @"Wed 2:00 am - 3:00 am", @"d");
    XCTAssertEqualObjects([hours objectAtIndex:2], @"Thu 3:00 am - 4:00 am", @"d");
    XCTAssertEqualObjects([hours objectAtIndex:3], @"Fri 4:00 am - 5:00 am", @"d");
    XCTAssertEqualObjects([hours objectAtIndex:4], @"Sat-Sun Closed", @"d");
    
}

//Test out Hours class
-(void)testHoursClass{
    Hours *normalHours = [[Hours alloc] initWithOneString:@"0955-1700"];
    XCTAssertNotNil(normalHours);
    
    NSString *dispString = [normalHours hoursToDisplayString];
    NSString *dataString = [normalHours hoursToDatabaseString];
    XCTAssertNotNil(dispString, @"@");
    XCTAssertNotNil(dataString, @"@");
    XCTAssertEqualObjects(dispString, @"9:55 am - 5:00 pm", @"@");
    XCTAssertEqualObjects(dataString, @"0955-1700", @"@");
    
    
    //These hours are initiated with a digits-dash-digits string presumably pulled from database
    //NOTE: may need to do checks on database inited hours to make sure valid, just as the checks are done for the regular init
    //This tests initWithOneString for a single hour set
    Hours *dbHours = [[Hours alloc] initWithOneString:@"0955-1700"];
    XCTAssertNotNil(dbHours);
    NSString *dispDbHours = [dbHours hoursToDisplayString];
    NSString *dataDbHours = [dbHours hoursToDatabaseString];
    XCTAssertEqualObjects(dispDbHours, @"9:55 am - 5:00 pm", @"@");
    XCTAssertEqualObjects(dataDbHours, @"0955-1700", @"@");
    //This tests initWithOneString for multiple hour set
    Hours *dbHoursMulti = [[Hours alloc] initWithOneString:@"0700-1300%1430-1700"];
    XCTAssertNotNil(dbHoursMulti);
    NSString *dispDbHoursMulti = [dbHoursMulti hoursToDisplayString];
    NSString *dataDbHoursMulti = [dbHoursMulti hoursToDatabaseString];
    XCTAssertEqualObjects(dispDbHoursMulti, @"7:00 am - 1:00 pm\n2:30 pm - 5:00 pm", @"@");
    XCTAssertEqualObjects(dataDbHoursMulti, @"0700-1300%1430-1700", @"@");
    
    //Closed!
    Hours *closed = [[Hours alloc]initAsClosedAllDay];
    XCTAssertNotNil(closed);
    NSString *closedString = [closed hoursToDisplayString];
    NSString *closedDataString = [closed hoursToDatabaseString];
    //
    XCTAssertEqualObjects(closedString, @"Closed", @"@");
    XCTAssertEqualObjects(closedDataString, @"Closed", @"@");
    
}


-(void)testSelectByName{
    NSMutableArray *places =[PlaceDatabase fetchPlacesByName:@"testName"];
    XCTAssertTrue([places count]==1, @"d");
    Place *test = [places objectAtIndex:0];
    XCTAssertEqualObjects(test.name, @"testName", @"@");
}

-(void)testSelectBySpecific{
    NSMutableArray *names =[PlaceDatabase fetchNamesbySpecific:@"testSpecific"];
    XCTAssertEqualObjects([names objectAtIndex:0], @"testName", @"@");
    XCTAssertEqualObjects([names objectAtIndex:1], @"inTestSpecific", @"@");
    
}
-(void)testSelectByBroad{
    NSMutableArray *names =[PlaceDatabase fetchNamesbyBroad:@"testBroad"];
    XCTAssertEqualObjects([names objectAtIndex:0], @"testName", @"@");
    XCTAssertEqualObjects([names objectAtIndex:1], @"inTestBroad", @"@");
}

//Update Hours test
-(void)testUpdateHours{
    Hours *newHours = [[Hours alloc] initWithOneString:@"0000-1000"];
    [PlaceDatabase updateMondayHoursByName:@"testName" andNewHours: newHours];
    NSMutableArray *places= [PlaceDatabase fetchPlacesByName:@"testName"];
    Place *test = [places objectAtIndex:0];
    XCTAssertEqualObjects(test.mondayHours.hoursToDisplayString, newHours.hoursToDisplayString, @"@");

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [PlaceDatabase deletePlaceByName:@"testName"];
    [PlaceDatabase deletePlaceByName:@"inTestSpecific"];
    [PlaceDatabase deletePlaceByName:@"inTestBroad"];
}



//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
