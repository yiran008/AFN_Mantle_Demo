#import <UIKit/UIKit.h>

@class WebViewJavascriptBridge;

@protocol WebViewJavascriptBridgeDelegate <UIWebViewDelegate>
@optional
- (void)javascriptBridge:(WebViewJavascriptBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView;

//以下自己按需求增加
//通过id和位置回复
- (void)discuzReply:(NSString *)discuzId withReferId:(NSString *)referId withPosition:(NSString *)position;

- (void)discussReplyFloor:(NSString *)topicID withReferID:(NSString *)referID withPosition:(NSString *)floorPosition withAuthorName:(NSString *)authorName withPublishTime:(NSString *)publishTime;

- (void)discuzPhotoPreview:(NSString *)photoUrl;

- (void)innerJump:(NSString *)url;

- (void)discuzTag:(NSString *)content;

- (void)discuzUserEncodeId:(NSString *)userEncodeId;

- (void)discuzAllBirthclubByWeek:(NSString *)week;

- (void)discuzNewBirthclubByWeek:(NSString *)week;

- (void)shareContentText:(NSString *)string;

- (void)topicInnerUrl:(NSString *)url;

- (void)modifyDuedate;

- (void)deleteTopic:(NSString *)topicId;

- (void)localUrlAddress:(NSString *)currentUrl;

- (void)customCreateTopic:(NSString *)navTitle withGroupId:(NSString *)groupId withGroupName:(NSString *)groupName withTopicTitle:(NSString *)topicTitle withTip:(NSString *)tip;

- (void)webviewClose;

- (void)bindWatch;

- (void)enterGroup:(NSString *)groupId withGroupName:(NSString *)groupName;

- (void)nativeLogin:(NSString *)action;

- (void)mikaMusic;

- (void)scanQR;

- (void)showShareButton:(NSString *)status;

- (void)showTabbar:(NSString *)status;

- (void)shareAction;

- (void)adAction:(NSString *)title withUrl:(NSString *)url;
@end

@interface WebViewJavascriptBridge : NSObject <UIWebViewDelegate>

@property (nonatomic, assign) IBOutlet id <WebViewJavascriptBridgeDelegate> delegate;

/* Create a javascript bridge with the given delegate for handling messages */
+ (id)javascriptBridgeWithDelegate:(id <WebViewJavascriptBridgeDelegate>)delegate;

/* Send a message to the web view. Make sure that this javascript bridge is the delegate
 * of the webview before calling this method (see ExampleAppDelegate.m) */
- (void)sendMessage:(NSString *)message toWebView:(UIWebView *)webView;

@end
