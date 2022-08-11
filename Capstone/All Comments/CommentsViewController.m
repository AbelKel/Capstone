//
//  CommentsViewController.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/8/22.
//
#import "DetailCommentCell.h"
#import "CommentsViewController.h"
#import "Translate.h"

@interface CommentsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *commentsNav;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    [Translate textToTranslate:@"Comments" translatedTextBlock:^(NSString * _Nonnull text) {
        self.commentsNav.title = text;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailComment"];
    Comment *comment = self.comments[indexPath.row];
    cell.comment = comment;
    return cell;
}
@end
