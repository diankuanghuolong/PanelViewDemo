//
//  SelectCtrl.h
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCtrl : UIControl

@property(nonatomic,copy)NSString *title;  //标题
@property(nonatomic,assign)BOOL  isSelect;  //选中状态
@property(nonatomic,strong)UIFont *font;    //字体大小
@end
