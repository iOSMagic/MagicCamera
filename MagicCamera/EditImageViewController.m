//
//  EditImageViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/15/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "EditImageViewController.h"

@interface EditImageViewController () <UIScrollViewDelegate>


@end

@implementation EditImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    self.imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    [_scrollView addSubview:_imageView];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 4;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = _originalImage;
    _scrollView.contentSize = _scrollView.bounds.size;
//    self.automaticallyAdjustsScrollViewInsets = NO;

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIResponder
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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
