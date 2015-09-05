//
//  Idea.h
//  DocTest
//
//  Created by Dean Thibault on 9/3/15.
//  Copyright © 2015 Digital Beans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Idea : UIDocument

@property (strong, nonatomic) NSString *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSAttributedString *group;

@property (nonatomic, strong) NSMutableArray *novels;
@property (nonatomic, strong) NSMutableArray *characters;
@property (nonatomic, strong) NSMutableArray *scenes;
@property (nonatomic, strong) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *images;

- (void) doSave;

@end
