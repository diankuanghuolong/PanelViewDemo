//
//  PanelView.h
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanelView : UIView
{
    
    NSMutableArray *_pathArray;
}


@property(nonatomic,strong) UIColor *color;
@property(nonatomic,assign) CGFloat width;

//撤销
- (void)undo;

//清屏
- (void)clear;
@end
