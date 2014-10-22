//
//  BBDownloadTask.m
//  pregnancy
//
//  Created by zhangzhongfeng on 13-11-18.
//  Copyright (c) 2013年 babytree. All rights reserved.
//

#import "BBDownloadTask.h"

@interface BBDownloadTask ()
@property (nonatomic, strong)   NSMutableData       *bufferData;
@property (nonatomic, strong)   NSURLConnection         *connection;
@property (nonatomic, copy)     NSString                *filePath;
@property (nonatomic, strong)    NSOutputStream          *fileStream;

@property (nonatomic, assign)   NSInteger               numberOfRetries;
@property (nonatomic, assign)   BOOL                    firstRecieveData;


@end

@implementation BBDownloadTask

- (void)dealloc
{
    [_bufferData release];
    if (_connection) {
        [_connection cancel];
        [_connection release];
        _connection = nil;
    }
    
    if (_fileStream) {
        [_fileStream close];
        [_fileStream release];
		_fileStream = nil;
    }
    [_filePath release];
    [_musicDic release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.fileStream = nil;
        self.numberOfRetries = 0;
    }
    
    return self;
}

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.fileStream = nil;
        self.numberOfRetries = 0;
        self.musicDic = dic;
        if (self.downloadSize == 0) {
            self.firstRecieveData = TRUE;
        }
        
    }
    return self;
}

- (void)startDownload:(NSString *)downloadUrl
{
	if ([self isBlankString:downloadUrl]) {
		return;
	}
    
    NSLog(@"startDownload, downloadSize: %lld, fileSize: %lld",self.downloadSize, self.fileSize);
    

    
    NSURL *url = [NSURL URLWithString:downloadUrl];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:120]autorelease];
    //如果要开启断点下载，需要开启下面注释的四行代码
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = nil;
    if ([paths count] > 0)
        documentsDirectory = [paths objectAtIndex:0];
    
    self.filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[self.musicDic objectForKey:MUSIC_ID]]];
    self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    
    [self.fileStream open];
    
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}



- (void)finishDownload
{
    
}

- (void)startNextDownload
{
    
}

- (void)pauseDownload
{
    if (self.connection) {
        [self.connection cancel];
		self.connection = nil;
    }
    if (self.fileStream) {
        [self.fileStream close];
		self.fileStream = nil;
    }
    
}

- (void) pauseConnection:(NSNotification*)aNotification{
    
	[self stopReceiveWithStatus:@"暂停下载"];
    
    [self performSelector:@selector(startNextDownload)];
    
}

- (void)stopReceiveWithStatus:(NSString *)statusString
{
    if (self.connection) {
        [self.connection cancel];
		self.connection = nil;
    }
    if (self.fileStream) {
        [self.fileStream close];
		self.fileStream = nil;
    }
}

- (void) retryDownload
{
    if (![Reachability reachabilityForInternetConnection]) {
        [self onDownloadFailed];
        return;
    }
    
    if (self.numberOfRetries >= 2) {
        [self onDownloadFailed];
        return;
    }
    
    self.numberOfRetries++;
}

- (void) onDownloadFailed
{
    [self pauseDownload];
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidFail:)]) {
        [self.delegate downloadDidFail:self];
    }
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse * httpResponse;
    httpResponse = (NSHTTPURLResponse *) response;
    if ((httpResponse.statusCode / 100) != 2) {
        
        NSLog(@"http error, %zd", (ssize_t) httpResponse.statusCode);
        
        if (self.connection) {
            [self.connection cancel];
            self.connection = nil;
        }
        if (self.fileStream) {
            [self.fileStream close];
            self.fileStream = nil;
        }
        
        [self retryDownload];
        
	}
    else {
        long long tmpLLFileSize = [[[httpResponse allHeaderFields] valueForKey:@"Content-Length"] longLongValue];
        if (self.fileSize == 0)
        {
            NSLog(@"fileSize: %lld", self.fileSize);
            self.fileSize = tmpLLFileSize;
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadFileSize:)]) {
                [self.delegate downloadFileSize:self];
            }
		}
	}
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
	if (self.bufferData == nil) {
		self.bufferData = [[[NSMutableData alloc] init] autorelease];
	}
	if ([data length]>0) {
        if (self.firstRecieveData) {
            self.firstRecieveData = FALSE;
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProcess:)]) {
                [self.delegate downloadProcess:self];
            }
        }
		[self.bufferData appendData:data];
	}
	if ([self.bufferData length] >= 1024*200) {
		NSInteger bytesWritten = [self.fileStream write:[self.bufferData bytes]
                                              maxLength:[self.bufferData length]];
		if (bytesWritten == -1) {
            NSLog(@"StreamError, %@", self.fileStream.streamError);
            self.bufferData = nil;
            return;
		}
        
		self.downloadSize += [self.bufferData length];
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProcess:)]) {
            [self.delegate downloadProcess:self];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadSize:)]) {
            [self.delegate downloadSize:self];
        }
        
		self.bufferData = nil;
	}
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self onDownloadFailed];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	if (    self.bufferData
        &&  [self.bufferData length]>0) {
		NSInteger bytesWritten = [self.fileStream write:[self.bufferData bytes]
                                              maxLength:[self.bufferData length]];
		if (bytesWritten == -1) {
            [AlertUtil showAlert:nil withMessage:@"文件写入错误"];
            return;
		}
		self.downloadSize += [self.bufferData length];
	}
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadSize:)]) {
        [self.delegate downloadSize:self];
    }
    
    if (self.downloadSize >= self.fileSize) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProcess:)]) {
            [self.delegate downloadProcess:self];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(downLoadDidFinish:)]) {
            [self.delegate downLoadDidFinish:self];
        }
    }
}

- (BOOL)isBlankString:(NSString *)string{
    
	if (string == nil) {
		return YES;
	}
	if (string == NULL) {
		return YES;
	}
    if (    [string isEqual:nil]
        ||  [string isEqual:Nil]){
        return YES;
    }
    if (0 == [string length]){
        return YES;
    }
	if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
		return YES;
	}
    if([string isEqualToString:@"(null)"]){
		return YES;
    }
    
	return NO;
    
}

@end
