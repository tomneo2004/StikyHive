//
//  SellingViewController2.m
//  StikyHive
//
//  Created by THV1WP15S on 23/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController2.h"
#import "ViewControllerUtil.h"
#import "SellingViewController3.h"
#import "SellingViewController33.h"
#import "SellingManager.h"
#import "SellingTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+RNActivityView.h"

@interface SellingViewController2 ()

@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, strong) UIImageView *secondVideo;
@property (nonatomic, strong) NSData *secondData;
@property (nonatomic, weak) UIImageView *videoImageViewTap;

@end

@implementation SellingViewController2

static NSMutableDictionary *Skill_Info;



//+ (UIViewController *)instantiateForInfo:(NSDictionary *)skillInfo
//{
//    Skill_Info = skillInfo.mutableCopy;
//    return [ViewControllerUtil instantiateViewController:@"selling_view_controller_2"];
//}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Start Selling";
    
//    NSLog(@"skill info ---- %@",Skill_Info);
    
    
    [_videoImageView setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer *tapVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoImageViewTapped:)];
    
    [_videoImageView addGestureRecognizer:tapVideo];
    

    
    BOOL videoStatus = [SellingManager sharedSellingManager].videoStatus;
    if (videoStatus)
    {
        _secondVideo = [[UIImageView alloc] initWithFrame:CGRectMake(_videoImageView.frame.origin.x, _videoImageView.frame.origin.y+_videoImageView.frame.size.height +120, 240, 145)];
        CGPoint center = _secondVideo.center;
        center.x = self.view.center.x;
        _secondVideo.center = center;
        
        [_secondVideo setUserInteractionEnabled:YES];
        _secondVideo.image = [UIImage imageNamed:@"sell_upload_video"];
        [self.view addSubview:_secondVideo];
        
        [_secondVideo addGestureRecognizer:tapVideo];
        
        CGRect labelFrame = _recommLabel.frame;
        labelFrame.origin.y = _secondVideo.frame.origin.y + _secondVideo.frame.size.height + 120;
        _recommLabel.frame = labelFrame;
        
    }

    
    
}

- (void)displaySecondVideo{
    
    UITapGestureRecognizer *tapVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoImageViewTapped:)];
    
    _secondVideo = [[UIImageView alloc] initWithFrame:CGRectMake(_videoImageView.frame.origin.x, _videoImageView.frame.origin.y+_videoImageView.frame.size.height +120, 240, 145)];
    CGPoint center = _secondVideo.center;
    center.x = self.view.center.x;
    _secondVideo.center = center;
    
    [_secondVideo setUserInteractionEnabled:YES];
    _secondVideo.image = [UIImage imageNamed:@"sell_upload_video"];
    [self.view addSubview:_secondVideo];
    
    [_secondVideo addGestureRecognizer:tapVideo];
    
    CGRect labelFrame = _recommLabel.frame;
    labelFrame.origin.y = _secondVideo.frame.origin.y + _secondVideo.frame.size.height + 120;
    _recommLabel.frame = labelFrame;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    int selfCount = 0;
    
    for(UIViewController *controller in self.navigationController.viewControllers){
        
        if([controller isKindOfClass:[SellingViewController2 class]])
            selfCount++;
    }
    
    //user change subscription plan
    if(selfCount >= 2){
        
        return;
    }
    
    //on edit skill
    if(_mySkillInfo){
        
        [self.view showActivityViewWithLabel:@"Fetching data..."];
       [WebDataInterface getSkillById:_mySkillInfo.skillId stkid:_mySkillInfo.stkId completion:^(NSObject *obj, NSError *error) {
           
           dispatch_async(dispatch_get_main_queue(), ^{
           
               if(error != nil){
                   
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can not get data" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                   [alert show];
                   
                   [self.view hideActivityView];
                   
               }
               else{
                   
                   
                   NSDictionary *dic = (NSDictionary *)obj;
                   NSArray *arr = dic[@"resultVideo"];
                   
                   if(arr.count<=0)
                       [self.view hideActivityView];
                   
                   int i=1;
                   for(NSDictionary *data in arr){
                       
                       if(i == 1){
                           
                           [SellingManager sharedSellingManager].videoEdit = YES;
                           [SellingManager sharedSellingManager].videoId = [data[@"id"] integerValue];
                           
                           __weak SellingViewController2 * weakSelf = self;
                           __weak UIImageView *weakImageView = _videoImageView;
                           [_videoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[WebDataInterface getFullUrlPath:data[@"thumbnailLocation"]]]] placeholderImage:[UIImage imageNamed:@"sell_upload_video"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                               
                               weakImageView.image = nil;
                               weakImageView.image = image;
                               
                               [weakSelf.view hideActivityView];
                               
                           } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                               
                               [weakSelf.view hideActivityView];
                           }];
                       }
                       
                       if(i == 2){
                           
                           [SellingManager sharedSellingManager].videoStatus = YES;
                           
                           if(_secondVideo == nil)
                               [self displaySecondVideo];
                           
                           [SellingManager sharedSellingManager].secVideoEdit = YES;
                           [SellingManager sharedSellingManager].secVideoId = [data[@"id"] integerValue];
                           
                           __weak SellingViewController2 * weakSelf = self;
                           __weak UIImageView *weakImageView = _secondVideo;
                           [_videoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[WebDataInterface getFullUrlPath:data[@"thumbnailLocation"]]]] placeholderImage:[UIImage imageNamed:@"sell_upload_video"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                               
                               weakImageView.image = nil;
                               weakImageView.image = image;
                               
                               [weakSelf.view hideActivityView];
                               
                           } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                               
                               [weakSelf.view hideActivityView];
                           }];
                       
                       }
                       
                       i++;
                   }
               }
           });
       }];
    }
    
}


