//
//  PatientListTable.m
//  SPdemo
//
//  Created by Manickam on 20/10/16.
//  Copyright © 2016 Solvedge. All rights reserved.
//

#import "PatientListTable.h"
#import "SQLiteManager.h"
#import "FMDatabase.h"
#import "PatientHistry.h"
#import "PatientReport.h"
#import "SurveyResult.h"
#import "Choices.h"
#import <QuartzCore/QuartzCore.h>
#import <MultipeerConnectivity/MCBrowserViewController.h>
#import "SessionContainer.h"
#import "Transcript.h"
#import "library.h"

@import MultipeerConnectivity;


NSString * const kNSDefaultDisplayName = @"displayNameKey";
NSString * const kNSDefaultServiceType = @"serviceTypeKey";


@interface PatientListTable ()<MCBrowserViewControllerDelegate, UITextFieldDelegate, SessionContainerDelegate, UINavigationControllerDelegate,UISearchBarDelegate>
{
    NSMutableArray *PatientListArry;
    NSMutableArray *JoinDataArray;
    NSMutableArray *myArray;
    NSMutableArray *DeleteArray;
    UIImageView *recipeImageView;
    NSMutableArray *ArrSingleShare;
    PatientHistry *patHist;
    NSMutableArray *ArrPushPatient;
}

+ (NSData *) base64DataFromString:(NSString *)string;


@end

@implementation PatientListTable
@synthesize filtereddata,searchBar,isFiltered;
@synthesize rehreshout;
@synthesize addNewOut;
@synthesize tblPatientList;
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.layer.borderColor = [[UIColor greenColor]CGColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"504080170.jpeg"]];
    searchBar.delegate=(id)self;
    filtereddata=[[NSMutableArray alloc]init];
    myArray=[[NSMutableArray alloc]init];
    DeleteArray=[[NSMutableArray alloc]init];
    ArrSingleShare=[[NSMutableArray alloc]init];
    JoinDataArray=[[NSMutableArray alloc]init];
    PatientListArry=[[NSMutableArray alloc]init];
    ArrPushPatient=[[NSMutableArray alloc]init];
    [myArray addObject:[UIImage imageNamed:@"pat_2N@2x.png"]];
    [myArray addObject:[UIImage imageNamed:@"pat_5n@2x.png"]];
    [myArray addObject:[UIImage imageNamed:@"pat_6@2x.png"]];
    [myArray addObject:[UIImage imageNamed:@"pat_7@2x"]];
    [myArray addObject:[UIImage imageNamed:@"pat_8@2x"]];
    [myArray addObject:[UIImage imageNamed:@"pat_9@2x"]];
    [myArray addObject:[UIImage imageNamed:@"pat_10@2x"]];
    [myArray addObject:[UIImage imageNamed:@"Untitled-1.png"]];
    // Init transcripts array to use as table view data source
    _transcripts = [NSMutableArray new];
    _imageNameIndex = [NSMutableDictionary new];
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"Name :%@",[[device identifierForVendor]UUIDString]);
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    NSString *DisplayName=[NSString stringWithFormat:@"[%@]-%@",deviceInfo.name,currentDeviceId];
    self.displayName=DisplayName;
    self.serviceType=@"SolvEdge";
