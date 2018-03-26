//
//  llt.m
//  LLTrackEventSDK
//
//  Created by admin on 2018/3/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LLTrackEventManager.h"
#import "FMDB.h"
#import "Reachability.h"
#import "LLNetworkManager.h"
#import "NSDictionary+TrackEvent.h"
@interface LLTrachEventManager ()

@property (nonatomic, assign) NSTimer *timer;

/** 数据库 */
@property (nonatomic, strong) FMDatabase * db;

/** 沙盒目录 */
@property (nonatomic, strong) NSString * docPath;

/*网络状态*/
@property (nonatomic, strong) Reachability *networkStatus;

/*判断是否处于上传状态*/
@property (nonatomic, assign) BOOL isUpLoad;

@end

@implementation LLTrachEventManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id trachEventManager;
    dispatch_once( &once, ^{
        trachEventManager= [[self alloc] init];
       
    } );
    return trachEventManager;
}

-(instancetype)init{
    self=[super init];
    if (self) {
         _isUpLoad=NO;
         [self reachNetWork];
    }
    return self;
}

-(void)reachNetWork{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.networkStatus = [Reachability reachabilityForInternetConnection];
    [self.networkStatus startNotifier];
    
}

#pragma mark  ====================  判断wifi还是wwan下上传本地数据  ================
-(void)networkStateChange{
    
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status =[conn currentReachabilityStatus];
    // 3.判断网络状态
    if (status==ReachableViaWiFi) { // 有wifi
        [_timer setFireDate:[NSDate distantFuture]];  //暂停定时器
        NSLog(@"有wifi");
        [self selectDataUpload];
    } else if (status==ReachableViaWWAN) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
         [_timer setFireDate:[NSDate distantPast]]; //手机网络开启 开启定时器
    } else { // 没有网络
        NSLog(@"没有网络");
         [_timer setFireDate:[NSDate distantFuture]];
    }
    
}

-(void)selectDataUpload{
    NSArray *array=[self selectDataPool];
    if (!array) {
        return;
    }
    
    [self uploadTrackEventData:array];
}

-(void)uploadTrackEventData:(NSArray *)dataArray{
    _isUpLoad=YES;
    [[LLNetworkManager sharedNetWorkManager] POSTWithURL:@"http//:www.baidu.com" parameters:nil success:^(NSDictionary *dit) {
        
        [self deleteDataPoolArray:nil];
        _isUpLoad=NO;
    } failure:^(NSString *error) {
        _isUpLoad=NO;
    }];
}


-(void)startTimeTrachEventDataWithTimeSpeed:(CGFloat)timeSpeed{
    
    [self initFMDB];
    
    if (timeSpeed<20.0) {
        timeSpeed=20.0;
    }
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeSpeed target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
       
    }
    [self networkStateChange];
}
-(void)timerAction:(id)sender{
    NSLog(@"doing");
    [self selectDataUpload];
}


-(void)closeTimerTrachEvent{
    if (_timer) {
        NSLog(@"1退出");
        [_timer invalidate];
        _timer=nil;
    }
}



-(void)initFMDB{
    //1.获取数据库文件的路径
    _docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"数据库路径%@",_docPath);
    
    //设置数据库名称
    NSString *fileName = [_docPath stringByAppendingPathComponent:@"trackEvent.sqlite"];
    //2.获取数据库
    _db = [FMDatabase databaseWithPath:fileName];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
    
    [self createTrachTable];
}
#pragma mark  ====================  初始化表  ================
-(void)createTrachTable{
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS trachEvent (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL);"];
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}
#pragma mark  ====================  插入事件  ================
-(void)insertDataToDataPoolTrackEventId:(NSString *)eventId parameters:(NSDictionary *)param{
    if (!eventId) {return ;}
    
    if (!param) {return;}
    
    NSString *jsonString=[NSDictionary jsonStringDictionary:param];
    
    //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
    BOOL result = [_db executeUpdate:@"INSERT INTO trachEvent (id,name) VALUES (?,?)",eventId,jsonString];
    //2.executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
    //    BOOL result = [_db executeUpdateWithFormat:@"insert into t_student (name,age, sex) values (%@,%i,%@)",name,age,sex];
    //3.参数是数组的使用方式
    //    BOOL result = [_db executeUpdate:@"INSERT INTO t_student(name,age,sex) VALUES  (?,?,?);" withArgumentsInArray:@[name,@(age),sex]];
    if (result) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    
//    [self selectDataPool];
    [self networkStateChange];
}

-(NSArray *)selectDataPool{
    //查询整个表
    FMResultSet * resultSet = [_db executeQuery:@"select * from trachEvent limit 10"];
    //根据条件查询
    //FMResultSet * resultSet = [_db executeQuery:@"select * from t_student where id < ?", @(4)];
    NSMutableArray *resultArray=[[NSMutableArray alloc]init];
    //遍历结果集合
    while ([resultSet next]) {
//        int idNum = [resultSet intForColumn:@"id"];
//        NSString *name = [resultSet objectForColumnName:@"name"];
//        int age = [resultSet intForColumn:@"age"];
//        NSString *sex = [resultSet objectForColumnName:@"sex"];
        [resultArray addObject:resultSet.resultDictionary];
//        NSLog(@"我晕--%@ %i",resultSet.resultDictionary,[resultSet intForColumn:@"id"]);
    }
    return resultArray;
}

-(void)deleteDataPoolArray:(NSArray *)array{
    //1.不确定的参数用？来占位 （后面参数必须是oc对象,需要将int包装成OC对象）
    int idNum = 11;
    BOOL result = [_db executeUpdate:@"delete from trachEvent where id = ?",@(idNum)];
    //2.不确定的参数用%@，%d等来占位
    //BOOL result = [_db executeUpdateWithFormat:@"delete from t_student where name = %@",@"王子涵"];
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    
}

-(void)changeDataPool{
    //修改学生的名字
    NSString *newName = @"李浩宇";
    NSString *oldName = @"王子涵2";
    BOOL result = [_db executeUpdate:@"update trachEvent set name = ? where name = ?",newName,oldName];
    if (result) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
    
}

#pragma mark  ====================  事件开始追踪  ================
-(void)trackEventPageBegin:(NSString *)pageName{
    
}
#pragma mark  ====================  事件结束追踪  ================
-(void)trackEventPageEnd:(NSString *)pageName{
    
}


@end
