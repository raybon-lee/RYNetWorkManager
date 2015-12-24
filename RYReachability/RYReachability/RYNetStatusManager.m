//
//  RYNetStatusManager.m
//  RYReachability
//
//  Created by Dinotech on 15/12/23.
//  Copyright © 2015年 Dinotech. All rights reserved.
//

#import "RYNetStatusManager.h"
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


static CTTelephonyNetworkInfo * RYTelphoyNet(){
    static CTTelephonyNetworkInfo * cttel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        cttel = [CTTelephonyNetworkInfo new];
    });
    return cttel;
}
static  RYReachabilityStatus  RYReachabilityStatusFlags(SCNetworkConnectionFlags flags, BOOL alloWWAN){
    
    if ((flags & kSCNetworkReachabilityFlagsReachable)==0x00) {
        return RYReachabilityStatus_None;
    }
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) && (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return RYReachabilityStatus_None;
    }
    if ((flags & kSCNetworkReachabilityFlagsIsLocalAddress)) {
        return RYReachabilityStatus_None;
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && alloWWAN) {
        
        
        if (!RYTelphoyNet().currentRadioAccessTechnology) {
            return RYReachabilityStatus_WWAN_None;
        }
        NSString * status = RYTelphoyNet().currentRadioAccessTechnology;
        if (!status) {
            return RYReachabilityStatus_WWAN_None;
        }
        static NSDictionary * dic;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dic = @{CTRadioAccessTechnologyGPRS:@(RYReachabilityStatus_WWAN_2G), // 2.5G 171Kbps
                    CTRadioAccessTechnologyEdge:
                        @(RYReachabilityStatus_WWAN_2G),//2.75G 384Kbps
                    CTRadioAccessTechnologyWCDMA:
                        @(RYReachabilityStatus_WWAN_3G),//3G 3.6Mbps/384Kbps
                    CTRadioAccessTechnologyHSDPA:
                        @(RYReachabilityStatus_WWAN_3G),//3.5G 14.4Mbps/384Kbps
                    CTRadioAccessTechnologyHSUPA:
                        @(RYReachabilityStatus_WWAN_3G),
                    // 3.75G 14.4Mbps/ 5.76Mbps
                    CTRadioAccessTechnologyCDMA1x:
                        @(RYReachabilityStatus_WWAN_3G),// 2.5G
                    CTRadioAccessTechnologyCDMAEVDORev0:
                        @(RYReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyCDMAEVDORevA:
                        @(RYReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyCDMAEVDORevB:
                        @(RYReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyeHRPD:
                        @(RYReachabilityStatus_WWAN_3G),
                    CTRadioAccessTechnologyLTE:
                        @(RYReachabilityStatus_WWAN_4G),//LTE :3.9G 150M/75M LTE-advanced:4G 300M/150M
                    
                    };
        });
        NSNumber * number = dic[status];
        if (number) {
            return number.unsignedIntegerValue;
            
        }else{
            return RYReachabilityStatus_WWAN_None;
        }
        return RYReachabilityStatus_WWAN;
    }
    
    
    return RYReachabilityStatus_WiFi;
}
static void RYReachablityCallback(SCNetworkReachabilityRef target,SCNetworkReachabilityFlags flags, void * info){
    RYNetStatusManager * self = ((__bridge RYNetStatusManager *)info);
    if (self.reachableBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reachableBlock(self);
        });
    }else{
        if (self.notReachableBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.notReachableBlock(self);
            });
        }
    }
    
    
    
}
@interface RYNetStatusManager ()
{
    NSRecursiveLock  * _netLock;
    NSLock * _lock;
    
}
@property (nonatomic, assign) SCNetworkReachabilityRef ref;

@property (nonatomic, assign) BOOL schedule;

@property (nonatomic, strong) CTTelephonyNetworkInfo * netWorkInfo;

@property (nonatomic, strong) NSRecursiveLock   * netLock;



@end


@implementation RYNetStatusManager

