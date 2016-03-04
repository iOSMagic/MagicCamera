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
#import "UIViewController+IBHelper.h"
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
    
    
    [self addModels];
    //    self.imageView.contentMode = UIViewContentModeCenter;
}

-(void)addModels
{
    CIModel *model = [CIModel new];
    //灰色
    model.filterName = @"CISepiaTone";
    model.desc = @"审核色调";
    [model.inputs setValue:@0.8f forKey:kCIInputIntensityKey];
    [_modelCollection addObject:model];
    
    
    model = [CIModel new];
    model.filterName = @"CIColorCrossPolynomial";
    model.desc = @"颜色调整";
    [_modelCollection addObject:model];
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
    });
    
    
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
