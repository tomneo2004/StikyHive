//
//  PrepareRequestTableViewController.m
//  StikyHive
//
//  Created by User on 25/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "PrepareRequestTableViewController.h"

@interface PrepareRequestTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *titleChaLimitLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *descChaLimitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *postRequestImageView;

@end

@implementation PrepareRequestTableViewController

@synthesize titleField = _titleField;
@synthesize titleChaLimitLabel = _titleChaLimitLabel;
@synthesize descTextView = _descTextView;
@synthesize descChaLimitLabel = _descChaLimitLabel;
@synthesize attachmentImageView = _attachmentImageView;
@synthesize postRequestImageView = _postRequestImageView;
@synthesize maxTitleCharacter = _maxTitleCharacter;
@synthesize maxDescCharacter = _maxDescCharacter;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _titleChaLimitLabel.text = [NSString stringWithFormat:@"%li", (unsigned long)_maxTitleCharacter];
    _descChaLimitLabel.text = [NSString stringWithFormat:@"%li", (unsigned long)_maxDescCharacter];
    _titleField.delegate = self;
    _descTextView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignInputField:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignInputField:(UIGestureRecognizer *)recognizer{
    
    [_titleField resignFirstResponder];
    [_descTextView resignFirstResponder];
}

#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger textLength = textField.text.length;
    
    if(range.length > 0){
        
        textLength = textLength - range.length + string.length;
    }
    else{
        
        textLength += string.length;
    }
    
    if(textLength > _maxTitleCharacter){
       
        [self updateTitleCharacterLimitValue:textLength];
        
        return NO;
    }
    
    [self updateTitleCharacterLimitValue:textLength];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if([_delegate respondsToSelector:@selector(onTitleDoneEdit:)]){
        
        [_delegate onTitleDoneEdit:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSUInteger textLength = textView.text.length;
    
    if(range.length > 0){
        
        textLength = textLength - range.length + text.length;
    }
    else{
        
        textLength += text.length;
    }
    
    if(textLength > _maxDescCharacter){
        
        [self updateDescCharacterLimitValue:textLength];
        
        return NO;
    }
    
    [self updateDescCharacterLimitValue:textLength];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if([_delegate respondsToSelector:@selector(onDescriptionChange:)]){
        
        [_delegate onDescriptionChange:textView.text];
    }
}

#pragma mark - internal
- (void)updateTitleCharacterLimitValue:(NSUInteger)currentTextLength{
    
    _titleChaLimitLabel.text = [NSString stringWithFormat:@"%li", (_maxTitleCharacter - MIN(currentTextLength, _maxTitleCharacter))];
}

- (void)updateDescCharacterLimitValue:(NSUInteger)currentTextLength{
 
     _descChaLimitLabel.text = [NSString stringWithFormat:@"%li", (_maxDescCharacter - MIN(currentTextLength, _maxDescCharacter))];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}
 */

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
