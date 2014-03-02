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

//Methods to handle the categories table
+(NSMutableArray *) fetchNamesbySpecific:(NSString *)specific;
+(NSMutableArray *) fetchNamesbyBroad:(NSString *)broad;
+(void) savePlace:(NSString *)name withSpecificCategory:(NSString *)specific andBroadCategory:(NSString*)broad;


//Updating Hours methods
//NOTICE: these need to be updated to accept Hours objects.
+ (void)updateMondayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateTuesdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateWednesdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateThursdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateFridayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateSaturdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateSundayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateAllHoursByName:(NSString *)name andNewHours:(Hours *)newHours;



@end
