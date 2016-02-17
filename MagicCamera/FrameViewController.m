//
//  FrameViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "FrameViewController.h"

@interface FrameViewController ()
{
    
}
@end

@implementation FrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_imageView];
    CGRect bounds = self.view.bounds;
    _imageView.frame = CGRectMake(0, 64, CGRectGetWidth(bounds), CGRectGetHeight(bounds)-200);
    _imageView.image = _originalImage;
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    [self.view addGestureRecognizer:pan];
//    _imageView.userInteractionEnabled = YES;
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(reciveGesture:)];
    [self.view addGestureRecognizer:pinch];
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

@end
