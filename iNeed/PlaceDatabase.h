//
//  PlaceDatabase.h
//  iNeed
//
//  Created by Anna Turner on 2/17/14.
//  Copyright (c) 2014 Anna Turner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "Constants.h"
#import "Hours.h"
#import <sqlite3.h>

@interface PlaceDatabase : NSObject



//To create database and initialize, to fetch all places
//Also to save an item with info, to delete an item, to clean up database
+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;
+ (void)saveItemWithPlace:(Place *)place;
+ (void)saveItemWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink;
+ (void)deletePlace:(int)rowid;
+ (void)cleanUpDatabaseForQuit;
+ (void)emptyDatabase;


//Fetch/select methods
+ (NSMutableArray *)fetchAllPlaces;
+ (NSMutableArray *)fetchPlacesByName:(NSString *)name;
+ (NSMutableArray *)fetchPlacesByBroadCategory:(NSString *)broadCategory;
+ (NSMutableArray *)fetchPlacesBySpecificCategory:(NSString *)specificCategory;

//Updating Hours methods
//NOTICE: these need to be updated to accept Hours objects.
//+ (void)updateMondayHoursByName:(NSString *)name;
//+ (void)updateTuesdayHoursByName:(NSString *)name;
//+ (void)updateWednesdayHoursByName:(NSString *)name;
//+ (void)updateThursdayHoursByName:(NSString *)name;
//+ (void)updateFridayHoursByName:(NSString *)name;
//+ (void)updateSaturdayHoursByName:(NSString *)name;
//+ (void)updateSundayHoursByName:(NSString *)name;
//+ (void)updateAllHoursByName:(NSString *)name;


//This method is for the updating hours methods. It checks the input format of the hours string




@end
