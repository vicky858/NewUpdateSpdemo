//
//  calenderView.m
//  SEPRODCCP
//
//  Created by administrator on 05/12/11.
//  Copyright 2011 Solvedge. All rights reserved.
//

#import "calenderView.h"


@implementation calenderView
@synthesize delegate;
@synthesize strTitle;
@synthesize dicSurPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)setMaximumDate:(NSDate*)dtMaxFrm{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dtString = [formatter stringFromDate:dtMaxFrm];
    dtMax = [formatter dateFromString:dtString];
}

-(void)setMinimumDate:(NSDate*)dtMinFrm{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dtString = [formatter stringFromDate:dtMinFrm];
    dtMin = [formatter dateFromString:dtString];
}

- (void)setTitleStatus:(NSString*)strTitleFrm{
   strTitle = strTitleFrm;
}
-(calenderView*)initMinMaxDate:(NSDictionary*)dicsender{
    self=[super initWithNibName:@"calenderView" bundle:nil];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dtString = [formatter stringFromDate:[dicsender objectForKey:@"maxdate"]];
    //    NSDate *dtSend = [formatter dat
    dtMax = [formatter dateFromString:dtString];
    NSString *dtString1 = [formatter stringFromDate:[dicsender objectForKey:@"mindate"]];
    dtMin = [formatter dateFromString:dtString1];
    NSString *dtString2 = [formatter stringFromDate:[dicsender objectForKey:@"defdate"]];
    dtDef = [formatter dateFromString:dtString2];
    strTitle = [dicsender objectForKey:@"header"];
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scvMonth.contentSize = CGSizeMake(150, 433);
    
    CGRect tmpRect = scvMonth.frame;
    tmpRect.origin.x=318;
    tmpRect.origin.y=384;
    scvMonth.frame = tmpRect;
    
    tmpRect = vewYear.frame;
    tmpRect.origin.x=318;
    tmpRect.origin.y=384;
    vewYear.frame = tmpRect;
    
    tmpRect = swMerdian.frame;
    tmpRect.size.width = 50;
    swMerdian.frame = tmpRect;
    if(dtDef){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtDef];
        [self setDateControl:components];
    }else{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
        [self setDateControl:components];
    }
    [sliderHour addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    if (strTitle) {
        lblStatus.text = strTitle;
        UIColor *color = [UIColor blueColor];
        lblStatus.layer.shadowColor = [color CGColor];
        lblStatus.layer.shadowRadius = 5.0f;
        lblStatus.layer.shadowOpacity = 1;
        lblStatus.layer.shadowOffset = CGSizeZero;
        lblStatus.layer.masksToBounds = NO;
    }
    if (dtDef) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        [formatter setDateFormat:@"d"];
        lblDay.text = [formatter stringFromDate:dtDef];
        [formatter setDateFormat:@"EEEE"];
        lblDayString.text = [formatter stringFromDate:dtDef];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        txtDate.text = [formatter stringFromDate:dtDef];
    }    
}
- (void)setDateControl:(NSDateComponents*)dateComp{
    NSDate * sendDate = [[NSCalendar currentCalendar] dateFromComponents:dateComp];
    NSInteger month = [dateComp month];
    NSInteger year = [dateComp year];    
    btnMonth.tag = month;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    [btnMonth setTitle:[formatter stringFromDate:sendDate] forState:UIControlStateNormal];    
    [btnYear setTitle:[NSString stringWithFormat:@"%ld",(long)year] forState:UIControlStateNormal];
    btnYear.tag = year;
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                       inUnit:NSCalendarUnitMonth
                                                      forDate:[[NSCalendar currentCalendar] dateFromComponents:dateComp]];   
    [dateComp setDay:1];
    
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:dateComp];
    [formatter setDateFormat:@"e"];
    int wekC = [[formatter stringFromDate:date] intValue];
    wekC = wekC - 1;    
    NSDate *tmpDate = nil;
    NSComparisonResult resultMax;
    BOOL isEnable;
    [formatter setDateFormat:@"MM/dd/yyyy"];
    BOOL isDefSet = NO;
    for (int i = 0; i < [vewDays.subviews count]; i++) 
    {
        if ([[vewDays.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]) 
        {
            UIButton *tmButton = (UIButton*)[vewDays.subviews objectAtIndex:i];
            if ((tmButton.tag - wekC >= 1) && (tmButton.tag - wekC <= range.length) ) {
                [tmButton setTitle:[NSString stringWithFormat:@"%ld",(tmButton.tag - wekC)] forState:UIControlStateNormal];
                tmButton.hidden = false;
                isEnable = YES;
                if (dtMax) {
                    tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)btnMonth.tag,(tmButton.tag - wekC),(long)btnYear.tag]];
                    resultMax = [tmpDate compare:dtMax];
                    if (resultMax == NSOrderedDescending) {
                        isEnable = NO;
                    }
                }
                if (dtMin) {
                    tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)btnMonth.tag,(tmButton.tag - wekC),(long)btnYear.tag]];
                    resultMax = [tmpDate compare:dtMin];
                    if (resultMax == NSOrderedAscending) {
                        isEnable = NO;
                    }
                }
                if (isEnable == YES) {
                    tmButton.enabled = YES;
                    if (isDefSet == NO) {
                        if (tmpDate) {
                            sendDate = tmpDate;
                        }
                        isDefSet = YES;
                    }
                }else{
                    tmButton.enabled = NO;
                }
            }else{
                tmButton.hidden = true;
            } 
        }
    }
    
    [formatter setDateFormat:@"d"];
    lblDay.text = [formatter stringFromDate:sendDate];
    
    [formatter setDateFormat:@"EEEE"];
    lblDayString.text = [formatter stringFromDate:sendDate];
    
    [formatter setDateFormat:@"MM/dd/yyyy"];
    txtDate.text = [formatter stringFromDate:sendDate];
}

