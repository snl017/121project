//
//  PlaceDatabase.m
//  iNeed
//
//  Created by Anna Turner on 2/17/14.
//  Copyright (c) 2014 Anna Turner. All rights reserved.
//

#import "PlaceDatabase.h"

@implementation PlaceDatabase

//Our Database is called db
static sqlite3 *db;

//Statements: Fetching each place, or deleting,inserting a place. Also creating database
static sqlite3_stmt *createPlaceDatabase;
static sqlite3_stmt *fetchPlaces;
static sqlite3_stmt *deletePlace;
static sqlite3_stmt *insertPlace;

//Specialized statements: Fetching by broad, specific, name categories, empty database
static sqlite3_stmt *selectBroadCategoryPlaces;
static sqlite3_stmt *selectSpecificCategoryPlaces;
static sqlite3_stmt *selectNamePlaces;
static sqlite3_stmt *emptyDatabase;

//Update statements for updating hours! This will be used once we implement scraping.
static sqlite3_stmt *updateMondayHoursByNameStmt;
static sqlite3_stmt *updateTuesdayHoursByNameStmt;
static sqlite3_stmt *updateWednesdayHoursByNameStmt;
static sqlite3_stmt *updateThursdayHoursByNameStmt;
static sqlite3_stmt *updateFridayHoursByNameStmt;
static sqlite3_stmt *updateSaturdayHoursByNameStmt;
static sqlite3_stmt *updateSundayHoursByNameStmt;
static sqlite3_stmt *updateAllHoursByNameStmt; //This will work by looking at the monday-sunday hours in the same table entry

//TODO - searching by school if we ever get to that

//Statements for the Categories table: Fetching, deleting, inserting, creating table.
static sqlite3_stmt *createCatTable;
static sqlite3_stmt *deleteCat;
static sqlite3_stmt *insertCat;

//Specialized statements: Fetching by broad, specific, name categories, empty database
static sqlite3_stmt *selectBroadCategoryCat;
static sqlite3_stmt *selectSpecificCategoryCat;
static sqlite3_stmt *emptyCategories;