//    if (self.displayName && self.serviceType) {
//        // Show the service type (room name) as a title
//        //self.navigationItem.title = self.serviceType;
//        // create the session
//        [self createSession];
//    }
    NSLog(@"Checking");
    [self createSession];
    NSString *Statuslbl=[NSString stringWithFormat:@"%@ Not Connected",deviceInfo.name];
    _devicename.text=Statuslbl;
    _devicename.textColor=[UIColor redColor];
    library *lib = [library sharedInstance];
    if (lib.ClrStr) {
        _devicename.textColor=lib.ClrStr;
    }
    NSUserDefaults *UdSession=[NSUserDefaults standardUserDefaults];
    if ([UdSession objectForKey:@"displayName"]){
        _devicename.text = [UdSession objectForKey:@"displayName"];
    }
    
    [tblPatientList reloadData];
    
    tblPatientList.backgroundColor=[UIColor clearColor];
    rehreshout.layer.cornerRadius = 6.5f;
    rehreshout.layer.borderWidth=2;
    rehreshout.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
    addNewOut.layer.cornerRadius = 6.5f;
    addNewOut.layer.borderWidth=2;
    addNewOut.layer.borderColor=[[UIColor colorWithRed:50/255.0f green:84/255.0f blue:255/255.0f alpha:1.0]CGColor];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self getDataFromDB];
    [tblPatientList reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Stop listening for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)getDataFromDB{
    [JoinDataArray removeAllObjects];
    [PatientListArry removeAllObjects];
    [filtereddata removeAllObjects];
    SQLiteManager *dbmang=[[SQLiteManager alloc]init];
    FMResultSet *fmr=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM PatientTable"]];
    while ([fmr next])
    {
        PatientHistry *ph=[[PatientHistry alloc]init];
        ph.patientid=[fmr stringForColumn:@"Patient_id"];
        ph.patientname=[fmr stringForColumn:@"PatientName"];
        ph.dob=[fmr stringForColumn:@"Dob"];
        ph.gender=[fmr stringForColumn:@"Gender"];
        ph.dataForImag=[fmr dataForColumn:@"Img_data"];
        [JoinDataArray addObject:ph];
    }
    for (PatientHistry *ph in JoinDataArray)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM Location where Patient_id='%@'",ph.patientid];
        fmr=[dbmang ExecuteQuery:query];
        while ([fmr next])
        {
            ph.locationName=[fmr stringForColumn:@"Loct_Name"];
        }
        fmr=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM SurveyResult where Patient_id='%@'",ph.patientid]];
        while ([fmr next])
        {
            SurveyResult *sr=[[SurveyResult alloc]init];
            sr.Resultid=[fmr stringForColumn:@"Result_id"];
            sr.surveyname=[fmr stringForColumn:@"SurveyName"];
            [ph.Arrsurveyresult addObject:sr];
//            ph.surveyname=[fmr stringForColumn:@"SurveyName"];
//            ph.answer=[fmr stringForColumn:@"Answer"];
        }
        for (SurveyResult *srone in ph.Arrsurveyresult)
        {
            NSString *steqery=[NSString stringWithFormat:@"SELECT * FROM ChoiceTab where Result_id='%@'",srone.Resultid];
            fmr=[dbmang ExecuteQuery:steqery];
            while ([fmr next]) {
                Choices *ch=[[Choices alloc]init];
                ch.resultid=[fmr stringForColumn:@"Result_id"];
                ch.choice=[fmr stringForColumn:@"Choices"];
                [srone.Arrchoices addObject:ch];
            }
        }
        
    }
    fmr=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT PatientName FROM PatientTable"]];
    while ([fmr next])
    {
        [PatientListArry addObject:[NSString stringWithFormat:@"%@",[fmr stringForColumn:@"PatientName"]]];

    }
    filtereddata = [JoinDataArray mutableCopy];
    [tblPatientList reloadData];
}

#pragma mark - Table View delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
    return 1;
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    NSInteger rowcount;
    rowcount=filtereddata.count;
    return rowcount;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    tableView.layoutMargins=UIEdgeInsetsZero;
    tableView.separatorInset=UIEdgeInsetsZero;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    recipeImageView=(UIImageView *)[cell viewWithTag:100];
    recipeImageView.layer.cornerRadius=40.5f;
    recipeImageView.layer.masksToBounds = YES;
    UILabel *ImageNameLabel = (UILabel *)[cell viewWithTag:101];
    PatientHistry *phon=[self.filtereddata objectAtIndex:indexPath.row];
    ImageNameLabel.text = phon.patientname;
    UIImage *imgfromdata=[UIImage imageWithData:phon.dataForImag];
    recipeImageView.image=imgfromdata;
    UILabel *doblabel = (UILabel *)[cell viewWithTag:102];
    PatientHistry *phonone=[self.filtereddata objectAtIndex:indexPath.row];
    doblabel.text = phonone.dob;
    cell.backgroundColor=[UIColor clearColor];
    UILabel *showreport = (UILabel *)[cell viewWithTag:103];
    showreport.layer.cornerRadius = 6.5f;
    showreport.layer.borderWidth=2;
    showreport.layer.borderColor=[[UIColor colorWithRed:51/255.0f green:92/255.0f blue:255/255.0f alpha:1.0]CGColor];
    
