//
//  NSDictionary+TrackEvent.m
//  LLTrackEventSDK
//
//  Created by admin on 2018/3/21.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "NSDictionary+TrackEvent.h"

@implementation NSDictionary (TrackEvent)

+(NSString *)jsonStringDictionary:(NSDictionary *)dic{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
