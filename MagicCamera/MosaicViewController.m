//
//  MosaicViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/16/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "MosaicViewController.h"
#import "MosaicView.h"

@interface MosaicViewController ()
{
    MosaicView *_mosaicView;
}
@end

@implementation MosaicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = nil;
    _mosaicView = [[MosaicView alloc]initWithMosaicImage:self.originalImage andFrame:self.scrollView.bounds];
    [self.scrollView addSubview:_mosaicView];
    
     UIButton *_mosaicBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mosaicBT setTitle:@"马赛克" forState:UIControlStateNormal];
    [_mosaicBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_mosaicBT addTarget:self action:@selector(mosaicBTClick) forControlEvents:UIControlEventTouchUpInside];
    _mosaicBT.frame = CGRectMake(10, self.view.bounds.size.height - 70, 100, 50);
    [self.view addSubview:_mosaicBT];
    
    UIButton *_cleanBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cleanBT setTitle:@"橡皮擦" forState:UIControlStateNormal];
    [_cleanBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_cleanBT addTarget:self action:@selector(cleanBTClick) forControlEvents:UIControlEventTouchUpInside];
    _cleanBT.frame = CGRectMake(160, _mosaicBT.frame.origin.y, 100, 50);
    [self.view addSubview:_cleanBT];
    
    UIButton *saveBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBT setTitle:@"保存" forState:UIControlStateNormal];
    [saveBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [saveBT addTarget:self action:@selector(saveBTClick) forControlEvents:UIControlEventTouchUpInside];
    saveBT.frame = CGRectMake(260, _mosaicBT.frame.origin.y, 100, 50);
    [self.view addSubview:saveBT];
}


-(void)cleanBTClick
{
    _mosaicView.opertionType = ImageOpertionType_Clean;
}

-(void)mosaicBTClick
{
    _mosaicView.opertionType = ImageOpertionType_Mosaic;
}

-(void)saveBTClick
{
    [_mosaicView savePhoto];
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
