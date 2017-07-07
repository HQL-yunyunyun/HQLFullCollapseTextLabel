//
//  UILabel+FullCollapseTextButton.m
//  HQLFullCollapseTextLabel
//
//  Created by weplus on 2017/7/6.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "UILabel+FullCollapseTextButton.h"
#import <objc/objc-runtime.h>

NSString const * HQLNumberOfCollapseLinesKey;
NSString const * HQLFullCollapseTextButtonKey;
NSString const * HQLCollapseStatusStringKey;
NSString const * HQLFullStatusStringKey;
NSString const * HQLFullCollapseTextButtonDidClickBlockKey;
NSString const * HQLLabelFrameDidChangeBlockKey;
NSString const * HQLFullCollapseTextButtonNormalTextColorKey;
NSString const * HQLFullCollapseTextButtonSelectedTextColorKey;
NSString const * HQLOriginStringKey;
NSString const * HQLCutStringKey;
NSString const * HQLUseButtonKey;
NSString const * HQLOriginNumberOfLinesKey;
NSString const * HQLOriginUserInteractionEnabledKey;

#define kFullCollapseTextButtonTag 2304

#define kPointString @"..."
#define kMargin 5

@interface UILabel ()

@property (strong, nonatomic) UIButton *fullCollapseTextButton;
@property (copy, nonatomic) NSString *originString;
@property (copy, nonatomic) NSString *cutString;

@property (assign, nonatomic) NSInteger originNumberOfLines;
@property (assign, nonatomic) BOOL originUserInteractionEnabled;

@property (assign, nonatomic, getter=isUseButton) BOOL useButton;

@end

@implementation UILabel (FullCollapseTextButton)

#pragma mark - life cycle

+ (void)load {
    [super load];
    
    Method setTextFromMethod = class_getInstanceMethod([self class], @selector(setText:));
    Method setTextToMethod = class_getInstanceMethod([self class], @selector(hql_setText:));
    method_exchangeImplementations(setTextFromMethod, setTextToMethod);
    
    Method sizeToFitFromMethod = class_getInstanceMethod([self class], @selector(sizeToFit));
    Method sizeToFitToMethod = class_getInstanceMethod([self class], @selector(hql_sizeToFit));
    method_exchangeImplementations(sizeToFitFromMethod, sizeToFitToMethod);
}

#pragma mark - event

- (void)hql_setText:(NSString *)text {
    if (self.numberOfCollapseLines > 0) {
        
        // 判断text是否能一行显示
        NSUInteger textLine = [self getStringLineWithString:text width:self.frame.size.width];
        if (textLine < self.numberOfCollapseLines) {
            [self hql_setText:text];
            self.useButton = NO;
            return;
        }
        self.useButton = YES;
        
        // 保存text
        if (![text isEqualToString:self.cutString]) {
            self.originString = text;
        }
        
        // 设置button
        [self.fullCollapseTextButton setTitle:self.collapseStatusString forState:UIControlStateNormal];
        [self.fullCollapseTextButton setTitle:self.fullStatusString forState:UIControlStateSelected];
        [self.fullCollapseTextButton setTitleColor:self.fullCollapseTextButtonNormalTextColor forState:UIControlStateNormal];
        [self.fullCollapseTextButton setTitleColor:self.fullCollapseTextButtonSelectedTextColor forState:UIControlStateSelected];
        self.fullCollapseTextButton.titleLabel.font = self.font;
        
        CGFloat buttonHeight = self.font.lineHeight;
        CGFloat buttonWidth = [self.fullStatusString sizeWithAttributes:[self labelFontAttribute]].width;
        if (buttonWidth < [self.collapseStatusString sizeWithAttributes:[self labelFontAttribute]].width) {
            buttonWidth = [self.collapseStatusString sizeWithAttributes:[self labelFontAttribute]].width;
        }
        self.fullCollapseTextButton.frame = CGRectMake(self.fullCollapseTextButton.frame.origin.x, self.fullCollapseTextButton.frame.origin.y, buttonWidth, buttonHeight);
        
        // 判断当前状态
        switch (self.fullCollapseTextButtonLabelStatus) {
            case HQLFullCollapseTextButtonLabelStatusFull: { // 需要显示全文
                [self hql_setText:self.originString];
                break;
            }
            case HQLFullCollapseTextButtonLabelStatusCollapse: { // 需要显示一部分
                // 截取string
                CGFloat pointStringWidth = [kPointString sizeWithAttributes:[self labelFontAttribute]].width;
                CGFloat cutStringWidth = self.frame.size.width * self.numberOfCollapseLines - 3 * kMargin - buttonWidth - pointStringWidth;
                NSString *cutString = [self getRangeStringWithString:self.originString width:cutStringWidth];
                cutString = [cutString stringByAppendingString:kPointString];
                self.cutString = cutString;
                [self hql_setText:cutString];
                break;
            }
            case HQLFullCollapseTextButtonLabelStatusUnknow: { break; } // 不会到这个状态
        }
        
//        NSLog(@"cutstring : %@, originstring : %@", self.cutString, self.originString);
        
        // 会调用 hql_sizeToFit
        [self sizeToFit];
        if (self.labelFrameDidChangeBlock) {
            self.labelFrameDidChangeBlock(self.frame);
        }
    } else {
        self.useButton = YES;
        [self hql_setText:text];
    }
}

