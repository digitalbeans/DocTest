//
//  ViewController.m
//  DocTest
//
//  Created by Dean Thibault on 9/3/15.
//  Copyright © 2015 Digital Beans. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize anIdea, uuidField, nameField, descriptionField;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[[NSNotificationCenter defaultCenter] addObserverForName:UIDocumentStateChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification __strong *notification) {
			uuidField.text = anIdea.uuid;
			nameField.text = anIdea.name;
			descriptionField.text = anIdea.description;
		
	}];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[uuidField setEnabled: YES];
	if (self.anIdea) {
		[uuidField setEnabled: NO];
		uuidField.text = anIdea.uuid;
		nameField.text = anIdea.name;
		descriptionField.text = anIdea.description;
	} else {
		uuidField.text = @"";
		nameField.text = @"";
		descriptionField.text = @"";
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)doLoad:(id)sender {
	anIdea = nil;
	NSString *fName = [NSString stringWithFormat:@"%@.idea", uuidField.text];
	NSURL* ubiq = [[NSFileManager defaultManager]URLForUbiquityContainerIdentifier:nil];
	NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"]  URLByAppendingPathComponent:fName];
	anIdea = [[Idea alloc] initWithFileURL:ubiquitousPackage];
	[anIdea openWithCompletionHandler:^(BOOL success) {
		if (success) {
			uuidField.text = anIdea.uuid;
			nameField.text = anIdea.name;
			descriptionField.text = anIdea.description;
		} else {
			NSLog(@"Error loading file: %@", ubiquitousPackage);
		}
		
	}];
}

- (IBAction)doSave:(id)sender {
	// if new, create new document
	if (!self.anIdea) {
		NSString *fName = [NSString stringWithFormat:@"%@.idea", uuidField.text];
		NSURL* ubiq = [[NSFileManager defaultManager]URLForUbiquityContainerIdentifier:nil];
		NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"]  URLByAppendingPathComponent:fName];
    	anIdea = [[Idea alloc] initWithFileURL:ubiquitousPackage];
	}
	// set the data in document
	anIdea.uuid = uuidField.text;
	anIdea.name = nameField.text;
	anIdea.description = descriptionField.text;
	
	// manually save the new document
	[anIdea doSave];
	
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}
@end
