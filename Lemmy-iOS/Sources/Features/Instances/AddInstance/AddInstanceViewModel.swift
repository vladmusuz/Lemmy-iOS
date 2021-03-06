//
//  AddInstanceViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

protocol AddInstanceViewModelProtocol: AnyObject {
    func doAddInstancePresentation(request: AddInstanceDataFlow.InstancePresentation.Request)
    func doAddInstanceCheck(request: AddInstanceDataFlow.InstanceCheck.Request)
}

final class AddInstanceViewModel: AddInstanceViewModelProtocol {
    
    weak var viewController: AddInstanceViewControllerProtocol?
        
    private var cancellable = Set<AnyCancellable>()
    
    func doAddInstancePresentation(request: AddInstanceDataFlow.InstancePresentation.Request) {
        self.viewController?.displayAddInstancePresentation(viewModel: .init())
    }
    
    func doAddInstanceCheck(request: AddInstanceDataFlow.InstanceCheck.Request) {
        guard let api = ApiManager(instanceUrl: request.query).requestsManager else {
            Logger.commonLog.error("Not valid instance url")
            self.viewController?.displayAddInstanceCheck(
                viewModel: .init(state: .noResult)
            )
            return
        }
        
        api
            .asyncGetSite(parameters: .init(auth: nil))
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                if case .failure = completion {
                    Logger.commonLog.error("GetSite request with \(request) completion: \(completion)")
                    self.viewController?.displayAddInstanceCheck(
                        viewModel: .init(state: .noResult)
                    )
                } else {
                    Logger.commonLog.verbose(completion)
                }
            } receiveValue: { (response) in
                
                guard let instanceUrl =
                        String.createInstanceFullUrl(instanceUrl: request.query)?.host
                else { return }
                
                self.viewController?.displayAddInstanceCheck(
                    viewModel: .init(
                        state: .result(iconUrl: response.siteView?.site.icon, instanceUrl: instanceUrl)
                    )
                )
            }.store(in: &self.cancellable)
    }
}

enum AddInstanceDataFlow {
    
    enum InstancePresentation {
        struct Request { }
        
        struct ViewModel { }
    }
    
    enum InstanceCheck {
        struct Request {
            let query: String
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case result(iconUrl: URL?, instanceUrl: String)
        case noResult
    }
}