return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientHistry *phon=[filtereddata objectAtIndex:indexPath.row];
    patHist=phon;
    [self performSegueWithIdentifier:@"PatientReportView" sender:self];
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
     //Share Action
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        PatientHistry *phon=[filtereddata objectAtIndex:indexPath.row];
        [filtereddata removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [DeleteArray removeAllObjects];
        ArrSingleShare=[[NSMutableArray alloc]init];
        SQLiteManager *dbmang=[[SQLiteManager alloc]init];
        FMResultSet *fmr=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM PatientTable where Patient_id='%@'",phon.patientid]];
        while ([fmr next])
        {
            NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
            [dictOne setObject:[fmr stringForColumn:@"PatientName"] forKey:@"patientname"];
            [dictOne setObject:[fmr stringForColumn:@"Dob"] forKey:@"Dob"];
            [dictOne setObject:[fmr stringForColumn:@"Gender"] forKey:@"Gender"];
            [dictOne setObject:[fmr stringForColumn:@"Patient_id"] forKey:@"patientid"];
            //convert data TO string
            NSData *dataforimage=[NSData dataWithData:[fmr dataForColumn:@"Img_data"]];
            NSString *str=[NSString base64StringFromData:dataforimage length:0];
            //NSLog(@"value for String :%@",str);
            [dictOne setObject:str    forKey:@"imagedata"];
            [ArrSingleShare addObject:dictOne];
        }
        
        for (NSMutableDictionary *dictAll in ArrSingleShare) {
            NSMutableArray *Two=[[NSMutableArray alloc]init];
            FMResultSet *fmr1=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM Location where Patient_id='%@'",phon.patientid]];
            while ([fmr1 next])
            {
                NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
                [dictOne setObject:[fmr1 stringForColumn:@"Loct_Name"] forKey:@"locationname"];
                [dictOne setObject:[fmr1 stringForColumn:@"Patient_id"] forKey:@"patientid"];
                [Two addObject:dictOne];
            }
            [dictAll setObject:Two forKey:@"Location"];
            NSMutableArray *Three=[[NSMutableArray alloc]init];
            FMResultSet *fmr2=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM SurveyResult where Patient_id='%@'",phon.patientid]];
            while ([fmr2 next])
            {
                NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
                [dictOne setObject:[fmr2 stringForColumn:@"Result_id"] forKey:@"resultid"];
                [dictOne setObject:[fmr2 stringForColumn:@"Patient_id"] forKey:@"patientid"];
                [dictOne setObject:[fmr2 stringForColumn:@"SurveyName"] forKey:@"surveyname"];
                [Three addObject:dictOne];
            }
            for (NSMutableDictionary *dictSec in Three) {
                NSMutableArray *Four=[[NSMutableArray alloc]init];
                FMResultSet *fmr3=[dbmang ExecuteQuery:[NSString stringWithFormat:@"select * from ChoiceTab where Result_id in (select Result_id from surveyResult where Patient_id='%@')",phon.patientid]];
                while ([fmr3 next])
                {
                    NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
                    [dictOne setObject:[fmr3 stringForColumn:@"Result_id"] forKey:@"resultid"];
                    [dictOne setObject:[fmr3 stringForColumn:@"Choices"] forKey:@"choices"];
                    [Four addObject:dictOne];
                }
                [dictSec setObject:Four forKey:@"choices"];
            }
            [dictAll setObject:Three forKey:@"surveyresult"];
        }
        
        [self shareAlert:phon.patientname];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTableView];
        });

    }];
    editAction.backgroundColor = [UIColor lightGrayColor];
    //editAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"screenShare.png"]];
    
    //Delete Action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
         PatientHistry *phon=[filtereddata objectAtIndex:indexPath.row];
        [filtereddata removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        SQLiteManager *manager = [[SQLiteManager alloc]init];
        NSString *strQuery = [NSString stringWithFormat:@"Delete from PatientTable where Patient_id= '%@'",phon.patientid];
        [manager ExecuteUpdateQuery:strQuery];
        NSString *strQuery1 = [NSString stringWithFormat:@"Delete from Location where Patient_id= '%@'",phon.patientid];
        [manager ExecuteUpdateQuery:strQuery1];
        NSString *strQuery3 = [NSString stringWithFormat:@"Delete from ChoiceTab where Result_id in (select Result_id from surveyResult where Patient_id='%@')",phon.patientid];
        [manager ExecuteUpdateQuery:strQuery3];
        NSString *strQuery2 = [NSString stringWithFormat:@"Delete from SurveyResult where Patient_id= '%@'",phon.patientid];
        [manager ExecuteUpdateQuery:strQuery2];
        
        NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
        [dictOne setObject:phon.patientid forKey:@"patientid"];
        [DeleteArray addObject:dictOne];
        [self deleteAlert:phon.patientname];
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
//    deleteAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"share-icons.png"]];
    return @[deleteAction,editAction];
}

