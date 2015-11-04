//
//  BuyerPostViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 19/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "BuyerPostViewController.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "ReportAbuseViewController.h"

@interface BuyerPostViewController ()
@property (assign, nonatomic) NSInteger buyerId;
@property (nonatomic, strong) NSString *picLocation;
@property (nonatomic, strong) UIWebView *descWebView;
@property (nonatomic, strong) UIWebView *respWebView;
@property (nonatomic, strong) UIWebView *buyerWebView;
@property (nonatomic, strong) NSDictionary *marketDict;
@property (assign, nonatomic) NSInteger numberOfWebViewLoaded;
@property (nonatomic, strong) UIButton *bookmarkBtn;
@property (nonatomic, strong) NSString *descHtml;
@property (nonatomic, strong) NSString *respHtml;
@property (nonatomic, strong) NSString *buyerHtml;
@property (nonatomic, strong) UIFont *semifont;

@end

@implementation BuyerPostViewController


- (void)setBuyerId:(NSInteger)buyerId
{
    _buyerId = buyerId;
}

- (void)setPictureLocation:(NSString *)location
{
    _picLocation = location;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CGFloat width = self.view.frame.size.width - 40;
    
    _semifont = [UIFont fontWithName:@"Semibold.ttf" size:20];
    
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    _descWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 0, width, 2)];
    _descWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, _descWebView.frame.size.height, -8);
    _descWebView.userInteractionEnabled = NO;
    _descWebView.delegate = self;
    
    _respWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 0, width, 2)];
    _respWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, _respWebView.frame.size.height, -8);
    _respWebView.userInteractionEnabled = NO;
    _respWebView.delegate = self;
    
    _buyerWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 0, width, 2)];
    _buyerWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, _buyerWebView.frame.size.height, -8);
    _buyerWebView.userInteractionEnabled = NO;
    _buyerWebView.delegate = self;
    _buyerWebView.opaque = NO;
    _buyerWebView.backgroundColor = [UIColor clearColor];
    
    UIFont *font14 = [UIFont fontWithName:@"Open Sans" size:14];
    NSString *fontFormat = @"<span style=\"font-family: %@; font-size: %i\">%@</span>";
    
    
    [WebDataInterface getBuyerMarketById:_buyerId completion:^(NSObject *obj, NSError *err) {
        NSDictionary *buyermarket = (NSDictionary *)obj;
        
        NSLog(@"buyer market -------- %@",buyermarket);
        
        if (buyermarket) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _marketDict = buyermarket[@"result"];
                
                NSString *description = _marketDict[@"description"];
                NSString *responsibility = _marketDict[@"responsibilities"];
                NSString *buyerInfo = _marketDict[@"userInfo"];
                
                _descHtml = description !=(id)[NSNull null] ? [NSString stringWithFormat:fontFormat, font14.fontName,(int)font14.pointSize,description] : @"";
                _respHtml = responsibility !=(id)[NSNull null] ? [NSString stringWithFormat:fontFormat, font14.fontName,(int)font14.pointSize,responsibility] : @"";
                _buyerHtml = buyerInfo !=(id)[NSNull null] ? [NSString stringWithFormat:fontFormat, font14.fontName,(int)font14.pointSize,buyerInfo] : @"";
                
                [_descWebView loadHTMLString:_descHtml baseURL:nil];
                [_respWebView loadHTMLString:_respHtml baseURL:nil];
                [_buyerWebView loadHTMLString:_buyerHtml baseURL:nil];
                
                
            });
        }
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)awebView
{
    _numberOfWebViewLoaded++;
    
    CGRect frame = awebView.frame;
    NSUInteger contentHeight = [[awebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] intValue];
    awebView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, contentHeight);
    
    if (_numberOfWebViewLoaded == 3) {
        
        [self displayContent];
        
        _numberOfWebViewLoaded = 0;
    }
}

- (void)displayContent
{
    
    CGFloat x = 0;
    CGFloat y = 0;
//    CGFloat vspace = 30;
//    CGFloat aspect = 9.0/16;
    CGFloat width = self.view.frame.size.width;
    
    y = [self displayTitleBg:CGPointMake(x, y) andWidth:width];
    
    y = [self displayTimeIssue:CGPointMake(x, y) andWidth:width];
    
    y = [self displayWebView:CGPointMake(x, y) andWidth:width];
    
    y = [self displayImage:CGPointMake(x, y) andWidth:width];
    
    y = [self displaySareButton:CGPointMake(x, y) andWidth:width];
    
    y = [self displayBuyer:CGPointMake(x, y) andWidth:width];
    
    y = y + 50;
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, y)];

    
    //bottom button ---------- display bottom button
    UIColor *color1 = [UIColor colorWithRed:82.0/255 green:191.0/255 blue:180.0/255 alpha:0.9];
    UIColor *color2 = [UIColor colorWithRed:61.0/255 green:182.0/255 blue:169.0/255 alpha:0.9];
    UIColor *color3 = [UIColor colorWithRed:39.0/255 green:162.0/255 blue:150.0/255 alpha:0.9];
    
    
