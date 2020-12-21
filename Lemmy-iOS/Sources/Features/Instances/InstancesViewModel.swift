//
//  InstancesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

protocol InstancesViewModelProtocol {
    func doInstancesRefresh(request: InstancesDataFlow.InstancesLoad.Request)
}

class InstancesViewModel: InstancesViewModelProtocol {
    
    weak var viewController: InstancesViewControllerProtocol?
    
    private let provider: InstancesProviderProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        provider: InstancesProviderProtocol
    ) {
        self.provider = provider
    }
    
    func doInstancesRefresh(request: InstancesDataFlow.InstancesLoad.Request) {
        
        self.provider.fetchCachedInstances()
            .receive(on: RunLoop.main)
            .sink { instances in
                
            }.store(in: &cancellable)
        
    }
}

enum InstancesDataFlow {
    
    enum InstancesLoad {
        struct Request { }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case loading
        case result(data: [Instance])
    }
}
