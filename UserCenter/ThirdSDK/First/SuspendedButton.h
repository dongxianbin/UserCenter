//
//  SuspendedButton.h
//  UserCenter
//
//  Created by 董现彬 on 17/7/12.
//  Copyright (c) 2017年 董现彬. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击第一个button
#define TOUCH_BUTTON_ZERO @"TOUCHBUTTONZERO"
//点击第二个button
#define TOUCH_BUTTON_ONE @"TOUCHBUTTONONE"
//点击第三个button
#define TOUCH_BUTTON_TWO @"TOUCHBUTTONTWO"
//点击第四个button
#define TOUCH_BUTTON_THREE @"TOUCHBUTTONTHREE"

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


//显示悬浮标
+ (SuspendedButton *)suspendedButtonWithCGPoint:(NdToolBarPlace)place inView:(UIView *)baseview;
//关闭悬浮标
+(void)deleteSuspendedButton;
-(void)close;
@end
