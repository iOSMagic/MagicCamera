//
//  EditImageViewController.h
//  MagicCamera
//
//  Created by SongWentong on 2/15/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditImageViewController : UIViewController
@property (nonatomic,strong) UIImage *originalImage;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@end
