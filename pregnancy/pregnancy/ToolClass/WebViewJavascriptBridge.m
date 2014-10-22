#import "WebViewJavascriptBridge.h"
#import "BBUser.h"
#import "BBPregnancyInfo.h"

@interface WebViewJavascriptBridge ()

@property (nonatomic,strong) NSMutableArray *startupMessageQueue;

- (void)_flushMessageQueueFromWebView:(UIWebView *)webView;
- (void)_doSendMessage:(NSString*)message toWebView:(UIWebView *)webView;

@end

@implementation WebViewJavascriptBridge

@synthesize delegate = _delegate;
@synthesize startupMessageQueue = _startupMessageQueue;

static NSString *MESSAGE_SEPARATOR = @"__wvjb_sep__";
static NSString *CUSTOM_PROTOCOL_SCHEME = @"webviewjavascriptbridge";
static NSString *QUEUE_HAS_MESSAGE = @"queuehasmessage";

+ (id)javascriptBridgeWithDelegate:(id <WebViewJavascriptBridgeDelegate>)delegate {
    WebViewJavascriptBridge* bridge = [[[WebViewJavascriptBridge alloc] init] autorelease];
    bridge.delegate = delegate;
    bridge.startupMessageQueue = [[[NSMutableArray alloc] init] autorelease];
    return bridge;
}

- (void)dealloc {
    _delegate = nil;
    [_startupMessageQueue release];
    
    [super dealloc];
}

- (void)sendMessage:(NSString *)message toWebView:(UIWebView *)webView {
    if (self.startupMessageQueue) {
        [self.startupMessageQueue addObject:message];
    }
    else {
        [self _doSendMessage:message toWebView: webView];
    }
}