- (void)videoImageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    _videoImageViewTap = _videoImageView;
    [self showVideoPicker];
}

- (void)secondImageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    _videoImageViewTap = _secondVideo;
    [self showVideoPicker];
}


- (void)showVideoPicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"select video source" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"photo library", nil];
        [alert show];
        
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoMaximumDuration = MAX_VIDEO_DURATION_DEFAULT;
        //    picker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
        picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        [self presentViewController:picker animated:YES completion:NULL];
        NSString *msg = @"Please record in landscape mode to ensure your video is not distorted.";
        [ViewControllerUtil showAlertWithTitle:@"" andMessage:msg];
 
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        [self presentModalViewController:picker animated:YES];
        
    }
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoMaximumDuration = MAX_VIDEO_DURATION_DEFAULT;
        //    picker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
        picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        [self presentViewController:picker animated:YES completion:NULL];
        NSString *msg = @"Please record in landscape mode to ensure your video is not distorted.";
        [ViewControllerUtil showAlertWithTitle:@"" andMessage:msg];    }
    else if (buttonIndex == 2)
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];

    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.videoURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.videoController = [[MPMoviePlayerController alloc] init];
    [self.videoController setContentURL:self.videoURL];
    
    if (self.videoController.contentURL) {
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mov"];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSURL *tempUrl = [NSURL fileURLWithPath:filePath];
        [self convertVideoToLowQuailtyWithInputURL:self.videoController.contentURL outputURL:tempUrl handler:^(AVAssetExportSession *session) {
            NSData *reduceData = [NSData dataWithContentsOfURL:tempUrl];
            
            if(_videoImageViewTap != nil){
                
                if(_videoImageViewTap == _videoImageView){
                    
                    _videoData = reduceData;
                }
                
                if(_videoImageViewTap == _secondVideo){
                    
                    _secondData = reduceData;
                }
                
            }
            
            
            
            
            [self storeAndShowThumbnailFromVideoURL:tempUrl];
            
        }];
        
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)videoPlayBackDidFinish:(NSNotification *)notification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
}




- (void)storeAndShowThumbnailFromVideoURL:(NSURL *)url
{
    CMTime thumbTime = CMTimeMakeWithSeconds(VIDEO_THUMBNAIL_TIME_SEC,VIDEO_THUMBNAIL_TIME_SEC);
    NSArray *array = [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]];
    CGSize thumbSize = _videoImageView.frame.size;
    
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    generator.maximumSize = CGSizeMake(thumbSize.width, thumbSize.height);
    
    AVAssetImageGeneratorCompletionHandler handler =
    ^(CMTime requestedTime, CGImageRef img, CMTime actualTime,
      AVAssetImageGeneratorResult result, NSError *error)
    {
        if (result != AVAssetImageGeneratorSucceeded)
        {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
            _videoImageViewTap = nil;
        }
        else
        {
            CGSize thumbSize = CGSizeMake(VIDEO_THUMBNAIL_WIDTH, VIDEO_THUMBNAIL_HEIGHT);
            UIImage *image = [[UIImage alloc] initWithCGImage:img];
            image = [ViewControllerUtil imageWithImage:image scaledToSize:thumbSize];
            NSData *data = UIImageJPEGRepresentation (image,1.0);
            
            
//            [LocalDataInterface storeVideoThumb1:data];
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                if(_videoImageViewTap != nil){
                    
                    if(_videoImageViewTap == _videoImageView){
                        
                        _videoImageView.image = nil;
                        _videoImageView.image = image;
                    }
                    
                    if(_videoImageViewTap == _secondVideo){
                        
                        _secondVideo.image = nil;
                        _secondVideo.image = image;
                    }
                    
                    _videoImageViewTap = nil;
                }
                
                
            });
        }
    };
    [generator generateCGImagesAsynchronouslyForTimes:array completionHandler:handler];
}

- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                           initWithAsset:asset presetName:VIDEO_OUTPUT_QUALITY];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {handler(exportSession);}];
}


- (IBAction)nextButton:(id)sender
{
    
//    UIImage *img = _videoImageView.image;
//    UIViewController *vc = [SellingViewController3 instantiateForInfo:Skill_Info videoThumb:img andVideodata:_videoData];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
//    UIImage *img = _videoImageView.image;
//    UIViewController *vc = [SellingViewController33 instantiateForInfo:Skill_Info videoThumb:img andVideodata:_videoData];
    
    [SellingManager sharedSellingManager].videoImage = _videoImageView.image;
    [SellingManager sharedSellingManager].video = _videoData;
    [SellingManager sharedSellingManager].secVideoImage = _secondVideo.image;
    [SellingManager sharedSellingManager].secVideo = _secondData;
    
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_table_view_controller"];
    SellingTableViewController *sv = (SellingTableViewController *)vc;
    sv.mySkillInfo = _mySkillInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
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
