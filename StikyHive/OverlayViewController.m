//
//  OverlayViewController.m
//  StikyHive
//
//  Created by User on 9/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "OverlayViewController.h"

@interface OverlayViewController ()

@end

@implementation OverlayViewController{
    
    UIWindow *_window;
    dismissComplete dismissCallBack;
    didPresentView presentCallBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public interface
- (void)presentOverlay:(didPresentView)presentComplete{
    
    presentCallBack = presentComplete;
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    UIView *parentView;
    
    if(windows.count > 0)
    {
        _window = [windows objectAtIndex:0];
        //keep the first subview
        if(_window.subviews.count > 0)
        {
            parentView = [_window.subviews lastObject];
            [parentView addSubview:self.view];
            
            self.view.frame = CGRectMake(0, 20.0f, parentView.frame.size.width, parentView.frame.size.height-20.0f);
            
            presentCallBack(self);
            
            [self didAddView];
        }
        
    }

}

- (void)dismissOverlay:(dismissComplete)complete;{
    
    dismissCallBack = complete;
    
    [self.view removeFromSuperview];
    
    dismissCallBack();
}

- (void)didAddView{
    
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
