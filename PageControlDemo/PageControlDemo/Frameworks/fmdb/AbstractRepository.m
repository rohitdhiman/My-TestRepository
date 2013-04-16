	//
//  AbstractRepository.m
//  safecell
//
//  Created by Ben Scheirman on 4/20/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "AbstractRepository.h"
#import "FMDatabaseAdditions.h"
#import "Constant.h"

@implementation AbstractRepository

+(NSString *)databaseFilename {
	return DATABASENAME;
}

+(NSString *)databasePath {
	NSString *filename = [AbstractRepository databaseFilename];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * dbfilePath = [documentsDirectory stringByAppendingPathComponent:filename];
	
	return dbfilePath;
}

-(id)init {
    self = [super init];
	if (self) {
		NSString *dbPath = [AbstractRepository databasePath];
		db = [FMDatabase databaseWithPath:dbPath];
		// [db setTraceExecution:YES];
		[db setLogsErrors:YES];
		[db open];
	}
	return self;
}

-(int) lastInsertRowId {
	NSString * query = @"SELECT last_insert_rowid()";
	int rowId = [db intForQuery:query];
	return rowId;
}



@end
