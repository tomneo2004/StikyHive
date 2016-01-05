//
//  EditEducationTableViewController.m
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "EditEducationTableViewController.h"
#import "UIView+RNActivityView.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "CountryInfo.h"

@interface EditEducationTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *instituteTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UITextField *qualificationTextField;
@property (weak, nonatomic) IBOutlet UIButton *fromDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *toDateBtn;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation EditEducationTableViewController{
    
    BOOL _shouldPullData;
    BOOL _isEditing;
    NSDateFormatter *_dateFormatter;
    NSMutableArray *_countryInfos;
    NSDate *_fromDate;
    NSDate *_toDate;
    NSInteger _countryIndex;
    UIAlertView *_toDateEarlyAlert;
    UIAlertView *_fromDateLateAlert;
    id _lastSender;
}

@synthesize instituteTextField = _instituteTextField;
@synthesize countryBtn = _countryBtn;
@synthesize qualificationTextField = _qualificationTextField;
@synthesize fromDateBtn = _fromDateBtn;
@synthesize toDateBtn = _toDateBtn;
@synthesize infoWebView = _infoWebView;
@synthesize submitBtn = _submitBtn;
@synthesize eduInfo = _eduInfo;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"dd MMM yyyy"];
    _shouldPullData = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_eduInfo != nil){
        
        self.title = @"Update Education";
    }
    else{
        
        self.title = @"Add Education";
    }
    
    if(_shouldPullData)
        [self pullData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal
- (void)pullData{
    
    [self.view showActivityViewWithLabel:@"Loading..." detailLabel:@"Fetching country data"];
    [WebDataInterface getCountry:1 completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get country data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                _countryInfos = [[NSMutableArray alloc] init];
                
                for(NSDictionary *data in dic[@"countries"]){
                    
                    CountryInfo *info = [CountryInfo createCountryInfoFromDictionary:data];
                    
                    [_countryInfos addObject:info];
                }

                if(_eduInfo != nil){
                    
                    [self becomeEditingMode];
                }
                else{
                    
                    [self becomeAddingMode];
                }
                
                [self.view hideActivityView];
                
                _shouldPullData = NO;
                
                return;
            }
            
            [self.view hideActivityView];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

- (void)becomeEditingMode{
    
    _isEditing = YES;
    
    _instituteTextField.text = _eduInfo.institute;
    
    _countryIndex = [_countryInfos indexOfObject:[self countryInfoByISO:_eduInfo.countryISO]];
    [_countryBtn setTitle:_eduInfo.countryName forState:UIControlStateNormal];
    
    _qualificationTextField.text = _eduInfo.qualification;
    
    [_infoWebView loadHTMLString:_eduInfo.otherInfo baseURL:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEditAdditionInfo:)];
    tap.delegate =self;
    [_infoWebView addGestureRecognizer:tap];
    
    _fromDate = _eduInfo.fromDate;
    [_fromDateBtn setTitle:[_dateFormatter stringFromDate:_fromDate] forState:UIControlStateNormal];
    
    _toDate = _eduInfo.toDate;
    [_toDateBtn setTitle:[_dateFormatter stringFromDate:_toDate] forState:UIControlStateNormal];
    
    
    [_submitBtn setTitle:@"Update" forState:UIControlStateNormal];
    
}

- (void)becomeAddingMode{
    
    _isEditing = NO;
    
    _countryIndex = -1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEditAdditionInfo:)];
    tap.delegate = self;
    [_infoWebView addGestureRecognizer:tap];
    
    [_submitBtn setTitle:@"Save" forState:UIControlStateNormal];
}

