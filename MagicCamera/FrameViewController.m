//
//  FrameViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "FrameViewController.h"

@interface FrameViewController () <UIGestureRecognizerDelegate>
{
    
}
@end

@implementation FrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    [self configViews];
}

-(void)configViews
{
    CGRect bounds = self.view.bounds;
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.frame = CGRectMake(0, 64, CGRectGetWidth(bounds), CGRectGetHeight(bounds)-200);
    _containerView.clipsToBounds = YES;
    [self.view addSubview:_containerView];
    self.imageView = [[UIImageView alloc] initWithFrame:_containerView.bounds];
    [_containerView addSubview:_imageView];
    
//    _imageView.frame = CGRectMake(0, 64, CGRectGetWidth(bounds), CGRectGetHeight(bounds)-200);
    _imageView.image = _originalImage;
    
    
    [self addGestures];
}

-(void)addGestures
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    [_containerView addGestureRecognizer:pan];

    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    [_containerView addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    rotate.delegate = self;
    [_containerView addGestureRecognizer:rotate];
}

-(void)reciveGesture:(UIGestureRecognizer*)recognizer
{
    Class theclass = [recognizer class];
    if (theclass == [UIPanGestureRecognizer class]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)recognizer;
        CGPoint translation = [pan translationInView:self.view];
        _imageView.center = CGPointMake(_imageView.center.x+translation.x, _imageView.center.y+translation.y);
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if (theclass == [UIPinchGestureRecognizer class]) {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer*)recognizer;
        _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
        pinch.scale = 1;
    }
    
    if (theclass == [UIRotationGestureRecognizer class]) {
        UIRotationGestureRecognizer *rotate = (UIRotationGestureRecognizer*)recognizer;
        _imageView.transform = CGAffineTransformRotate(_imageView.transform, rotate.rotation);
        rotate.rotation = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