#pragma mark - prepare for segue methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"PatientReportView"]) {
        PatientReport *Patrprt=[segue destinationViewController];
        Patrprt.Phishiory=patHist;
    }
}

#pragma mark - search bar Delegate
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(nonnull NSString *)text
{
    [filtereddata removeAllObjects];
    if (text.length > 0) {
        for (PatientHistry *food in JoinDataArray)
        {
            NSRange nameRange=[food.patientname rangeOfString:text options:NSCaseInsensitiveSearch];
            //NSRange descriptionrange=[food.description rangeOfString:text options:NSCaseInsensitiveSearch];
            if (nameRange.location!=NSNotFound)
            {
                [filtereddata addObject:food];
            }
        }
    }else{
        filtereddata =[JoinDataArray mutableCopy];
    }
     [tblPatientList reloadData];
}
#pragma mark - MCBrowserViewControllerDelegate methods
// Override this method to filter out peers based on application specific needs
- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
//    NSLog(@"Found a nearby advertising peer %@ withDiscoveryInfo %@", peerID, info);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"peerConnectionChanged" object:info];
    return YES;
}
// Override this to know when the user has pressed the "done" button in the MCBrowserViewController

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
// Override this to know when the user has pressed the "cancel" button in the MCBrowserViewControllerre
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - SessionContainerDelegate
-(void)reloadTableView
{
    [self getDataFromDB];
    [tblPatientList reloadData];
}
-(void)displayConnectionStatus:(NSString *)status RecePeer:(NSString *)recePer color:(UIColor *)clr
{
    UIDevice *deviceInfo = [UIDevice currentDevice];
    NSString *str=[NSString stringWithFormat:@"%@ %@",deviceInfo.name,status];
    _devicename.text=str;
    _devicename.textColor=clr;
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    [userDe setObject:str forKey:@"displayName"];
    [userDe synchronize];
}
-(void)deletePatFrom:(NSString *)msg
{
    NSString *str=[NSString stringWithFormat:@"%@",msg];
    UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Patient Deleted From" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                            //No Action
                             }];
    [alertNew addAction:nobutton];
    [self presentViewController:alertNew animated:YES completion:nil];

}
- (void)receivedTranscript:(Transcript *)transcript
{
    // Add to table view data source and update on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self insertTranscript:transcript];
    });
}
- (void)updateTranscript:(Transcript *)transcript
{
    // Find the data source index of the progress transcript
    NSNumber *index = [_imageNameIndex objectForKey:transcript.imageName];
    NSUInteger idx = [index unsignedLongValue];
    // Replace the progress transcript with the image transcript
    [_transcripts replaceObjectAtIndex:idx withObject:transcript];
    
    }
-(void)shareAlertDelegate:(NSString *)msg
{
    NSString *str=[NSString stringWithFormat:@"%@",msg];
   
    UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Received Patient From" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 //no action
                             }];
    [alertNew addAction:nobutton];
    [self presentViewController:alertNew animated:YES completion:nil];
  
}
#pragma mark - private methods

