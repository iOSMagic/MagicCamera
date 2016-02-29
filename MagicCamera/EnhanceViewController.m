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

#import "EnhaceModel.h"
#import <objc/message.h>

#import "GPUImage.h"
#import "EnhanceViewController.h"
#import "PPCollectionViewCell.h"
#import <Masonry/Masonry.h>
//#import <GPUImage/GPUImage.h>
#include <objc/runtime.h>
#import "IFInkwellFilter.h"

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
    
    
    
    [self addFilterArray];
 
    [self createcontrollerSlider];

    // Do any additional setup after loading the view.
}

-(void)addFilterArray
{
    _fileterArray = [NSMutableArray array];
    EnhaceModel *model = nil;

    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageSaturationFilter";
    model.selector = @"setSaturation:";
    model.showname = @"饱和度";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];


    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageBrightnessFilter";
    model.selector = @"setBrightness:";
    model.showname = @"亮度";
    model.maxValue = 0.5;
    model.minValue = -0.5;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageExposureFilter";
    model.selector = @"setExposure:";
    model.showname = @"曝光";
    model.maxValue = 10;
    model.minValue = -10;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageContrastFilter";
    model.selector = @"setContrast:";
    model.showname = @"对比度";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    


    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageMonochromeFilter";
    model.selector = @"setIntensity:";
    model.showname = @"单色";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageRGBFilter";
    model.selector = @"setGreen:";
    model.showname = @"RGB绿色";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageRGBFilter";
    model.selector = @"setBlue:";
    model.showname = @"RGB蓝色";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageRGBFilter";
    model.selector = @"setRed:";
    model.showname = @"RGB红色";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageHueFilter";
    model.selector = @"setHue:";
    model.showname = @"色度";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
   
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageSharpenFilter";
    model.selector = @"setSharpness:";
    model.showname = @"锐化";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageGammaFilter";
    model.selector = @"setGamma:";
    model.showname = @"伽马线";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImagePosterizeFilter";
    model.selector = @"setColorLevels:";
    model.showname = @"色调分离 噪点效果";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageLuminanceThresholdFilter";
    model.selector = @"setThreshold:";
    model.showname = @"亮度阈";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageSwirlFilter";
    model.selector = @"setAngle:";
    model.showname = @"漩涡，中间形成卷曲的画面" ;
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    

    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageEmbossFilter";
    model.selector = @"setIntensity:";
    model.showname = @"浮雕效果，带有点3d的感觉" ;
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageSmoothToonFilter";
    model.selector = @"setBlurSize:";
    model.showname =@"粗旷的画风" ;
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageBulgeDistortionFilter";
    model.selector = @"setScale:";
    model.showname =@"凸起失真，鱼眼效果" ;
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageSphereRefractionFilter";
    model.selector = @"setRadius:";
    model.showname =@"球形折射，图形倒立";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageGlassSphereFilter";
    model.selector = @"setRadius:";
    model.showname =@"水晶球效果";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageToneCurveFilter";
    model.selector = @"setBlueControlPoints:";
    model.showname =@"色调曲线";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImagePinchDistortionFilter";
    model.selector = @"setScale:";
    model.showname =@"收缩失真，凹面镜";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageMosaicFilter";
    model.selector = @"setDisplayTileSize:";
    model.showname =@"黑白马赛克";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageVignetteFilter";
    model.selector = @"setVignetteEnd:";
    model.showname =@"晕影，形成黑色圆形边缘，突出中间图像的效果";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageGaussianBlurFilter";
    model.selector = @"setBlurSize:";
    model.showname =@"高斯模糊";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
  
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageBilateralFilter";
    model.selector = @"setBlurSize:";
    model.showname =@"双边模糊";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageFastBlurFilter";
    model.selector = @"setBlurPasses:";
    model.showname =@"模糊";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
    
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"GPUImageOpacityFilter";
    model.selector = @"setOpacity:";
    model.showname =@"不透明度";
    model.maxValue = 1;
    model.minValue = 0;
    [_fileterArray addObject:model];
 
    model = [[EnhaceModel alloc] init];
    model.classname = @"IFInkwellFilter";
    model.selector = @"setOpacity:";
    model.showname =@"IFInkwellFilter";
    model.maxValue = 1;
    model.minValue = -1;
    [_fileterArray addObject:model];
 
    
}

- (void)updateFilterFromSlider:(id)sender
{
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        EnhaceModel *model = _fileterArray[_selectRow];
        
        Class classname = NSClassFromString(model.classname);
        _stillImageFilter = [[classname alloc] init];
        SEL selector = NSSelectorFromString(model.selector);
        if ([_stillImageFilter respondsToSelector:selector]) {
            
            if (_stillImageFilter && [_stillImageFilter isKindOfClass:[GPUImageToneCurveFilter class]])
            {
                [(GPUImageToneCurveFilter *)_stillImageFilter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
            }
            else
            {
                void (*objc_msgSendTyped)(id self, SEL _cmd, CGFloat arg1) = (void*)objc_msgSend;
                CGFloat value = _controllerSlider.value;
                objc_msgSendTyped(_stillImageFilter, selector,value);
            }
        }
        
        //    [_stillImageFilter setRed:_controllerSlider.value];
        UIImage *quickFilteredImage = [_stillImageFilter imageByFilteringImage:self.originalImage];
        self.imageView.image = quickFilteredImage;
        //    self.originalImage = quickFilteredImage;
    });

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
    EnhaceModel *model = _fileterArray[indexPath.row];
    cell.nameLabel.text = model.showname;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectRow = indexPath.row;
//    self.originalImage = self.imageView.image;
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createcontrollerSlider];
        [self updateFilterFromSlider:_controllerSlider];
    });
}

-(void)createcontrollerSlider
{
    EnhaceModel *model = _fileterArray[_selectRow];
    
    [_controllerSlider removeFromSuperview];
    MB_WeakSelfDefine(self);
    _controllerSlider = [[UISlider alloc] init];
    _controllerSlider.minimumValue = (float)model.minValue;
    _controllerSlider.maximumValue = (float)model.maxValue;
    _controllerSlider.value=0.6;
    [_controllerSlider addTarget:self action:@selector(updateFilterFromSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_controllerSlider];
    [_controllerSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_listCollectionView.mas_top);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).offset(-60);
        make.height.equalTo(@44);
        
    }];
}
@end