- (IBAction)btnAllDay_Touch:(id)sender {
    UIButton *send = (UIButton*)sender;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    [components setDay:[send.titleLabel.text intValue]];
    [components setMonth:btnMonth.tag];
    [components setYear:btnYear.tag];
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    txtDate.text = [formatter stringFromDate:date];
    lblDay.text = send.titleLabel.text;
    [formatter setDateFormat:@"EEEE"];
    lblDayString.text = [formatter stringFromDate:date];
}

- (void)viewDidUnload{
    btnBack = nil;
    btnNext = nil;
    btnMonth = nil;
    btnYear = nil;
    vewDays = nil;
    scvMonth = nil;
    vewYear = nil;
    txtDate = nil;
    btnDone = nil;
    lblDay = nil;
    lblDay = nil;
    txtHour = nil;
    txtMin = nil;
    swMerdian = nil;
    vewSlider = nil;
    sliderHour = nil;
    btnHH = nil;
    btnmm = nil;
    btnHMok = nil;
    lblStatus = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}

- (IBAction)btnExit_Touch:(id)sender {
    if ([self.dicSurPage objectForKey:@"surpage"]) {
        NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
        [dicTemp setObject:@"exit" forKey:@"status"];
        [[self delegate] calViewSurveyDateSelected:dicTemp];
    }else{
        [[self delegate]calViewDateSelected:@"exit"];
    }
    [self.view removeFromSuperview];
}

- (IBAction)btnHMok_Touch:(id)sender {
    vewSlider.hidden = true;
}

- (IBAction)btnYear_Touch:(id)sender {
    if (vewYear.hidden ==true) {
        UIButton *send = (UIButton*)sender;
        int selYear = (int)send.tag;
        selYear = selYear - 8;
        NSDate *tmpDate;
        NSComparisonResult resultMax;
        BOOL isEnable;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMax];
        int dayMax = (int)[components day];
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMin];
        int dayMin = (int)[components day];
        for (int i = 0; i < [vewYear.subviews count]; i++) 
        {
            if ([[vewYear.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]) 
            {
                UIButton *tmButton = (UIButton*)[vewYear.subviews objectAtIndex:i];
                [tmButton setTitle:[NSString stringWithFormat:@"%ld",(tmButton.tag + selYear)] forState:UIControlStateNormal];
                isEnable = YES;
                if (dtMax) {
                    tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)btnMonth.tag,dayMax,(tmButton.tag + selYear)]];
                    resultMax = [tmpDate compare:dtMax];
                    if (resultMax == NSOrderedDescending) {
                        isEnable = NO;
                    }
                }
                if (dtMin) {
                    tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)btnMonth.tag,dayMin,(tmButton.tag + selYear)]];
                    resultMax = [tmpDate compare:dtMin];
                    if (resultMax == NSOrderedAscending) {
                        isEnable = NO;
                    }
                }
                if (isEnable == YES) {
                    tmButton.enabled = YES;
                }else{
                    tmButton.enabled = NO;
                }
            }
        }
        vewYear.hidden = false;
    }else{
        vewYear.hidden = true;
    }
}