//    CGFloat width = self.view.frame.size.width;
    UIButton *emailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, width/3, 50)];
    emailBtn.backgroundColor = color1;
    [emailBtn setImage:[UIImage imageNamed:@"skillpg_email"] forState:UIControlStateNormal];
    [emailBtn setTitle:@"Email" forState:UIControlStateNormal];
    emailBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 26, 10, 70);
    
    
    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(width/3, emailBtn.frame.origin.y, emailBtn.frame.size.width, emailBtn.frame.size.height)];
    callBtn.backgroundColor = color2;
    [callBtn setImage:[UIImage imageNamed:@"skillpg-call"] forState:UIControlStateNormal];
    [callBtn setTitle:@"Call" forState:UIControlStateNormal];
    callBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 26, 10, 66);
    
    
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(emailBtn.frame.size.width*2, emailBtn.frame.origin.y, emailBtn.frame.size.width, emailBtn.frame.size.height)];
    chatBtn.backgroundColor = color3;
    [chatBtn setImage:[UIImage imageNamed:@"skillpg-chat"] forState:UIControlStateNormal];
    [chatBtn setTitle:@"Chat" forState:UIControlStateNormal];
    chatBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 27, 10, 68);
    
    
    [self.view addSubview:emailBtn];
    [self.view addSubview:callBtn];
    [self.view addSubview:chatBtn];

    
}


- (CGFloat)displayTitleBg:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, y, width, 120)];
    bgImageView.image = [UIImage imageNamed:@"skillpage-bg"];
    bgImageView.userInteractionEnabled = YES;
    
    
    NSString *avalibility = _marketDict[@"availability"];
    NSInteger avaliInt = [avalibility integerValue];
    
    UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 10, 10)];
    UILabel *avaLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointView.frame.origin.x + pointView.frame.size.width+10, 10, 70, 30)];
    avaLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17];
    avaLabel.font = _semifont;
    
    if (avaliInt == 1)
    {
        pointView.image = [UIImage imageNamed:@"buyerspost_open"];
        [avaLabel setText:@"OPEN"];
        avaLabel.textColor = greenColor;
        
    }
    else
    {
        pointView.image = [UIImage imageNamed:@"buyerspost_closed"];
        [avaLabel setText:@"CLOSED"];
        avaLabel.textColor = [UIColor redColor];
    }
    
    UILabel *expireDay = [[UILabel alloc] initWithFrame:CGRectMake(avaLabel.frame.origin.x+avaLabel.frame.size.width +25, 14, 100, 20)];
//    expireDay.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
//    NSString *todayDate =
    
    NSString *endDate = _marketDict[@"expiredDate"];
    ////// calculaate days left -----------
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *postDate = [formate dateFromString:endDate];
    [formate setDateFormat:@"yyyy-MM-dd"];
    
    NSString *endDateString = [formate stringFromDate:postDate];
    
    NSDate *expireDate = [formate dateFromString:endDateString];
    
    NSLog(@" end date string -------- %@",endDateString);

    NSDate* startDate = [NSDate date];
//    [formate setDateFormat:@"yyyy-MM-dd "];

    
//    NSDate *todayDate = [formate ]
    
    NSLog(@"today date --- %@",startDate);
//    NSString* startDateString = [formate stringFromDate:startDate];

    
    NSLog(@"expire date ----- %@",expireDate);
    
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [greCalendar components:NSCalendarUnitDay fromDate:startDate toDate:expireDate options:NSCalendarWrapComponents];
    
    
    
    NSInteger manyOfDays = [components day];
    expireDay.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
    expireDay.text = [NSString stringWithFormat:@"%ld days left",(long)manyOfDays];
    
    _bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-65, 15, 25, 30)];
    [_bookmarkBtn setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [_bookmarkBtn setImage:[UIImage imageNamed:@"bookmark_filled"] forState:UIControlStateSelected];
    [_bookmarkBtn addTarget:self action:@selector(bookmarkBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *bmLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-80, _bookmarkBtn.frame.origin.y+_bookmarkBtn.frame.size.height+10, 60, 10)];
    [bmLabel setText:@"Bookmark"];
    bmLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11];
    [bmLabel setTextColor:greenColor];
    bmLabel.textAlignment = NSTextAlignmentCenter;
    CGPoint bmLabelCenter = bmLabel.center;
    bmLabelCenter.x = _bookmarkBtn.center.x;
    bmLabel.center = bmLabelCenter;


    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, bgImageView.frame.size.height-40, 300, 30)];
    titleLabel.text = _marketDict[@"name"];
    titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18];;
    
    [bgImageView addSubview:expireDay];
    [bgImageView addSubview:pointView];
    [bgImageView addSubview:avaLabel];
    [bgImageView addSubview:_bookmarkBtn];
    [bgImageView addSubview:bmLabel];
    [bgImageView addSubview:titleLabel];
    
    
    [_contentScrollView addSubview:bgImageView];
    
    y = y+bgImageView.frame.size.height;
    
    return y;
}