- (void)hql_sizeToFit {
    if (self.numberOfCollapseLines > 0 && self.isUseButton) { // 自行计算高度
        
        CGFloat width = self.frame.size.width;
        NSUInteger textLine = self.numberOfCollapseLines;
        CGFloat buttonX = width - kMargin - self.fullCollapseTextButton.frame.size.width;
        
        switch (self.fullCollapseTextButtonLabelStatus) {
            case HQLFullCollapseTextButtonLabelStatusCollapse: { // 显示一部分
                textLine = self.numberOfCollapseLines;
                break;
            }
            case HQLFullCollapseTextButtonLabelStatusFull: { // 显示全文
                // 判断能否在全文后面添加button
                CGFloat fullTextWidth = [self.originString sizeWithAttributes:[self labelFontAttribute]].width;
                textLine = [self getStringLineWithString:self.originString width:width];
                if (fullTextWidth + self.fullCollapseTextButton.frame.size.width + 2 * kMargin > self.font.lineHeight * textLine) {
                    textLine++;
                    buttonX = kMargin;
                }
                break;
            }
            case HQLFullCollapseTextButtonLabelStatusUnknow: { break; }
        }
        CGFloat height = self.font.lineHeight * textLine;
        CGFloat buttonY = height - self.font.lineHeight;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
        self.fullCollapseTextButton.frame = CGRectMake(buttonX, buttonY, self.fullCollapseTextButton.frame.size.width, self.fullCollapseTextButton.frame.size.height);
    } else {
        [self hql_sizeToFit];
    }
}

- (void)fullCollapseTextButtonDidClick:(UIButton *)button {
    button.selected = !button.isSelected;
    switch (self.fullCollapseTextButtonLabelStatus) {
        case HQLFullCollapseTextButtonLabelStatusFull: {
            [self setText:self.originString];
            break;
        }
        case HQLFullCollapseTextButtonLabelStatusCollapse: {
            [self setText:self.cutString];
            break;
        }
        case HQLFullCollapseTextButtonLabelStatusUnknow: { break; }
    }
    
    if (self.fullCollapseTextButtonDidClickBlock) {
        self.fullCollapseTextButtonDidClickBlock(self.fullCollapseTextButton, self.fullCollapseTextButtonLabelStatus);
    }
}

- (NSDictionary *)labelFontAttribute {
    return @{NSFontAttributeName : self.font};
}

#pragma mark - tool method

- (NSUInteger)getStringLineWithString:(NSString *)string width:(CGFloat)width {
    CGFloat sringWidth = [string sizeWithAttributes:[self labelFontAttribute]].width;
    CGFloat line = sringWidth / width;
    NSUInteger intLine = line;
    NSUInteger sign = (line - intLine) > 0 ? 1 : 0;
    return (intLine + sign);
}

