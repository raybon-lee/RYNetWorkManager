//
//  RYNetStatusManager.h
//  RYReachability
//
//  Created by Dinotech on 15/12/23.
//  Copyright © 2015年 Dinotech. All rights reserved.
//
/*
 
 
 */
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <ifaddrs.h>

typedef NS_ENUM(NSInteger,RYReachabilityStatus) {
    /**
     *  Not Reachability
     */
    RYReachabilityStatus_None =0x00,
    /**
     *  当前网络状态是WiFi
     */
    RYReachabilityStatus_WiFi =0x01,
    /**
     *  当前网络链接的是蜂窝网络 （2G、3G/4G）
     */
    RYReachabilityStatus_WWAN =0x05,
    /**
     *  蜂窝网络无连接行为(信号较弱)
     */
    RYReachabilityStatus_WWAN_None ,
    /**
     *  当前网络为2G网络 （GPRS/EDGE） 10~100 Kbps
     */
    RYReachabilityStatus_WWAN_2G =0x02,
    /**
     *  链接网络为3G 网络 （WCDMA/HSDPA）1~10Mbps
     */
    RYReachabilityStatus_WWAN_3G = 0x03,
    /**
     *  当前网络为4G 网络 （HRPD/LTE） 100Mbps
     */
    
    RYReachabilityStatus_WWAN_4G = 0x04,
    /**
     *  预留空间，apple API 还未更新 检测5G （蜂窝网络）
     */
    RYReachabilityStatus_WWAN_5G = 0x05,
    
};
#if  !__has_feature(objc_arc)
#error "please use arc "
#endif
@class RYNetStatusManager;
typedef void (^connectReachable)(RYNetStatusManager * reachable);
typedef void (^notConnectReachable)(RYNetStatusManager * reachable);
@interface RYNetStatusManager : NSObject
/**
 *  网路连接类型
 */
@property (nonatomic, assign, readonly) SCNetworkConnectionFlags flags;
@property (nonatomic, assign, readonly) RYReachabilityStatus     status NS_AVAILABLE_IOS(7_0);
@property (nonatomic, assign, readonly, getter=isReachable) BOOL reachable;
/**
 *  运营商类型
 */
@property (nonatomic, strong) NSString     * carrierTypeName;
@property (nonatomic, copy) connectReachable  reachableBlock;
@property (nonatomic, copy) notConnectReachable notReachableBlock;
/**
 *  是否支持从蜂窝网络接入网络
 */
@property (nonatomic, assign) BOOL reachableOnWWAN;

/**
 *  是否可以链接WiFi
 *
 *  @return <#return value description#>
 */
- (BOOL)isReachableViaWiFi;

- (BOOL)isReachableViaWWAN;
/**
 *  开始谅连接
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachability;
/**
 *  从本地WiFi链接
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachabilityForLocalWifi;
/**
 * 主机地址 hostName  e.g "https://www.apple.com"
 *
 *  @param hostname host domain
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostname;
/**
 *  接受一个结构体的ip 地址  e.g 192.168.0.0
 *
 *  @param hostAddress ip 地址
 *
 *  @return <#return value description#>
 */
+ (instancetype)reachabilityWithIPAddress:(const struct sockaddr_in *)hostAddress;
/**
 *  用一个SCNetworkConnectionRef  对象初始化该类
 *
 *  @param ref <#ref description#>
 *
 *  @return <#return value description#>
 */
- (RYNetStatusManager *)initWithReachabilityCNNetRef:(SCNetworkReachabilityRef)ref;

@end
