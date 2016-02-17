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
@property (nonatomic,strong) UIImageView *imageView;

//背景视图
@property (nonatomic,strong) UIView *backView;
//包含图片的view
@property (nonatomic,strong) UIView *containerView;
//前景视图
@property (nonatomic,strong) UIView *foreView;

//风格
@property (weak, nonatomic) IBOutlet UICollectionView *styleCollectionView;

//类型
@property (weak, nonatomic) IBOutlet UICollectionView *typeCollectionView;
@end
