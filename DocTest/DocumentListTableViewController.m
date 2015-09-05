//
//  DocumentListTableViewController.m
//  DocTest
//
//  Created by Dean Thibault on 9/4/15.
//  Copyright © 2015 Digital Beans. All rights reserved.
//

#import "DocumentListTableViewController.h"
#import "Idea.h"
#import "ViewController.h"

@interface DocumentListTableViewController ()

@end

@implementation DocumentListTableViewController
@synthesize docs, selectedIdea;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[[NSNotificationCenter defaultCenter] addObserverForName:UIDocumentStateChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification __strong *notification) {
		[self.tableView reloadData];
		
	}];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[self loadDocs];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDocs {
    if (!self.docs) { 
        self.docs = [[NSMutableArray alloc] init]; 
    } 
      
    NSURL *baseURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil]; 
      
    if (baseURL) { 
        self.query = [[NSMetadataQuery alloc] init]; 
        [self.query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]]; 
          
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like '*'", NSMetadataItemFSNameKey]; 
        [self.query setPredicate:predicate]; 
          
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
        [nc addObserver:self selector:@selector(queryDidFinish:) name:NSMetadataQueryDidFinishGatheringNotification object:self.query]; 
        [nc addObserver:self selector:@selector(queryDidUpdate:) name:NSMetadataQueryDidUpdateNotification object:self.query]; 
		
        [self.query startQuery]; 
    } 
}


- (void)queryDidFinish:(NSNotification *)notification { 
    [self.refreshControl endRefreshing];
    NSMetadataQuery *query = [notification object];
      
    // Stop Updates 
    [query disableUpdates]; 
      
    // Stop Query 
    [query stopQuery]; 
      
    // Clear Bookmarks 
    [self.docs removeAllObjects];
      
    [query.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { 
        NSURL *documentURL = [(NSMetadataItem *)obj valueForAttribute:NSMetadataItemURLKey]; 
        Idea *idea = [[Idea alloc] initWithFileURL:documentURL];
          
        [idea openWithCompletionHandler:^(BOOL success) {
            if (success) { 
                [self.docs addObject:idea];
                [self.tableView reloadData]; 
            } 
        }]; 
    }]; 
      
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
}

- (void)queryDidUpdate:(NSNotification *)notification {
    [self.refreshControl endRefreshing];
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.docs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCellReuseIdentifier" forIndexPath:indexPath];
	
    // Fetch Bookmark 
    Idea *idea = [self.docs objectAtIndex:indexPath.row];
      
    // Configure Cell 
    cell.textLabel.text = idea.name;
    cell.detailTextLabel.text = idea.description;
      
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	selectedIdea = [self.docs objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"EditIdeaSegue" sender:self];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Fetch Document 
        Idea *idea = [self.docs objectAtIndex:indexPath.row];
          
        // Delete Document 
        NSError *error = nil; 
        if (![[NSFileManager defaultManager] removeItemAtURL:idea.fileURL error:&error]) {
            NSLog(@"An error occurred while trying to delete document. Error %@ with user info %@.", error, error.userInfo); 
        } 
          
        // Update Bookmarks 
        [self.docs removeObjectAtIndex:indexPath.row];
          
        // Update Table View 
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqual:@"EditIdeaSegue"]) {
		ViewController *nvc =  (ViewController *)[segue destinationViewController];
		[nvc setAnIdea:selectedIdea];
	}
}


- (IBAction)doRefresh:(id)sender {
	[self loadDocs];
}
@end