- (NSString *)getRangeStringWithString:(NSString *)string width:(CGFloat)width {
    NSString *targetString = @"";
    NSRange range;
    CGFloat targetWidth = 0;
    for(int i=0; i<string.length; i+=range.length){
        range = [string rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [string substringWithRange:range];
        CGFloat sWidth = [s sizeWithAttributes:[self labelFontAttribute]].width;
        if (sWidth + targetWidth > width) {
            break;
        } else {
            targetWidth += sWidth;
            targetString = [targetString stringByAppendingString:s];
        }
    }
    return targetString;
}

#pragma mark - setter

// 设置lines
- (void)setNumberOfCollapseLines:(NSUInteger)numberOfCollapseLines {
    // 设置了这个属性 numberOfLines 默认为0
    if (numberOfCollapseLines == 0) {
        self.numberOfLines = self.originNumberOfLines;
        self.userInteractionEnabled = self.originUserInteractionEnabled;
        [self.fullCollapseTextButton removeFromSuperview];
        self.fullCollapseTextButton = nil;
    } else {
        self.originUserInteractionEnabled = self.userInteractionEnabled;
        self.originNumberOfLines = self.numberOfLines;
        
        self.numberOfLines = 0;
        self.userInteractionEnabled = YES;
    }
    objc_setAssociatedObject(self, &HQLNumberOfCollapseLinesKey, [NSNumber numberWithUnsignedInteger:numberOfCollapseLines], OBJC_ASSOCIATION_ASSIGN);
}

// 设置button文字
- (void)setCollapseStatusString:(NSString *)collapseStatusString {
    if (!collapseStatusString || [collapseStatusString isEqualToString:@""]) {
        collapseStatusString = @"全文";
    }
    objc_setAssociatedObject(self, &HQLCollapseStatusStringKey, collapseStatusString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// 设置button文字
- (void)setFullStatusString:(NSString *)fullStatusString {
    if (!fullStatusString || [fullStatusString isEqualToString:@""]) {
        fullStatusString = @"收起";
    }
    objc_setAssociatedObject(self, &HQLFullStatusStringKey, fullStatusString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// text color
- (void)setFullCollapseTextButtonNormalTextColor:(UIColor *)fullCollapseTextButtonNormalTextColor {
    fullCollapseTextButtonNormalTextColor = fullCollapseTextButtonNormalTextColor ? fullCollapseTextButtonNormalTextColor : [UIColor blueColor];
    objc_setAssociatedObject(self, &HQLFullCollapseTextButtonNormalTextColorKey, fullCollapseTextButtonNormalTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// text color
- (void)setFullCollapseTextButtonSelectedTextColor:(UIColor *)fullCollapseTextButtonSelectedTextColor {
    fullCollapseTextButtonSelectedTextColor = fullCollapseTextButtonSelectedTextColor ? fullCollapseTextButtonSelectedTextColor : [UIColor blueColor];
    objc_setAssociatedObject(self, &HQLFullCollapseTextButtonSelectedTextColorKey, fullCollapseTextButtonSelectedTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// block
- (void)setFullCollapseTextButtonDidClickBlock:(void (^)(UIButton *, HQLFullCollapseTextButtonLabelStatus))fullCollapseTextButtonDidClickBlock {
    objc_setAssociatedObject(self, &HQLFullCollapseTextButtonDidClickBlockKey, fullCollapseTextButtonDidClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// frame change block
- (void)setLabelFrameDidChangeBlock:(void (^)(CGRect))labelFrameDidChangeBlock {
    objc_setAssociatedObject(self, &HQLLabelFrameDidChangeBlockKey, labelFrameDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// button
- (void)setFullCollapseTextButton:(UIButton *)fullCollapseTextButton {
    if (fullCollapseTextButton.tag == kFullCollapseTextButtonTag) {
        objc_setAssociatedObject(self, &HQLFullCollapseTextButtonKey, fullCollapseTextButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

// origin string
- (void)setOriginString:(NSString *)originString {
    objc_setAssociatedObject(self, &HQLOriginStringKey, originString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// cut string
- (void)setCutString:(NSString *)cutString {
    objc_setAssociatedObject(self, &HQLCutStringKey, cutString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// is use button
- (void)setUseButton:(BOOL)useButton {
    if (!useButton) {
        [self.fullCollapseTextButton removeFromSuperview];
        self.fullCollapseTextButton = nil;
    }
    objc_setAssociatedObject(self, &HQLUseButtonKey, [NSNumber numberWithBool:useButton], OBJC_ASSOCIATION_ASSIGN);
}

- (void)setOriginNumberOfLines:(NSInteger)originNumberOfLines {
    objc_setAssociatedObject(self, &HQLOriginNumberOfLinesKey, [NSNumber numberWithInteger:originNumberOfLines], OBJC_ASSOCIATION_ASSIGN);
}

- (void)setOriginUserInteractionEnabled:(BOOL)originUserInteractionEnabled {
    objc_setAssociatedObject(self, &HQLOriginUserInteractionEnabledKey, [NSNumber numberWithBool:originUserInteractionEnabled], OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - getter

// button
- (UIButton *)fullCollapseTextButton {
    if (self.numberOfCollapseLines == 0 || !self.isUseButton) {
        return nil;
    }
    
    UIButton *button = objc_getAssociatedObject(self, &HQLFullCollapseTextButtonKey);
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(fullCollapseTextButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kFullCollapseTextButtonTag;
//        [self addSubview:button];
        [self bringSubviewToFront:button];
        [self.layer addSublayer:button.layer];
        [self setFullCollapseTextButton:button];
    }
    return objc_getAssociatedObject(self, &HQLFullCollapseTextButtonKey);
}

// number
- (NSUInteger)numberOfCollapseLines {
    NSNumber *number = objc_getAssociatedObject(self, &HQLNumberOfCollapseLinesKey);
    return [number unsignedIntegerValue];
}

// button string
- (NSString *)collapseStatusString {
    NSString *string = objc_getAssociatedObject(self, &HQLCollapseStatusStringKey);
    if (!string){
        string = @"全文";
        [self setCollapseStatusString:string];
    }
    return objc_getAssociatedObject(self, &HQLCollapseStatusStringKey);
}

// button string
- (NSString *)fullStatusString {
    NSString *string = objc_getAssociatedObject(self, &HQLFullStatusStringKey);
    if (!string) {
        string = @"收起";
        [self setFullStatusString:string];
    }
    return objc_getAssociatedObject(self, &HQLFullStatusStringKey);
}

// text color
- (UIColor *)fullCollapseTextButtonNormalTextColor {
    UIColor *color = objc_getAssociatedObject(self, &HQLFullCollapseTextButtonNormalTextColorKey);
    if (!color) {
        color = [UIColor blueColor];
        [self setFullCollapseTextButtonNormalTextColor:color];
    }
    return objc_getAssociatedObject(self, &HQLFullCollapseTextButtonNormalTextColorKey);
}

// text color
- (UIColor *)fullCollapseTextButtonSelectedTextColor {
    UIColor *color = objc_getAssociatedObject(self, &HQLFullCollapseTextButtonSelectedTextColorKey);
    if (!color) {
        color = [UIColor blueColor];
        [self setFullCollapseTextButtonSelectedTextColor:color];
    }
    return objc_getAssociatedObject(self, &HQLFullCollapseTextButtonSelectedTextColorKey);
}

// status
- (HQLFullCollapseTextButtonLabelStatus)fullCollapseTextButtonLabelStatus {
    if (self.numberOfCollapseLines == 0 || !self.isUseButton) {
        return HQLFullCollapseTextButtonLabelStatusUnknow;
    }
    if ([self fullCollapseTextButton].selected) { // selected 为 yes 表示显示全文
        return HQLFullCollapseTextButtonLabelStatusFull;
    } else {
        return HQLFullCollapseTextButtonLabelStatusCollapse; // 显示一段文字
    }
}

// button click block
- (void (^)(UIButton *, HQLFullCollapseTextButtonLabelStatus))fullCollapseTextButtonDidClickBlock {
    return objc_getAssociatedObject(self, &HQLFullCollapseTextButtonDidClickBlockKey);
}

// frame change block
- (void (^)(CGRect))labelFrameDidChangeBlock {
    return objc_getAssociatedObject(self, &HQLLabelFrameDidChangeBlockKey);
}

// origin string
- (NSString *)originString {
    return objc_getAssociatedObject(self, &HQLOriginStringKey);
}

// cut string
- (NSString *)cutString {
    return objc_getAssociatedObject(self, &HQLCutStringKey);
}

// is use button
- (BOOL)isUseButton {
    return [objc_getAssociatedObject(self, &HQLUseButtonKey) boolValue];
}

- (NSInteger)originNumberOfLines {
    return [objc_getAssociatedObject(self, &HQLOriginNumberOfLinesKey) integerValue];
}

- (BOOL)originUserInteractionEnabled {
    return [objc_getAssociatedObject(self, &HQLOriginUserInteractionEnabledKey) boolValue];
}

@end
