//
//  FrameViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "FrameViewController.h"
#import "ResultDisplayViewController.h"
//#import "UIViewController+IBHelper.h"
#import "WTKit.h"
@interface FrameViewController () <UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
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
    CGRect frame = CGRectMake(0, 64, CGRectGetWidth(bounds), CGRectGetHeight(bounds)-200);
//    self.backView = [[UIImageView alloc] initWithFrame:frame];
//    _backView.contentMode = UIViewContentModeCenter;
//    _backView.image = [UIImage imageNamed:@"meituframe1"];
//    [self.view addSubview:_backView];
    
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.frame = frame;
    _containerView.clipsToBounds = YES;
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_containerView];
    
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:_containerView.bounds];
    [_containerView addSubview:_imageView];
    

    _imageView.image = _originalImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.foreView = [[UIImageView alloc] initWithFrame:frame];
    _foreView.image = [UIImage imageNamed:@"meituframe1"];
//    _foreView.contentMode = UIViewContentModeScaleAspectFit;
    _foreView.clipsToBounds = YES;
    [self.view addSubview:_foreView];
    _foreView.userInteractionEnabled = NO;
    
    
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)_typeCollectionView.collectionViewLayout;
    collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(bounds)/5, collectionViewLayout.itemSize.height);
    
    [self addGestures];
    
    
    
    
    
    
}


//重置containerView的frame,因为根据图片不同,在的位置也不同
-(void)refreshContrinerViewFrame
{
    
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



-(NSArray<NSString*>*)titlesForTypeCollectionView
{
    return @[@"关闭",@"海报边框",@"简单边框",@"炫彩边框",@"完成"];
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if ([collectionView isEqual:_typeCollectionView]) {
        number = 5;
    }
    
    
    
    
    return number;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if ([collectionView isEqual:_typeCollectionView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UILabel *label = [cell viewWithTag:1];
        label.text = [self titlesForTypeCollectionView][indexPath.item];
    }
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([collectionView isEqual:_typeCollectionView]) {
        switch (indexPath.item) {
            case 0:
            {
                //关闭
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 4:
            {
                //进入
//                [self.navigationController popViewControllerAnimated:YES];
                ResultDisplayViewController *vc = [ResultDisplayViewController instanceFromIB];
                
                UIImage *image = [self snapshot:self.view];
                vc.resultImage = image;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (UIImage *)snapshot:(UIView *)view
{
    _styleCollectionView.hidden = YES;
    _typeCollectionView.hidden = YES;
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height-40), YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _styleCollectionView.hidden = NO;
    _typeCollectionView.hidden = NO;
    return image;
}




#pragma mark - other
@end
