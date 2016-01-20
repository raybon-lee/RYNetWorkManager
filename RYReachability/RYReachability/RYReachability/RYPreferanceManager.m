//
//  RYPreferanceManager.m
//  NewXinLing
//
//  Created by Dinotech on 15/12/24.
//  Copyright © 2015年 why. All rights reserved.
//

#import "RYPreferanceManager.h"

@implementation RYPreferanceManager

- (BOOL)canReachableViaWiFi{
    
    if ([self.netstatusManager isReachableViaWiFi]) {
        return YES;
    }
    return NO;
}
- (BOOL)canReachableViaWWAN{
    if ([self.netstatusManager isReachableViaWWAN]) {
        return YES;
    }
    return NO;
}

//- (RYNetStatusManager *)netstatusManager{
//    if (!_netstatusManager) {
//        _netstatusManager  = [RYNetStatusManager reachabilityWithHostName:@"http://www.baidu.com"];
//       
//
//    }
//    return _netstatusManager;
//}
- (NetWorkSatusType )getReachablitySttatus{
    RYReachabilityStatus  status = self.currentNumberType.unsignedIntegerValue;
    if ([self canReachableViaWiFi] || [self canReachableViaWWAN]) {
        status = self.netstatusManager.status;
        
    }
    switch (status) {
        case RYReachabilityStatus_None:
            return NetWorkSatusType_None;
            
        case RYReachabilityStatus_WiFi:
            return NetWorkSatusType_WiFi;
            
        case RYReachabilityStatus_WWAN:
            return NetWorkSatusType_WiFi;
            
        case RYReachabilityStatus_WWAN_2G:
            return NetWorkSatusType_2G;
            
        case RYReachabilityStatus_WWAN_3G:
            return NetWorkSatusType_3G;
            
        case RYReachabilityStatus_WWAN_4G:
            return NetWorkSatusType_4G;
            
        case RYReachabilityStatus_WWAN_5G:
            return NetWorkSatusType_5G;
            
        default:
            return NetWorkSatusType_None;
    }

    
}

- (void)getReachablityStatusWithChangeBlock:(void (^)(NetWorkSatusType))complete{
    self.netchangeNotifationBlock = nil;
    self.netchangeNotifationBlock =[complete copy];
    
}
- (void)listenLocalWifiBlock:(CallBackBlock)block{
    self.block = nil;
    self.block = [block copy];
    
}
- (NetWorkSatusType)currentNetStatusType{
    
    RYReachabilityStatus  status = self.currentNumberType.unsignedIntegerValue;
    if ([self canReachableViaWiFi] || [self canReachableViaWWAN]) {
        status = self.netstatusManager.status;
        
    }
    switch (status) {
        case RYReachabilityStatus_None:
            return NetWorkSatusType_None;
            
        case RYReachabilityStatus_WiFi:
            return NetWorkSatusType_WiFi;
            
        case RYReachabilityStatus_WWAN:
            return NetWorkSatusType_WiFi;
            
        case RYReachabilityStatus_WWAN_2G:
            return NetWorkSatusType_2G;
            
        case RYReachabilityStatus_WWAN_3G:
            return NetWorkSatusType_3G;
            
        case RYReachabilityStatus_WWAN_4G:
            return NetWorkSatusType_4G;
            
        case RYReachabilityStatus_WWAN_5G:
            return NetWorkSatusType_5G;
            
        default:
            return NetWorkSatusType_None;
    }
}

+ (instancetype)sharePreferanceManager{
    static RYPreferanceManager * __preferance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __preferance = [[self.class alloc]init];
    });
    return __preferance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [super allocWithZone:zone];
}
- (instancetype)init
{
    self = [super init];
    if (self) {

        __weak typeof(self) weakSelf = self;
       
        self.netManager = [RYNetStatusManager reachabilityForLocalWifi];
        self.netManager.reachableBlock= ^(RYNetStatusManager * man){
            NSLog(@"======dfdfdfd");
            weakSelf.currentNumberType = [NSNumber numberWithInteger:man.status];
            NetWorkSatusType stat =   [weakSelf getReachablitySttatus];
            weakSelf.block(stat,@"ddd");
        };
         self.netstatusManager  = [RYNetStatusManager reachabilityWithHostName:@"http://www.baidu.com"];
        self.netstatusManager.reachableBlock = ^(RYNetStatusManager * manager){
            if (manager.status==RYReachabilityStatus_WiFi) {
                RYLog(@"current sttus is wifi");
            }else{
                RYLog(@"无网络");
                
            }
            
            weakSelf.currentNumberType = [NSNumber numberWithInteger:manager.status];
            NetWorkSatusType stat =   [weakSelf getReachablitySttatus];
            
            weakSelf.netchangeNotifationBlock(stat);
            
            
            
        };
        
        
    }
    return self;
}

@end
