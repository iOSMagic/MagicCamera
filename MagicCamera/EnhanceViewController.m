//
//  EnhanceViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//
// 每行CELL数量
#define COLUMN_COUNT        5
// CELL间的距离
#define COLUMN_INTERVAL     2
#define CELL_WIDTH  floor(([UIScreen mainScreen].bounds.size.width-10 - 10) / COLUMN_COUNT)
// HEADER高度
#define FOOTVIEW_HEIGHT     50
#define MB_WeakSelfDefine(obj) __weak typeof(self) weakSelf = obj


//#import <objc/message.h>
#import <GPUImage/GPUImageSaturationFilter.h>
#import "EnhanceViewController.h"
#import "PPCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <GPUImage/GPUImage.h>
#include <objc/runtime.h>
static NSString * const PhotoInfoReuseIdentifier = @"PhotoInfoReuseIdentifier";

@interface EnhanceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView   *_listCollectionView;
    UISlider  *_controllerSlider;
    GPUImageFilter *_stillImageFilter;
    NSMutableArray *_fileterArray;
    NSInteger _selectRow;
}
@end

@implementation EnhanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _listCollectionView.collectionViewLayout = layout;
    _listCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _listCollectionView.dataSource = self;
    _listCollectionView.delegate = self;
    _listCollectionView.backgroundColor = [UIColor clearColor];
    // 注册item
    [_listCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PPCollectionViewCell class])
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:PhotoInfoReuseIdentifier];
    [self.view addSubview:_listCollectionView];
    [_listCollectionView reloadData];
    _listCollectionView.backgroundColor = [UIColor whiteColor
                                           ];
    
    MB_WeakSelfDefine(self);
    [_listCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view);
        make.height.equalTo(@(CELL_WIDTH));
        
    }];
    
    _controllerSlider = [[UISlider alloc] init];
    _controllerSlider.value = 0.6;
    [_controllerSlider addTarget:self action:@selector(updateFilterFromSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_controllerSlider];
    [_controllerSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_listCollectionView.mas_top);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).offset(-60);
        make.height.equalTo(@44);
        
    }];
    
    [self addFilterArray];
 
    
    // Do any additional setup after loading the view.
}

-(void)addFilterArray
{
    _fileterArray = [NSMutableArray array];
    NSDictionary *dic = @{@"classname":@"GPUImageSaturationFilter",@"selector":@"setSaturation:",@"showname":@"饱和度"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageContrastFilter",@"selector":@"setContrast:",@"showname":@"对比度"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageExposureFilter",@"selector":@"setExposure:",@"showname":@"曝光"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageMonochromeFilter",@"selector":@"setIntensity:",@"showname":@"单色"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageRGBFilter",@"selector":@"setGreen:",@"showname":@"RGB绿色"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageRGBFilter",@"selector":@"setBlue:",@"showname":@"RGB蓝色"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageRGBFilter",@"selector":@"setRed:",@"showname":@"RGB红色"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageHueFilter",@"selector":@"setHue:",@"showname":@"色度"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageSharpenFilter",@"selector":@"setSharpness:",@"showname":@"锐化"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageGammaFilter",@"selector":@"setGamma:",@"showname":@"伽马线"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImagePosterizeFilter",@"selector":@"setColorLevels:",@"showname":@"色调分离 噪点效果"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageLuminanceThresholdFilter",@"selector":@"setThreshold:",@"showname":@"亮度阈"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageSwirlFilter",@"selector":@"setAngle:",@"showname":@"漩涡，中间形成卷曲的画面"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageEmbossFilter",@"selector":@"setIntensity:",@"showname":@"浮雕效果，带有点3d的感觉"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageSmoothToonFilter",@"selector":@"setBlurSize:",@"showname":@"粗旷的画风"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageBulgeDistortionFilter",@"selector":@"setScale:",@"showname":@"凸起失真，鱼眼效果"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageSphereRefractionFilter",@"selector":@"setRadius:",@"showname":@"球形折射，图形倒立"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageGlassSphereFilter",@"selector":@"setRadius:",@"showname":@"水晶球效果"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageToneCurveFilter",@"selector":@"setBlueControlPoints:",@"showname":@"色调曲线"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImagePinchDistortionFilter",@"selector":@"setScale:",@"showname":@"收缩失真，凹面镜"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageMosaicFilter",@"selector":@"setDisplayTileSize:",@"showname":@"黑白马赛克"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageVignetteFilter",@"selector":@"setVignetteEnd:",@"showname":@"晕影，形成黑色圆形边缘，突出中间图像的效果"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageGaussianBlurFilter",@"selector":@"setBlurSize:",@"showname":@"高斯模糊"};
    [_fileterArray addObject:dic];

    dic = @{@"classname":@"GPUImageBilateralFilter",@"selector":@"setBlurSize:",@"showname":@"双边模糊"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageFastBlurFilter",@"selector":@"setBlurPasses:",@"showname":@"模糊"};
    [_fileterArray addObject:dic];
    
    dic = @{@"classname":@"GPUImageOpacityFilter",@"selector":@"setOpacity:",@"showname":@"不透明度"};
    [_fileterArray addObject:dic];
}

- (void)updateFilterFromSlider:(id)sender
{
    NSDictionary *dic = _fileterArray[_selectRow];
    Class classname = NSClassFromString(dic[@"classname"]);
    _stillImageFilter = [[classname alloc] init];
    SEL selector = NSSelectorFromString(dic[@"selector"]);
    if ([_stillImageFilter respondsToSelector:selector]) {

        if (_stillImageFilter && [_stillImageFilter isKindOfClass:[GPUImageToneCurveFilter class]])
        {
        [(GPUImageToneCurveFilter *)_stillImageFilter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
        }
        else
        {
//            void (*objc_msgSendTyped)(id self, SEL _cmd, float arg1) = (void*)objc_msgSend;
//            objc_msgSendTyped(_stillImageFilter, selector,_controllerSlider.value);
            objc_msgSend(_stillImageFilter, selector,_controllerSlider.value);
        }
    }
    
//    [_stillImageFilter setRed:_controllerSlider.value];
    UIImage *quickFilteredImage = [_stillImageFilter imageByFilteringImage:self.originalImage];
    self.imageView.image = quickFilteredImage;
}


#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 7, 0, 7);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return COLUMN_INTERVAL;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}



#pragma mark - UICollectionViewdatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _fileterArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPCollectionViewCell *cell = (PPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PhotoInfoReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    NSDictionary *dic = _fileterArray[indexPath.row];
    cell.nameLabel.text = dic[@"showname"];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectRow = indexPath.row;
    [self updateFilterFromSlider:_controllerSlider];
}
@end
