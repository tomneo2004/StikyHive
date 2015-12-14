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
@property (weak, nonatomic) IBOutlet UIButton *dobBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTextField;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;


@end

@implementation EditProfileTableViewController{
    
    NSMutableArray *_countryInfos;
    BOOL _circleImage;
    NSDateFormatter *_dateformatter;

    
    //current user day of birth
    NSDate *_userDOB;
    
    //current country index
    NSInteger _countryIndex;
    
    DescEditorViewController *_descViewController;
}

@synthesize avatarImageView = _avatarImageView;
@synthesize firstnameTextField = _firstnameTextField;
@synthesize lastnameTextField = _lastnameTextField;
@synthesize dobBtn = _dobBtn;
@synthesize addressTextField = _addressTextField;
@synthesize countryBtn = _countryBtn;
@synthesize postalCodeTextField = _postalCodeTextField;
@synthesize descriptionWebView = _descriptionWebView;
@synthesize navigationController = _navigationController;
@synthesize delegate = _delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dateformatter = [[NSDateFormatter alloc]init];
    [_dateformatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDescriptionTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    tap.delegate = self;
    [_descriptionWebView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllInputField)];
    [dismissTap setNumberOfTapsRequired:1];
    [dismissTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:dismissTap];
    
    
    _circleImage = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_circleImage){
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [_avatarImageView addGestureRecognizer:tap];
        
        //make person's profile picture circle
        _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.userInteractionEnabled = YES;
        
        _circleImage = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - public interface
- (void)startPullingData{
    
    [self pullData];
}

#pragma mark - internal
- (void)pullData{
    
    if([_delegate respondsToSelector:@selector(beginPullingData:)]){
        
        [_delegate beginPullingData:self];
    }
    
    [WebDataInterface getCountry:1 completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                //tell delegate pull data fail
                if([_delegate respondsToSelector:@selector(PullingDataFail:)]){
                    
                    [_delegate PullingDataFail:self];
                }
                
                return;
            }
            
            NSDictionary *dic = (NSDictionary *)obj;
            
            _countryInfos = [[NSMutableArray alloc] init];
            
            for(NSDictionary *data in dic[@"countries"]){
                
                CountryInfo *info = [CountryInfo createCountryInfoFromDictionary:data];
                
                [_countryInfos addObject:info];
            }
            
            [WebDataInterface getStikyBeeInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    if(error != nil){
                        
                        //tell delegate pull data fail
                        if([_delegate respondsToSelector:@selector(PullingDataFail:)]){
                            
                            [_delegate PullingDataFail:self];
                        }
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
                    [_dateformatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    _userDOB = [_dateformatter dateFromString:infoDic[@"dob"]];
                    [_dateformatter setDateFormat:@"MMM-dd-yyyy"];
                    [_dobBtn setTitle:[_dateformatter stringFromDate:_userDOB] forState:UIControlStateNormal];
                    
                    
                    //address
                    if(![infoDic[@"address1"] isEqual:[NSNull null]])
                        _addressTextField.text = infoDic[@"address1"];
                    
                    //country
                    CountryInfo *cInfo = [self countryInfoByISO:infoDic[@"countryISO"]];
                    if(cInfo != nil){
                        
                        _countryIndex = [_countryInfos indexOfObject:cInfo];
                        [_countryBtn setTitle:cInfo.countryName forState:UIControlStateNormal];
                    }
                    else{
                        
                        _countryIndex = 0;
                        [_countryBtn setTitle:@"Unknow" forState:UIControlStateNormal];
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
                    
                    if([_delegate respondsToSelector:@selector(PullingDataSuccessful:)]){
                        
                        [_delegate PullingDataSuccessful:self];
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

- (NSArray *)allCountriesName{
    
    if(_countryInfos != nil){
    
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for(CountryInfo *info in _countryInfos){
            
            [arr addObject:info.countryName];
        }
        
        return arr;
    }
    
    return nil;
}

- (void)onDescriptionTap:(UIGestureRecognizer *)recognizer{
    
    _descViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DescEditorViewController"];
    _descViewController.htmlText = [_descriptionWebView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    _descViewController.delegate = self;
    [_navigationController pushViewController:_descViewController animated:YES];
}

- (void)dismissAllInputField{
    
    [_firstnameTextField resignFirstResponder];
    [_lastnameTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_postalCodeTextField resignFirstResponder];
}

- (void)changeImage{
    
    [self dismissAllInputField];
    
    if([_delegate respondsToSelector:@selector(didTapAvatarImage:)]){
        
        [_delegate didTapAvatarImage:_avatarImageView];
        
       
    }
}

- (NSString *)convertHtmlToServer:html{
    
    return [html stringByReplacingOccurrencesOfString:@"style=\"background-color:" withString:@"stile=\"background-color:"];
}

#pragma mark - DescEditorViewController delegate
- (void)didFinishEditingWithHtmlText:(NSString *)htmlText{
    
    [_descriptionWebView loadHTMLString:htmlText baseURL:nil];
}

#pragma mark - IBAction
- (IBAction)updateProfile:(id)sender{
    
    if(_firstnameTextField.text == nil || _firstnameTextField.text.length <= 0){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your first name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    if(_lastnameTextField.text == nil || _lastnameTextField.text.length <= 0){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    if(_addressTextField.text == nil || _addressTextField.text.length <= 0){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    if(_postalCodeTextField.text == nil || _postalCodeTextField.text.length <= 0){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your postal code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [_dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *countryISO = ((CountryInfo *)[_countryInfos objectAtIndex:_countryIndex]).countryISO;
    
    if([_delegate respondsToSelector:@selector(beginUpdateProfile:)]){
        
        [_delegate beginUpdateProfile:self];
    }
    
    [WebDataInterface updateProfile:[LocalDataInterface retrieveStkid] fname:_firstnameTextField.text lname:_lastnameTextField.text description:[self convertHtmlToServer:[_descriptionWebView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"]] dob:[_dateformatter stringFromDate:_userDOB] address:_addressTextField.text countryISO:countryISO postalcode:_postalCodeTextField.text completion:^(NSObject *obj, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(error != nil){
                
                //tell delegate update profile fail
                if([_delegate respondsToSelector:@selector(updateProfileFail:)]){
                    
                    [_delegate updateProfileFail:self];
                }
                
                return;
            }
            
            [WebDataInterface profileImageUpload:_avatarImageView.image stikyid:[LocalDataInterface retrieveStkid]];
            
            //tell delegate upload profile successful
            if([_delegate respondsToSelector:@selector(updateProfileSuccessful:)]){
                
                [_delegate updateProfileSuccessful:self];
            }
        });
        
    }];
}

- (IBAction)dobTap:(id)sender{
    
    [self dismissAllInputField];
    
    [ActionSheetDatePicker showPickerWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:_userDOB doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        
        _userDOB = selectedDate;
        
        [_dateformatter setDateFormat:@"MMM-dd-yyyy"];
        
        [_dobBtn setTitle:[_dateformatter stringFromDate:_userDOB] forState:UIControlStateNormal];
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
        
    } origin:sender];
    
}

- (IBAction)countryTap:(id)sender{
    
    [self dismissAllInputField];
    
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:[self allCountriesName] initialSelection:_countryIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        _countryIndex = selectedIndex;
        
        [_countryBtn setTitle:selectedValue forState:UIControlStateNormal];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
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



#pragma mark - UITableView deleagate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