// Private helper method for the Multipeer Connectivity local peerID, session, and advertiser.  This makes the application discoverable and ready to accept invitations
- (void)createSession{
    // Create the SessionContainer for managing session related functionality.
    library *lib = [library sharedInstance];
    if (!lib.sessionCont) {
        self.sessionContainer = [[SessionContainer alloc] initWithDisplayName:self.displayName serviceType:self.serviceType];
        lib.sessionCont = self.sessionContainer;
    }else{
        self.sessionContainer = lib.sessionCont;
    }
    _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:self.serviceType discoveryInfo:nil session:_sessionContainer.session];
     //Set this view controller as the SessionContainer delegate so we can display incoming Transcripts and session state changes in our table view.
    _sessionContainer.delegate = self;
}
// Helper method for inserting a sent/received message into the data source and reload the view.
// Make sure you call this on the main thread
- (void)insertTranscript:(Transcript *)transcript
{    // Add to the data source
    [_transcripts addObject:transcript];
}
#pragma mark - IBAction methods
// Action method when pressing the "browse" (search icon).  It presents the MCBrowserViewController: a framework UI which enables users to invite and connect to other peers with the same room name (aka service type).
- (IBAction)browseForPeers:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:_displayName];
    NSLog(@"%@",peerID);
    
    // Instantiate and present the MCBrowserViewController
    MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:self.serviceType session:self.sessionContainer.session];
    browserViewController.delegate = self;
    browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
    browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers;
    [self presentViewController:browserViewController animated:YES completion:nil];
  
}
- (IBAction)Refresh_btn:(id)sender
{
    UIAlertController *objalert=[UIAlertController alertControllerWithTitle:@"Attention" message:@"Please select the follwing process" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *PullData=[UIAlertAction actionWithTitle:@"Pull Data" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 [self pullDatamethod];
                                 
                             }];
    UIAlertAction *ShareData=[UIAlertAction actionWithTitle:@"Push Data" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              {
                                  [self sendMessageTapped];
                              }];
    UIAlertAction *Disconnect=[UIAlertAction actionWithTitle:@"Disconnect Device" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
                                   [self reloadTableView];
                                   [_advertiserAssistant stop];
                                   [self.sessionContainer.session disconnect];
                               }];
    UIAlertAction *Data=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                         {
                         }];
    [objalert addAction:PullData];
    [objalert addAction:ShareData];
    [objalert addAction:Disconnect];
    [objalert addAction:Data];
    [self presentViewController:objalert animated:YES completion:nil];
}
#pragma mark - Patient share methods
- (void)sendMessageTapped
{
    [DeleteArray removeAllObjects];
    NSMutableArray *One=[[NSMutableArray alloc]init];
   
    SQLiteManager *dbmang=[[SQLiteManager alloc]init];
    FMResultSet *fmr=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM PatientTable"]];
    while ([fmr next])
    {
        NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
        [dictOne setObject:[fmr stringForColumn:@"PatientName"] forKey:@"patientname"];
        [dictOne setObject:[fmr stringForColumn:@"Dob"] forKey:@"Dob"];
        [dictOne setObject:[fmr stringForColumn:@"Gender"] forKey:@"Gender"];
        [dictOne setObject:[fmr stringForColumn:@"Patient_id"] forKey:@"patientid"];
        //convert data TO string
        NSData *dataforimage=[NSData dataWithData:[fmr dataForColumn:@"Img_data"]];
        NSString *str=[NSString base64StringFromData:dataforimage length:0];
        //NSLog(@"value for String :%@",str);
        [dictOne setObject:str    forKey:@"imagedata"];
        [One addObject:dictOne];
    }
    
    for (NSMutableDictionary *dictAll in One) {
         NSMutableArray *Two=[[NSMutableArray alloc]init];
        FMResultSet *fmr1=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM Location where Patient_id='%@'",[dictAll objectForKey:@"patientid"]]];
        while ([fmr1 next])
        {
            NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
            [dictOne setObject:[fmr1 stringForColumn:@"Loct_Name"] forKey:@"locationname"];
            [dictOne setObject:[fmr1 stringForColumn:@"Patient_id"] forKey:@"patientid"];
            [Two addObject:dictOne];
        }
        [dictAll setObject:Two forKey:@"Location"];
         NSMutableArray *Three=[[NSMutableArray alloc]init];
        FMResultSet *fmr2=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM SurveyResult where Patient_id='%@'",[dictAll objectForKey:@"patientid"]]];
        while ([fmr2 next])
        {
            NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
            [dictOne setObject:[fmr2 stringForColumn:@"Result_id"] forKey:@"resultid"];
            [dictOne setObject:[fmr2 stringForColumn:@"Patient_id"] forKey:@"patientid"];
            [dictOne setObject:[fmr2 stringForColumn:@"SurveyName"] forKey:@"surveyname"];
            [Three addObject:dictOne];
        }
        for (NSMutableDictionary *dictSec in Three) {
            NSMutableArray *Four=[[NSMutableArray alloc]init];
            FMResultSet *fmr3=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM ChoiceTab where Result_id='%@'",[dictSec objectForKey:@"resultid"]]];
            while ([fmr3 next])
            {
                NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
                [dictOne setObject:[fmr3 stringForColumn:@"Result_id"] forKey:@"resultid"];
                [dictOne setObject:[fmr3 stringForColumn:@"Choices"] forKey:@"choices"];
                [Four addObject:dictOne];
            }
            [dictSec setObject:Four forKey:@"choices"];
        }
        [dictAll setObject:Three forKey:@"surveyresult"];
    }
          NSError *error;
    NSMutableDictionary *dictTwo=[[NSMutableDictionary alloc]init];
    [dictTwo setObject:One forKey:@"pushpatient"];
    [dictTwo setObject:DeleteArray forKey:@"deletearry"];
     //Dict to JSON
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictTwo options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"$$$$$$$$$$$$$$---JSON DATA---$$$$$$$$$$$$$$$$$$$$$$$");
    Transcript *transcript = [self.sessionContainer sendMessage:jsonString];
    if (transcript)
    {
        [self insertTranscript:transcript];
    }
    UIAlertController *objalert=[UIAlertController alertControllerWithTitle:@"Sync Data" message:@"Patients Shared" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [objalert addAction:nobutton];
    [self presentViewController:objalert animated:YES completion:nil];
}
-(void)singlePatShare
{
    NSError *error;
    NSMutableDictionary *dicSingleShare=[[NSMutableDictionary alloc]init];
    [dicSingleShare setObject:ArrSingleShare forKey:@"singleshare"];
    //json conversion......
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dicSingleShare options:NSJSONWritingPrettyPrinted error:&error];
    [ArrSingleShare removeAllObjects];
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    Transcript *transcript = [self.sessionContainer sendMessage:jsonString];
    if (transcript) {
        // Add the transcript to the table view data source and reload
        [self insertTranscript:transcript];
    }
 }
