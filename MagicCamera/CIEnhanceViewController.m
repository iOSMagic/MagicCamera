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
@interface CIEnhanceViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    
}
@end

@implementation CIEnhanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CIImage *myImage = [CIImage imageWithCGImage:self.originalImage.CGImage];
        
        /*
         NSDictionary *options = @{ CIDetectorImageOrientation :
         [[myImage properties] valueForKey:(NSString*)kCGImagePropertyOrientation] };
         */
        NSArray *adjustments = [myImage autoAdjustmentFiltersWithOptions:nil];
        for (CIFilter *filter in adjustments) {
            [filter setValue:myImage forKey:kCIInputImageKey];
            myImage = filter.outputImage;
        }
        UIImage *image = [UIImage imageWithCIImage:myImage scale:1.0 orientation:UIImageOrientationUp];
        dispatch_sync(dispatch_get_main_queue(), ^{
//            self.imageView.image = image;
            ResultDisplayViewController *vc = [ResultDisplayViewController instanceFromIB];
            vc.resultImage = image;
            [self.navigationController pushViewController:vc animated:YES];
//            CGSize size = self.scrollView.contentSize;
//            NSLog(@"%@",NSStringFromCGSize(size));
        });
    });


//    self.imageView.contentMode = UIViewContentModeCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:1];
    label.text = @"老照片";
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
