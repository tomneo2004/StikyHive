//
//  MakeOfferViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 17/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "MakeOfferViewController.h"
#import "WebDataInterface.h"
#import "UIView+RNActivityView.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"
//#import "ChatMessagesViewController.h"

@interface MakeOfferViewController ()

@property (nonatomic, strong) UIPickerView *skillPickeView;

@property (nonatomic, strong) NSMutableArray *skillArray;

@property (nonatomic, strong) NSDictionary *dictObj;

@property (nonatomic, assign) NSInteger status;

@end

@implementation MakeOfferViewController

@synthesize delegate = _delegate;


static NSString *ToStikyBee = nil;

+ (void)setToStikyBee:(NSString *)toStikyBee
{
    ToStikyBee = toStikyBee;
    NSLog(@"to stiky bee --- %@",ToStikyBee);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _status = 0;
    
    // Prepare for check box
    [_checkBoxBtn setImage:[UIImage imageNamed:@"uicheckbox_unchecked"] forState:UIControlStateNormal];
    [_checkBoxBtn setImage:[UIImage imageNamed:@"uicheckbox_checked"] forState:UIControlStateSelected];
    
    
    _skillPickeView = [[UIPickerView alloc] init];
    _skillPickeView.delegate = self;
    _skillPickeView.dataSource = self;
    [_skillTextField setInputView:_skillPickeView];
    
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    [WebDataInterface getSellAllMakeOffer:0 catId:0 stkid:ToStikyBee completion:^(NSObject *obj, NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"obj --- %@",obj);
            NSLog(@"err --- %@",err);
            
            NSDictionary *dict = (NSDictionary *)obj;
            
            
            _skillArray = [[NSMutableArray alloc] init];
            _skillArray = dict[@"result"];
            
            NSLog(@"skill array ------- %@",_skillArray);
            
            
            
            
            
            
            
            
            

            
            [self.view hideActivityView];
        });
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)checkBoxPressed:(id)sender
{
    
    _checkBoxBtn.selected = !_checkBoxBtn.selected;
    
}

- (IBAction)makeOfferPressed:(id)sender
{
    
    NSString *message = [NSString stringWithFormat:@"$%@ for %@ %@",_priceTextField.text,_dictObj[@"name"], _rateTextField.text];
    NSLog(@"message ----- %@",message);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"send date time %@", dateString);

    
    if (_checkBoxBtn.isSelected == YES) {
        _status = 0;
    }
    else
    {
        _status = 2;
    }
    
    
    [WebDataInterface insertOffer:_dictObj[@"skillId"] price:_priceTextField.text rate:_rateTextField.text status:_status fromStikyBee:[LocalDataInterface retrieveStkid] toStikyBee:ToStikyBee message:message createDate:dateString completion:^(NSObject *obj, NSError *err) {
        
        
        NSDictionary *dict = (NSDictionary *)obj;
        
        if ([dict[@"status"] isEqualToString:@"success"])
        {
            if ([_delegate respondsToSelector:@selector(onMakeOfferTapped:dict:)]) {
//                [_delegate onMakeOfferTapped:self ];
                
                [_delegate onMakeOfferTapped:self dict:dict];
                
                
                
            }
        }
        
        
        
//        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"message ---- %@",message);
        NSLog(@"obj --- %@",obj);
        NSLog(@"err --- %@",err);
    }];
    
    
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _skillArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return _skillArray[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _skillTextField.text = _skillArray[row][@"name"];
    
    
    if (_skillArray[row][@"thumbnailLocation"] != [NSNull null])
    {
        
        _profileImageView.image = [ViewControllerUtil getImageWithPath:[WebDataInterface getFullUrlPath:_skillArray[row][@"thumbnailLocation"]]];
        
    }
    else if (_skillArray[row][@"profilePicture"] != [NSNull null])
    {
        _profileImageView.image = [ViewControllerUtil getImageWithPath:[WebDataInterface getFullUrlPath:_skillArray[row][@"profilePicture"]]];
    }
    else
    {
        _profileImageView.image = [UIImage imageNamed:@"default_seller_post"];
    }
    
    
    _dictObj = _skillArray[row];
    NSLog(@"dict obj ---- %@",_dictObj);
    
}


#pragma mark - delegate
- (void)onMakeOfferTapped:(MakeOfferViewController *)makeOfferViewController dict:(NSDictionary *)dict
{
    NSLog(@"make offer page pop");
    
    
    
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}














@end