- (CGFloat)displayTimeIssue:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y + 10;
    
    UILabel *postDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 180, 30)];
    postDateLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:8];
    UILabel *expireDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 170, y, 150, 30)];
    expireDateLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:8];
    expireDateLabel.textAlignment = NSTextAlignmentRight;
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    NSString *postDateString = _marketDict[@"createDate"];
    NSString *expDateString = _marketDict[@"expiredDate"];
    [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *postDate = [formate dateFromString:postDateString];
    NSDate *date = [formate dateFromString:expDateString];
    [formate setDateFormat:@"dd MMM yyyy"];
    NSString *postDateText = [formate stringFromDate:postDate];
    NSString *expireDate = [formate stringFromDate:date];
    
    postDateLabel.text = [NSString stringWithFormat:@"Posted on %@",postDateText];
    expireDateLabel.text = [NSString stringWithFormat:@"Expiring %@",expireDate];
    
    
//    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, postDateLabel.frame.origin.y+postDateLabel.frame.size.height+10, self.view.frame.size.width - 40, 1)];
//    CGPoint center = lineView.center;
//    center.x = self.view.center.x;
//    lineView.center = center;
//    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self displayLineView:CGPointMake(20, postDateLabel.frame.origin.y+postDateLabel.frame.size.height+10) andWith:width];
    
    [_contentScrollView addSubview:postDateLabel];
    [_contentScrollView addSubview:expireDateLabel];
//    [_contentScrollView addSubview:lineView];
    
    CGFloat x = (self.view.frame.size.width-40)/3;
//    y = lineView.frame.origin.y +1;
    y = postDateLabel.frame.origin.y+postDateLabel.frame.size.height+11;
    
    // part view -------------------------------
    UIView *partView = [[UIView alloc] initWithFrame:CGRectMake(20, y, x-10, 50)];
//    partView.backgroundColor = [UIColor redColor];
    UIImageView *calenderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 25, 25)];
    calenderImageView.image = [UIImage imageNamed:@"buyerspost_job_type"];
    CGPoint calenderCenter = calenderImageView.center;
    calenderCenter.y = partView.frame.size.height/2;
    calenderImageView.center = calenderCenter;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(calenderImageView.frame.origin.x+calenderImageView.frame.size.width+7, 10, x-30, 25)];
    CGPoint timeLabelCenter = timeLabel.center;
    timeLabelCenter.y = partView.frame.size.height/2;
    timeLabel.center = timeLabelCenter;
    timeLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
    NSString *jobTypeString = _marketDict[@"jobType"];
    NSInteger jobTypeInt = [jobTypeString integerValue];
    if (jobTypeInt == 1)
    {
        timeLabel.text = @"FULL TIME";
    }
    else
    {
        timeLabel.text = @"PART TIME";
    }
    
    
//    CGPoint imageCenter = calenderImageView.center;
//    imageCenter.y = partView.center.y;
//    calenderImageView.center = imageCenter;
//    
//    CGPoint labelCenter = timeLabel.center;
//    labelCenter.y = partView.center.y;
//    timeLabel.center = labelCenter;
    
    [partView addSubview:calenderImageView];
    [partView addSubview:timeLabel];
    
    // time view ----------------------
    
