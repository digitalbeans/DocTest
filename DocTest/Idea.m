//
//  Idea.m
//  DocTest
//
//  Created by Dean Thibault on 9/3/15.
//  Copyright © 2015 Digital Beans. All rights reserved.
//

#import "Idea.h"

@implementation Idea

@synthesize uuid, name, description, group;
@synthesize novels, characters, locations, scenes, images;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

// Called to manual save the document
- (void) doSave
{
	
	[self saveToURL:[self fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
		if (success) {
		    NSLog(@"Synced with iCloud");
		} else {
			NSLog(@"Syncing FAILED with iCloud");
		}
	}];

}

// opend a document and loads the data
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
	if ([contents length] > 0) {
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:contents];
		
		uuid = [unarchiver decodeObjectForKey:@"uuid"];
		name = [unarchiver decodeObjectForKey:@"name"];
		description = [unarchiver decodeObjectForKey:@"description"];
	} else {
		NSLog(@"An error occured in loadFromContenst");
	}

	return YES;
}

// Called whenever the application (auto)saves the content of a document
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError 
{
		NSMutableData *data = [[NSMutableData alloc] init];
		NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[archiver encodeObject:uuid forKey:@"uuid"];
		[archiver encodeObject:name forKey:@"name"];
		[archiver encodeObject:description forKey:@"description"];
		[archiver finishEncoding];
	
		return data;
}


@end
