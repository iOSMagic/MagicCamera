//
//  EditImageViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/15/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "EditImageViewController.h"

@interface EditImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EditImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView.image = _originalImage;
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
