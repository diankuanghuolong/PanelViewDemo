//
//  SelectCtrl.m
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "SelectCtrl.h"

@implementation SelectCtrl

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = @"默认字符串";
        _isSelect = NO;
        _font = [UIFont systemFontOfSize:17];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    [self setNeedsDisplay];
}

- (void)setIsSelect:(BOOL)isSelect{
    
    _isSelect = isSelect;
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    
    _font = font;
    [self setNeedsDisplay];
}

//绘制内容
- (void)drawRect:(CGRect)rect {
    
    //绘制文字
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dic = @{
                          NSFontAttributeName: _font,
                          NSParagraphStyleAttributeName:style
                          };
    
    //修改绘制文字的位置
    rect.origin.y += 10;
    [_title drawInRect:rect withAttributes:dic];
    
    //绘制红色线条
    if (_isSelect) {
        CGRect frame = CGRectMake(0, CGRectGetHeight(rect)-2, CGRectGetWidth(rect), 2);
        //设置颜色
        [[UIColor redColor]set];
        UIRectFill(frame);
    }
    
}

@end
