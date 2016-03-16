//
//  CIEnhanceViewController.m
//  MagicCamera
//
//  Created by SongWentong on 3/4/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "CIEnhanceViewController.h"
@import CoreImage;
@import ImageIO;
#import "ResultDisplayViewController.h"
#import "WTKit.h"
#import "CIModel.h"
@interface CIEnhanceViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    
}
@property (nonatomic,strong) NSArray *effectNames;
@property (nonatomic,strong) NSMutableArray *modelCollection;
@end

@implementation CIEnhanceViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view bringSubviewToFront:self.typeCollection];
    
    
    self.modelCollection = [NSMutableArray array];
    
    
    NSMutableArray *rightBarButtonItems = [NSMutableArray new];
    [rightBarButtonItems addObject:[[UIBarButtonItem alloc]initWithTitle:@"去掉效果" style:UIBarButtonItemStylePlain target:self action:@selector(resetEffects:)]];
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    [self addModels];
    //    self.imageView.contentMode = UIViewContentModeCenter;
}

-(void)resetEffects:(id)sender
{
    self.imageView.image = self.originalImage;
}

-(void)addModels
{
    
    CIModel *model = [CIModel new];
    //灰色
    model.filterName = @"CISepiaTone";
    model.desc = @"审核色调";
    [model.inputs setValue:@0.8f forKey:kCIInputIntensityKey];
    [_modelCollection addObject:model];
    


//    [self.typeCollection reloadData];
    
    model = [CIModel new];
    model.filterName = @"CIColorCrossPolynomial";
    model.desc = @"颜色调整";
    [_modelCollection addObject:model];
    
    
    
    model = [CIModel new];
    model.filterName = @"CIColorInvert";
    model.desc = @"颜色对调";
    [_modelCollection addObject:model];
//    model.inputs =
    
    
    model = [CIModel new];
    model.filterName = @"CIBumpDistortion";
    model.desc = @"隆胸";
    [model.inputs setValue:[NSNumber numberWithFloat:100] forKey:kCIAttributeTypeDistance];
    [_modelCollection addObject:model];
    
    
    model = [CIModel new];
    model.filterName = @"CICircularWrap";
    model.desc = @"圆圈";
    [_modelCollection addObject:model];
    
    
    model = [CIModel new];
    model.filterName = @"CIHoleDistortion";
    model.desc = @"洞";
    [_modelCollection addObject:model];
    
    model = [CIModel new];
    model.filterName = @"CILineOverlay";
    model.desc = @"铅笔画";
    [_modelCollection addObject:model];
    
    
    model = [CIModel new];
    model.filterName = @"CIGaussianBlur";
    model.desc = @"高斯模糊";
    [_modelCollection addObject:model];
    
    
    model = [CIModel new];
    model.filterName = @"CIPhotoEffectMono";
    model.desc = @"单色";
    [_modelCollection addObject:model];
    
    model = [CIModel new];
    model.filterName = @"CIColorClamp";
    model.desc = @"限制颜色范围";
    [_modelCollection addObject:model];
    
    model = [CIModel new];
    model.filterName = @"CICircularScreen";
    model.desc = @"圆圈";
    [_modelCollection addObject:model];
    
    
    model = [CIModel new];
    model.filterName = @"CIDotScreen";
    model.desc = @"半色调";
    [_modelCollection addObject:model];
    
    
    model = [CIModel new];
    model.filterName = @"CISharpenLuminance";
    model.desc = @"锐化";
    [_modelCollection addObject:model];
}

-(void)addModelWithBlock:(void(^)(CIModel *aModel))block{
    __block CIModel *model = [CIModel new];
    [_modelCollection addObject:model];
    if (block) {
        block(model);
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelCollection.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:1];
    CIModel *model = self.modelCollection[indexPath.item];
    NSString *text = model.desc;
    label.text = text;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self effectWithIndex:indexPath.item];
}

-(void)effectWithIndex:(NSInteger)index
{
    
    [[NSOperationQueue globalQueue] addOperationWithBlock:^{
        CIModel *model = self.modelCollection[index];
        CIContext *context = [CIContext contextWithOptions:nil];               // 1
        CIImage *image = [CIImage imageWithCGImage:self.originalImage.CGImage];               // 2
        CIFilter *filter = [CIFilter filterWithName:model.filterName];           // 3
        [filter setValue:image forKey:kCIInputImageKey];
        [filter setValuesForKeysWithDictionary:model.inputs];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
        CGRect extent = [result extent];
        CGImageRef cgImage = [context createCGImage:result fromRect:extent];   // 5
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = [UIImage imageWithCGImage:cgImage];
        }];
    }];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
//    });

    
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
