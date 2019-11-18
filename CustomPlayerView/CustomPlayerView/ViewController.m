//
//  ViewController.m
//  CustomPlayerView
//
//  Created by MrZhou on 2019/10/25.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()
{
    UIView* _fullScreenBlackView;
}

@property (strong , nonatomic) UIView * playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fullScreenBlackView = [[UIView alloc]init];
    _fullScreenBlackView.backgroundColor = UIColor.blackColor;
    _fullScreenBlackView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    self.playerView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.leading.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(@300);
        
    }];
    self.playerView.backgroundColor = UIColor.redColor;
    
    /**
     *  开始生成 设备旋转 通知
     */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    /**
     *  添加 设备旋转 通知
     *
     *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
     *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    
    
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    
    //1.获取 当前设备 实例
      UIDevice *device = [UIDevice currentDevice] ;
    if (device.orientation == UIDeviceOrientationFaceUp || device.orientation == UIDeviceOrientationFaceDown) {
        return;
    }
    if(device.orientation == UIDeviceOrientationUnknown || device.orientation == UIDeviceOrientationPortraitUpsideDown || device.orientation == UIDeviceOrientationPortrait) {
        [_fullScreenBlackView removeFromSuperview];
        [self addPlayerToFatherView:self.playerView];
    }else {
        
        [self.playerView removeFromSuperview];

        [[UIApplication sharedApplication].keyWindow addSubview:_fullScreenBlackView];
        [_fullScreenBlackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.playerView];
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        
                         make.leading.mas_equalTo(0);
                         make.right.mas_equalTo(0);
                         make.top.mas_equalTo(0);
                         make.bottom.mas_equalTo(0);

                     }];
        [self _adjustTransform:device.orientation];
    }

}

/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    [view removeFromSuperview];
    [self.view addSubview:view];
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(@300);
    }];
}

- (void)_adjustTransform:(UIDeviceOrientation)orientation {

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.playerView.transform = [self getTransformRotationAngleOfOrientation:orientation];
    _fullScreenBlackView.transform = self.playerView.transform;
    [UIView commitAnimations];
    
    
}

/**
 * 获取变换的旋转角度
 *
 * @return 变换矩阵
 */
- (CGAffineTransform)getTransformRotationAngleOfOrientation:(UIDeviceOrientation)orientation {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (interfaceOrientation == (UIInterfaceOrientation)orientation) {
        return CGAffineTransformIdentity;
    }
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

-(void)dealloc {
    
    /**
       *  销毁 设备旋转 通知
       *
       *  @return return value description
       */
      [[NSNotificationCenter defaultCenter] removeObserver:self
                                                      name:UIDeviceOrientationDidChangeNotification
                                                    object:nil
       ];
      
      
      /**
       *  结束 设备旋转通知
       *
       *  @return return value description
       */
      [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];

    
}

@end
