//
//  ViewController.h
//  SPdemo
//
//  Created by Manickam on 25/11/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientRegistration.h"

@protocol colldeleggate <NSObject>

-(void)getdatacollection:(NSData *)imgdata;

@end

@interface collectionview : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property(assign,nonatomic)id <colldeleggate> delegate;


- (IBAction)backBtn:(id)sender;

@end
