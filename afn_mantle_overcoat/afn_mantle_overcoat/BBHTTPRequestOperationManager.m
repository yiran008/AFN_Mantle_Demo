//
//  BBHTTPRequestOperationManager.m
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/24/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "BBHTTPRequestOperationManager.h"
#import "ObjcAssociatedObjectHelpers.h"

typedef int (^RetryDelayCalcBlock)(int, int, int); // int totalRetriesAllowed, int retriesRemaining, int delayBetweenIntervalsModifier

@interface BBHTTPRequestOperationManager ()
@property (nonatomic,assign)BOOL isAllowRetry;
@property (strong) id operationsDict;
@property (copy) id retryDelayCalcBlock;
@end

@implementation BBHTTPRequestOperationManager
SYNTHESIZE_ASC_OBJ(__operationsDict, setOperationsDict);
SYNTHESIZE_ASC_OBJ(__retryDelayCalcBlock, setRetryDelayCalcBlock);

- (instancetype)initWithBaseURL:(NSURL *)url;
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        _isAllowRetry = YES;
    }
    return self;
}
- (void)cancelAllRequests {
    self.isAllowRetry = NO;
    [self.operationQueue cancelAllOperations];
}

- (void)createOperationsDict {
    [self setOperationsDict:[[NSDictionary alloc] init]];
}

- (void)createDelayRetryCalcBlock {
    RetryDelayCalcBlock block = ^int(int totalRetries, int currentRetry, int delayInSecondsSpecified) {
        return delayInSecondsSpecified;
    };
    [self setRetryDelayCalcBlock:block];
}

- (id)retryDelayCalcBlock {
    if (!self.__retryDelayCalcBlock) {
        [self createDelayRetryCalcBlock];
    }
    return self.__retryDelayCalcBlock;
}

- (id)operationsDict {
    if (!self.__operationsDict) {
        [self createOperationsDict];
    }
    return self.__operationsDict;
}

#pragma mark - Common Use

#warning 公共参数和错误处理 可以统一在这里加

