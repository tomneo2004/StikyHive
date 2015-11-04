//
//  UserInfoEditorViewController2.m
//  StikyHive
//
//  Created by Koh Quee Boon on 19/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserInfoEditorViewController2.h"
#import "ViewControllerUtil.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"

@interface UserInfoEditorViewController2 ()

@property (nonatomic, strong) NSMutableArray *industryList;
@property (nonatomic, strong) NSMutableArray *categoryList;

@property (nonatomic, strong) NSArray *skillList;

@property (nonatomic, retain) UIPickerView *industryPickerView;
@property (nonatomic, retain) UIPickerView *categoryPickerView;


@end

@implementation UserInfoEditorViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _doneButton.layer.borderColor = [UIColor colorWithRed:19.0/255 green:152.0/255 blue:139.0/255 alpha:1.0].CGColor;
//    _joinButton.backgroundColor =   [UIColor colorWithRed:231.0/255 green:229.0/255 blue:231.0/255 alpha:1.0];
    _skillLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:22];
    _industryLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    _hobbyLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:22];
    _categoryLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    
    [self setTextFields:@[_skillTextField, _industryTextField, _hobbyTextField, _categoryTextField]];
    
    //_industryTextField:[NSNumber numberWithInteger:-90],
    
    NSDictionary *animateDists = @{_hobbyTextField:[NSNumber numberWithInteger:-70],
                                   _categoryTextField:[NSNumber numberWithInteger:-70]};
    [self setAnimateDistances:animateDists];
    
    
    // create industry picker view
    _industryPickerView = [[UIPickerView alloc] init];
    _industryPickerView.dataSource = self;
    _industryPickerView.delegate = self;
    _industryPickerView.tag = 111;
    
    [_industryTextField setInputView:_industryPickerView];
    
    
    // create category picker view
    _categoryPickerView = [[UIPickerView alloc] init];
    _categoryPickerView.dataSource = self;
    _categoryPickerView.delegate = self;
    _categoryPickerView.tag = 222;
    
    
    _industryList = [[NSMutableArray alloc] init];
    _categoryList = [[NSMutableArray alloc] init];
    
    
    NSInteger status = 1;
    [WebDataInterface getCategory:status completion:^(NSObject *obj,NSError *err)
    {
        NSDictionary *category = (NSDictionary *)obj;
        _skillList = category[@"skills"];
        
//        NSLog(@"skilllist ------ %@",_skillList);
        
        for (int i = 0; i < _skillList.count; i++) {
            
            NSString *type =[[_skillList objectAtIndex:i]valueForKey:@"type"];
            long long intType = [type integerValue];
            if (intType == 1){
                [_industryList addObject:_skillList[i]];
            }
            else if (intType == 2) {
                [_categoryList addObject:_skillList[i]];
            }
        }
        
    }];

    
    [_categoryTextField setInputView:_categoryPickerView];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView.tag == 111) {
        return 1;
    }
    else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 111) {
        return _industryList.count;
    }
    else {
        return _categoryList.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 111) {
        return _industryList[row][@"name"];
    }
    else {
        return  _categoryList[row][@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 111) {
        NSString *name = _industryList[row][@"name"];
        _industryTextField.text = name;
    }
    else {
        _categoryTextField.text = _categoryList[row][@"name"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataReceived:(NSDictionary *)dict {
    
    if (dict && dict[@"status"]) {
        NSString *statusString = dict[@"status"];
        NSString *stikyid = dict[@"stkid"];
//        NSLog(@"id --------------  %@",stikyid);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([statusString isEqualToString:@"success"]) {
                // check if image exist
                UIImage *profileImage = [LocalDataInterface retrieveProfileImage];
                
                if (profileImage == nil) {
                    NSLog(@"iamge no");
                }
                else {
                    NSLog(@"have image");
                    [self uploadImage:profileImage stikyid:stikyid];
                    
                    [WebDataInterface getImageLocation:stikyid completion:^(NSObject *obj,NSError *err)
                     {
                         [self dataReceivedImageLocation:(NSDictionary *)obj];
                     }];
                }
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please select date of birth."];
            }
        });
    }
}

