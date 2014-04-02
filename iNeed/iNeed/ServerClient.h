//
//  ServerClient.h
//  iNeed
//
//  Created by jarthurcs on 4/1/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerClient : NSObject<NSStreamDelegate>

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;

@end
