//
//  LocationPage.m
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import "LocationPage.h"

@interface LocationPage ()
{
    NSString *StrHip;
    NSString *StrKnee;
    NSMutableArray *LocationArray;
}

@end

@implementation LocationPage
//@synthesize hip_out,knee_out;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LocationArray=[[NSMutableArray alloc]init];
    StrHip=@"Hip";
    StrKnee=@"Knee";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(int )patientCount{
    int totCt = 0;
    NSString *strQry = [NSString stringWithFormat:@"select count(rowid) as totCount from Location"];
    SQLiteManager *dbManage = [[SQLiteManager alloc] init];
    FMResultSet *result = [dbManage ExecuteQuery:strQry];
    if ([result next]) {
        totCt = [result intForColumn:@"totCount"];
    }
    return totCt;
}

- (IBAction)Location_Hip_btn:(id)sender{
        StrHip=@"Hip";
        SQLiteManager *sqlMng=[[SQLiteManager alloc]init];
        static NSString *strQry=@"INSERT INTO Location(Loct_Name,Patient_id)VALUES(?,?)";
        LocationArray=[[NSMutableArray alloc]init];
        [LocationArray addObject:StrHip];
        [LocationArray addObject:_strPatientId];
        [sqlMng ExecuteInsertQuery:strQry withCollectionOfValues:LocationArray];
    [self performSegueWithIdentifier:@"SurveyView" sender:self];
}

- (IBAction)Location_Knee_btn:(id)sender{
       StrKnee=@"Knee";
        SQLiteManager *sqlMng=[[SQLiteManager alloc]init];
        static NSString *strQry=@"INSERT INTO Location(Loct_Name,Patient_id)VALUES(?,?)";
        LocationArray=[[NSMutableArray alloc]init];
        [LocationArray addObject:StrKnee];
        [LocationArray addObject:_strPatientId];
        [sqlMng ExecuteInsertQuery:strQry withCollectionOfValues:LocationArray];
    [self performSegueWithIdentifier:@"SurveyView" sender:self];
}
#pragma prepareSegu-methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"SurveyView"]) {
        SurveyPage *surveypage=[segue destinationViewController];
        surveypage.strPatid=_strPatientId;
    }
}
@end
