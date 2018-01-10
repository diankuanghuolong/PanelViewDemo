//
//  PanelView.m
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "PanelView.h"
#import "PathModel.h"
@implementation PanelView
{
    CGMutablePathRef _drawPath;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //设置默认值
        _color = [UIColor grayColor];
        _width = 1.0;
        
        _logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 10, 60, 60)];
        _logoIV.layer.cornerRadius = 6;
        _logoIV.layer.masksToBounds = YES;
        _logoIV.alpha = 0.6;
        [self addSubview:_logoIV];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    //绘制数组中的路径
    if (_pathArray != nil)
    {
        
        for (int i = 0; i<_pathArray.count; i++)
        {
            //取得model
            PathModel *model = _pathArray[i];
            
            //取得路径
            CGMutablePathRef path = model.path;
            UIColor *color = model.color;
            CGFloat width = model.width;
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextAddPath(context, path);
            
            //设置绘制的属性
            [color set];
            CGContextSetLineWidth(context, width);
            CGContextDrawPath(context, kCGPathStroke);
            /*
             kCGPathFill,
             kCGPathEOFill,
             kCGPathStroke,
             kCGPathFillStroke,
             kCGPathEOFillStroke
             */
        }
    }
    
    if (_drawPath != nil) {
        
        //获取上下文
        CGContextRef contest = UIGraphicsGetCurrentContext();
        
        //颜色
        [_color set];
        
        //线宽
        CGContextSetLineWidth(contest, _width);
        
        //将路径添加到上下文
        CGContextAddPath(contest, _drawPath);
        
        //绘制
        CGContextDrawPath(contest, kCGPathStroke);
        
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //取得手指的坐标
    CGPoint p = [[touches anyObject] locationInView:self];
    
    //创建路径
    _drawPath = CGPathCreateMutable();
    
    //设置路径的起始点
    CGPathMoveToPoint(_drawPath, NULL, p.x, p.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //取得手指的坐标
    CGPoint p = [[touches anyObject] locationInView:self];
    
    //把手指坐标添加到路径上
    CGPathAddLineToPoint(_drawPath, NULL, p.x, p.y);
    
    //重新绘制
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_pathArray == nil) {
        
        _pathArray = [[NSMutableArray alloc] init];
    }
    
    //创建model
    PathModel *model = [[PathModel alloc] init];
    
    model.path = _drawPath;
    model.color = _color;
    model.width = _width;
    
    [_pathArray addObject:model];
    
    
    //释放路径
    CGPathRelease(_drawPath);
    _drawPath = nil;
}

- (void)undo{
    
    if (_pathArray.count > 0) {
        
        [_pathArray removeLastObject];
        
        [self setNeedsDisplay];
    }
}

- (void)clear{
    
    if (_pathArray.count > 0) {
        [_pathArray removeAllObjects];
        [self setNeedsDisplay];
    }
}
@end
