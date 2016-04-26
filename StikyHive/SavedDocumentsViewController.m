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
#import "DocumentTableViewCell.h"
#import "AFNetworking.h"
#import "Helper.h"
#import "PDFViewController.h"
#import "UIView+RNActivityView.h"

@interface SavedDocumentsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SavedDocumentsViewController{
    
    NSMutableArray *_documentInfos;
    NSMutableArray *_removedDocumentInfo;
    NSInteger _removedCount;
    AFHTTPRequestOperation *_downloadOp;
    BOOL _shouldUpdate;
    NSDateFormatter *_dateFormatter;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Document";
    
    _removedDocumentInfo = [[NSMutableArray alloc] init];
    _tableView.allowsSelectionDuringEditing = YES;
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"dd MMM yyyy"];
    _shouldUpdate = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    [self configureButtonitems];
    
    if(_shouldUpdate)
        [self pullData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self existEditMode];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    _shouldUpdate = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal
- (void)configureButtonitems{

    if(_documentInfos == nil || _documentInfos.count <= 0){
        
        [self.navigationItem setRightBarButtonItems:nil];
        return;
    }
    
    if(_tableView.isEditing){
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(existEditMode)];
        
        [self.navigationItem setRightBarButtonItems:@[doneBtn]];
    }
    else{
        
        UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(enterEditMode)];
        
        [self.navigationItem setRightBarButtonItems:@[editBtn]];
    }
}

- (void)enterEditMode{
    
    [_tableView setEditing:YES];
    
    for(UITableViewCell *cell in [_tableView visibleCells]){
        
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    
    [self configureButtonitems];
}

- (void)existEditMode{
    
    [_tableView setEditing:NO];
    
    _removedCount = 0;
    [_removedDocumentInfo removeAllObjects];
    
    [self configureButtonitems];
}

- (void)updateRemovedCount{
    
    _removedCount = _removedDocumentInfo.count;
    
    if(_removedCount > 0){
        
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteSelectedFile)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(existEditMode)];
        
        [self.navigationItem setRightBarButtonItems:@[doneBtn, deleteBtn]];
    }
    else{
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(existEditMode)];
        
        [self.navigationItem setRightBarButtonItems:@[doneBtn]];
    }
    
    
}

- (void)deleteSelectedFile{
    
    NSMutableArray *removedDocId = [[NSMutableArray alloc] init];
    
    [self.view showActivityViewWithLabel:@"Deleting files..."];
    
    for(DocumentInfo *info in _removedDocumentInfo){
        
        [removedDocId addObject:[NSNumber numberWithInteger:info.documentId]];
        
        //remove local file
        [Helper deleteFileInDocument:[NSString stringWithFormat:@"%li", info.documentId] extension:@"pdf"];
        
        [_documentInfos removeObject:info];
    }
    
    [_removedDocumentInfo removeAllObjects];
    
    [WebDataInterface deleteDocuments:removedDocId completion:^(NSObject *obj, NSError *error){
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can not removed document in server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            _removedCount --;
            
            if(_removedCount <= 0){
                
                [self existEditMode];
                
                [_tableView reloadData];
                
                [self.view hideActivityView];
            }
        });
        
        
    }];
}

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
                    
                    [self configureButtonitems];
                    
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

- (void)showPdfDocumentWithURL:(NSURL *)documentURL{
    
    PDFViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PDFViewController"];
    
    controller.pdfURL = documentURL;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)downloadPdfFileWithURL:(NSURL *)downloadURL withFileName:(NSString *)fileName{
    
    __weak typeof(self) weakSelf = self;
    
    if(![_downloadOp isFinished]){
        
        [_downloadOp cancel];
    }
    
    [self.view showActivityViewWithLabel:@"Downloading File..."];
    
    _downloadOp = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:downloadURL]];
    
    [_downloadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        
        if(fileName == nil || fileName.length <= 0){
            
            NSLog(@"cant save file without name");
            
            [weakSelf.view hideActivityView];
            
            return;
        }
        
        [Helper writeFileIntoDocumentWithData:data withFileName:fileName withFileExtension:@"pdf"];
        
        NSString *pdfPath = nil;
        
        if([Helper isFileExistInDocument:fileName extension:@"pdf"]){
            
            pdfPath = [Helper filePathFromDocument:fileName extension:@"pdf"];
            
            if(pdfPath != nil){
                
                [weakSelf showPdfDocumentWithURL:[NSURL fileURLWithPath:pdfPath]];
            }
        }
        
        [weakSelf.view hideActivityView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Download file fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    
        [weakSelf.view hideActivityView];
    }];
    
    [_downloadOp start];
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
    
    static NSString *cellId = @"DocumentCell";
    
    DocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[DocumentTableViewCell alloc] init];
    }
    
    DocumentInfo *info = [_documentInfos objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = info.documentName;
    
    cell.dateLabel.text = [_dateFormatter stringFromDate:info.createDate];
    
    if(tableView.isEditing){
        
        if([_removedDocumentInfo containsObject:info]){
            
            cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DocumentInfo *info = [_documentInfos objectAtIndex:indexPath.row];
    
    if(_tableView.isEditing){
        
        if(![_removedDocumentInfo containsObject:info]){
            
            [_removedDocumentInfo addObject:info];
            
            DocumentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            
            [_removedDocumentInfo removeObject:info];
            
            DocumentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
        }
        
        [self updateRemovedCount];
    }
    else{
        
        NSString *pdfPath;
        
        NSString *fileName = [NSString stringWithFormat:@"%li", (long)info.documentId];
        
        if([Helper isFileExistInDocument:fileName extension:@"pdf"]){
            
            pdfPath = [Helper filePathFromDocument:fileName extension:@"pdf"];
            
            if(pdfPath != nil){
                
                [self showPdfDocumentWithURL:[NSURL fileURLWithPath:pdfPath]];
                
                return;
            }
        }
        
        [self downloadPdfFileWithURL:[NSURL URLWithString:[WebDataInterface getFullStoragePath:info.documentLocation]] withFileName:[NSString stringWithFormat:@"%li", (long)info.documentId]];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UINavigationViewController delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if([fromVC isKindOfClass:[PDFViewController class]])
        _shouldUpdate = NO;
    
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
