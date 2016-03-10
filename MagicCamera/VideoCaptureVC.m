//
//  VideoCaptureVC.m
//  MagicCamera
//
//  Created by SongWentong on 3/9/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

#import "VideoCaptureVC.h"
#import "PewviewView.h"
@import AVFoundation;
@interface VideoCaptureVC ()

@property (weak, nonatomic) IBOutlet PewviewView *previewView;


@property (nonatomic) AVCaptureSession *session;
@property (nonatomic,strong) NSOperationQueue *sessionQueue;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;


@property (nonatomic) AVAuthorizationStatus authorizationStatus;
@end

@implementation VideoCaptureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.session = [[AVCaptureSession alloc] init];
    self.sessionQueue = [[NSOperationQueue alloc] init];
    self.previewView.session = _session;
    [_session startRunning];
    
    AVAuthorizationStatus authorization = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorization) {
        case AVAuthorizationStatusAuthorized:
        {
            self.authorizationStatus = AVAuthorizationStatusAuthorized;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [self.sessionQueue setSuspended:YES];
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
            {
                if (!granted) {
                    self.authorizationStatus = AVAuthorizationStatusNotDetermined;
                }
                [self.sessionQueue setSuspended:NO];
            }];
        }
            break;
            
        default:
        {
            self.authorizationStatus = AVAuthorizationStatusDenied;
        }
            break;
    }
    
    [self.sessionQueue addOperationWithBlock:^{
        if (self.authorizationStatus != AVAuthorizationStatusAuthorized ) {
            return ;
        }
        
        
        
        [self.session beginConfiguration];
        
        //---视频
        NSError *error = nil;
        AVCaptureDevice *videoDevice = [VideoCaptureVC deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        [self.session addInput:videoDeviceInput];
        
        
        //---音频
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        [self.session addInput:audioDeviceInput];
        
        [self.session commitConfiguration];
        
    }];
    
}
+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (IBAction)recordButtonPressed:(id)sender {
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
