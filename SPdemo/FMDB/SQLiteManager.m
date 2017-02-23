//
//  SQLiteManager.m
//  iSurvey
//
//  Created by Prem on 15/07/10.
//  Copyright 2010 Solvedge. All rights reserved.
//

#import "SQLiteManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation SQLiteManager

FMDatabase *db;
-(NSString*)GetDBPath
{
	//Get the complete users document directory path.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	//Get the first path in the array.
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//Create the complete path to the database file.
	return [documentsDirectory stringByAppendingPathComponent:@"PatientDataBase.sqlite"];
}

-(void)createDatabaseIfNeeded{
	
	BOOL success;
	NSError *error;
	
	//FileManager - Object allows easy access to the File System.
	NSFileManager *FileManager = [NSFileManager defaultManager];
	
	//Get the complete users document directory path.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	//Get the first path in the array.
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//Create the complete path to the database file.
	NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"PatientDataBase.sqlite"];
	
	//Check if the file exists or not.
	success = [FileManager fileExistsAtPath:databasePath];
	
	//If the database is present then quit.
	if(success)
	{
		[self OpenDB:databasePath];
		return;
	}
	
	//the database does not exists, so we will copy it to the users document directory]
	NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PatientDataBase.sqlite"];
	
	//Copy the database file to the users document directory.
	success = [FileManager copyItemAtPath:dbPath toPath:databasePath error:&error];
    
	//If the above operation is not a success then display a message.
	//Error message can be seen in the debugger's console window.
	if(!success)
		NSAssert1(0, @"Failed to copy the database. Error: %@.", [error localizedDescription]);
	[self OpenDB:databasePath];
}

-(void)OpenDB:(NSString*)strDBPath
{
	if(!db)
	{
		db = [[FMDatabase alloc] initWithPath:strDBPath];
		if (![db open]) {
			//(@"Could not open db.");
			return;
		}
		NSLog(@"FM DB instance ready at path = %@",strDBPath);
	}
}
-(void)Close
{
	if (db) {
		[db close];
	}
}
-(BOOL)ExecuteUpdateQuery:(NSString*)strQuery
{
	if (!db)
	{
		[self createDatabaseIfNeeded];
	}
	BOOL bReturnFlag = [db executeUpdate:strQuery];
    
    //	if (bReturnFlag)
    //	{
    //		[self CommitLastQuery];
    //	}
    
    if ([db hadError]) {
        //NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
	return bReturnFlag;
}

-(BOOL)ExecuteInsertQuery :(NSString*)strQuery withCollectionOfValues:(NSMutableArray*)objCollections
{
    //NSLog(@"ExecuteInsert Query : %@",strQuery);
	if (!db)
	{
		[self createDatabaseIfNeeded];
	}
	BOOL bFlag = [db executeUpdate:strQuery withArgumentsInArray:objCollections];
	if ([db hadError])
	{
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    //	[self CommitLastQuery];
	return bFlag;
}

-(BOOL)BeginTransaction
{
	//(@"Begin transactions %@",[NSDate date]);
	return [db beginTransaction];
}

-(BOOL)CommitLastQuery
{
	//(@"Commit transactions %@",[NSDate date]);
	return [db commit];
}

-(BOOL)rollBackTransaction
{
	//(@"Commit transactions %@",[NSDate date]);
	return [db rollback];
}

-(FMDatabase*) DBmanager{
    return db;
}

-(FMResultSet*) ExecuteQuery:(NSString*)strQuery
{
    //NSLog(@"Execute Query : %@",strQuery);
	if (!db)
	{
		[self createDatabaseIfNeeded];
		db = [[FMDatabase alloc] initWithPath:[self GetDBPath]];
		if (![db open]) {
			NSLog(@"Could not open db: %@",strQuery);
			return nil;
		}
		//(@"FM DB instance ready again = %@",[self GetDBPath]);
	}
	return [db executeQuery:strQuery];
}

-(FMResultSet*) ExecuteQueryWithArg:(NSString*)strQuery Argument:(NSArray*)arrArg
{
	if (!db)
	{
		[self createDatabaseIfNeeded];
		db = [[FMDatabase alloc] initWithPath:[self GetDBPath]];
		if (![db open]) {
			//(@"Could not open db.");
			return nil;
		}
		//(@"FM DB instance ready again = %@",[self GetDBPath]);
	}
	return [db executeQuery:strQuery withArgumentsInArray:arrArg];
}


-(void)dealloc
{
//	[db release];
//	[super dealloc];
}

@end
