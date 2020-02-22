//
//  JiraIssueModel.h
//  createJiraTicket
//
//  Created by tokopedia on 22/02/20.
//  Copyright © 2020 tokopedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiraIssueModel : NSObject

@property (nonatomic) int total;
@property (nonatomic) NSArray *issueSummary;
@property (nonatomic) NSString *projectName;
-(JiraIssueModel *)issueFromJSONData:(NSData *)jsonData;

NS_ASSUME_NONNULL_END

@end