- (IBAction)btnBack_Touch:(id)sender {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    [components setDay:1];
    if (btnMonth.tag - 1 < 1) {
        [components setMonth:12];
        [components setYear:[btnYear.titleLabel.text intValue] - 1];
    }else{
        [components setMonth:btnMonth.tag - 1];
        [components setYear:[btnYear.titleLabel.text intValue]];
    }
    [self setDateControl:components];
}

- (IBAction)btnNext_Touch:(id)sender {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
    [components setDay:1];
    if (btnMonth.tag + 1 > 12) {
        [components setMonth:1];
        [components setYear:[btnYear.titleLabel.text intValue] + 1];
    }else{
        [components setMonth:btnMonth.tag + 1];
        [components setYear:[btnYear.titleLabel.text intValue]];
    }
    [self setDateControl:components];

}

- (IBAction)btnMonth_Touch:(id)sender {
    if (scvMonth.hidden == true) {
        scvMonth.hidden = false;
        NSDate *tmpDate;
        NSComparisonResult resultMax;
        BOOL isEnable;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMax];
        int dayMax = (int)[components day];
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMin];
        int dayMin = (int)[components day];
        for (int i = 0; i < [scvMonth.subviews count]; i++) 
        {
            if ([[scvMonth.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]) 
            {
                UIButton *tmButton = (UIButton*)[scvMonth.subviews objectAtIndex:i];
                isEnable = YES;
                if (dtMax) {
                    tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)tmButton.tag,dayMax,(long)btnYear.tag]];
                    resultMax = [tmpDate compare:dtMax];
                    if (resultMax == NSOrderedDescending) {
                        isEnable = NO;
                    }
                }
                if (dtMin) {
                    tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)tmButton.tag,dayMin,(long)btnYear.tag]];
                    resultMax = [tmpDate compare:dtMin];
                    if (resultMax == NSOrderedAscending) {
                        isEnable = NO;
                    }
                }
                if (isEnable == YES) {
                    tmButton.enabled = YES;
                }else{
                    tmButton.enabled = NO;
                }

            }
        }
    }else{
        scvMonth.hidden = true;
    }
}

- (IBAction)btnDone_Touch:(id)sender {
    if ([txtDate.text length]>0) {
        if ([self.dicSurPage objectForKey:@"surpage"]) {
            NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
            [dicTemp setObject:@"yes" forKey:@"status"];
            [dicTemp setObject:[self.dicSurPage objectForKey:@"format"] forKey:@"format"];
            NSString *strDate = [NSString stringWithFormat:@"%@ %@:%@",txtDate.text,btnHH.titleLabel.text,btnmm.titleLabel.text];
            [dicTemp setObject:strDate forKey:@"date"];
            [[self delegate] calViewSurveyDateSelected:dicTemp];
        }else{
            [[self delegate]calViewDateSelected:[NSString stringWithFormat:@"%@ %@:%@",txtDate.text,btnHH.titleLabel.text,btnmm.titleLabel.text]];
        }
        [self.view removeFromSuperview];
    }else{
        UIAlertController *objalert=[UIAlertController alertControllerWithTitle:@"Message:" message:@"Please select the date" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [objalert addAction:nobutton];
        
        [self presentViewController:objalert animated:YES completion:nil];
    }
}

- (IBAction)btnAllMonth_Touch:(id)sender {
    UIButton *send = (UIButton*)sender;
//    [btnMonth setTitle:send.titleLabel.text forState:UIControlStateNormal];
    scvMonth.hidden = true;
    
    if (send.tag != btnMonth.tag) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
        [components setDay:1];
        [components setMonth:send.tag];
        [components setYear:[btnYear.titleLabel.text intValue]];
        [self setDateControl:components];
    }  
    
}

- (IBAction)btnAllYear_Touch:(id)sender {
    UIButton *send = (UIButton*)sender;
//    int yearCal = [send.titleLabel.text intValue];
//    btnYear.tag = yearCal;
//    [btnYear setTitle:[NSString stringWithFormat:@"%d",yearCal] forState:UIControlStateNormal];
    vewYear.hidden = true;
    if (send.tag != btnYear.tag) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:[NSDate date]];
        [components setDay:1];
        [components setMonth:btnMonth.tag];
        [components setYear:[send.titleLabel.text intValue]];
        [self setDateControl:components];
    }  
}