- (AFHTTPRequestOperation *)GET:(NSString *)APIString
                     parameters:(NSDictionary *)parameters
                     completion:(void (^)(id, NSError *))completion
{
    return [self GET:APIString parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (completion) completion(responseObject, nil);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (completion) completion(operation.responseObject, error);
             } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)APIString
                      parameters:(id)parameters
                      completion:(void (^)(id, NSError *))completion
{
    return [self HEAD:APIString parameters:parameters
              success:^(AFHTTPRequestOperation *operation) {
                  if (completion) completion(operation.responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) completion(operation.responseObject, error);
              } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)POST:(NSString *)APIString
                      parameters:(NSDictionary *)parameters
                      completion:(void (^)(id, NSError *))completion
{
    return [self POST:APIString parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (completion) completion(responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) completion(operation.responseObject, error);
              } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)POST:(NSString *)APIString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                      completion:(void (^)(id, NSError *))completion
{
    return [self POST:APIString parameters:parameters constructingBodyWithBlock:block
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (completion) completion(responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) completion(operation.responseObject, error);
              } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)APIString
                     parameters:(NSDictionary *)parameters
                     completion:(void (^)(id, NSError *))completion
{
    return [self PUT:APIString parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (completion) completion(responseObject, nil);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (completion) completion(operation.responseObject, error);
             } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)APIString
                       parameters:(NSDictionary *)parameters
                       completion:(void (^)(id, NSError *))completion
{
    return [self PATCH:APIString parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   if (completion) completion(responseObject, nil);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (completion) completion(operation.responseObject, error);
               } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)APIString
                        parameters:(NSDictionary *)parameters
                        completion:(void (^)(id, NSError *))completion
{
    return [self DELETE:APIString parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (completion) completion(responseObject, nil);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (completion) completion(operation.responseObject, error);
                } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

#pragma mark- Retry Support

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
{
    return [self POST:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
{
    return [self GET:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
{
    return [self HEAD:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
{
    return [self PUT:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                        autoRetry:(int)timesToRetry
{
    return [self PATCH:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                         autoRetry:(int)timesToRetry
{
    return [self DELETE:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

#pragma mark- Retry+RetryInterval Support
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:AFN_REQUEST_TIMEOUT];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}


- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
                  retryInterval:(int)intervalInSeconds
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:AFN_REQUEST_TIMEOUT];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:AFN_REQUEST_TIMEOUT];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *requestOperation, __unused id responseObject) {
        if (success) {
            success(requestOperation);
        }
    }                                                                 failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    [request setTimeoutInterval:AFN_REQUEST_TIMEOUT];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      autoRetry:(int)timesToRetry
                  retryInterval:(int)intervalInSeconds
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:AFN_REQUEST_TIMEOUT];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                        autoRetry:(int)timesToRetry
                    retryInterval:(int)intervalInSeconds
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:AFN_REQUEST_TIMEOUT];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                         autoRetry:(int)timesToRetry
                     retryInterval:(int)intervalInSeconds
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:AFN_REQUEST_TIMEOUT];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure autoRetryOf:timesToRetry retryInterval:intervalInSeconds];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                                autoRetryOf:(int)retriesRemaining retryInterval:(int)intervalInSeconds {
    void (^retryBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary *retryOperationDict = self.operationsDict[request];
        int originalRetryCount = [retryOperationDict[@"originalRetryCount"] intValue];
        int retriesRemainingCount = [retryOperationDict[@"retriesRemainingCount"] intValue];
        if (retriesRemainingCount > 0 && self.isAllowRetry) {
            NSLog(@"AutoRetry: Request failed: %@, retry %d out of %d begining...",
                  error.localizedDescription, originalRetryCount - retriesRemainingCount + 1, originalRetryCount);
            AFHTTPRequestOperation *retryOperation = [self HTTPRequestOperationWithRequest:request
                                                                                   success:success
                                                                                   failure:failure
                                                                               autoRetryOf:retriesRemainingCount - 1
                                                                             retryInterval:intervalInSeconds];
            void (^addRetryOperation)() = ^{
                [self.operationQueue addOperation:retryOperation];
            };
            RetryDelayCalcBlock delayCalc = self.retryDelayCalcBlock;
            int intervalToWait = delayCalc(originalRetryCount, retriesRemainingCount, intervalInSeconds);
            if (intervalToWait > 0) {
                NSLog(@"AutoRetry: Delaying retry for %d seconds...", intervalToWait);
                dispatch_time_t delay = dispatch_time(0, (int64_t) (intervalToWait * NSEC_PER_SEC));
                dispatch_after(delay, dispatch_get_main_queue(), ^(void) {
                    addRetryOperation();
                });
            } else {
                addRetryOperation();
            }
        } else {
            NSLog(@"AutoRetry: Request failed %d times: %@", originalRetryCount, error.localizedDescription);
            NSLog(@"AutoRetry: No more retries allowed! executing supplied failure block...");
            failure(operation, error);
            NSLog(@"AutoRetry: done.");
        }
    };
    NSMutableDictionary *operationDict = self.operationsDict[request];
    if (!operationDict) {
        operationDict = [NSMutableDictionary new];
        operationDict[@"originalRetryCount"] = [NSNumber numberWithInt:retriesRemaining];
    }
    operationDict[@"retriesRemainingCount"] = [NSNumber numberWithInt:retriesRemaining];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self.operationsDict];
    newDict[request] = operationDict;
    self.operationsDict = newDict;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObj) {
                                                                          NSMutableDictionary *successOperationDict = self.operationsDict[request];
                                                                          int originalRetryCount = [successOperationDict[@"originalRetryCount"] intValue];
                                                                          int retriesRemainingCount = [successOperationDict[@"retriesRemainingCount"] intValue];
                                                                          NSLog(@"AutoRetry: success with %d retries, running success block...", originalRetryCount - retriesRemainingCount);
                                                                          success(operation, responseObj);
                                                                          NSLog(@"AutoRetry: done.");
                                                                          
                                                                      } failure:retryBlock];
    
    return operation;
}


@end
