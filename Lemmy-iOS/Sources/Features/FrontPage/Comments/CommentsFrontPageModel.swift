//
//  CommentsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class CommentsFrontPageModel: NSObject {
    var dataLoaded: (([LemmyModel.CommentView]) -> Void)?
    var newDataLoaded: (([LemmyModel.CommentView]) -> Void)?
    
    private var isFetchingNewContent = false
    private var currentPage = 1
    
    var commentsDataSource: [LemmyModel.CommentView] = []
    
    private let upvoteDownvoteService = UpvoteDownvoteRequestService(userAccountService: UserAccountService())
    
    private var cancellable = Set<AnyCancellable>()
    
    // at init always posts
    var currentContentType: LemmyContentType = LemmyContentType.posts {
        didSet {
            print(currentContentType)
        }
    }
    
    // at init always all
    var currentFeedType: LemmyPostListingType = LemmyPostListingType.all {
        didSet {
            print(currentFeedType)
        }
    }
    
    func loadComments() {
        let parameters = LemmyModel.Comment.GetCommentsRequest(type: self.currentFeedType,
                                                               sort: LemmySortType.hot,
                                                               page: 1,
                                                               limit: 20,
                                                               auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.getComments(
            parameters: parameters
        ) { (res: Result<LemmyModel.Comment.GetCommentsResponse, LemmyGenericError>) in
            switch res {
            case .success(let response):
                self.commentsDataSource = response.comments
                self.dataLoaded?(response.comments)
            case .failure(let error):
                Logger.commonLog.error("Failed to get valid response from getComments request \(error)")
            }
        }
    }
    
    func loadMoreComments(completion: @escaping (() -> Void)) {
        let parameters = LemmyModel.Comment.GetCommentsRequest(type: self.currentFeedType,
                                                               sort: LemmySortType.hot,
                                                               page: currentPage,
                                                               limit: 20,
                                                               auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.getComments(
            parameters: parameters
        ) { (res: Result<LemmyModel.Comment.GetCommentsResponse, LemmyGenericError>) in
            switch res {
            case .success(let response):
                self.newDataLoaded?(response.comments)
                completion()
            case .failure(let error):
                Logger.commonLog.error("Failed to get valid response from getComments request \(error)")
            }
        }
    }
    
    func createCommentLike(newVote: LemmyVoteType, comment: LemmyModel.CommentView) {
        self.upvoteDownvoteService.createCommentLike(vote: newVote, comment: comment)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (comment) in
                self.saveNewComment(comment)
            }.store(in: &cancellable)
    }
    
    private func saveNewComment(_ comment: LemmyModel.CommentView) {
        if let index = commentsDataSource.firstIndex(where: { $0.id == comment.id }) {
            commentsDataSource[index] = comment
        }
    }
    
}

extension CommentsFrontPageModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForComments(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // TODO(uuttff8): go to comments
    private func handleDidSelectForComments(indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        let bottomItems = self.commentsDataSource.count - 5
        
        if indexPathRow >= bottomItems {
            guard !self.isFetchingNewContent else { return }
            
            self.isFetchingNewContent = true
            self.currentPage += 1
            self.loadMoreComments {
                self.isFetchingNewContent = false
            }
        }
    }
}

extension CommentsFrontPageModel: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        self.currentContentType = content
        self.loadComments()
    }
    
    func feedTypeChanged(to feed: LemmyPostListingType) {
        self.currentFeedType = feed
        self.loadComments()
    }
}
