# RYNetWorkManager
参考reachability 增加一些检测蜂窝网络的类型，同时调用更加方便，支持通知，和block 监听网络状态改变
通过单例类进行设置

##  使用方法

`#import "RYPreferanceManager.h"`

e.g 

=========

```
#import "ViewController.h"
#import "RYPreferanceManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
[super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.

NetWorkSatusType type =  [[RYPreferanceManager sharePreferanceManager]currentNetStatusType];
switch (type) {
case NetWorkSatusType_None:
{
NSLog(@"没有网络");
}
break;
case NetWorkSatusType_WiFi:{
NSLog(@" current net is wifi");
}
break;
case NetWorkSatusType_2G:{
NSLog(@" current net is 2g");

}
break;
case NetWorkSatusType_3G:{
NSLog(@" current net is 3g");

}
break;
case NetWorkSatusType_4G:{
NSLog(@" current net is 4g");

}
break;
case NetWorkSatusType_5G:{
NSLog(@" current net is 5g  暂时还未找到支持5G的API");

}
break;


default:
break;
}
[[RYPreferanceManager sharePreferanceManager]getReachablityStatusWithChangeBlock:^(NetWorkSatusType status) {
NSLog(@"current net status = %@",@(status));
}];


}

- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}

@end

```