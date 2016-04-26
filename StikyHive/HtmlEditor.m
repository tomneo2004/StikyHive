//
//  HtmlTextView.m
//  StikyHive
//
//  Created by Koh Quee Boon on 20/7/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "HtmlEditor.h"
#import "ViewControllerUtil.h"

@implementation HtmlEditor

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarUndo,
                                 ZSSRichTextEditorToolbarRedo,
                                 ZSSRichTextEditorToolbarBold,
                                 ZSSRichTextEditorToolbarItalic,
                                 ZSSRichTextEditorToolbarTextColor,
                                 ZSSRichTextEditorToolbarBackgroundColor,
                                 ZSSRichTextEditorToolbarUnorderedList,
                                 ZSSRichTextEditorToolbarOrderedList,
                                 ZSSRichTextEditorToolbarOutdent,
                                 ZSSRichTextEditorToolbarIndent];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(savePressed)];
    self.navigationItem.rightBarButtonItems = @[saveButton];
}

- (void)savePressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
