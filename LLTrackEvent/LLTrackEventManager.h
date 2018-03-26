//
//  llt.h
//  LLTrackEventSDK
//
//  Created by admin on 2018/3/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface LLTrachEventManager : NSObject

+ (instancetype)sharedInstance;


/**
 初始化数据库开启定时器上传数据
 */
-(void)startTimeTrachEventDataWithTimeSpeed:(CGFloat)timeSpeed;


/**
 关闭定时任务记录事件
 */
-(void)closeTimerTrachEvent;



/**
 插入数据进本地数据库
 @param eventId 触发事件Id
 @param param 触发事件的拼接字典
 */
-(void)insertDataToDataPoolTrackEventId:(NSString *)eventId parameters:(NSDictionary *)param;

/**
 开始跟踪某一页面，记录页面打开时间
 建议在viewWillAppear或者viewDidAppear方法里调用
 @param pageName 页面名称（自定义）
 */
-(void)trackEventPageBegin:(NSString *)pageName;


/**
 结束某一页面的跟踪（可选），记录页面的关闭时间
 此方法与trackPageBegin方法结对使用，
 建议在viewWillDisappear或者viewDidDisappear方法里调用
 @param pageName 页面名称，请跟trackPageBegin方法的页面名称保持一致
 */
-(void)trackEventPageEnd:(NSString *)pageName;

@end
