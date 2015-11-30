//
//  RequestPostTableViewController.m
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "RequestPostTableViewController.h"
#import "Helper.h"
#import "UIImageView+AFNetworking.h"
#import "WebDataInterface.h"

@interface RequestPostTableViewController ()


@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation RequestPostTableViewController{
    
    UITextView *_calculateTextView;
}

@synthesize titleTextView = _titleTextView;
@synthesize descTextView = _descTextView;
@synthesize attachmentImageView = _attachmentImageView;
@synthesize avatarImageView = _avatarImageView;
@synthesize nameLabel = _nameLabel;
@synthesize webView = _webView;
@synthesize request = _request;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    self.title = @"Requester's Post";
    
    [self configureNavigationBar];
   
    if(_request == nil)
        return;
    
    //in interface builder UITextView's text field must be empty otherwise thie ViewController will not be presented and
    //freeze the screen. Another fucking annoying bug done by Apple. Fuck
    _titleTextView.text = _request.title;
    _descTextView.text = _request.desc;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _request.firstname, _request.lastname];
    
    if(_request.beeInfo != nil && ![_request.beeInfo isEqual:[NSNull null]]){
        
        [_webView loadHTMLString:_request.beeInfo baseURL:nil];
    }
    
    
    [_attachmentImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[WebDataInterface getFullUrlPath:_request.photoLocation]]] placeholderImage:[UIImage imageNamed:@"Default_buyer_post"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        _attachmentImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
    
    [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[WebDataInterface getFullUrlPath:_request.profilePicture]]] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        _avatarImageView.image = image;
        
        _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 1;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //in interface builder you have to turn off ScrollEnable, Apple make text start from the end of text view
    //by turning it off then turn in code will prevent it happen. Who the fuck is this idiot in Apple and design it like this.
    _titleTextView.scrollEnabled = YES;
    _descTextView.scrollEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_attachmentImageView cancelImageRequestOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal
- (void)configureNavigationBar{
    
    UIBarButtonItem *chatItem = [[UIBarButtonItem alloc] initWithImage:[Helper imageWithImage:[UIImage imageNamed:@"buzzr_chat"] scaledToSize:CGSizeMake(35, 35)] style:UIBarButtonItemStylePlain target:self action:@selector(buzzrChat)];
    chatItem.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    
    UIBarButtonItem *phoneItem = [[UIBarButtonItem alloc] initWithImage:[Helper imageWithImage:[UIImage imageNamed:@"buzzr_call"] scaledToSize:CGSizeMake(35, 35)] style:UIBarButtonItemStylePlain target:self action:@selector(buzzrCall)];
    phoneItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:phoneItem, chatItem, nil];


}

#pragma mark - IBAction
- (void)buzzrCall{
    
    NSLog(@"buzzr call");
}

- (void)buzzrChat{
    
    NSLog(@"buzzr chat");
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