//    NSString *time1 = _marketDict[@"startTime"] !=(id)[NSNull null] ? _marketDict[@"startTime"] : @"";
//    NSString *time2 = _marketDict[@"endTime"] !=(id)[NSNull null] ? _marketDict[@"endTime"] : @"";

    NSString *time1 = _marketDict[@"startTime"];
    NSString *time2 = _marketDict[@"endTime"];
    
    if (time1 != (id)[NSNull null] && time2 != (id)[NSNull null])
    {
        
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(10+x, y, x+25, 50)];
//        timeView.backgroundColor = [UIColor yellowColor];
        
        UIImageView *clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
        clockImageView.image = [UIImage imageNamed:@"buyerspost_job_time"];
        CGPoint clockImageViewCenter = clockImageView.center;
        clockImageViewCenter.y = timeView.frame.size.height/2;
        clockImageView.center = clockImageViewCenter;
        
        UILabel *clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockImageView.frame.origin.x+clockImageView.frame.size.width+2, 10, timeView.frame.size.width-22, 25)];
        CGPoint clockLabelCenter = clockLabel.center;
        clockLabelCenter.y = timeView.frame.size.height/2;
        clockLabel.center = clockLabelCenter;
        [formate setDateFormat:@"HH:mm"];
        NSDate *timeDate = [formate dateFromString:time1];
        NSDate *time2Date = [formate dateFromString:time2];
        [formate setDateFormat:@"hh:mm a"];
        NSString *timeString = [formate stringFromDate:timeDate];
        NSString *time2String = [formate stringFromDate:time2Date];
        
        clockLabel.text = [NSString stringWithFormat:@"%@-%@",timeString,time2String];
        clockLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12];
        
        [timeView addSubview:clockImageView];
        [timeView addSubview:clockLabel];

        
        [_contentScrollView addSubview:timeView];
        
    }
    
    // type view --------------------------
    NSString *priceString = _marketDict[@"price"];
    NSString *rateString = _marketDict[@"rateName"];
    
    
    if (priceString != (id)[NSNull null] && rateString != (id)[NSNull null])
    {
        
        UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(20+2*x+15, y, x-15, 50)];
//        typeView.backgroundColor = [UIColor greenColor];
        
        UIImageView *payImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 13, 25)];
        payImageView.image = [UIImage imageNamed:@"buyerspost_job_pay"];
        CGPoint payImageViewCenter = payImageView.center;
        payImageViewCenter.y = typeView.frame.size.height/2;
        payImageView.center = payImageViewCenter;
        
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(payImageView.frame.origin.x+payImageView.frame.size.width+3, 10, x-30, 25)];
        CGPoint payLabelCenter = payLabel.center;
        payLabelCenter.y = typeView.frame.size.height/2;
        payLabel.center = payLabelCenter;
        payLabel.text = [NSString stringWithFormat:@"%@/%@",priceString,rateString];
        payLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
        
        [typeView addSubview:payImageView];
        [typeView addSubview:payLabel];
        
        [_contentScrollView addSubview:typeView];
    }
    
//    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20, y+partView.frame.size.height, self.view.frame.size.width - 40, 1)];
//    CGPoint center2 = lineView2.center;
//    center2.x = self.view.center.x;
//    lineView2.center = center2;
//    [lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    
    [self displayLineView:CGPointMake(20, y+partView.frame.size.height) andWith:width];
    
    
//    [_contentScrollView addSubview:lineView2];
    
    [_contentScrollView addSubview:partView];
    
    
    y = y+partView.frame.size.height + 30;
    
    return y;
}


- (CGFloat)displayWebView:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    if (_descHtml.length > 0)
    {
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 150, 20)];
        descLabel.text = @"Job Descriptor";
        descLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17];
        
        CGRect frame = _descWebView.frame;
        frame.origin.y = y + 25;
        _descWebView.frame = frame;
        
        y = _descWebView.frame.origin.y + _descWebView.frame.size.height + 10;
        
        [_contentScrollView addSubview:descLabel];
        [_contentScrollView addSubview:_descWebView];
        
    }
    
    if (_respHtml.length > 0)
    {
        
        UILabel *respLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 150, 20)];
        respLabel.text = @"Responsibilities";
        respLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17];
        
        CGRect frame = _respWebView.frame;
        frame.origin.y = y + 25;
        _respWebView.frame = frame;
        
        y = _respWebView.frame.origin.y + _respWebView.frame.size.height + 10;
        
        [_contentScrollView addSubview:respLabel];
        [_contentScrollView addSubview:_respWebView];
        
    }
    
    y = y + 10;
    
    return y;
}

- (CGFloat)displayImage:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, width-40, 200)];
    if (_picLocation != (id)[NSNull null])
    {
        NSString *url = [WebDataInterface getFullUrlPath:_picLocation];
        UIImage *image = [ViewControllerUtil getImageWithPath:url];
        
        imageView.image = image;
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"Default_buyer_post"];
    }
    
    
    NSLog(@"picture location -------------90 ---- %@",_picLocation);
    
    [_contentScrollView addSubview:imageView];
    
    y = imageView.frame.origin.y + imageView.frame.size.height + 20;
    
    return y;
}

