//
//  EditProfileTableViewController.m
//  StikyHive
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "EditProfileTableViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "CountryInfo.h"
#import "UIImageView+AFNetworking.h"


@interface EditProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTextField;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;

@end

@implementation EditProfileTableViewController{
    
    NSMutableArray *_countryInfos;
    BOOL _circleImage;
}

@synthesize avatarImageView = _avatarImageView;
@synthesize firstnameTextField = _firstnameTextField;
@synthesize lastnameTextField = _lastnameTextField;
@synthesize dobPicker = _dobPicker;
@synthesize addressTextField = _addressTextField;
@synthesize countryPicker = _countryPicker;
@synthesize postalCodeTextField = _postalCodeTextField;
@synthesize descriptionWebView = _descriptionWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _circleImage = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_circleImage){
        
        //make person's profile picture circle
        _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.userInteractionEnabled = YES;
        
        _circleImage = NO;
    }
    
    
    [self pullData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal
- (void)pullData{
    
    [WebDataInterface getCountry:1 completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                //tell delegate pull data fail
            }
            
            NSDictionary *dic = (NSDictionary *)obj;
            
            _countryInfos = [[NSMutableArray alloc] init];
            
            for(NSDictionary *data in dic[@"countries"]){
                
                CountryInfo *info = [CountryInfo createCountryInfoFromDictionary:data];
                
                [_countryInfos addObject:info];
            }
            
            [_countryPicker reloadAllComponents];
            
            [WebDataInterface getStikyBeeInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    if(error != nil){
                        
                        //tell delegate pull data fail
                    }
                    
                    NSDictionary *infoDic = ((NSDictionary *)obj)[@"stikybee"];
                    
                    //setup avatar image
                    if(![infoDic[@"profilePicture"] isEqual:[NSNull null]]){
                        
                        //get full url
                        NSString *fullURL = [WebDataInterface getFullUrlPath:infoDic[@"profilePicture"]];
                        
                        //url request
                        NSURL *requestURL = [NSURL URLWithString:fullURL];
                        
                        //start download image
                        [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:requestURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                            
                            //set image
                            _avatarImageView.image = image;
                            
                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                            
                            
                        }];
                        
                    }
                    else{
                        
                        [_avatarImageView setImage:[UIImage imageNamed:@"Default_profile_small@2x"]];
                    }
                    
                    
                    //first name
                    if(![infoDic[@"firstname"] isEqual:[NSNull null]])
                        _firstnameTextField.text = infoDic[@"firstname"];
                    else
                        _firstnameTextField.text = nil;
                    
                    //last name
                    if(![infoDic[@"lastname"] isEqual:[NSNull null]])
                        _lastnameTextField.text = infoDic[@"lastname"];
                    else
                        _lastnameTextField.text = nil;
                    
                    //day of birth
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    
                    [_dobPicker setDate:[formatter dateFromString:infoDic[@"dob"]]];
                    
                    //address
                    if(![infoDic[@"address1"] isEqual:[NSNull null]])
                        _addressTextField.text = infoDic[@"address1"];
                    
                    //country
                    CountryInfo *cInfo = [self countryInfoByISO:infoDic[@"countryISO"]];
                    if(cInfo != nil){
                        
                        [_countryPicker selectRow:[_countryInfos indexOfObject:cInfo] inComponent:0 animated:NO];
                    }
                    
                    //postal code
                    if(![infoDic[@"postalCode"] isEqual:[NSNull null]])
                        _postalCodeTextField.text = infoDic[@"postalCode"];
                    else
                        _postalCodeTextField.text = nil;
                    
                    //description
                    if(![infoDic[@"description"] isEqual:[NSNull null]]){
                        
                        [_descriptionWebView loadHTMLString:infoDic[@"description"] baseURL:nil];
                    }
                    
                });
            }];
            
        });
    }];
}

- (CountryInfo *)countryInfoByISO:(NSString *)countryISO{
    
    if(_countryInfos != nil){
        
        for(CountryInfo *info in _countryInfos){
            
            if([info.countryISO isEqualToString:countryISO]){
                
                return info;
            }
        }
    }
    
    return nil;
}

#pragma mark - IBAction
- (IBAction)updateProfile:(id)sender{
    
}

#pragma mark - UIPickerDataSource delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(_countryInfos != nil){
        
        return _countryInfos.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    CountryInfo *info = [_countryInfos objectAtIndex:row];
    
    return info.countryName;
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

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
