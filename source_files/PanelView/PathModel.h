//
//  PathModel.h
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PathModel : NSObject


@property (nonatomic ,assign)CGMutablePathRef path;
@property (nonatomic ,strong)UIColor *color;
@property (nonatomic ,assign)CGFloat width;
@end