- (void)dataReceivedImageLocation:(NSDictionary *)dict {
    if (dict && dict[@"status"]) {
        NSString *statusString = dict[@"status"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([statusString isEqualToString:@"success"]) {
                NSString *imageLocation = dict[@"location"];
                
//                NSString *dataHost2 = DATA_HOST_2;
                NSString *httpImageLocation = [NSString stringWithFormat:@"%@%@",DATA_HOST_2,imageLocation];
                
                NSLog(@"image location ----- %@",httpImageLocation);
            }
        });
    }
}

//////////// Upload Image ////////////////////////

- (void)uploadImage:(UIImage *)profileImage stikyid:(NSString *)stikyid {
 NSData *imageData =UIImageJPEGRepresentation(profileImage, 1.0);
 
 NSString *urlString = [NSString stringWithFormat:@"http://202.150.214.50/androidstikyhive/fileupload.php?id=%@",stikyid];
 
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setURL:[NSURL URLWithString:urlString]];
 [request setHTTPMethod:@"POST"];
 
 NSString *boundary = @"---------------------------14737809831466499882746641449";
// NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
 [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
 
 NSMutableData *body = [NSMutableData data];
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
// [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[NSData dataWithData:imageData]];
 [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [request setHTTPBody:body];
 
 [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 }
 

- (IBAction)doneButtonPressed:(id)sender {
    if (_skillTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please fill in professional skill"];
    }
    else if (_industryTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please select industry"];
    }
    else if (_hobbyTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please fill in your hobby"];
    }
    else if (_categoryTextField.text.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please select category"];
    }
    else {
        
        UserInfo *userInfo = [LocalDataInterface retrieveUserInfo];
        NSString *email = [LocalDataInterface retrieveUsername];
        NSString *pass = [LocalDataInterface retrievePassword];
        NSString *firstName = userInfo.firstName;
        NSString *surName = userInfo.lastName;
        NSString *address = userInfo.address;
        NSString *postalCode = userInfo.postalCode;
        NSString *country = userInfo.country;
        NSString *dob = userInfo.dob;
        
        
        NSString *skillname1 = _skillTextField.text;
        NSDictionary *skillObj = _industryList[[_industryPickerView selectedRowInComponent:0]];
        NSString *industryInt = skillObj[@"id"];
        //    NSInteger skillid1 = [industryInt integerValue];
        
        NSString *skilltype1 = @"1";
        NSString *talentname1 = _hobbyTextField.text;
        NSString *categoryid = _categoryList[[_categoryPickerView selectedRowInComponent:0]][@"id"];
        //    NSInteger talentid1 = [categoryid integerValue];
        //    NSInteger *talentid1 = 2;
        NSString * talenttype1 = @"2";
        
        //    NSLog(@"iddf ----- %d",skillid1);
        //    NSLog(@"iddf ----- %d",talentid1);
        
//        NSLog(@"email : ---- %@",email);
//        NSLog(@"pass : ----- %@",pass);
//        NSLog(@"firstname ----- %@",firstName);
//        NSLog(@"lastname ----- %@",surName);
//        NSLog(@"address ----- %@",address);
//        NSLog(@"postalcode ----- %@",postalCode);
//        NSLog(@"country ----- %@",country);
//        NSLog(@"dob ----- %@",dob);
//        NSLog(@"skillname ----- %@",skillname1);
//        NSLog(@"skillid ----- %@",industryInt);
//        NSLog(@"skilltype ----- %@",skilltype1);
//        NSLog(@"talentname ----- %@",talentname1);
//        NSLog(@"talentid ----- %@",categoryid);
//        NSLog(@"talentype ----- %@",talenttype1);
        
        [WebDataInterface saveStikyBeeInfo:email password:pass firstname:firstName lastname:surName dob:dob address:address country:country postalcode:postalCode skillname1:skillname1 skillid1:industryInt skilltype1:skilltype1 talentname1:talentname1 talentid1:categoryid talenttype1:talenttype1 completion:^(NSObject *obj,NSError *err)
         {
//             NSLog(@"obj ----- %@",obj);
             [self dataReceived:(NSDictionary *)obj];
         }];
        
        //    [WebDataInterface saveStikyBee:email password:pass firstname:firstName lastname:surName dob:dob address:address country:country postalcode:postalCode skillname:skillname1 skillid:skillid1 skilltype1:skilltype1 talentname:talentname1 talentid:talentid1 talenttype:talenttype1 completion:^(NSObject *obj,NSError *err){
        //        [self dataReceived:(NSDictionary *)obj];
        //    }];

    }
}
@end
