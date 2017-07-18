//
//  ViewController.m
//  UserCenter
//
//  Created by yinhu on 2017/7/11.
//  Copyright © 2017年 yinhu. All rights reserved.
//

#import "ViewController.h"
#import "SuspendedButton.h"
#import "DXBSuspendWindow.h"


@interface ViewController ()
{
    DXBSuspendWindow *DXBsuspendWindow;
    SuspendedButton *sususpendWindow;
}
@end

@implementation ViewController
-(void)viewDidAppear:(BOOL)animated{
    //显示悬浮图标
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat floatWidowHeight = 50, floatWindowWidth = 50;
//    DXBsuspendWindow = [[DXBSuspendWindow alloc]initWithFrame:CGRectMake(0, (screenHeight - floatWidowHeight)/2, floatWindowWidth, floatWidowHeight) mainImageName:Resouse(@"YH_center_logo@2x.png") imagesAndTitle:@{Resouse(@"YH_center_user@2x.png"):@"用户中心"} bgcolor:[UIColor lightGrayColor] animationColor:[UIColor purpleColor]];
//
//
//    DXBsuspendWindow.clickBolcks = ^(NSInteger i){
//        NSLog(@"-------点击了%ld--------",(long)i);
//    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view, typically from a nib.
//    //显示悬浮图标
   
    sususpendWindow = [[SuspendedButton alloc]initWithWithCGPoint:NdToolBarAtMiddleLeft inView:self.view];
    
    sususpendWindow.clickBolcks = ^(NSInteger i){
        NSLog(@"-------点击了%ld--------",(long)i);
        switch (i) {
            case 0:
            {
                
            }
                break;
                
            default:
                break;
        }
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
