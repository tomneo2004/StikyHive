//
//  TextEditorViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 10/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "TextEditorViewController.h"

@interface TextEditorViewController ()

@property (nonatomic, strong) NSArray *textFields;
@property (nonatomic, strong) NSArray *textViews;
@property (nonatomic, strong) NSDictionary* animateDistances;
@property (nonatomic, strong) NSDictionary* maxCharacters;
@property (nonatomic, strong) NSDictionary* countDownLabels;

@end

@implementation TextEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SEL sel = @selector(tapDetected:);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:sel]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAnimateDistances:(NSDictionary *)animateDistances
{
    _animateDistances = animateDistances;
}

- (void)setMaxCharacters:(NSDictionary *)maxChars
{
    _maxCharacters = maxChars;
}

- (void)setCharCountDownIndicators:(NSDictionary *)countDownLabels
{
    _countDownLabels = countDownLabels;
}

- (void)setTextFields:(NSArray *)textFields
{
    _textFields = textFields;
    for (UITextField *textField in textFields)
        textField.delegate = self;
}

- (void)setTextViews:(NSArray *)textViews
{
    _textViews = textViews;
    for (UITextView *textView in textViews)
        textView.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSNumber *maxChars = _maxCharacters[textField];
    if (maxChars)
    {
        NSUInteger len = textField.text.length + string.length - range.length;
        UILabel *countLabel = _countDownLabels[textField];
        
        if (countLabel)
            countLabel.text = [NSString stringWithFormat:@"%ld Characters left", maxChars.integerValue-len];
        
        return len < maxChars.integerValue;
    }
    else
        return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
    NSNumber *maxChars = _maxCharacters[textView];
    if (maxChars)
    {
        NSUInteger len = textView.text.length + string.length - range.length;

        UILabel *countLabel = _countDownLabels[textView];
        
        if (countLabel)
            countLabel.text = [NSString stringWithFormat:@"%ld Characters left", maxChars.integerValue-len];

        return len < maxChars.integerValue;
    }
    else
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

// For shifting the textfields upward so that the keyboard will not block it.
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    NSNumber *dist = _animateDistances[textField];
    if (dist)
    {
        NSInteger distance = dist.integerValue;
        [self shiftByDistance:distance up:up];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView:textView up:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:textView up:NO];
}

// For shifting the textfields upward so that the keyboard will not block it.
-(void)animateTextView:(UITextView *)textView up:(BOOL)up
{
    NSNumber *dist = _animateDistances[textView];
    if (dist)
    {
        NSInteger distance = dist.integerValue;
        [self shiftByDistance:distance up:up];
    }
}

- (void)shiftByDistance:(NSInteger)movementDistance up:(BOOL)up
{
    const float movementDuration = 0.5f; // tweak as needed
    
    NSInteger movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextView" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)tapDetected:(UITapGestureRecognizer *)tapGestureRecognizer
{
    for (UITextField *textField in _textFields)
        [textField resignFirstResponder];

    for (UITextView *textView in _textViews)
        [textView resignFirstResponder];
}

@end
