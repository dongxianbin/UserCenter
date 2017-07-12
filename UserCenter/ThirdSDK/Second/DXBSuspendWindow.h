//
//  DXBSuspendWindow.h
//  UserCenter
//
//  Created by 董现彬 on 17/7/12.
//  Copyright © 2017年 董现彬. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MYBUNDLE_NAME @"Center.bundle"

#define MYBUNDLE_PATH  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]

#define MYBUNDLE [NSBundle bundleWithPath:MYBUNDLE_PATH]

#define Resouse(fileName) (NSString *)[MYBUNDLE_PATH stringByAppendingPathComponent: fileName]


@interface DXBSuspendWindow : UIView

@property (nonatomic,copy) void(^clickBolcks)(NSInteger i);

//重要：所有图片都要是圆形的，程序里并没有自动处理成圆形

//  warning: frame的长宽必须相等
- (instancetype)initWithFrame:(CGRect)frame mainImageName:(NSString *)mainImageName imagesAndTitle:(NSDictionary*)imagesAndTitle bgcolor:(UIColor *)bgcolor;

// 长按雷达辐射效果
- (instancetype)initWithFrame:(CGRect)frame mainImageName:(NSString *)mainImageName imagesAndTitle:(NSDictionary*)imagesAndTitle bgcolor:(UIColor *)bgcolor animationColor:animationColor;

// 显示（默认）
- (void)showWindow;

// 隐藏
- (void)dissmissWindow;

@end