- (void)onEditAdditionInfo:(UIGestureRecognizer *)recognizer{
    
    OtherInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherInfoViewController"];
    controller.htmlText = [_infoWebView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)dismissAllInputField{
    
    [_instituteTextField resignFirstResponder];
    [_qualificationTextField resignFirstResponder];
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

- (BOOL)validateInfo{
    
    if([_instituteTextField.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill Institute field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    
    if(_countryIndex < 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select your country" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    
    if([_qualificationTextField.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill Qualification field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    
    if(_fromDate == nil){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select \"From Date\"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    
    if(_toDate == nil){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select \"To Date\"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    
    
    return YES;
}

#pragma mark - override
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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

#pragma mark - IBAction
- (IBAction)submit:(id)sender{
    
    if([self validateInfo]){
        
        if(_isEditing){
            
            //ToDo: update education info
        }
        else{
            
            //ToDo: add education info
        }
    }
}

- (IBAction)onCountryTap:(id)sender{
    
    [self dismissAllInputField];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Country" rows:[self allCountriesName] initialSelection:_countryIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        _countryIndex = selectedIndex;
        
        [_countryBtn setTitle:selectedValue forState:UIControlStateNormal];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (IBAction)onFromDateTap:(id)sender{
    
    [self dismissAllInputField];
    
    if(_isEditing){
        
        [ActionSheetDatePicker showPickerWithTitle:@"From Date" datePickerMode:UIDatePickerModeDate selectedDate:_fromDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            
            //if to date is earlier than selected date
            if(_toDate != nil && [_toDate compare:selectedDate] == NSOrderedAscending){
                
                _toDateEarlyAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"\"From Date\" have to be earlier than \"To Date\"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [_toDateEarlyAlert show];
                _fromDateLateAlert = nil;
                _lastSender = sender;
                
                
                return;
            }
            
            _fromDate = selectedDate;
            [_fromDateBtn setTitle:[_dateFormatter stringFromDate:_fromDate] forState:UIControlStateNormal];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:sender];
    }
    else{
        
        [ActionSheetDatePicker showPickerWithTitle:@"From Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            
            //if to date is earlier than selected date
            if(_toDate != nil && [_toDate compare:selectedDate] == NSOrderedAscending){
                
                _toDateEarlyAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"\"From Date\" have to be earlier than \"To Date\"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [_toDateEarlyAlert show];
                _fromDateLateAlert = nil;
                _lastSender = sender;
                

                
                return;
            }
            
            _fromDate = selectedDate;
            [_fromDateBtn setTitle:[_dateFormatter stringFromDate:_fromDate] forState:UIControlStateNormal];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:sender];
    }
    
}

- (IBAction)onToDateTap:(id)sender{
    
    [self dismissAllInputField];
    
    if(_isEditing){
        
        [ActionSheetDatePicker showPickerWithTitle:@"To Date" datePickerMode:UIDatePickerModeDate selectedDate:_toDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            
            //if from date is later than selected date
            if(_fromDate != nil && [_fromDate compare:selectedDate] == NSOrderedDescending){
                
                _fromDateLateAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"\"To Date\" have to later than \"From Date\"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [_fromDateLateAlert show];
                _toDateEarlyAlert = nil;
                _lastSender =sender;
                

                
                return;
            }
            
            _toDate = selectedDate;
            [_toDateBtn setTitle:[_dateFormatter stringFromDate:_toDate] forState:UIControlStateNormal];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:sender];
    }
    else{
        
        [ActionSheetDatePicker showPickerWithTitle:@"To Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            
            //if from date is later than selected date
            if(_fromDate != nil && [_fromDate compare:selectedDate] == NSOrderedDescending){
                
                _fromDateLateAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"\"To Date\" have to later than \"From Date\"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [_fromDateLateAlert show];
                _toDateEarlyAlert = nil;
                _lastSender = sender;
                
                
                return;
            }
            
            _toDate = selectedDate;
            [_toDateBtn setTitle:[_dateFormatter stringFromDate:_toDate] forState:UIControlStateNormal];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:sender];
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - OtherInfoViewController delegate
- (void)didFinishEditingWithHtmlText:(NSString *)htmlText{
    
    [_infoWebView loadHTMLString:htmlText baseURL:nil];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(_toDateEarlyAlert){
        
        _toDateEarlyAlert = nil;
        
        [self onFromDateTap:_lastSender];
    }
    else if(_fromDateLateAlert){
        
        _fromDateLateAlert = nil;
        
        [self onToDateTap:_lastSender];
    }
}

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
