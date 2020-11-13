//
//  PostScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 13.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenAssembly: Assembly {
    
    private let postId: Int
    private let postInfo: LemmyModel.PostView? // show post if have pre-generated
    
    init(postId: Int, postInfo: LemmyModel.PostView? = nil) {
        self.postId = postId
        self.postInfo = postInfo
    }
    
    func makeModule() -> UIViewController {
        let viewModel = PostScreenViewModel(postId: self.postId,
                                            postInfo: self.postInfo)
        
        let vc = PostScreenViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}