//Create Database if Needed.
+ (void)createEditableCopyOfDatabaseIfNeeded {
    
    BOOL success;
    
    // Look for an existing database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"placeDatabase.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    NSLog(@"%@", writableDBPath);
    if (success) return;
    
    // if failed to find one, copy the empty scrapdatabase database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"placeDatabase.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}



//Setup of Database.
//School - name - broad category - specific category - location - monday - tuesday - wednesday - thursday - friday - saturday - sunday - allhours - phone - email - link//
+ (void)initDatabase{
    
    //These are the actual calls to sqlite table placeDatabase.
        //Creation, fetchall, insert, delete, empty database queries
    const char *createTableString = "CREATE TABLE IF NOT EXISTS placeDatabase (rowid INTEGER PRIMARY KEY AUTOINCREMENT, school TEXT, name TEXT, broad TEXT, specific TEXT, location TEXT, monday TEXT, tuesday TEXT, wednesday TEXT, thursday TEXT, friday TEXT, saturday TEXT, sunday TEXT, allhours TEXT, phone TEXT, email TEXT, link TEXT)";
    const char *fetchPlacesString = "SELECT * FROM placeDatabase";
    const char *insertPlaceString = "INSERT INTO placeDatabase (school, name, broad, specific, location, monday, tuesday, wednesday, thursday, friday, saturday, sunday, allhours, phone, email, link) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    const char *deletePlaceString = "DELETE FROM placeDatabase WHERE rowid=?";
    const char *emptyDatabaseString = "DELETE FROM placeDatabase;";
        //Specific selection queries
    const char *selectBroadCategoryPlacesString = "SELECT * FROM placeDatabase WHERE broad=?";
    const char *selectSpecificCategoryPlacesString = "SELECT * FROM placeDatabase WHERE specific=?";
    const char *selectNamePlacesString = "SELECT * FROM placeDatabase WHERE name=?";
        //Update queries
    const char *updateMondayHoursByNameString = "UPDATE placeDatabase SET monday=? WHERE name=?";
    
    //Calls to the sqlite table categories
    //Creation, fetchall, insert, delete, empty database queries
    const char *createCatTableString = "CREATE TABLE IF NOT EXISTS categories (rowid INTEGER PRIMARY KEY AUTOINCREMENT, broad TEXT, specific TEXT, name TEXT)";
    const char *insertCatString = "INSERT INTO categories (broad, specific, name) VALUES (?, ?, ?)";
    const char *deleteCatString = "DELETE FROM categories WHERE rowid=?";
    const char *emptyCatTableString = "DELETE FROM categories;";
    //Specific selection queries
    const char *selectBroadCatString = "SELECT name FROM categories WHERE broad=?";
    const char *selectSpecificCatString = "SELECT name FROM categories WHERE specific=?";
   
    
    
    // Create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"placeDatabase"];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    int success;
    
    
    //init table statement for placeDatabase table
    if (sqlite3_prepare_v2(db, createTableString, -1, &createPlaceDatabase, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare create table statement for places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    
    // execute the table creation statement
    success = sqlite3_step(createPlaceDatabase);
    sqlite3_reset(createPlaceDatabase);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create table placeDatabase");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchPlacesString, -1, &fetchPlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare fetching statement for places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    //init insertion statement
    if (sqlite3_prepare_v2(db, insertPlaceString, -1, &insertPlace, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare inserting statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deletePlaceString, -1, &deletePlace, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare deleting statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    // init select broad statement
    if (sqlite3_prepare_v2(db, selectBroadCategoryPlacesString, -1, &selectBroadCategoryPlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectBroadCategoryPlaces statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    // init select specific statement
    if (sqlite3_prepare_v2(db, selectSpecificCategoryPlacesString, -1, &selectSpecificCategoryPlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectSpecificCategoryPlaces statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    // init select name statement
    if (sqlite3_prepare_v2(db, selectNamePlacesString, -1, &selectNamePlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectNamePlaces statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    // init empty statement
    if (sqlite3_prepare_v2(db, emptyDatabaseString, -1, &emptyDatabase, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare empty database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init all the update hours satements
    if (sqlite3_prepare_v2(db, updateMondayHoursByNameString, -1, &updateMondayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update monday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    
    //Prepare the statements for the categories table
    //init table statement for categories table
    if (sqlite3_prepare_v2(db, createCatTableString, -1, &createCatTable, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare create table statement for categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    //execute table creation statement
    success = sqlite3_step(createCatTable);
    sqlite3_reset(createCatTable);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create table categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    //init insertion statement for categories
    if (sqlite3_prepare_v2(db, insertCatString, -1, &insertCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare inserting statement for categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deleteCatString, -1, &deleteCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare deleting statement for categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    // init select broad statement for categories table
    if (sqlite3_prepare_v2(db, selectBroadCatString, -1, &selectBroadCategoryCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectBroadCategoryPlaces statement for categories table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    // init select specific statement
    if (sqlite3_prepare_v2(db, selectSpecificCatString, -1, &selectSpecificCategoryCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectSpecificCategoryPlaces statement for categories table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    // init empty statement for categories table
    if (sqlite3_prepare_v2(db, emptyCatTableString, -1, &emptyCategories, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare empty database statement for categories table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
}

/*
 * These next several methods pertain to the categories table.
 *
 *
 */
 
+(NSMutableArray *) fetchNamesbySpecific:(NSString *)specific{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectSpecificCategoryCat, 1, [specific UTF8String], -1, SQLITE_TRANSIENT);
        
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
        
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectSpecificCategoryCat) == SQLITE_ROW) {
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryCat,0)];
        [ret addObject:nameString];
        }
    
    //Reset!
    sqlite3_reset(selectSpecificCategoryCat);
    return ret;
}

+(NSMutableArray *) fetchNamesbyBroad:(NSString *)broad{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectBroadCategoryCat, 1, [broad UTF8String], -1, SQLITE_TRANSIENT);
    
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectBroadCategoryCat) == SQLITE_ROW) {
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryCat,0)];
        [ret addObject:nameString];
    }
    
    //Reset!
    sqlite3_reset(selectBroadCategoryCat);
    return ret;
}

+(void) savePlace:(NSString *)name withSpecificCategory:(NSString *)specific andBroadCategory:(NSString*)broad{
    // bind data to the statement
    sqlite3_bind_text(insertCat, 1, [broad UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertCat, 2, [specific UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertCat, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(insertCat);
    
    //Reset!
    sqlite3_reset(insertPlace);
    
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert item");
    }
}


//School - name - broad category - specific category - location - monday - tuesday - wednesday - thursday - friday - saturday - sunday - allhours - phone - email - link//
//Read in everything from database
+ (NSMutableArray *)fetchAllPlaces
{
    //Create array to hold information
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(fetchPlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 16)];
        
        //Now we turn the hour-related strings to Hours objects in order to make a Place object.
        Hours *mondayHours = [[Hours alloc] initWithOneString:mondayString];
        Hours *tuesdayHours = [[Hours alloc] initWithOneString:tuesdayString];
        Hours *wednesdayHours = [[Hours alloc] initWithOneString:wednesdayString];
        Hours *thursdayHours = [[Hours alloc] initWithOneString:thursdayString];
        Hours *fridayHours = [[Hours alloc] initWithOneString:fridayString];
        Hours *saturdayHours = [[Hours alloc] initWithOneString:saturdayString];
        Hours *sundayHours = [[Hours alloc] initWithOneString:sundayString];
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayHours andTuesdayHours:tuesdayHours andWednesdayHours:wednesdayHours andThursdayHours:thursdayHours andFridayHours:fridayHours andSaturdayHours:saturdayHours andSundayHours:sundayHours andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
    }
    
    //Reset and Return
    sqlite3_reset(fetchPlaces);
    return ret;
}

//More Fetching/Selecting functions
+ (NSMutableArray *)fetchPlacesByName:(NSString *)name{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectNamePlaces, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectNamePlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 16)];
        
        //Now we turn the hour-related strings to Hours objects in order to make a Place object.
        Hours *mondayHours = [[Hours alloc] initWithOneString:mondayString];
        Hours *tuesdayHours = [[Hours alloc] initWithOneString:tuesdayString];
        Hours *wednesdayHours = [[Hours alloc] initWithOneString:wednesdayString];
        Hours *thursdayHours = [[Hours alloc] initWithOneString:thursdayString];
        Hours *fridayHours = [[Hours alloc] initWithOneString:fridayString];
        Hours *saturdayHours = [[Hours alloc] initWithOneString:saturdayString];
        Hours *sundayHours = [[Hours alloc] initWithOneString:sundayString];
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayHours andTuesdayHours:tuesdayHours andWednesdayHours:wednesdayHours andThursdayHours:thursdayHours andFridayHours:fridayHours andSaturdayHours:saturdayHours andSundayHours:sundayHours andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        //Should we be checking for success here?
    }
    
    //Reset the statement
    sqlite3_reset(selectNamePlaces);
    
    //if (success != SQLITE_DONE) {
    //    NSLog(@"ERROR: failed to select by name");
    //}
    
    //Return
    return ret;
}

+ (NSMutableArray *)fetchPlacesByBroadCategory:(NSString *)broadCategory{
    
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectBroadCategoryPlaces, 1, [broadCategory UTF8String], -1, SQLITE_TRANSIENT);

    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectBroadCategoryPlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryPlaces, 16)];
        
        
        //Now we turn the hour-related strings to Hours objects in order to make a Place object.
        Hours *mondayHours = [[Hours alloc] initWithOneString:mondayString];
        Hours *tuesdayHours = [[Hours alloc] initWithOneString:tuesdayString];
        Hours *wednesdayHours = [[Hours alloc] initWithOneString:wednesdayString];
        Hours *thursdayHours = [[Hours alloc] initWithOneString:thursdayString];
        Hours *fridayHours = [[Hours alloc] initWithOneString:fridayString];
        Hours *saturdayHours = [[Hours alloc] initWithOneString:saturdayString];
        Hours *sundayHours = [[Hours alloc] initWithOneString:sundayString];
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayHours andTuesdayHours:tuesdayHours andWednesdayHours:wednesdayHours andThursdayHours:thursdayHours andFridayHours:fridayHours andSaturdayHours:saturdayHours andSundayHours:sundayHours andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        //Should we be checking for success here?
    }
    
    //Reset the statement
    sqlite3_reset(selectBroadCategoryPlaces);
    
    //if (success != SQLITE_DONE) {
    //    NSLog(@"ERROR: failed to select by broad category");
    //}
    
    //Return
    return ret;
}


+ (NSMutableArray *)fetchPlacesBySpecificCategory:(NSString *)specificCategory{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectSpecificCategoryPlaces, 1, [specificCategory UTF8String], -1, SQLITE_TRANSIENT);
    
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectSpecificCategoryPlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryPlaces, 16)];
        
        //Now we turn the hour-related strings to Hours objects in order to make a Place object.
        Hours *mondayHours = [[Hours alloc] initWithOneString:mondayString];
        Hours *tuesdayHours = [[Hours alloc] initWithOneString:tuesdayString];
        Hours *wednesdayHours = [[Hours alloc] initWithOneString:wednesdayString];
        Hours *thursdayHours = [[Hours alloc] initWithOneString:thursdayString];
        Hours *fridayHours = [[Hours alloc] initWithOneString:fridayString];
        Hours *saturdayHours = [[Hours alloc] initWithOneString:saturdayString];
        Hours *sundayHours = [[Hours alloc] initWithOneString:sundayString];
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayHours andTuesdayHours:tuesdayHours andWednesdayHours:wednesdayHours andThursdayHours:thursdayHours andFridayHours:fridayHours andSaturdayHours:saturdayHours andSundayHours:sundayHours andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        //Should we be checking for success here?
    }
    
    //Reset the statement
    sqlite3_reset(selectSpecificCategoryPlaces);
    
    //Return
    return ret;
}



//Save Function: saving item into database. Will we need to use this? Probably not. But it's good to have just in case.
+ (void)saveItemWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink{
    
    //PlaceDatabase Table
    // bind data to the statement
    sqlite3_bind_text(insertPlace, 1, [school UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 3, [broadCategory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 4, [specificCategory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 5, [location UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 6, [monday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 7, [tuesday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 8, [wednesday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 9, [thursday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 10, [friday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 11, [saturday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 12, [sunday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 13, [allhours UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 14, [phone UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 15, [email UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 16, [webLink UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success1 = sqlite3_step(insertPlace);
    
    //Reset!
    sqlite3_reset(insertPlace);
    
    //categories Table
    // bind data to the statement
    sqlite3_bind_text(insertCat, 1, [broadCategory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertCat, 2, [specificCategory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertCat, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
    
    int success2 = sqlite3_step(insertCat);
    
    //Reset!
    sqlite3_reset(insertCat);
    
    if (success1 != SQLITE_DONE || success2!=SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert item");
    }
}

+ (void)saveItemWithPlace:(Place *)place{
    //Convert Hours into database-friendly strings
    NSString *mondayString = [place.mondayHours hoursToDatabaseString];
    NSString *tuesdayString = [place.tuesdayHours hoursToDatabaseString];
    NSString *wednesdayString = [place.wednesdayHours hoursToDatabaseString];
    NSString *thursdayString = [place.thursdayHours hoursToDatabaseString];
    NSString *fridayString = [place.fridayHours hoursToDatabaseString];
    NSString *saturdayString = [place.saturdayHours hoursToDatabaseString];
    NSString *sundayString = [place.sundayHours hoursToDatabaseString];
    
    //Use those strings in saving to database
    [self saveItemWithSchool:place.school andName:place.name andBroadCategory:place.broadCategory andSpecificCategory:place.specificCategory andLocation:place.location andMondayHours:mondayString andTuesdayHours:tuesdayString andWednesdayHours:wednesdayString andThursdayHours:thursdayString andFridayHours:fridayString andSaturdayHours:saturdayString andSundayHours:sundayString andAllHours:place.allHours andPhoneString:place.phone andEmailString:place.email andLinkString:place.webLink];
}



//Again, unclear if we are going to be deleting from our app. Can remove this function if necessary.
//Delete Item from database
+ (void)deletePlace:(int)rowid;
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deletePlace, 1, rowid);    //I AM UNSURE IF SHOULD BE 1 OR 0
    int success = sqlite3_step(deletePlace);
    sqlite3_reset(deletePlace);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete item");
    }
}


//NOTE: these need to accept Hours objects.
//All the update methods.
//Update Monday Hours
//+ (void)updateMondayHoursByName:(NSString *)name{
//    //Query takes in name and updated hours. Check hour against correct format and abort with message
//    //If incorrect format. Otherwise proceed. Bind values to query and then proceed with step stmt.
//    
//}
//+ (void)updateTuesdayHoursByName:(NSString *)name{
//    
//}
//+ (void)updateWednesdayHoursByName:(NSString *)name{
//    
//}
//+ (void)updateThursdayHoursByName:(NSString *)name{
//    
//}
//+ (void)updateFridayHoursByName:(NSString *)name{
//    
//}
//+ (void)updateSaturdayHoursByName:(NSString *)name{
//    
//}
//+ (void)updateSundayHoursByName:(NSString *)name{
//    
//}
//+ (void)updateAllHoursByName:(NSString *)name{
//    
//}






//Completely empty the databse. Please do not call accidentally.
+ (void)emptyDatabase{
    sqlite3_step(emptyDatabase);
    sqlite3_step(emptyCategories);
}


//Cleanup Function
+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchPlaces);
    sqlite3_finalize(insertPlace);
    sqlite3_finalize(deletePlace);
    sqlite3_finalize(createPlaceDatabase);
    sqlite3_close(db);
}






@end
