//
//  PDFViewController.m
//  StikyHive
//
//  Created by User on 2/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation PDFViewController

@synthesize webView = _webView;
@synthesize pdfURL = _pdfURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self showPdf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPdf{
    
    if(_pdfURL == nil){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to show pdf file" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_pdfURL];
    
    [_webView loadRequest:request];
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
