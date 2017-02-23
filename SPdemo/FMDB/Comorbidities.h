//
//  Co-morbidities.h
//  SPdemo
//
//  Created by Manickam on 06/02/17.
//  Copyright © 2017 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
@interface Comorbidities : UIViewController
{
    UIButton *btn;
}


@property (weak, nonatomic) IBOutlet UILabel *Anemia_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *Cancer_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *Depression_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *diabetes_lbl;
@property (weak, nonatomic) IBOutlet UILabel *Endocrine_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *GastroDise_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *heart_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *HBP_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *immune_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *Kidney_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *liver_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *Lung_lbl;
@property (weak, nonatomic) IBOutlet UILabel *Nerurological_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *obesity_lbl;
@property (weak, nonatomic) IBOutlet UILabel *Rheumatoid_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *None_Lbl;
@property(retain,nonatomic) NSString *strPatid;

- (IBAction)comorbities_btnAct:(id)sender;


@end
