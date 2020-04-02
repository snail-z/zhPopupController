//
//  UILabel+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/30.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UILabel+PKExtend.h"
#import <objc/runtime.h>

@implementation UILabel (PKExtend)

+ (void)load {
    SEL selectors[] = {
        @selector(textRectForBounds:limitedToNumberOfLines:),
        @selector(drawTextInRect:),
    };
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"_pk_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (CGRect)_pk_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.pk_textEdgeInsets)) {
        return [self _pk_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    CGRect rect = [self _pk_textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.pk_textEdgeInsets) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.pk_textEdgeInsets.left;
    rect.origin.y -= self.pk_textEdgeInsets.top;
    rect.size.width += self.pk_textEdgeInsets.left + self.pk_textEdgeInsets.right;
    rect.size.height += self.pk_textEdgeInsets.top + self.pk_textEdgeInsets.bottom;
    return rect;
}

- (void)_pk_drawTextInRect:(CGRect)rect {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.pk_textEdgeInsets)) {
        return [self _pk_drawTextInRect:rect];
    }
    return [self _pk_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.pk_textEdgeInsets)];
}

- (UIEdgeInsets)pk_textEdgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setPk_textEdgeInsets:(UIEdgeInsets)pk_textEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, pk_textEdgeInsets)) return;
    NSValue *value = [NSValue valueWithUIEdgeInsets:pk_textEdgeInsets];
    objc_setAssociatedObject(self, @selector(pk_textEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