- (CGFloat)displaySareButton:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
//    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, y, width - 40, 1)];
//    CGPoint center = lineView.center;
//    center.x = self.view.center.x;
//    lineView.center = center;
//    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self displayLineView:CGPointMake(20, y) andWith:width];
    
    
//    UIImageView *reportImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width-80, y+23, 60, 45)];
//    reportImageView.image = [UIImage imageNamed:@"reportabuse.png"];
    
    UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(width-80, y+23, 60, 45)];
    [reportButton setImage:[UIImage imageNamed:@"reportabuse"] forState:UIControlStateNormal];
    [reportButton addTarget:self action:@selector(reportBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    y = y + 25;
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 200, 15)];
    shareLabel.text = @"Share this Skill Page";
    
    y = y + 35;
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y, 40, 40)];
//    emailButton.backgroundColor = [UIColor lightGrayColor];
    [emailButton setImage:[UIImage imageNamed:@"share-email"] forState:UIControlStateNormal];
    
    CGFloat x = emailButton.frame.origin.x + 50;
    
    UIButton *twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    [twitterButton setImage:[UIImage imageNamed:@"share-twitter"] forState:UIControlStateNormal];
    x = x + 50;
    
    UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    [fbButton setImage:[UIImage imageNamed:@"share-facebook"] forState:UIControlStateNormal];
    x = x + 50;
    
    UIButton *pintButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    [pintButton setImage:[UIImage imageNamed:@"share-pinterest"] forState:UIControlStateNormal];
    
    x = x + 50;
    
    UIButton *googleButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    [googleButton setImage:[UIImage imageNamed:@"share-google"] forState:UIControlStateNormal];
    
    
    
//    [_contentScrollView addSubview:lineView];
    [_contentScrollView addSubview:reportButton];
    [_contentScrollView addSubview:shareLabel];
    [_contentScrollView addSubview:emailButton];
    [_contentScrollView addSubview:twitterButton];
    [_contentScrollView addSubview:fbButton];
    [_contentScrollView addSubview:pintButton];
    [_contentScrollView addSubview:googleButton];
    
    y = y + 70;
    
    
    
    return y;
}

- (CGFloat)displayBuyer:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    UIView *buyerView = [[UIView alloc] initWithFrame:CGRectMake(point.x, y, width, 150)];
    buyerView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    aboutLabel.text = @"About Buyer";
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, aboutLabel.frame.origin.y+aboutLabel.frame.size.height +20, 200, 25)];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",_marketDict[@"firstname"],_marketDict[@"lastname"]];
    nameLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    [nameLabel setTextColor:[UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0]];
    
    
    CGRect frame = _buyerWebView.frame;
    frame.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height + 10;
    _buyerWebView.frame = frame;
    
    NSString *profileUrl = [WebDataInterface getFullUrlPath:_marketDict[@"profilePicture"]];
    UIView *profilePhotoView = [ViewControllerUtil getViewWithImageURLNormal:profileUrl xOffset:width - 80 yOffset:-20 width:60.0 heigth:60.0 defaultPhoto:@"Default_profile_small@2x"];
    profilePhotoView.layer.cornerRadius = 60.0/2;
    profilePhotoView.layer.masksToBounds = YES;
    profilePhotoView.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePhotoView.layer.borderWidth = 1;
    
    CGRect buyerFrame = buyerView.frame;
    buyerFrame.size.height = _buyerWebView.frame.size.height + 100;
    buyerView.frame = buyerFrame;
    
    
    [buyerView addSubview:aboutLabel];
    [buyerView addSubview:nameLabel];
    [buyerView addSubview:_buyerWebView];
    [buyerView addSubview:profilePhotoView];
    
    
    [_contentScrollView addSubview:buyerView];

    y = y + buyerView.frame.size.height;
    
    return y;
}

- (void)displayLineView:(CGPoint)point andWith:(CGFloat)width
{
    
    UIColor *lineColor = [UIColor colorWithRed:215.0/255 green:217.0/255 blue:218.0/255 alpha:1.0];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20, point.y, width - 40, 1)];
    CGPoint center2 = lineView2.center;
    center2.x = self.view.center.x;
    lineView2.center = center2;
    [lineView2 setBackgroundColor:lineColor];

    
    [_contentScrollView addSubview:lineView2];
}


- (void)reportBtnTapped:(UITapGestureRecognizer *)sender
{
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"report_abuse_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)bookmarkBtnTapped:(UITapGestureRecognizer *)sender
{
    _bookmarkBtn.selected = !_bookmarkBtn.selected;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
