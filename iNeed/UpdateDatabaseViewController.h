//
//  UpdateDatabaseViewController.h
//  iNeed
//
//  Created by jarthurcs on 4/2/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UpdateDatabaseViewController : UIViewController <NSStreamDelegate>

@property NSString *lastUpdate;
@property NSString *currentTime;

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;

-(void)initTimeStamp;
-(void)initNetworkCommunication;
-(void)sendTimeStamp;
-(void)updateTimeAndClose;

//- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)sender;

@end
