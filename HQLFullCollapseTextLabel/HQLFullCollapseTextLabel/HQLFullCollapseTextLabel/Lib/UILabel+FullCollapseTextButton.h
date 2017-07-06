//
//  UILabel+FullCollapseTextButton.h
//  HQLFullCollapseTextLabel
//
//  Created by weplus on 2017/7/6.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HQLFullCollapseTextButtonLabelStatusFull , // 正在显示全文
    HQLFullCollapseTextButtonLabelStatusCollapse , // 只显示一段文字
    HQLFullCollapseTextButtonLabelStatusUnknow, // 没有启用
} HQLFullCollapseTextButtonLabelStatus;

/*
 重写 setText / sizeToFit 两个方法 --- 只要启用了这个方法，label的高度是不能控制的
 */
@interface UILabel (FullCollapseTextButton)

@property (assign, nonatomic) NSUInteger numberOfCollapseLines; // 收起的情况下 显示的行数 --- 0 表示不启用

//@property (strong, nonatomic, readonly) UIButton *fullCollapseTextButton;

/* 只有在 setText 方法调用之后 这些属性才会起作用 */
@property (copy, nonatomic) NSString *collapseStatusString; // 收起状态下button的string default: 全文 --- 不会为空
@property (copy, nonatomic) NSString *fullStatusString; // 全文状态下button的string default: 收起 --- 不会为空
@property (strong, nonatomic) UIColor *fullCollapseTextButtonNormalTextColor; // default blue
@property (strong, nonatomic) UIColor *fullCollapseTextButtonSelectedTextColor; // default blue

@property (assign, nonatomic, readonly) HQLFullCollapseTextButtonLabelStatus fullCollapseTextButtonLabelStatus;

@property (copy, nonatomic) void(^fullCollapseTextButtonDidClickBlock)(UIButton *button, HQLFullCollapseTextButtonLabelStatus status);
@property (copy, nonatomic) void(^labelFrameDidChangeBlock)(CGRect labelFrame);

@end
