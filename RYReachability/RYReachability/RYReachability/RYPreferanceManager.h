//
//  RYPreferanceManager.h
//  NewXinLing
//
//  Created by Dinotech on 15/12/24.
//  Copyright © 2015年 why. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetStatusManager.h"
#ifdef DEBUG
#   define RYLog(fmt, ...) NSLog((@"Method_%s [Current_Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define RYLog(...)
#endif
typedef NS_ENUM(NSInteger , NetWorkSatusType) {
    NetWorkSatusType_None =0x00,
    NetWorkSatusType_WiFi =0x01,
    NetWorkSatusType_2G = 0x02,
    NetWorkSatusType_3G = 0x03,
    NetWorkSatusType_4G = 0x04,
    /**
     *  暂不支持 检测5G类型 ，还未找到支持5G类型的
     */
    NetWorkSatusType_5G = 0x05,
    
};

typedef  void (^NetChangeStatusBlock)(NetWorkSatusType status);

@interface RYPreferanceManager : NSObject


/**
 *  是否支持一键换肤操作
 */
@property (nonatomic, assign, readwrite) BOOL  isSupportORMSkinChange;

@property (nonatomic, strong) RYNetStatusManager * netstatusManager;
@property (nonatomic,strong ) NSNumber * currentNumberType;

@property (nonatomic, copy) NetChangeStatusBlock netchangeNotifationBlock;

/**
 *  获取当前网络类型
 */
@property (nonatomic, assign) NetWorkSatusType  currentNetStatusType;

/**
 *  是否能够连接到WiFi网络
 *
 *  @return BOOL YES OR NO
 */
- (BOOL)canReachableViaWiFi;

/**
 *  蜂窝网络是否可达
 *
 *  @return 返回一个yes or no
 */
- (BOOL)canReachableViaWWAN;
/**
 *  获取最新的网络状态
 *
 *  @return NetWorkSatusType
 */

- (NetWorkSatusType )getReachablitySttatus;
/**
 * 监听当前网络状态类型 支持block 回调 返回一个 枚举类型的状态
 *
 *  @param complete 网络状态发生改变启用的回调处理
 */
- (void )getReachablityStatusWithChangeBlock:(void (^)(NetWorkSatusType status))complete;









/**
 *  创建单利设置管理类，包含网络，基本设置
 *
 *  @return 返回单利对象
 */
+ (instancetype)sharePreferanceManager;


@end
