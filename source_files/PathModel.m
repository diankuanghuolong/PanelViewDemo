//
//  PathModel.m
//  PanelViewDemo
//
//  Created by Ios_Developer on 2017/12/19.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "PathModel.h"

@implementation PathModel

-(void)setPath:(CGMutablePathRef)path
{   CGPathRetain(path);
    _path = path;
}
-(void)dealloc
{
    CGPathRelease(_path);
}
@end
