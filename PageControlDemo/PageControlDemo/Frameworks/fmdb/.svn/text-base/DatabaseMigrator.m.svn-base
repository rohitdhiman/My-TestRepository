#import "DatabaseMigrator.h"
#import "NSString+utility.h"

//if you need to force a migration # for whatever reason, uncomment this line.
//Just remember to put it back when you're done!
//#define FORCE_MIGRATION 5

@implementation DatabaseMigrator

@synthesize filename = _filename, overwriteDatabase;

-(id)initWithDatabaseFile:(NSString *)filename {
	if (self = [super init]) {
		self.filename = filename;
		database = [[FMDatabase alloc] initWithPath:[self databasePath]];
		[database setLogsErrors:YES];
		[database setBusyRetryTimeout:15];
	}
	
	return self;
}

-(NSString *)databasePath {
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:self.filename];
}

-(BOOL)moveDatabaseToUserDirectoryIfNeeded {
	NSString *databasePath = [self databasePath];
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	if([fileMgr fileExistsAtPath:databasePath]) {
		if (overwriteDatabase) {
			NSLog(@"Overwrite is set to YES, deleting old database file...");
			[fileMgr removeItemAtPath:databasePath error:nil];
		} else {
			return NO;
		}
	}
	
	NSArray *fileParts = [self.filename splitOnChar:'.'];
	if(fileParts == NULL || [fileParts count] < 2) {
		NSLog(@"Invalid filename passed to verifyWritableDatabase ==> %@", self.filename);
		[[NSException exceptionWithName:@"Invalid filename" reason:@"Expected a filename like foo.db" userInfo:nil] raise];
		exit(-1);
	}
	
	NSString *name = [fileParts objectAtIndex:0];
	NSString *extension = [fileParts objectAtIndex:1];
	
	NSLog(@"Moving database from app package to user directory");
	NSString *dbPathFromAppPackage = [[NSBundle mainBundle] pathForResource:name ofType:extension];
	
	if(dbPathFromAppPackage == nil) {
		[[NSException exceptionWithName:@"Invalid resource path" reason:[NSString stringWithFormat:@"Couldn't find %@ in the bundle!", self.filename] userInfo:nil] raise];
		exit(1);
	}
	
	NSError *error;
	BOOL success = [fileMgr copyItemAtPath:dbPathFromAppPackage toPath:databasePath error:&error];
	
	NSLog(@"done copying");
	if(!success) {	
		NSString *msg = [NSString stringWithFormat:@"Error moving database to user directory: %@", [error localizedDescription]];
		NSLog(@"error: %@", msg);
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Database error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	return YES;
}

//gets the current version of the database
-(int)version {
	
#ifdef FORCE_MIGRATION
	[self setVersion:FORCE_MIGRATION];
#endif
	
	int version = [database intForQuery:@"PRAGMA user_version"];
	return version;
}

//sets the current version of the database
-(void)setVersion:(int)version {	
	[database executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version=%d", version]];
}

//applies a migration file (migration-X.sql -- where X is the migration #)
//the first migration file would be 1 (since the db starts at version 0)
-(BOOL)applyMigration:(int)version {

	NSString *migrationFile = [NSString stringWithFormat:@"/migration-%d.sql", version];
	NSLog(@"File: %@", migrationFile);
	NSString *fullPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:migrationFile];
	NSLog(@"Path: %@", fullPath);
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
		NSLog(@"WARNING: Couldn't find migration-%d.sql at %@", version, fullPath);
		return NO;
	}
	
	NSString *migrationSql = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
	
	@try {
		NSArray *statements = [migrationSql splitOnChar:';'];
		
		for(NSString *statement in statements) {
			NSString *cleanedStatement = [statement stringByStrippingWhitespace];
			
			if([cleanedStatement length] > 0) {
				NSLog(@"==> Executing:    %@", cleanedStatement);			
				[database executeUpdate:cleanedStatement];
				
				if ([database hadError]) {
					return NO;
				}
			}
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Error executing migration %d.  The error was: %@", version, exception);
		NSLog(@"Continuing anyway...");
	}
	
	return YES;
}

//applies all necessary migrations to bring this database up to the specified version
-(void)migrateToVersion:(NSInteger)version {
	[database open];
	NSInteger currentVersion = [self version];
	
	if(currentVersion == version) {
		NSLog(@"No migration needed, already at version %d", version);
		[database close];
		return;
	}
	
	
	BOOL success = NO;
	for(int m = currentVersion + 1; m <= version; m++) {
		NSLog(@"Running migration %d", m);
		success = [self applyMigration:m];
		
		if (!success) {
			NSLog(@"Error executing migration %d", m);
			break;
		}
		
		//update to the latest successful migration
		[self setVersion:m];
	}
	
	NSLog(@"Done with migrations....");
	if(!success) {
		NSLog(@"There were errors during the migration.  The current version is %d", [self version]);
	} else {
		NSLog(@"Successfully migrated to version %d", version);
	}
}


#pragma mark - DB Flush

- (BOOL)applyMigrationForFlushDB:(NSString *)fileName {
    [database open];
	NSString *migrationFile = [@"/" stringByAppendingString:fileName];
	NSLog(@"File: %@", migrationFile);
	NSString *fullPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:migrationFile];
	NSLog(@"Path: %@", fullPath);
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
		NSLog(@"WARNING: Couldn't find flushDB.sql at %@", fullPath);
		return NO;
	}
	
	NSString *migrationSql = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    
	@try {
		NSArray *statements = [migrationSql splitOnChar:';'];
		
		for(NSString *statement in statements) {
			NSString *cleanedStatement = [statement stringByStrippingWhitespace];
			
			if([cleanedStatement length] > 0) {
				NSLog(@"==> Executing:    %@", cleanedStatement);			
				[database executeUpdate:cleanedStatement];
				
				if ([database hadError]) {
					return NO;
				}
			}
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Error executing migration .  The error was: %@",exception);
		NSLog(@"Continuing anyway...");
	}
	
	return YES;
}



-(void)dealloc {
	self.filename = nil;
	[database release];
	[super dealloc];
}

@end
