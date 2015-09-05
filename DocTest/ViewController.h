//
//  ViewController.h
//  DocTest
//
//  Created by Dean Thibault on 9/3/15.
//  Copyright © 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Idea.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) Idea *anIdea;
@property (strong, nonatomic) IBOutlet UITextField *uuidField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionField;

- (IBAction)doLoad:(id)sender;
- (IBAction)doSave:(id)sender;

@end

