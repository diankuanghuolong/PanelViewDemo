//
//  ViewController.m
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "ViewController.h"
#import "PanelView.h"
#import "ToolView.h"

/*
 定义安全区域到顶部／底部高度
 */

#define SafeAreaTopHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 34 : 0)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //创建画板视图
    PanelView *panelView = [[PanelView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 110 - SafeAreaTopHeight - SafeAreaBottomHeight)];
    panelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:panelView];
    
    //创建工具视图
    ToolView *toolView = [[ToolView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 110 - SafeAreaBottomHeight, width, 110)];
    toolView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:toolView];
    
    //传递block
    [toolView addBlockWithColorBlock:^(UIColor *color) {
        panelView.color = color;
    } withLineWidthBlock:^(CGFloat width) {
        panelView.width = width;
        
    } withSelectEraserBlock:^{
        
        //橡皮
        
        panelView.color = [UIColor whiteColor];
        panelView.width = 25;
        
    } withSelectUndoBlock:^{
        
        //撤销
        [panelView undo];
        
    } withSelectClearBlock:^{
        
        //清屏
        [panelView clear];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
