//
//  ResultDisplayViewController.m
//  MagicCamera
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "ResultDisplayViewController.h"

@interface ResultDisplayViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ResultDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = _resultImage;
    
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
