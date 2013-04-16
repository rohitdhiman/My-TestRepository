#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface DatabaseMigrator : NSObject {
	NSString *_filename;
	BOOL overwriteDatabase;
	FMDatabase *database;
}

@property (nonatomic, copy) NSString *filename;
@property (nonatomic) BOOL overwriteDatabase;

-(NSString *)databasePath;
-(id)initWithDatabaseFile:(NSString *)filename;

-(BOOL)moveDatabaseToUserDirectoryIfNeeded;
-(void)migrateToVersion:(NSInteger)version;

-(int)version;
-(void)setVersion:(int)version;

-(BOOL)applyMigrationForFlushDB:(NSString *)fileName;
@end
