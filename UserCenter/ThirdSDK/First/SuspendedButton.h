///Users/yinhu/Desktop/UserCenter/UserCenter
//  SuspendedButton.h
//  UserCenter
//
//  Created by 董现彬 on 17/7/12.
//  Copyright (c) 2017年 董现彬. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MYBUNDLE_NAME @"Center.bundle"

#define MYBUNDLE_PATH  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]

#define MYBUNDLE [NSBundle bundleWithPath:MYBUNDLE_PATH]

#define Resouse(fileName) (NSString *)[MYBUNDLE_PATH stringByAppendingPathComponent: fileName]


typedef enum  _NdToolBarPlace
{
    NdToolBarAtTopLeft = 1,			  /**< 左上 */
    NdToolBarAtTopRight,              /**< 右上 */
    NdToolBarAtMiddleLeft,            /**< 左中 */
    NdToolBarAtMiddleRight,           /**< 右中 */
    NdToolBarAtBottomLeft,            /**< 左下 */
    NdToolBarAtBottomRight,           /**< 右下 */
}	NdToolBarPlace;

@interface SuspendedButton : UIView

@property (nonatomic,copy) void(^clickBolcks)(NSInteger i);
//显示悬浮标
- (instancetype)initWithWithCGPoint:(NdToolBarPlace)place inView:(UIView *)baseview;
//关闭悬浮标
-(void)deleteSuspendedButton;
-(void)close;
@end
