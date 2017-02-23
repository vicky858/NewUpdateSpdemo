//
//  ViewController.m
//  SPdemo
//
//  Created by Manickam on 25/11/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import "collectionview.h"
#import "PatientRegistration.h"

@interface collectionview ()
{
    NSMutableArray *myArray;

 __weak IBOutlet UICollectionView *CollectionView;
}



@end

@implementation collectionview


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Alert Controller test..
   
    // Do any additional setup after loading the view.
    myArray=[[NSMutableArray alloc]init];
    
    [myArray addObject:[UIImage imageNamed:@"pat_2N@2x.png"]];
    [myArray addObject:[UIImage imageNamed:@"pat_5n@2x.png"]];
    [myArray addObject:[UIImage imageNamed:@"pat_6@2x.png"]];
    [myArray addObject:[UIImage imageNamed:@"pat_7@2x"]];
    [myArray addObject:[UIImage imageNamed:@"pat_8@2x"]];
    [myArray addObject:[UIImage imageNamed:@"pat_9@2x"]];
    [myArray addObject:[UIImage imageNamed:@"pat_10@2x"]];
    
    [myArray addObject:[UIImage imageNamed:@"Untitled-1.png"]];
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


//collection view delegate methods....

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [myArray count];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
           static NSString *identifier=@"Cell";
        
        UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        UIImageView *recipeImageView=(UIImageView *)[cell viewWithTag:201];
        cell.contentView.backgroundColor=[UIColor clearColor];
        //        cell.layer.borderWidth=1.5f;
        //        cell.layer.borderColor=[UIColor grayColor].CGColor;
        //       cell.layer.cornerRadius=8;
    
    
     recipeImageView.image=[myArray objectAtIndex:indexPath.row];
    
//        NSMutableDictionary *dicImag = [[NSMutableDictionary alloc] initWithDictionary:[ReadDocImg objectAtIndex:indexPath.row]];
//        self.imagecount.text=[NSString stringWithFormat:@"IMG:%d",[ReadDocImg count]];
//        NSString *imgPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_DIRECTORY,[dicImag objectForKey:@"NameKey"]];
//        UIImage *imagName = [UIImage imageWithContentsOfFile:imgPath];
//        recipeImageView.image=imagName;
//        
    
        //NSLog(@"Received image name %@",[dicImag objectForKey:@"NameKey"]);
        return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        UICollectionViewCell *cell= [collectionView cellForItemAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor orangeColor];
    
        UIImage *imagename=[myArray objectAtIndex:indexPath.row];
    
        NSData *imageData = UIImagePNGRepresentation(imagename);//[NSData dataWithData:UIImagePNGRepresentation(imagename)];
    
        //NSLog(@"images name:%@",imageData);
        //UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
       [[self delegate]getdatacollection:imageData];
    
    
       //     controler.imgData=imageData;
    
       [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)backBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end