- (IBAction)btnYearBack_Touch:(id)sender {
    UIButton *send = (UIButton*)sender;
    int selYear = [send.titleLabel.text intValue];
    selYear = selYear - 13;
    NSDate *tmpDate;
    NSComparisonResult resultMax;
    BOOL isEnable;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMax];
    int dayMax = (int)[components day];
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMin];
    int dayMin = (int)[components day];
    for (int i = 0; i < [vewYear.subviews count]; i++) 
    {
        if ([[vewYear.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]) 
        {
            UIButton *tmButton = (UIButton*)[vewYear.subviews objectAtIndex:i];
            [tmButton setTitle:[NSString stringWithFormat:@"%ld",(tmButton.tag + selYear)] forState:UIControlStateNormal];
            isEnable = YES;
            if (dtMax) {
                tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)btnMonth.tag,dayMax,(tmButton.tag + selYear)]];
                resultMax = [tmpDate compare:dtMax];
                if (resultMax == NSOrderedDescending) {
                    isEnable = NO;
                }
            }
            if (dtMin) {
                tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)btnMonth.tag,dayMin,(tmButton.tag + selYear)]];
                resultMax = [tmpDate compare:dtMin];
                if (resultMax == NSOrderedAscending) {
                    isEnable = NO;
                }
            }
            if (isEnable == YES) {
                tmButton.enabled = YES;
            }else{
                tmButton.enabled = NO;
            }
        }
    }
}

- (IBAction)btnYearNag_Touch:(id)sender {
    UIButton *send = (UIButton*)sender;
    
    int selYear = [send.titleLabel.text intValue];
    selYear = selYear - 2;
    NSDate *tmpDate;
    NSComparisonResult resultMax;
    BOOL isEnable;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMax];
    int dayMax = (int)[components day];
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal fromDate:dtMin];
    int dayMin = (int)[components day];
    for (int i = 0; i < [vewYear.subviews count]; i++) 
    {
        if ([[vewYear.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]) 
        {
            UIButton *tmButton = (UIButton*)[vewYear.subviews objectAtIndex:i];
            [tmButton setTitle:[NSString stringWithFormat:@"%ld",(tmButton.tag + selYear)] forState:UIControlStateNormal];
            isEnable = YES;
            if (dtMax) {
                tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)btnMonth.tag,dayMax,(tmButton.tag + selYear)]];
                resultMax = [tmpDate compare:dtMax];
                if (resultMax == NSOrderedDescending) {
                    isEnable = NO;
                }
            }
            if (dtMin) {
                tmpDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld/%d/%ld",(long)btnMonth.tag,dayMin,(tmButton.tag + selYear)]];
                resultMax = [tmpDate compare:dtMin];
                if (resultMax == NSOrderedAscending) {
                    isEnable = NO;
                }
            }
            if (isEnable == YES) {
                tmButton.enabled = YES;
            }else{
                tmButton.enabled = NO;
            }
        }
    }
}

- (void)sliderAction:sender{
    UISlider *tmSlider = (UISlider*)sender;
    if (tmSlider.tag == 1) {
        [btnHH setTitle:[NSString stringWithFormat:@"%0.0f",tmSlider.value] forState:UIControlStateNormal];
    }else if(tmSlider.tag == 2){
        [btnmm setTitle:[NSString stringWithFormat:@"%0.0f",tmSlider.value] forState:UIControlStateNormal];
    }
}

- (IBAction)btnmmTouch:(id)sender {
    if (vewSlider.hidden == true) {
        UIButton *tmpFie = (UIButton*)sender;
        sliderHour.tag = 2;
        sliderHour.minimumValue = 1;
        sliderHour.maximumValue = 59;
        int slVal = [tmpFie.titleLabel.text intValue];
        sliderHour.value = slVal;
        vewSlider.hidden = false;
    }else{
        vewSlider.hidden = true;
    }
}

- (IBAction)btnHHTouch:(id)sender {
    if (vewSlider.hidden == true) {
        UIButton *tmpFie = (UIButton*)sender;
        sliderHour.tag = 1;
        sliderHour.minimumValue = 1;
        sliderHour.maximumValue = 23;
        int slVal = [tmpFie.titleLabel.text intValue];
        sliderHour.value = slVal;
        vewSlider.hidden = false;
    }else{
        vewSlider.hidden = true;
    }

}

@end
