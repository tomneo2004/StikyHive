//
//  UserInfoEditorViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 2/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserInfoEditorViewController.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"

@interface UserInfoEditorViewController ()

@property (nonatomic, strong) NSArray *countryList;
//@property (nonatomic, strong) NSArray *skillList;
//@property (nonatomic, strong) NSArray *categoryList;
@property (nonatomic, assign) BOOL imageSelected;
@property (nonatomic, strong) NSString *countryISO;


@end

@implementation UserInfoEditorViewController

UIDatePicker *datePicker;
UIPickerView *countryPickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    _dateTextField.delegate = self;
    _givenNameTextField.delegate = self;
    
    _nextButton.layer.borderColor = [UIColor colorWithRed:19.0/255 green:152.0/255 blue:139.0/255 alpha:1.0].CGColor;
    
    _givenNameLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    _surnameLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    _dobLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    _addressLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    _countryLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    _postalCodeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50,50, self.view.frame.size.width, 1)];
    //    lineView.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:lineView];
    
    
    // create datePicker
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [_dateTextField setInputView:datePicker];
    
    //dismissDatePicker
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisDatePicker)];
    [self.view addGestureRecognizer:tap];
    
    // create country picker view
    countryPickerView = [[UIPickerView alloc] init];
    countryPickerView.delegate = self;
    countryPickerView.dataSource = self;
    
    
//    NSArray *countries = [LocalDataInterface retrieveAllCountry];
    /////////////////
    
    NSInteger status = 1;
    [WebDataInterface getCountry:status completion:^(NSObject *obj,NSError *err)
     {
         NSDictionary *contry = (NSDictionary *)obj;
         _countryList = contry[@"countries"];
         
     }];
    
    
    [_countryTextField setInputView:countryPickerView];
    
    
    [self setTextFields:@[_givenNameTextField,_surnameTextField,_addressTextField,_pstalCodeTextField, _countryTextField]];
    NSDictionary *animateDists = @{_givenNameTextField:[NSNumber numberWithInteger:-100],
                                   _surnameTextField:[NSNumber numberWithInteger:-100],
                                   _addressTextField:[NSNumber numberWithInteger:-130],
                                   _pstalCodeTextField:[NSNumber numberWithInteger:-150],
                                   _countryTextField:[NSNumber numberWithInteger:-130]};
    [self setAnimateDistances:animateDists];
    
    SEL selImage = @selector(tapImageDetected:);
    [_profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:selImage]];
    [_profileImageView setUserInteractionEnabled:YES];

}

/// set navigation
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
}

// dismiss keyboard by touch anywhere -- works on all the components in the UIView for all UITextField
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dismisDatePicker {
    [_dateTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_givenNameTextField resignFirstResponder];
    return YES;
}

// poto image
- (void)tapImageDetected:(UITapGestureRecognizer *)tapGestureRecognizer {
    _imageSelected = YES;
    
    //    [self showImagePickerForImageView:_profileImageView];
    
    [self showCropViewControllerWithOptions:_profileImageView andType:1];
}


// update date textfield from datePicker
-(void) updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker *)_dateTextField.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd-MM-YYYY"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _dateTextField.text = [NSString stringWithFormat:@"%@",dateString];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _countryList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return  _countryList[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _countryISO = _countryList[row][@"iso"];
    _countryTextField.text = _countryList[row][@"name"];
}

//////////// Image ////////////////////////
/*
 - (void)uploadImage {
 NSData *imageData = _imageSelected ? UIImageJPEGRepresentation(_profileImageView.image, 1.0) : nil;
 
 NSString *urlString = [NSString stringWithFormat:@"http://202.150.214.50/androidstikyhive/fileupload.php?id=1"];
 
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setURL:[NSURL URLWithString:urlString]];
 [request setHTTPMethod:@"POST"];
 
 NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
 [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
 
 NSMutableData *body = [NSMutableData data];
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[NSData dataWithData:imageData]];
 [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [request setHTTPBody:body];
 
 [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 
 }
 */

- (UserInfo *)extractUserProfile
{
    NSCharacterSet *whiteChars = [NSCharacterSet whitespaceCharacterSet];
    UserInfo *userInfo = [LocalDataInterface retrieveUserInfo];
    userInfo = userInfo ? userInfo : [[UserInfo alloc] init];
    userInfo.firstName = [_givenNameTextField.text stringByTrimmingCharactersInSet:whiteChars];
    userInfo.lastName = [_surnameTextField.text stringByTrimmingCharactersInSet:whiteChars];
    userInfo.address = [_addressTextField.text stringByTrimmingCharactersInSet:whiteChars];
    //    userInfo.address2 = [_addressLine2TextField.text stringByTrimmingCharactersInSet:whiteChars];
    userInfo.postalCode = [_pstalCodeTextField.text stringByTrimmingCharactersInSet:whiteChars];
    //    NSDictionary *countryly = [_countryList objectAtIndex:[countryPickerView selectedRowInComponent:0]];
    userInfo.country = _countryISO;
    //    userInfo.desc = [_descWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    //    userInfo.country = _countryList[[_countryPicker selectedRowInComponent:0]][@"iso"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = datePicker.date;
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    //    NSString *dateString = [dateFormat stringFromDate:eventDate];
    
    userInfo.dob = dateString;
    //    userInfo.dob = _dobDatePicker.date;
    NSString *timeStamp = [ViewControllerUtil getCurrentDateTimeWithFormat:@"YYYY-MM-dd"];
    userInfo.profilePicture = [NSString stringWithFormat:@"%@.jpg",timeStamp];
    
    [LocalDataInterface storeUserInfo:userInfo];
    
    return userInfo;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonPressed:(id)sender {
    
    UserInfo *userInfo = [self extractUserProfile];
    
    if (_givenNameTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please fill in first name."];
    }
    else if (_surnameTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please fill in surname."];
    }
    else if (_dateTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please select date of birth."];
    }
    else if (_addressTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please fill in address."];
    }
    else if (_countryTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please select country."];
    }
    else if (_pstalCodeTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please fill in postal code."];
    }
    else {
        
        [LocalDataInterface storeUserInfo:userInfo];
        
//        UIImage *profileImage = [LocalDataInterface retrieveProfileImage];
        if (_imageSelected) {
            UIImage *proimage =_profileImageView.image;
            
            [LocalDataInterface storeProfileImage:proimage];
            NSLog(@"------%@",proimage);
        }
        
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_info_editor_view_controller2"];
        [self.navigationController pushViewController:vc animated:YES];
        
        //        [self uploadImage];
    }
    

}
@end
