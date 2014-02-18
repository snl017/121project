//
//  PlaceDatabase.h
//  iNeed
//
//  Created by Anna Turner on 2/17/14.
//  Copyright (c) 2014 Anna Turner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import <sqlite3.h>

@interface PlaceDatabase : NSObject


//To create database and initialize, to fetch all places
//Also to save an item with info, to delete an item, to clean up database

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;
+ (void)saveItemWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink;
+ (void)deletePlace:(int)rowid;
+ (void)cleanUpDatabaseForQuit;

//Fetch/select statements
+ (NSMutableArray *)fetchAllPlaces;
+ (NSMutableArray *)fetchPlacesByName:(NSString *)name;
+ (NSMutableArray *)fetchPlacesByBroadCategory:(NSString *)broadCategory;
+ (NSMutableArray *)fetchPlacesBySpecificCategory:(NSString *)specificCategory;



@end
