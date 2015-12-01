//
//  SavedDocumentsViewController.m
//  StikyHive
//
//  Created by User on 1/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SavedDocumentsViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "UIView+RNActivityView.h"
#import "DocumentInfo.h"

@interface SavedDocumentsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SavedDocumentsViewController{
    
    NSMutableArray *_documentInfos;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self pullData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal
- (void)pullData{
    
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    [WebDataInterface getSavedDocument:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(error != nil){
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                if(((NSArray *)dic[@"documents"]).count <=0){
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No documents yet!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    _documentInfos = [[NSMutableArray alloc] init];
                    
                    for(NSDictionary *data in dic[@"documents"]){
                        
                        DocumentInfo *info = [DocumentInfo createDocumentInfoFromDictionary:data];
                        [_documentInfos addObject:info];
                    }
                    
                    [_tableView reloadData];
                    
                    [self.view hideActivityView];
                    
                    return;
                }
                
            }
            
            [self.view hideActivityView];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_documentInfos != nil){
        
        return _documentInfos.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
