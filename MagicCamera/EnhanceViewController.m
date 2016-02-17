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

#import "EnhanceViewController.h"
#import "PPCollectionViewCell.h"
#import <Masonry/Masonry.h>

static NSString * const PhotoInfoReuseIdentifier = @"PhotoInfoReuseIdentifier";

@interface EnhanceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView   *_listCollectionView;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPCollectionViewCell *cell = (PPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PhotoInfoReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
        cell.nameLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
