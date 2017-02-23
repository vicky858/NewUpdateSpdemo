//
//  SurveyPage.h
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "FMDatabase.h"
#import "Comorbidities.h"

@interface SurveyPage : UIViewController
//Blood group survey List of Answers

- (IBAction)AN:(id)sender;
- (IBAction)AP:(id)sender;
- (IBAction)BN:(id)sender;
- (IBAction)BP:(id)sender;
- (IBAction)ABN:(id)sender;
- (IBAction)ABP:(id)sender;
- (IBAction)ON:(id)sender;
- (IBAction)OP:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Aneg_out;
@property (weak, nonatomic) IBOutlet UIButton *Apos_out;
@property (weak, nonatomic) IBOutlet UIButton *Bneg_out;
@property (weak, nonatomic) IBOutlet UIButton *Bpos_out;
@property (weak, nonatomic) IBOutlet UIButton *ABneg_out;
@property (weak, nonatomic) IBOutlet UIButton *ABpos_out;
@property (weak, nonatomic) IBOutlet UIButton *Oneg_out;
@property (weak, nonatomic) IBOutlet UIButton *Opos_btn;
@property(retain,nonatomic)NSString *strPatid;

@end
