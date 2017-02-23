//
//  SQLiteManager.h
//  iSurvey
//
//  Created by Prem on 15/07/10.
//  Copyright 2010 Solvedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
#import "FMDatabase.h"

@interface SQLiteManager : NSObject 
{
	
}

-(void)createDatabaseIfNeeded;
-(FMResultSet*) ExecuteQuery:(NSString*)strQuery;
-(NSString*)GetDBPath;
-(BOOL)ExecuteInsertQuery :(NSString*)strQuery withCollectionOfValues:(NSMutableArray*)objCollections;
-(BOOL)BeginTransaction;
-(BOOL)CommitLastQuery;
-(BOOL)rollBackTransaction;
-(void)OpenDB:(NSString*)strDBPath;
-(void)Close;
-(BOOL)ExecuteUpdateQuery:(NSString*)strQuery;
-(FMResultSet*) ExecuteQueryWithArg:(NSString*)strQuery Argument:(NSArray*)arrArg;
-(FMDatabase*) DBmanager;

@end
