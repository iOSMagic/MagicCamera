//
//  FrameViewController.h
//  MagicCamera
//
//  Created by SongWentong on 2/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
//边框界面
@interface FrameViewController : UIViewController
@property (nonatomic,strong) UIImage *originalImage;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

//背景视图
@property (nonatomic,strong) UIView *backView;
//包含图片的view
@property (nonatomic,strong) UIView *containerView;
//前景视图
@property (nonatomic,strong) UIView *foreView;
//各种选项
@property (nonatomic,strong) UIView *collectionView;
@end
