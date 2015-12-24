//
//  ViewController.m
//  RYReachability
//
//  Created by Dinotech on 15/12/23.
//  Copyright © 2015年 Dinotech. All rights reserved.
//

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
