//
//  PostCommentViewController.m
//  StikyHive
//
//  Created by User on 21/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "PostCommentViewController.h"
#import "UIView+RNActivityView.h"

@interface PostCommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PostCommentViewController

@synthesize textView = _textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal
- (void)onTap:(UIGestureRecognizer *)recognizer{
    
    [_textView resignFirstResponder];
}

#pragma mark - IBAction
- (IBAction)close:(id)sender{
    
    [self dismissOverlay:^{
        
        if([_delegate respondsToSelector:@selector(onPostCommentClose)]){
            
            [_delegate onPostCommentClose];
        }
        
    }];
}

- (IBAction)submit:(id)sender{
    
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