+ (dispatch_queue_t)shareSerialQueue{
    static dispatch_queue_t serialQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue  = dispatch_queue_create("www.xinling.com.RYReachability", DISPATCH_QUEUE_SERIAL);
       
    });
    return serialQueue;
}
- (NSString *)getCurrentCarrier{
    
    return RYTelphoyNet().subscriberCellularProvider.carrierName;
    
}
- (NSString *)carrierTypeName{
    return [self getCurrentCarrier];
    
}
- (NSRecursiveLock *)netLock{
    if (_netLock==nil) {
        _netLock = [[NSRecursiveLock alloc]init];
        
    }
    return _netLock;
}
- (instancetype)init{
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr));
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family =AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    return [self initWithReachabilityCNNetRef:ref];
    
}
- (RYNetStatusManager *)initWithReachabilityCNNetRef:(SCNetworkReachabilityRef)ref{
    if (!ref) {
        return nil;
    }
    self = super.init;
    if (!self) {
        return nil;
    }
    _ref = ref;
    _reachableOnWWAN=YES;
   
//    self.schedule = YES;
    if (NSFoundationVersionNumber >=NSFoundationVersionNumber_iOS_7_0) {
        _netWorkInfo = RYTelphoyNet();
      
        
    }
    return self;
    
}
- (void)setSchedule:(BOOL)schedule{
    if (_schedule==schedule) {
        return;
    }
    _schedule = schedule;
   
    if (schedule) {
        SCNetworkReachabilityContext context = {0,(__bridge void *)self,NULL,NULL,NULL};
        SCNetworkReachabilitySetCallback(self.ref, RYReachablityCallback, &context);
        SCNetworkReachabilitySetDispatchQueue(self.ref, [self.class shareSerialQueue]);
        
    }else{
        SCNetworkReachabilitySetDispatchQueue(self.ref, NULL);
    }
}
- (BOOL)isReachableViaWiFi{
    SCNetworkConnectionFlags flags;
    if (SCNetworkReachabilityGetFlags(self.ref, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable)) {
            
#if TARGET_OS_IPHONE
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return NO;
            }
#endif
            return YES;
        }
    }
    return NO;
}
- (BOOL)isReachableViaWWAN{
#if TARGET_OS_IPHONE
    SCNetworkReachabilityFlags flags =0;
    if (SCNetworkReachabilityGetFlags(self.ref, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable)) {
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
                return YES;
            }
        }
    }
#endif
    return NO;
}
- (SCNetworkConnectionFlags)flags{
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(self.ref, &flags);
    return flags;
}
- (RYReachabilityStatus)status{
    
RYReachabilityStatus status =RYReachabilityStatusFlags(self.flags, self.reachableOnWWAN);
    
    
    return status;
}
- (BOOL)isReachable{
    return self.status !=RYReachabilityStatus_None;
}
+ (instancetype)reachability{
    return self.new;
    
}
+ (instancetype)reachabilityWithHostName:(NSString *)hostname{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    return [[self alloc] initWithReachabilityCNNetRef:ref];
}
+ (instancetype)reachabilityForLocalWifi{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    RYNetStatusManager *net = [self reachabilityWithIPAddress:&localWifiAddress];
    net.reachableOnWWAN = NO;
    return net;
}
+ (instancetype)reachabilityWithIPAddress:(const struct sockaddr_in *)hostAddress{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    return [[self alloc] initWithReachabilityCNNetRef:ref];
}
- (void)setReachableBlock:(connectReachable)reachableBlock{
    _reachableBlock = [reachableBlock copy];
    self.schedule = (self.reachableBlock!=nil);
}
- (void)setNotReachableBlock:(notConnectReachable)notReachableBlock{
    _notReachableBlock = [notReachableBlock copy];
    self.schedule = (self.notReachableBlock!=nil);
    
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [super allocWithZone:zone];
}
- (void)dealloc{
    
    CFRelease(self.ref);
    self.reachableBlock = nil;
    self.notReachableBlock = nil;
    self.schedule = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
