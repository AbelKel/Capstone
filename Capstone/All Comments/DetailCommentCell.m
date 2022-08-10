//
//  DetailCommentCell.m
//  Capstone
//
//  Created by Abel Kelbessa on 8/8/22.
//

#import "DetailCommentCell.h"

@implementation DetailCommentCell {
    NSMutableArray<NSString *> *upvotes;
    NSMutableArray<NSString *> *downvotes;
    NSString *commentObjectId;
    PFUser *currentUser;
    Comment *commentFromParse;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setComment:(Comment *)comment {
    self.usernameLabel.text = comment.usernameForDisplaying;
    self.userCommentLabel.text = comment.comment;
    self.counterLabel.text = [[NSString alloc] initWithFormat:@"%d", comment.vote];
    self.userProfileImageView.file = comment.image;
    [self.userProfileImageView loadInBackground];
    self->currentUser = [PFUser currentUser];
    self->commentObjectId = comment.objectId;
    [self voteStatusChecker];
    [self getTheCommentFromParse];
}

- (void)getTheCommentFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"objectId" equalTo:self->commentObjectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self->commentFromParse = [comments objectAtIndex:0];
            self->upvotes = self->commentFromParse[@"upvoted"];
            self->downvotes = self->commentFromParse[@"downvotedUsers"];
            [self voteStatusChecker];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapUpvote:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"objectId" equalTo:self->commentObjectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self->commentFromParse = [comments objectAtIndex:0];
            [self.downvoteHeartButton setImage:[UIImage imageNamed:@"arrow.down.heart.png"]forState:UIControlStateNormal];
            [self.upvoteHeartButton setImage:[UIImage imageNamed:@"arrow.up.heart.fill.png"]forState:UIControlStateNormal];
            self->upvotes = self->commentFromParse[@"upvoted"];
            [self->upvotes addObject:self->currentUser.username];
            self->commentFromParse[@"upvoted"] = [NSArray arrayWithArray:self->upvotes];
            self->downvotes = self->commentFromParse[@"downvotedUsers"];
            if ([self->downvotes containsObject:self->currentUser.username]) {
                [self->downvotes removeObject:self->currentUser.username];
                self->commentFromParse[@"downvotedUsers"] = [NSArray arrayWithArray:self->downvotes];
            }
            self->commentFromParse.vote++;
            [self->commentFromParse saveInBackground];
            [self counterUpdateForLabel];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapDownVote:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"objectId" equalTo:self->commentObjectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self->commentFromParse = [comments objectAtIndex:0];
            [self.upvoteHeartButton setImage:[UIImage imageNamed:@"arrow.up.heart.png"] forState:UIControlStateNormal];
            [self.downvoteHeartButton setImage:[UIImage imageNamed:@"arrow.down.heart.fill.png"] forState:UIControlStateNormal];
            self->downvotes = self->commentFromParse[@"downvotedUsers"];
            [self->downvotes addObject:self->currentUser.username];
            self->commentFromParse[@"downvotedUsers"] = [NSArray arrayWithArray:self->downvotes];
            self->upvotes = self->commentFromParse[@"upvoted"];
            if ([self->upvotes containsObject:self->currentUser.username]) {
                [self->upvotes removeObject:self->currentUser.username];
                self->commentFromParse[@"upvoted"] = [NSArray arrayWithArray:self->upvotes];
            }
            self->commentFromParse.vote--;
            [self counterUpdateForLabel];
            [self->commentFromParse saveInBackground];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)counterUpdateForLabel {
    self.counterLabel.text = [[NSString alloc] initWithFormat:@"%d", self->commentFromParse.vote];
}

- (void)voteStatusChecker {
    if ([self->upvotes containsObject:self->currentUser.username]) {
        [self.upvoteHeartButton setImage:[UIImage imageNamed:@"arrow.up.heart.fill.png"] forState:UIControlStateNormal];
    } else if ([self->downvotes containsObject:self->currentUser.username]) {
        [self.downvoteHeartButton setImage:[UIImage imageNamed:@"arrow.down.heart.fill.png"] forState:UIControlStateNormal];
    }
}
@end
