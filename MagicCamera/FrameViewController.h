//
//  FrameViewController.h
//  MagicCamera
//
//  Created by SongWentong on 2/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>
//边框
@interface FrameViewController : UIViewController
@property (nonatomic,strong) UIImage *originalImage;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@end
