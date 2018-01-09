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
#import "MBProgressHUD.h"
/*
 定义安全区域到顶部／底部高度
 */

#define SafeAreaTopHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 34 : 0)

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic ,strong)PanelView *panelView;
@property (nonatomic ,strong)UIButton *leftBtn;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"画板";
    
    //init
    [self.view addSubview:self.panelView];
    
    //savePhoto
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBbi = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    //inputPhoto
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [leftBtn setTitle:@"插入水印" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(inputPhoto:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn = leftBtn;
    UIBarButtonItem *leftBbi = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.rightBarButtonItem = rightBbi;
    self.navigationItem.leftBarButtonItem = leftBbi;
    
    //kvo监听leftBtn状态
    [self.leftBtn addObserver:self forKeyPath:@"select" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark =====  laizyLoad  =====
- (PanelView *)panelView
{
    if(!_panelView)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        //创建画板视图
        _panelView = [[PanelView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 110 - SafeAreaTopHeight - SafeAreaBottomHeight)];
        _panelView.backgroundColor = [UIColor whiteColor];
        
        //创建工具视图
        ToolView *toolView = [[ToolView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 110 - SafeAreaBottomHeight, width, 110)];
        toolView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:toolView];
        
        //传递block
        [toolView addBlockWithColorBlock:^(UIColor *color) {
            _panelView.color = color;
        } withLineWidthBlock:^(CGFloat width) {
            _panelView.width = width;
            
        } withSelectEraserBlock:^{
            
            //橡皮
            
            _panelView.color = [UIColor whiteColor];
            _panelView.width = 25;
            
        } withSelectUndoBlock:^{
            
            //撤销
            [_panelView undo];
            
        } withSelectClearBlock:^{
            
            //清屏
            [_panelView clear];
        }];
    }
    return _panelView;
}

#pragma mark  ===== action  =====
-(void)savePhoto:(UIButton *)sender
{
    UIView * contentView = _panelView;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(contentView.frame.size.width, contentView.frame.size.height), YES, 0);     //设置截屏大小
    [[contentView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//保存图片到照片
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = @"已经保存到本地";
    hud.margin = 12.f;
    hud.offset = CGPointMake(0, 0);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.f];
}
-(void)inputPhoto:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected && !_panelView.logoIV.image)//插入水印
    {
        sender.selected = NO;
        [sender setTitle:@"清除水印" forState:UIControlStateNormal];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleAlert];
        
        //打开相册
        __weak typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf openPhotoShop];
        }];
        [alert addAction:action];
        
        //打开相机
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf openCamare];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else//清除水印
    {
        sender.selected = YES;
        [sender setTitle:@"插入水印" forState:UIControlStateNormal];
        _panelView.logoIV.image = nil;
    }
   
}
-(void)openCamare
{
    BOOL isAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isAvailable)
    {
        UIImagePickerController *camare = [[UIImagePickerController alloc]init];
        camare.sourceType = UIImagePickerControllerSourceTypeCamera;
        camare.mediaTypes = [[NSArray alloc]initWithObjects:@"public.image", nil];
        camare.delegate = self;
        [self presentViewController:camare animated:YES completion:nil];
    }
    else
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持照相机" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            

        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
-(void)openPhotoShop
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
#pragma mark =====  pickerDelegate  =====
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^() {
        
        NSData *data = [self imageData:editedImage];
        UIImage *zibImg = [UIImage imageWithData:data];
        //            NSData * imageData = UIImageJPEGRepresentation(editedImage,1);
        //            NSLog(@"原图==%u压缩图==%u",[imageData length]/1024,[data length]/1024);
        //do
        
        [_panelView.logoIV setImage:zibImg];
        
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark ===== kvo  =====
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
}

#pragma mark  =====  tool =====
-(NSData *)imageData:(UIImage *)myimage//图片压缩
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024)
    {
        if (data.length>1024*1024)
        {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }
        else if (data.length>512*1024)
        {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }
        else if (data.length>200*1024)
        {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}
@end
