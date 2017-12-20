//
//  ToolView.h
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColorBlock) (UIColor *color);
typedef void(^LineWidthBlock) (CGFloat width);
typedef void(^SelectBlock) (void);

@class SelectCtrl;
@interface ToolView : UIView
{
    
    SelectCtrl *_lastCtrl;
    NSArray *_colorArray;
    NSArray *_lineArray;
    UIView *_colorView;
    UIView *_lineView;
    
    
    ColorBlock _colorBlock;         //颜色
    LineWidthBlock _lineWidthBlock; //线条
    
    SelectBlock _selectEraser;     //橡皮
    SelectBlock _selectUndo;       //撤销
    SelectBlock _selectClear;      //清屏
}

- (void)addBlockWithColorBlock:(ColorBlock)colorBlock
            withLineWidthBlock:(LineWidthBlock)lineWidthBlock
         withSelectEraserBlock:(SelectBlock)selectEraser
           withSelectUndoBlock:(SelectBlock)selectUndo
          withSelectClearBlock:(SelectBlock)selectClear;
@end
