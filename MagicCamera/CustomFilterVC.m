//
//  AutoEnhanceVC.m
//  MagicCamera
//
//  Created by SongWentong on 3/4/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "CustomFilterVC.h"
@import CoreImage;
@import ImageIO;
#import "WTKit.h"
#import "CIModel.h"
@interface CustomFilterVC () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *models;
@end

@implementation CustomFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIImage *image = self.originalImage;
    [self.view bringSubviewToFront:_collectionView];
    
    
    self.models = [NSMutableArray array];
    CIModel *model = [CIModel new];
    model.filterName = @"OldeFilm";
    model.desc = @"老照片";
    [_models addObject:model];

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
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:1];
    label.text = @"老照片";
    
    
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CIFilter *filter = [CIFilter filterWithName:@"OldFilm"];
    
    [[NSOperationQueue globalQueue] addOperationWithBlock:^{
        CIContext *context = [CIContext contextWithOptions:nil];               // 1
        CIImage *image = [CIImage imageWithCGImage:self.originalImage.CGImage];               // 2
        CIFilter *filter = [CIFilter filterWithName:@"OldeFilm"];           // 3
        [filter setValue:image forKey:kCIInputImageKey];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
        CGRect extent = [result extent];
        CGImageRef cgImage = [context createCGImage:result fromRect:extent];   // 5
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = [UIImage imageWithCGImage:cgImage];
        }];
    }];
}
@end







