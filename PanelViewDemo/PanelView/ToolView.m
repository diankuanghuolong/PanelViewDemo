//
//  ToolView.m
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "ToolView.h"
#import "SelectCtrl.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ToolView()

@property (nonatomic ,strong)NSMutableArray *lineWidthBtnArr;
@property (nonatomic ,strong)NSMutableArray *selectColorArr;
@end
@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _lineWidthBtnArr = [NSMutableArray new];
        _selectColorArr = [NSMutableArray new];
        
        //创建选择按钮
        [self _initSelectButton];
        
        //创建颜色视图
        [self colorView];
        
        //创建线宽视图
        [self lineView];
    }
    return self;
}

#pragma mark  ===== loadViews  =====
//创建颜色视图
- (void)colorView
{
    
    //创建颜色数组
    _colorArray = @[
                    [UIColor grayColor],
                    [UIColor redColor],
                    [UIColor greenColor],
                    [UIColor blueColor],
                    [UIColor yellowColor],
                    [UIColor orangeColor],
                    [UIColor purpleColor],
                    [UIColor brownColor],
                    [UIColor blackColor]
                    ];
    //创建显示颜色视图的父视图
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 65)];
    _colorView.backgroundColor = [UIColor clearColor];
    
//    _colorView.hidden = YES;
    _colorView.hidden = NO;//默认选中颜色
    [self addSubview:_colorView];
    
    //设置颜色小视图的宽度
    CGFloat width = SCREEN_WIDTH/_colorArray.count,x = 2.5;
    for (int i=0; i<_colorArray.count; i++)
    {
        
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(x, 5, width-5, 65-10)];
        control.backgroundColor = _colorArray[i];
        
        //选择颜色的点击事件
        [control addTarget:self action:@selector(conlorAction:) forControlEvents:UIControlEventTouchUpInside];
        [_colorView addSubview:control];
        
        if (i ==0)
        {
            control.layer.borderWidth = 1;
            control.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        
        [_selectColorArr addObject:control];
        x += width;
    }
    
}

//创建线宽视图
- (void)lineView
{
    //创建线宽数组
    _lineArray = @[@1,@3,@5,@8,@10,@15,@20];
    
    //创建显示线宽视图的父视图
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 65)];
    _lineView.backgroundColor = [UIColor clearColor];
    _lineView.hidden = YES;
    [self addSubview:_lineView];
    
    CGFloat width = SCREEN_WIDTH/_lineArray.count;
    for (int i = 0; i<_lineArray.count; i++)
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *name = [NSString stringWithFormat:@"%@点",_lineArray[i]];
        [button setTitle:name forState:UIControlStateNormal];
        button.frame = CGRectMake(width*i, 5, width-5, 65-10);
        
        //选择线宽事件
        [button addTarget:self action:@selector(lineButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置tag值
        button.tag = i;
        [_lineView addSubview:button];
        
        [_lineWidthBtnArr addObject:button];
    }
}

- (void)addBlockWithColorBlock:(ColorBlock)colorBlock
            withLineWidthBlock:(LineWidthBlock)lineWidthBlock
         withSelectEraserBlock:(SelectBlock)selectEraser
           withSelectUndoBlock:(SelectBlock)selectUndo
          withSelectClearBlock:(SelectBlock)selectClear{
    
    _colorBlock = colorBlock;
    _lineWidthBlock = lineWidthBlock;
    _selectEraser = selectEraser;
    _selectUndo = selectUndo;
    _selectClear = selectClear;
}

//创建选择按钮
- (void)_initSelectButton
{
    NSArray *titleArray = @[@"颜色",@"线宽",@"橡皮",@"撤销",@"清屏"];
    
    //每个按钮的宽度
    CGFloat width = SCREEN_WIDTH/5.0;
    
    for (int i = 0; i< titleArray.count; i++)
    {
        SelectCtrl *ctrl = [[SelectCtrl alloc] initWithFrame:CGRectMake(width*i, 0, width, 40)];
        
        //添加点击事件
        [ctrl addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
        ctrl.tag = i + 100;
        ctrl.title = titleArray[i];
        ctrl.backgroundColor = [UIColor clearColor];
        [self addSubview:ctrl];
        
        if (i ==0)
        {
            ctrl.isSelect = YES;
            _lastCtrl = ctrl;
        }
    }
}

#pragma mark  ===== action  =====
//添加点击事件
- (void)didClickAction:(SelectCtrl*)sender
{
    //取消前一次点击的按钮
    _lastCtrl.isSelect = NO;
    
    sender.isSelect = YES;
    
    //记录选中按钮
    _lastCtrl = sender;
    
    
    switch (sender.tag - 100)
    {
        case 0:
            //选择颜色面板
            _colorView.hidden = NO;
            _lineView.hidden = YES;
            break;
        case 1:
            //选择线宽面板
            _colorView.hidden = YES;
            _lineView.hidden = NO;
            break;
        case 2:
            //选择橡皮
            if (_selectEraser != nil) {
                _selectEraser();
            }
            break;
        case 3:
            //选择撤销
            if (_selectUndo != nil) {
                _selectUndo();
            }
            break;
        case 4:
            //选择清屏
            if (_selectClear != nil) {
                _selectClear();
            }
            break;
        default:
            break;
    }
}

//选择颜色的点击事件
- (void)conlorAction:(UIControl *)control
{
    for (UIControl *ctrl in _selectColorArr)
    {
        ctrl.layer.borderWidth = 0;
        ctrl.layer.borderColor = [UIColor clearColor].CGColor;
    }
    control.layer.borderWidth = 1;
    control.layer.borderColor = [UIColor whiteColor].CGColor;

    
    //取得选择的颜色
    UIColor *color = control.backgroundColor;
    
    if (_colorBlock != nil) {
        
        _colorBlock(color);
    }
}

//选择线宽事件
- (void)lineButtonAction:(UIButton *)button{
    
    for (UIButton *btn in _selectColorArr)
    {
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = [UIColor clearColor].CGColor;
    }
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //取得选择的线宽
    NSNumber *number = _lineArray[button.tag];
    CGFloat value = [number floatValue];
    
    if (_lineWidthBlock != nil) {
        
        _lineWidthBlock(value);
    }
}

@end
