//
//  initDatabaseFromServer.h
//  iNeed
//
//  Created by Shannon Lubetich on 4/20/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface initDatabaseFromServer : NSObject <NSStreamDelegate>

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;

-(void)initNetworkCommunication;
-(void)sendTimeStamp;
-(void)updateTimeAndClose;

@end