-(void)SinglepatDelete{
    NSError *error;
    NSMutableDictionary *dictTwo=[[NSMutableDictionary alloc]init];
    [dictTwo setObject:DeleteArray forKey:@"deletearry"];
    //json conversion......
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictTwo options:NSJSONWritingPrettyPrinted error:&error];
    [DeleteArray removeAllObjects];
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    Transcript *transcript = [self.sessionContainer sendMessage:jsonString];
    if (transcript) {
        // Add the transcript to the table view data source and reload
        [self insertTranscript:transcript];
    }
}
-(void)pullDatamethod
{
    NSError *error;
    NSString *StrpullChck=@"PullCheck";
    NSMutableArray *ArrpullCheck=[[NSMutableArray alloc]init];
    [ArrpullCheck addObject:StrpullChck];
    NSMutableDictionary *dictpullCheck=[[NSMutableDictionary alloc]init];
    [dictpullCheck setObject:ArrpullCheck forKey:@"pullPressed"];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictpullCheck options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"$$$$$$$$$$$$$$---JSON DATA---$$$$$$$$$$$$$$$$$$$$$$$");
    Transcript *transcript = [self.sessionContainer sendMessage:jsonString];
    if (transcript)
    {
        [self insertTranscript:transcript];
    }
}
-(void)DelegateForPull
{
    NSMutableArray *One=[[NSMutableArray alloc]init];
    SQLiteManager *dbmang=[[SQLiteManager alloc]init];
    FMResultSet *fmr=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM PatientTable"]];
    while ([fmr next])
    {
        NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
        [dictOne setObject:[fmr stringForColumn:@"PatientName"] forKey:@"patientname"];
        [dictOne setObject:[fmr stringForColumn:@"Dob"] forKey:@"Dob"];
        [dictOne setObject:[fmr stringForColumn:@"Gender"] forKey:@"Gender"];
        [dictOne setObject:[fmr stringForColumn:@"Patient_id"] forKey:@"patientid"];
        //convert data TO string
        NSData *dataforimage=[NSData dataWithData:[fmr dataForColumn:@"Img_data"]];
        NSString *str=[NSString base64StringFromData:dataforimage length:0];
        //NSLog(@"value for String :%@",str);
        [dictOne setObject:str    forKey:@"imagedata"];
        [One addObject:dictOne];
    }
    
    for (NSMutableDictionary *dictAll in One) {
        NSMutableArray *Two=[[NSMutableArray alloc]init];
        FMResultSet *fmr1=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM Location where Patient_id='%@'",[dictAll objectForKey:@"patientid"]]];
        while ([fmr1 next])
        {
            NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
            [dictOne setObject:[fmr1 stringForColumn:@"Loct_Name"] forKey:@"locationname"];
            [dictOne setObject:[fmr1 stringForColumn:@"Patient_id"] forKey:@"patientid"];
            [Two addObject:dictOne];
        }
        [dictAll setObject:Two forKey:@"Location"];
        NSMutableArray *Three=[[NSMutableArray alloc]init];
        FMResultSet *fmr2=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM SurveyResult where Patient_id='%@'",[dictAll objectForKey:@"patientid"]]];
        while ([fmr2 next])
        {
            NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
            [dictOne setObject:[fmr2 stringForColumn:@"Result_id"] forKey:@"resultid"];
            [dictOne setObject:[fmr2 stringForColumn:@"Patient_id"] forKey:@"patientid"];
            [dictOne setObject:[fmr2 stringForColumn:@"SurveyName"] forKey:@"surveyname"];
            [Three addObject:dictOne];
        }
        for (NSMutableDictionary *dictSec in Three) {
            NSMutableArray *Four=[[NSMutableArray alloc]init];
            FMResultSet *fmr3=[dbmang ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM ChoiceTab where Result_id='%@'",[dictSec objectForKey:@"resultid"]]];
            while ([fmr3 next])
            {
                NSMutableDictionary *dictOne=[[NSMutableDictionary alloc]init];
                [dictOne setObject:[fmr3 stringForColumn:@"Result_id"] forKey:@"resultid"];
                [dictOne setObject:[fmr3 stringForColumn:@"Choices"] forKey:@"choices"];
                [Four addObject:dictOne];
            }
            [dictSec setObject:Four forKey:@"choices"];
        }
        [dictAll setObject:Three forKey:@"surveyresult"];
    }
    NSError *error;
    NSMutableDictionary *dictTwo=[[NSMutableDictionary alloc]init];
    [dictTwo setObject:One forKey:@"PullCheckKey"];
    [dictTwo setObject:DeleteArray forKey:@"deletearry"];
    //json conversion......
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictTwo options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"$$$$$$$$$$$$$$---JSON DATA---$$$$$$$$$$$$$$$$$$$$$$$");
    Transcript *transcript = [self.sessionContainer sendMessage:jsonString];
    if (transcript)
    {
        [self insertTranscript:transcript];
    }
}
#pragma - Alert Controllers
//support share and delete action display Alert Controllers
-(void)shareAlert:(NSString *)patName{
    NSString *str=[NSString stringWithFormat:@"Name of Patient:'%@'",patName];
    UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:@"Patient Shared" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {   //connect to next location pade view controller
                                [self singlePatShare];
                             }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadTableView];
    });
    [alertNew addAction:nobutton];
    [self presentViewController:alertNew animated:YES completion:nil];
}
-(void)deleteAlert:(NSString *)patName{
    NSString *str=[NSString stringWithFormat:@"%@ Patient is Deleted",patName];
    UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {   //connect to next location pade view controller
                                [self SinglepatDelete];
                             }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadTableView];
    });
    [alertNew addAction:nobutton];
    [self presentViewController:alertNew animated:YES completion:nil];

}
-(void)alertForDeletePat:(NSString *)msg patname:(NSString *)name
{
    
    NSString *str=[NSString stringWithFormat:@"%@",msg];
    NSString *strone=[NSString stringWithFormat:@"Patient %@ is Deleted 'From'",name];
    
    UIAlertController *alertNew=[UIAlertController alertControllerWithTitle:strone message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *nobutton=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    
    [alertNew addAction:nobutton];
    [self presentViewController:alertNew animated:YES completion:nil];
}
@end