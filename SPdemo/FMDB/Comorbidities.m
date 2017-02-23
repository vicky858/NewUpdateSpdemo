//
//  Co-morbidities.m
//  SPdemo
//
//  Created by Manickam on 06/02/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import "Comorbidities.h"

@interface Comorbidities ()
{
    NSMutableArray *multpleselect;
}
@end

@implementation Comorbidities

- (void)viewDidLoad {
    [super viewDidLoad];
    multpleselect=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
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

- (IBAction)comorbities_btnAct:(id)sender
{
    UIButton *btntwo=(UIButton *)sender;
        if ([btntwo isSelected]) {
        for (UIView *viw in self.view.subviews) {
            if ([viw isKindOfClass:[UIImageView class]]) {
                UIImageView *imgone=(UIImageView *)viw;
                if (btntwo.tag==imgone.tag) {
                    [imgone setImage:nil];
                    break;
                }
                
            }
        }

        NSString *str=[btntwo titleForState:UIControlStateNormal];
        [multpleselect removeObject:str];
        [btntwo setSelected:NO];

    }
  
    else{
        for (UIView *viw in self.view.subviews) {
            if ([viw isKindOfClass:[UIImageView class]]) {
                UIImageView *imgone=(UIImageView *)viw;
                if (btntwo.tag==imgone.tag) {
                    [imgone setImage:[UIImage imageNamed:@"1486417274_check.png"]];
                    break;
                }
               
            }
        }
        NSString *str=[btntwo titleForState:UIControlStateNormal];
        [multpleselect addObject:str];
         [btntwo setSelected:YES];
    }
    for (int i=0;i<[multpleselect count];i++) {
        if ([[multpleselect objectAtIndex:i]isEqualToString:@"None"]) {
           
        }
    }
   
    NSLog(@"%@",multpleselect);
}
- (IBAction)contin_action:(id)sender {
    if ([multpleselect count]!=0) {
        UIDevice *device = [UIDevice currentDevice];
        NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
        SQLiteManager *dbmgr=[[SQLiteManager alloc]init];
         static NSString *strQry=@"INSERT INTO SurveyResult(Result_id,Patient_id,SurveyName)VALUES(?,?,?)";
        NSString *strtwo;
        FMResultSet *fmr=[dbmgr ExecuteQuery:[NSString stringWithFormat:@"select max(rowid) as maxid from SurveyResult"]];
        if ([fmr next]) {
            strtwo=[NSString stringWithFormat:@"%d_%@",[fmr intForColumn:@"maxid"]+1,currentDeviceId];
        }
        NSMutableArray *ChoiceArr=[[NSMutableArray alloc]init];
        [ChoiceArr addObject:strtwo];
        [ChoiceArr addObject:_strPatid];
        [ChoiceArr addObject:@"Co-morbidities"];
        NSString *query=[NSString stringWithFormat:@"INSERT INTO ChoiceTab(Result_id,Choices)VALUES(?,?)"];
        [dbmgr ExecuteInsertQuery:strQry withCollectionOfValues:ChoiceArr];

             for (int i=0; i<[multpleselect count];i++) {
                 NSMutableArray *dbacessarray=[[NSMutableArray alloc]init];
                 [dbacessarray addObject:strtwo];
                 [dbacessarray addObject:[multpleselect objectAtIndex:i]];
                 if ([[multpleselect objectAtIndex:i] isEqualToString:@"None"]) {
                     [multpleselect removeAllObjects];
                 }
                 [dbmgr ExecuteInsertQuery:query withCollectionOfValues:dbacessarray];
        }
    }
    [self performSegueWithIdentifier:@"PatientListView" sender:self];
}
@end
