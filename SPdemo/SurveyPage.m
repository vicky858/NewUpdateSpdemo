//
//  SurveyPage.m
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import "SurveyPage.h"

@interface SurveyPage ()
{
    NSString *Answer;
    NSString *NameSurvey;
    NSMutableArray *SurveyArray;
}

@end

@implementation SurveyPage
@synthesize Aneg_out,Apos_out,Bneg_out,Bpos_out,ABneg_out,ABpos_out,Oneg_out,Opos_btn;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nf2pXZp.jpg"]];
    
   
    Aneg_out.layer.borderWidth=2;
    Aneg_out.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    Aneg_out.layer.cornerRadius=4;
    
    Apos_out.layer.borderWidth=2;
    Apos_out.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    Apos_out.layer.cornerRadius=4;
    
    Bneg_out.layer.borderWidth=2;
    Bneg_out.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    Bneg_out.layer.cornerRadius=4;
    
    Bpos_out.layer.borderWidth=2;
    Bpos_out.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    Bpos_out.layer.cornerRadius=4;
    
    ABneg_out.layer.borderWidth=2;
    ABneg_out.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    ABneg_out.layer.cornerRadius=4;
    
    ABpos_out.layer.borderWidth=2;
    ABpos_out.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    ABpos_out.layer.cornerRadius=4;
    
    Oneg_out.layer.borderWidth=2;
    Oneg_out.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    Oneg_out.layer.cornerRadius=4;
    
    Opos_btn.layer.borderWidth=2;
    Opos_btn.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    Opos_btn.layer.cornerRadius=4;
    

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
    NSString *strQry = [NSString stringWithFormat:@"select count(rowid) as totCount from PatientTable"];
    SQLiteManager *dbManage = [[SQLiteManager alloc] init];
    FMResultSet *result = [dbManage ExecuteQuery:strQry];
    if ([result next]) {
        totCt = [result intForColumn:@"totCount"];
    }
    return totCt;
}

-(void)surveyAnswerReload
{
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    SQLiteManager *sqlMng=[[SQLiteManager alloc]init];
    static NSString *strQry=@"INSERT INTO SurveyResult(Result_id,Patient_id,SurveyName)VALUES(?,?,?)";

    SurveyArray=[[NSMutableArray alloc]init];
    FMResultSet *fmr=[sqlMng ExecuteQuery:[NSString stringWithFormat:@"select max(rowid) as maxid from SurveyResult"]];
    NSString *str;
    if ([fmr next]) {
        str=[NSString stringWithFormat:@"%d_%@",[fmr intForColumn:@"maxid"]+1,currentDeviceId];
        }
    [SurveyArray addObject:str];
    [SurveyArray addObject:_strPatid];
    [SurveyArray addObject:NameSurvey];
    [sqlMng ExecuteInsertQuery:strQry withCollectionOfValues:SurveyArray];
    NSString *query=[NSString stringWithFormat:@"INSERT INTO ChoiceTab(Result_id,Choices)VALUES(?,?)"];
    [SurveyArray removeAllObjects];
    [SurveyArray addObject:str];
    [SurveyArray addObject:Answer];
    [sqlMng ExecuteInsertQuery:query withCollectionOfValues:SurveyArray];
}

- (IBAction)AN:(id)sender
{
    Answer=@"A(-) Negative";
    NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
    [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
- (IBAction)AP:(id)sender
{
    Answer=@"A(+) Postive";
     NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
     [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
- (IBAction)BN:(id)sender
{
    Answer=@"B(-) Negative";
     NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
     [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
- (IBAction)BP:(id)sender
{
    Answer=@"B(+) Positive";
     NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
     [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
- (IBAction)ABN:(id)sender
{
    Answer=@"AB(-) Negative";
     NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
     [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
- (IBAction)ABP:(id)sender
{
    Answer=@"AB(+) Postive";
     NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
     [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
- (IBAction)ON:(id)sender
{
    Answer=@"O(-) Negative";
     NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
     [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
- (IBAction)OP:(id)sender
{
    Answer=@"O(+) Postive";
     NameSurvey=@"Blood Group";
    [self surveyAnswerReload];
     [self performSegueWithIdentifier:@"ComorbiditiesView" sender:self];
}
#pragma prepareforsegue-methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ComorbiditiesView"]) {
      Comorbidities *cormobidit=[segue destinationViewController];
        cormobidit.strPatid=_strPatid;
    }
}
@end
