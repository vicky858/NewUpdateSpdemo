



#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

@class Transcript;

@protocol SessionContainerDelegate;

// Container utility class for managing MCSession state, API calls, and it's delegate callbacks
@interface SessionContainer : NSObject <MCSessionDelegate>
@property (readonly, nonatomic) MCSession *session;
@property(retain,nonatomic)UIColor *ClrStr;
@property (assign, nonatomic) id<SessionContainerDelegate> delegate;
// Designated initializer
- (id)initWithDisplayName:(NSString *)displayName serviceType:(NSString *)serviceType;
// Method for sending text messages to all connected remote peers.  Returna a message type transcript
- (Transcript *)sendMessage:(NSString *)message;
// Method for sending image resources to all connected remote peers.  Returns an progress type transcript for monitoring tranfer
- (Transcript *)sendImage:(NSURL *)imageUrl;


@end

// Delegate protocol for updating UI when we receive data or resources from peers.
@protocol SessionContainerDelegate <NSObject>
-(void)reloadTableView;
-(void)alertForDeletePat:(NSString *)msg patname:(NSString *)name;
-(void)displayConnectionStatus:(NSString *)status RecePeer:(NSString *)recePer color:(UIColor *)clr;

-(void)shareAlertDelegate:(NSString *)msg;
-(void)DelegateForPull;
// Method used to signal to UI an initial message, incoming image resource has been received
- (void)receivedTranscript:(Transcript *)transcript;
// Method used to signal to UI an image resource transfer (send or receive) has completed
- (void)updateTranscript:(Transcript *)transcript;



@end




