//
//  DocumentListTableViewController.h
//  DocTest
//
//  Created by Dean Thibault on 9/4/15.
//  Copyright © 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Idea.h"
@interface DocumentListTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *docs;
@property (strong, nonatomic) NSMetadataQuery *query;
@property (strong, nonatomic) Idea *selectedIdea;

- (IBAction)doRefresh:(id)sender;

@end
