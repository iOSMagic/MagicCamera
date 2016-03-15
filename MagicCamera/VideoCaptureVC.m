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
@import Photos;
#import "AVSEViewController.h"
@interface VideoCaptureVC () <AVCaptureFileOutputRecordingDelegate>

@property (weak, nonatomic) IBOutlet PewviewView *previewView;


@property (nonatomic) AVCaptureSession *session;
@property (nonatomic,strong) NSOperationQueue *sessionQueue;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;


@property (nonatomic) AVAuthorizationStatus authorizationStatus;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@end

@implementation VideoCaptureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _recordButton.enabled = NO;
    self.session = [[AVCaptureSession alloc] init];
    self.sessionQueue = [[NSOperationQueue alloc] init];
    self.previewView.session = _session;
    [_session startRunning];
    
    
    [self configSession];
}

-(void)configSession
{
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
        
        _recordButton.enabled = YES;
        
        [self.session beginConfiguration];
        
        //---视频
        NSError *error = nil;
        AVCaptureDevice *videoDevice = [VideoCaptureVC deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (videoDeviceInput) {
            [self.session addInput:videoDeviceInput];
        }else{
            
        }
        
        
        
        //---音频
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if (audioDeviceInput) {
            [self.session addInput:audioDeviceInput];
        }
        [self.session commitConfiguration];
        
        
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ([self.session canAddOutput:movieFileOutput]) {
            [self.session addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            self.movieFileOutput = movieFileOutput;
        }
        
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
    [self.sessionQueue addOperationWithBlock:^{
        if (!self.movieFileOutput.isRecording) {
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                
                
                AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
                AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
                connection.videoOrientation = previewLayer.connection.videoOrientation;
                [VideoCaptureVC setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
                NSString *outputFileName = [NSProcessInfo processInfo].globallyUniqueString;
                NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
                [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
            }
        }else{
            [self.movieFileOutput stopRecording];
        }
    }];
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ( device.hasFlash && [device isFlashModeSupported:flashMode] ) {
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    dispatch_async( dispatch_get_main_queue(), ^{
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:@"停止" forState:UIControlStateNormal];
    });
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    UIBackgroundTaskIdentifier currentBackgroundRecordingID = self.backgroundRecordingID;
    self.backgroundRecordingID = UIBackgroundTaskInvalid;
    
    
    AVSEViewController *vc = [[AVSEViewController alloc] initWithNibName:@"AVSEViewController_iPad" bundle:nil];
    vc.fileURL = outputFileURL;
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    
    dispatch_block_t cleanup = ^{
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
            [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
        }
    };
    
    BOOL success = YES;
    
    if ( error ) {
        NSLog( @"Movie file finishing error: %@", error );
        success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
    }
    
    if (success) {
        
//        __block PHObjectPlaceholder *placeHolder = nil;
        
        //请求相册状态
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            //允许调用
            if (status==PHAuthorizationStatusAuthorized) {
                
                
                //准备添加一下信息
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    if ( [PHAssetResourceCreationOptions class] ) {
                        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                        options.shouldMoveFile = YES;
                        PHAssetCreationRequest *changeRequest = [PHAssetCreationRequest creationRequestForAsset];
                        [changeRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:outputFileURL options:options];
//                        placeHolder = changeRequest.placeholderForCreatedAsset;
                    }else{
                        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
//                        placeHolder = request.placeholderForCreatedAsset;
                    }
                    
                    
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    
                    if ( ! success ) {
                        NSLog( @"Could not save movie to photo library: %@", error );
                    }
                    cleanup();
                }];
            }else{
                cleanup();
            }
        }];

    }else{
        cleanup();
    }
    
    
    dispatch_async( dispatch_get_main_queue(), ^{

        
        
        
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:@"录制" forState:UIControlStateNormal];
    });
     */
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
