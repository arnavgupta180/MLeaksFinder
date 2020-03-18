//
//  JiraIssueModel.h
//  createJiraTicket
//
//  Created by tokopedia on 22/02/20.
//  Copyright © 2020 tokopedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CodeOwnerModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSArray *squads;

-(CodeOwnerModel *)parseData:(NSData *)jsonData;
NS_ASSUME_NONNULL_END

@end