- (void)_doSendMessage:(NSString *)message toWebView:(UIWebView *)webView {
    message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\\\\n"];
    message = [message stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');", message]];
}

- (void)_flushMessageQueueFromWebView:(UIWebView *)webView {
    NSString *messageQueueString = [webView stringByEvaluatingJavaScriptFromString:@"WebViewJavascriptBridge._fetchQueue();"];
    NSArray* messages = [messageQueueString componentsSeparatedByString:MESSAGE_SEPARATOR];
    for (id message in messages) {
        [self.delegate javascriptBridge:self receivedMessage:message fromWebView:webView];
    }
}
//接口对接实现
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js = [NSString stringWithFormat:@";(function() {"
                    "if (window.WebViewJavascriptBridge) { return; };"
                    "var _readyMessageIframe,"
                    "     _sendMessageQueue = [],"
                    "     _receiveMessageQueue = [],"
                    "     _MESSAGE_SEPERATOR = '%@',"
                    "     _CUSTOM_PROTOCOL_SCHEME = '%@',"
                    "     _QUEUE_HAS_MESSAGE = '%@';"
                    ""
                    "function _createQueueReadyIframe(doc) {"
                    "     _readyMessageIframe = doc.createElement('iframe');"
                    "     _readyMessageIframe.style.display = 'none';"
                    "     doc.documentElement.appendChild(_readyMessageIframe);"
                    "};"
                    ""
                    "function _sendMessage(message) {"
                    "     _sendMessageQueue.push(message);"//设置数据
                    "     _readyMessageIframe.src = _CUSTOM_PROTOCOL_SCHEME + '://' + _QUEUE_HAS_MESSAGE;"//发送格式消息请求
                    "};"
                    ""
                    "function _nativeDiscuzReply(discuz_id,refer_id,position){"
                    "     var url = 'reply&' + discuz_id + '&' + refer_id + '&' + position;"
                    "     _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' + encodeURI(url);"
                    "};"
                    ""
                    "function _nativeDiscuzResponseReply(discuz_id,refer_id,position,response_user_name,response_time){"
                    "     var url = 'response_reply&' + discuz_id + '&' + refer_id + '&' + position + '&' + response_user_name + '&'+ response_time;"
                    "     _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' + encodeURI(url);"
                    "};"
                    ""
                    "function _nativeDiscuzByTag(tag){"
                    "    var url = 'tag&' + tag;"
                    "    _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' + encodeURI(url);"
                    "};"
                    ""
                    "function _nativeNavigate(url){"
                    "      url = 'url&' + url;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativePhotoBrowse(url){"
                    "      url = 'photourl&' + url;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeJumpUrl(url){"
                    "      url = 'inner_jump_url&' + url;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _showShareButton(status){"
                    "      var url = 'show_share_button&' + status;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _showTabbar(status){"
                    "      var url = 'show_tabbar&' + status;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeAllBirthclubByWeek(week){"
                    "      var url = 'all_birthclub&' + week;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeNewBirthclubByWeek(week){"
                    "      var url = 'new_birthclub&' + week;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeUserBrowse(encode_id){"
                    "      var url = 'encode_id&' + encode_id;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeSetTitle(title){"
                    "      var url = 'share_content&' + title;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _customCreateTopic(navTitle,groupId,groupName,topicTitle,tip){"
                    "      var url = 'custom_create_topic&';"
                    "      var content =url + navTitle + '&'+ groupId + '&'+ groupName + '&'+ topicTitle + '&'+ tip;"
                    "document.custom_create_topic = content;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeModfiyDuedate(){"
                    "      var url = 'modify_duedate&';"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _scanQR(){"
                    "      var url = 'scan_QR&';"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _deleteTopic(topic_id){"
                    "      var url = 'delete_topic&' + topic_id;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _enterGroup(group_id,group_name){"
                    "      var url = 'enter_group&' + group_id + '&' +group_name;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeLogin(android_action,ios_action){"
                    "      var url = 'nativeLogin&' + ios_action;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _adAction(title,url){"
                    "      var urlstr = 'adAction&' + title + '&' +url;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(urlstr);"
                    "};"
                    ""
                    "function _bindWatch(){"
                    "      var url = 'bind_watch&';"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _mikaMusic(){"
                    "      var url = 'mika_music&';"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _shareAction(){"
                    "      var url = 'share_action&';"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _goEvaluation(){"
                    "      var url = 'go_evaluation&';"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeWebviewClose(){"
                    "      var url = 'webview_close&';"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _nativeCallByNumber(number){"
                    "      var url = 'call_by_number&' + number;"
                    "      _readyMessageIframe.src =_CUSTOM_PROTOCOL_SCHEME + '://' +encodeURI(url);"
                    "};"
                    ""
                    "function _fetchQueue() {"
                    "     var messageQueueString = _sendMessageQueue.join(_MESSAGE_SEPERATOR);"
                    "     _sendMessageQueue = [];"
                    "     return messageQueueString;"
                    "};"
                    ""
                    "function _setMessageHandler(messageHandler) {"
                    "     if (WebViewJavascriptBridge._messageHandler) { return alert('WebViewJavascriptBridge.setMessageHandler called twice'); }"
                    "     WebViewJavascriptBridge._messageHandler = messageHandler;"
                    "     var receivedMessages = _receiveMessageQueue;"
                    "     _receiveMessageQueue = null;"
                    "     for (var i=0; i<receivedMessages.length; i++) {"
                    "         messageHandler(receivedMessages[i]);"
                    "     }"
                    "};"
                    ""
                    "function _handleMessageFromObjC(message) {"
                    "     if (_receiveMessageQueue) { _receiveMessageQueue.push(message); }"
                    "     else { WebViewJavascriptBridge._messageHandler(message); }"
                    "};"
                    ""
                    "window.WebViewJavascriptBridge = {"
                    "     setMessageHandler: _setMessageHandler,"
                    "     sendMessage: _sendMessage,"
                    "     nativeDiscuzByTag: _nativeDiscuzByTag,"
                    "     customCreateTopic: _customCreateTopic,"
                    "     nativeUserBrowse: _nativeUserBrowse,"
                    "     nativeNavigate: _nativeNavigate,"
                    "     nativeDiscuzReply: _nativeDiscuzReply,"
                    "     nativeDiscuzResponseReply: _nativeDiscuzResponseReply,"
                    "     nativePhotoBrowse: _nativePhotoBrowse,"
                    "     nativeJumpUrl: _nativeJumpUrl,"
                    "     showShareButton: _showShareButton,"
                    "     showTabbar: _showTabbar,"
                    "     nativeAllBirthclubByWeek: _nativeAllBirthclubByWeek,"
                    "     nativeNewBirthclubByWeek: _nativeNewBirthclubByWeek,"
                    "     nativeSetTitle: _nativeSetTitle,"
                    "     deleteTopic: _deleteTopic,"
                    "     enterGroup: _enterGroup,"
                    "     nativeLogin: _nativeLogin,"
                    "     adAction: _adAction,"
                    "     bindWatch: _bindWatch,"
                    "     mikaMusic: _mikaMusic,"
                    "     shareAction: _shareAction,"
                    "     goEvaluation: _goEvaluation,"
                    "     nativeWebviewClose: _nativeWebviewClose,"
                    "     nativeCallByNumber: _nativeCallByNumber,"
                    "     nativeModfiyDuedate: _nativeModfiyDuedate,"
                    "     scanQR: _scanQR,"
                    "     _fetchQueue: _fetchQueue,"
                    "     _handleMessageFromObjC: _handleMessageFromObjC"
                    "};"
                    ""
                    "var doc = document;"
                    "_createQueueReadyIframe(doc);"
                    "var readyEvent = doc.createEvent('Events');"
                    "readyEvent.initEvent('WebViewJavascriptBridgeReady');"
                    "doc.dispatchEvent(readyEvent);"
                    ""
                    "})();"
                    "var nativeNavigate = new Function('url','WebViewJavascriptBridge.nativeNavigate(url)');"
                    "var nativePhotoBrowse = new Function('url','WebViewJavascriptBridge.nativePhotoBrowse(url)');"
                    "var nativeJumpUrl = new Function('url','WebViewJavascriptBridge.nativeJumpUrl(url)');"
                    "var showShareButton = new Function('status','WebViewJavascriptBridge.showShareButton(status)');"
                    "var showTabbar = new Function('status','WebViewJavascriptBridge.showTabbar(status)');"
                    "var nativeAllBirthclubByWeek = new Function('week','WebViewJavascriptBridge.nativeAllBirthclubByWeek(week)');"
                    "var nativeNewBirthclubByWeek = new Function('week','WebViewJavascriptBridge.nativeNewBirthclubByWeek(week)');"
                    "var nativeUserBrowse = new Function('encode_id','WebViewJavascriptBridge.nativeUserBrowse(encode_id)');"
                    "var nativeDiscuzByTag = new Function('tag','WebViewJavascriptBridge.nativeDiscuzByTag(tag)');"
                    "var customCreateTopic = new Function('navTitle','groupId','groupName','topicTitle','tip','WebViewJavascriptBridge.customCreateTopic(navTitle,groupId,groupName,topicTitle,tip)');"
                    "var nativeSetTitle = new Function('title','WebViewJavascriptBridge.nativeSetTitle(title)');"
                    "var deleteTopic = new Function('topic_id','WebViewJavascriptBridge.deleteTopic(topic_id)');"
                    "var nativeWebviewClose = new Function('','WebViewJavascriptBridge.nativeWebviewClose()');"
                    "var enterGroup = new Function('group_id','group_name','WebViewJavascriptBridge.enterGroup(group_id,group_name)');"
                    "var nativeLogin = new Function('android_action','ios_action','WebViewJavascriptBridge.nativeLogin(android_action,ios_action)');"
                    "var adAction = new Function('title','url','WebViewJavascriptBridge.adAction(title,url)');"
                    "var bindWatch = new Function('','WebViewJavascriptBridge.bindWatch()');"
                    "var mikaMusic = new Function('','WebViewJavascriptBridge.mikaMusic()');"
                    "var shareAction = new Function('','WebViewJavascriptBridge.shareAction()');"
                    "var goEvaluation = new Function('','WebViewJavascriptBridge.goEvaluation()');"
                    "var nativeCallByNumber = new Function('number','WebViewJavascriptBridge.nativeCallByNumber(number)');"
                    "var nativeModfiyDuedate = new Function('','WebViewJavascriptBridge.nativeModfiyDuedate()');"
                    "var scanQR = new Function('','WebViewJavascriptBridge.scanQR()');"
                    "var nativeDiscuzReply = new Function('discuz_id','refer_id','position','WebViewJavascriptBridge.nativeDiscuzReply(discuz_id,refer_id,position)');"
                    "var nativeDiscuzResponseReply  = new Function('discuz_id','refer_id','position','response_user_name','response_time','WebViewJavascriptBridge.nativeDiscuzResponseReply(discuz_id,refer_id,position,response_user_name,response_time)');"
                    ,
                    MESSAGE_SEPARATOR,
                    CUSTOM_PROTOCOL_SCHEME,
                    QUEUE_HAS_MESSAGE];
    
    if (![[webView stringByEvaluatingJavaScriptFromString:@"typeof WebViewJavascriptBridge == 'object'"] isEqualToString:@"true"]) {
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        if ([BBUser isLogin]) {
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
                                                             @"window.USER_INFO = {loginString: '%@',encUserId: '%@',nickname: '%@',birthday: '%@'};",
                                                             [BBUser getLoginString],[BBUser getEncId],[BBUser getNickname],[BBPregnancyInfo pregancyDateYMDByStringForAPI]]];
        }
        else
        {
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
                                                             @"window.USER_INFO = {birthday: '%@'};",
                                                             [BBPregnancyInfo pregancyDateYMDByStringForAPI]]];
        }
        //页面加载回调方法
        [webView stringByEvaluatingJavaScriptFromString:@"pageLoadFinish();"];
    }

    for (id message in self.startupMessageQueue) {
        [self _doSendMessage:message toWebView: webView];
    }
    
    self.startupMessageQueue = nil;
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

//处理请求部分在此实现
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        //对锚点特殊处理，否则不能跳转到
        if([[url absoluteString] rangeOfString:@"%23"].length > 0 || [[url absoluteString] rangeOfString:@"#"].length > 0){
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
                return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
            }
            return YES;
        }else if ([self.delegate respondsToSelector:@selector(topicInnerUrl:)]) {
            if ([[url absoluteString] hasPrefix:@"https://itunes.apple.com"] || [[url absoluteString] hasPrefix:@"itms-appss://itunes.apple.com"] || [[url absoluteString] rangeOfString:@".alipay"].length > 0 || [[url absoluteString] hasPrefix:@"http://www.babytree.com/orderpay/"]|| [[url absoluteString] hasPrefix:@"http://mall.babytree.com/flashsale/"]) {
                return YES;
            }else{
                [self.delegate topicInnerUrl:[url absoluteString]];
                return NO;
            }
        }
    }
    if (![[url scheme] isEqualToString:CUSTOM_PROTOCOL_SCHEME]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
            return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
        }
        return YES;
    }
    
    if ([[url host] isEqualToString:QUEUE_HAS_MESSAGE]) {
        [self _flushMessageQueueFromWebView: webView];
    } else {
        //        NSLog(@"WebViewJavascriptBridge: WARNING: Received unknown WebViewJavascriptBridge command %@://%@", CUSTOM_PROTOCOL_SCHEME, [url path]);
        NSString *head = [[url host] substringWithRange:NSMakeRange(0, [[url host] rangeOfString:@"&"].location)];
        if([head isEqualToString:@"tag"]&&[self.delegate respondsToSelector:@selector(discuzTag:)]){
            // NSString *encodeUrl = [[url host] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",head);
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate discuzTag:[array objectAtIndex:1]];
            }
        }else if([head isEqualToString:@"url"]){
            NSLog(@"%@",head);
            
            NSString *readUrl = [[url absoluteString] substringFromIndex:[[url absoluteString] rangeOfString:@"&"].location+1];
            if([readUrl rangeOfString:@"http"].location==0){
                NSURL *httpUrl = [NSURL URLWithString:readUrl];
                [webView loadRequest:[NSURLRequest requestWithURL:httpUrl]];
            }else{
                //加载本地html数据
                NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
                NSString *filePath = [resourcePath stringByAppendingPathComponent:readUrl];
                NSString *htmlstring=[[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil]autorelease];
                [webView loadHTMLString:htmlstring  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
                if ([self.delegate respondsToSelector:@selector(localUrlAddress:)]) {
                    [self.delegate localUrlAddress:readUrl];
                }
            }
        }else if([head isEqualToString:@"reply"]&&[self.delegate respondsToSelector:@selector(discuzReply:withReferId:withPosition:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            //            NSString *discuzId = [decodeUrl substringWithRange:NSMakeRange(0, [decodeUrl rangeOfString:@"&"].location)];
            //            NSString *referId = [decodeUrl substringWithRange:NSMakeRange(0, [decodeUrl rangeOfString:@"&"].location)];
            //            NSString *position = [decodeUrl substringWithRange:NSMakeRange(0, [decodeUrl rangeOfString:@"&"].location)];
            if ([array count]>3) {
                [self.delegate discuzReply:[array objectAtIndex:1] withReferId:[array objectAtIndex:2] withPosition:[array objectAtIndex:3]];
            }
            //NSLog(@"%@,%@,%@,%@",decodeUrl,[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3]);
        }else if([head isEqualToString:@"response_reply"]&&[self.delegate respondsToSelector:@selector(discussReplyFloor:withReferID:withPosition:withAuthorName:withPublishTime:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            NSLog(@"%@",array);
            if ([array count]>5) {
                [self.delegate discussReplyFloor:[array objectAtIndex:1] withReferID:[array objectAtIndex:2] withPosition:[array objectAtIndex:3] withAuthorName:[array objectAtIndex:4] withPublishTime:[array objectAtIndex:5]];
            }
        }else if([head isEqualToString:@"photourl"]&&[self.delegate respondsToSelector:@selector(discuzPhotoPreview:)]){
            NSLog(@"%@",head);
            //NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *readUrl = [[url absoluteString] substringFromIndex:[[url absoluteString] rangeOfString:@"&"].location+1];
            [self.delegate discuzPhotoPreview:readUrl];
        }else if([head isEqualToString:@"inner_jump_url"]&&[self.delegate respondsToSelector:@selector(innerJump:)]){
            NSLog(@"%@",head);
            //NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *readUrl = [[url absoluteString] substringFromIndex:[[url absoluteString] rangeOfString:@"&"].location+1];
            [self.delegate innerJump:readUrl];
        }else if([head isEqualToString:@"encode_id"]&&[self.delegate respondsToSelector:@selector(discuzUserEncodeId:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate discuzUserEncodeId:[array objectAtIndex:1]];
            }
        }else if([head isEqualToString:@"all_birthclub"]&&[self.delegate respondsToSelector:@selector(discuzAllBirthclubByWeek:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate discuzAllBirthclubByWeek:[array objectAtIndex:1]];
            }
        }else if([head isEqualToString:@"new_birthclub"]&&[self.delegate respondsToSelector:@selector(discuzNewBirthclubByWeek:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate discuzNewBirthclubByWeek:[array objectAtIndex:1]];
            }
        }else if([head isEqualToString:@"share_content"]&&[self.delegate respondsToSelector:@selector(shareContentText:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate shareContentText:[array objectAtIndex:1]];
                
            }
        }else if([head isEqualToString:@"modify_duedate"]&&[self.delegate respondsToSelector:@selector(modifyDuedate)]){
            [self.delegate modifyDuedate];
        }else if([head isEqualToString:@"delete_topic"]&&[self.delegate respondsToSelector:@selector(deleteTopic:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate deleteTopic:[array objectAtIndex:1]];
            }
        }else if([head isEqualToString:@"custom_create_topic"]&&[self.delegate respondsToSelector:@selector(customCreateTopic:withGroupId:withGroupName:withTopicTitle:withTip:)]){
            NSString *encodeContent = [webView  stringByEvaluatingJavaScriptFromString:@"document.custom_create_topic"];
            NSString *decodeUrl = [encodeContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            NSLog(@"%@",array);
            if ([array count]>5) {
                [self.delegate customCreateTopic:[array objectAtIndex:1] withGroupId:[array objectAtIndex:2] withGroupName:[array objectAtIndex:3] withTopicTitle:[array objectAtIndex:4] withTip:[array objectAtIndex:5]];
            }
        }else if([head isEqualToString:@"go_evaluation"]){
#if (APP_ID==0)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=523063187"]];
#else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=570934785"]];
#endif
        }else if([head isEqualToString:@"call_by_number"]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[array objectAtIndex:1]]]];
            }
        }else if([head isEqualToString:@"webview_close"]&&[self.delegate respondsToSelector:@selector(webviewClose)]){
            [self.delegate webviewClose];
        }else if([head isEqualToString:@"bind_watch"]&&[self.delegate respondsToSelector:@selector(bindWatch)]){
            [self.delegate bindWatch];
        }else if([head isEqualToString:@"enter_group"]&&[self.delegate respondsToSelector:@selector(enterGroup:withGroupName:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>2) {
                [self.delegate enterGroup:[array objectAtIndex:1] withGroupName:[array objectAtIndex:2]];
            }
        }else if([head isEqualToString:@"nativeLogin"]&&[self.delegate respondsToSelector:@selector(nativeLogin:)]){
            NSString *decodeUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *readUrl = [decodeUrl substringFromIndex:[decodeUrl rangeOfString:@"&"].location+1];
            [self.delegate nativeLogin:readUrl];
            //            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            //            if ([array count]>1) {
            //                [self.delegate nativeLogin:[array objectAtIndex:1]];
            //            }
        }else if([head isEqualToString:@"mika_music"]&&[self.delegate respondsToSelector:@selector(mikaMusic)]){
            [self.delegate mikaMusic];
        }else if([head isEqualToString:@"scan_QR"]&&[self.delegate respondsToSelector:@selector(scanQR)]){
            [self.delegate scanQR];
        }else if([head isEqualToString:@"show_share_button"]&&[self.delegate respondsToSelector:@selector(showShareButton:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate showShareButton:[array objectAtIndex:1]];
            }
        }else if([head isEqualToString:@"show_tabbar"]&&[self.delegate respondsToSelector:@selector(showTabbar:)]){
            NSString *decodeUrl = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>1) {
                [self.delegate showTabbar:[array objectAtIndex:1]];
            }
        }else if([head isEqualToString:@"share_action"]&&[self.delegate respondsToSelector:@selector(shareAction)]){
            [self.delegate shareAction];
        }else if([head isEqualToString:@"adAction"]&&[self.delegate respondsToSelector:@selector(adAction:withUrl:)]){
            NSString *decodeUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *array = [decodeUrl componentsSeparatedByString:@"&"];
            if ([array count]>2) {
                [self.delegate adAction:[[array objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withUrl:[[array objectAtIndex:2]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}

@end
