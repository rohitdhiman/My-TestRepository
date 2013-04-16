//
//  AbstractRepository.h
//  safecell
//
//  Created by Ben Scheirman on 4/20/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface AbstractRepository : NSObject {
	FMDatabase *db;
}

+(NSString *)databaseFilename;
-(int) lastInsertRowId;

@end
