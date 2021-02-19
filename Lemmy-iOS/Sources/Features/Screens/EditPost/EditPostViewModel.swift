//
//  EditPostViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol EditPostViewModelProtocol: AnyObject {
    func doEditPostFormLoad(request: EditPost.FormLoad.Request)
    func doRemoteEditPost(request: EditPost.RemoteEditPost.Request)
}

class EditPostViewModel: EditPostViewModelProtocol {
    weak var viewController: EditPostViewControllerProtocol?
    
    private let postSource: LMModels.Source.Post
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        postSource: LMModels.Source.Post,
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.postSource = postSource
        self.userAccountService = userAccountService
    }
    
    func doEditPostFormLoad(request: EditPost.FormLoad.Request) {
        
        let headerText = FormatterHelper.newMessagePostHeaderText(name: postSource.name, body: postSource.body)
        
        self.viewController?.displayEditPostForm(
            viewModel: .init(headerText: headerText,
                             name: self.postSource.name,
                             body: self.postSource.body,
                             url: self.postSource.url,
                             nsfw: self.postSource.nsfw)
        )
    }
    
    func doRemoteEditPost(request: EditPost.RemoteEditPost.Request) {
        guard let jwtToken = userAccountService.jwtToken else {
            Logger.commonLog.error("JWT Token not found: User should not be able to edit post when not authed")
            return
        }
        
        let params = LMModels.Api.Post.EditPost(postId: self.postSource.id,
                                                name: request.name,
                                                url: request.url,
                                                body: request.body,
                                                nsfw: request.nsfw,
                                                auth: jwtToken)
        
        ApiManager.requests.asyncEditPost(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayEditPostError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (response) in
                self.viewController?.displaySuccessEditingPost(
                    viewModel: .init(postView: response.postView)
                )
            }.store(in: &cancellable)
    }
}

enum EditPost {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel {
            let headerText: String
            let name: String
            let body: String?
            let url: String?
            let nsfw: Bool
        }
    }
    
    enum RemoteEditPost {
        struct Request {
            let name: String
            let body: String?
            let url: String?
            let nsfw: Bool
        }
        
        struct ViewModel {
            let postView: LMModels.Views.PostView
        }
    }
    
    enum CreatePostError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
}