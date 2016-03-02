//
//  ViewController.m
//  MagicCamera
//
//  Created by SongWentong on 2/15/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "ViewController.h"
#import "EditImageViewController.h"
#import "FrameViewController.h"
#import "ShowcaseFilterListController.h"
@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
    //自动选图,默认是YES
    BOOL _autoSelectPhoto;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自动选图" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavigationItemPressed:)];
    _autoSelectPhoto = YES;
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)rightNavigationItemPressed:(UIBarButtonItem*)sender
{
    _autoSelectPhoto = !_autoSelectPhoto;
    NSString *title = @"手动选图";
    if (_autoSelectPhoto) {
        title = @"自动选图";
    }
    [sender setTitle:title];
}

-(NSArray<NSString*>*)avalibleEffect
{
    return @[@"增强",@"滤镜",@"马赛克",@"边框"];
}

-(NSArray<NSString*>*)avalibleSegues
{
    return @[@"enhance",@"filter",@"mosaic",@"frame"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[EditImageViewController class]]) {
        EditImageViewController *temp = (EditImageViewController*)vc;
        temp.originalImage = sender;
    }
    if ([vc isKindOfClass:[FrameViewController class]]) {
        FrameViewController *temp = (FrameViewController*)vc;
        temp.originalImage = sender;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSArray *avalibleSegues = [self avalibleSegues];
        NSString *segue = avalibleSegues[_tableView.indexPathForSelectedRow.row];
        [self performSegueWithIdentifier:segue sender:image];
    }];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
        {
            number = [self avalibleEffect].count;
        }
            break;
        case 1:
        {

        }
            break;
            
        default:
            break;
    }
    return number;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self avalibleEffect][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_autoSelectPhoto) {
        
        //滤镜效果
        if (indexPath.row==1) {
            
            
            ShowcaseFilterListController * filterListController = [[ShowcaseFilterListController alloc] initWithNibName:nil bundle:nil];
            
            [self.navigationController pushViewController:filterListController animated:YES];
        }
       else
       {
        
        NSArray *avalibleSegues = [self avalibleSegues];
        NSString *segue = avalibleSegues[indexPath.row];
        UIImage *image = [UIImage imageNamed:@"Image"];
        [self performSegueWithIdentifier:segue sender:image];
           
       }
    }else{
        [self pickPhoto];
    }

    
}





@end
