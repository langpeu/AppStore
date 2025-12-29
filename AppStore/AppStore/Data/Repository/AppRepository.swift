//
//  AppRepository.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import Dependencies

struct AppRepository {
    private let network: AppNetworkProtocol
    init(network: AppNetworkProtocol) {
        self.network = network
    }
    
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError> {
        return await network.fetchAppList(term: term, limit: limit)
    }
    
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        return await network.fetchAppDetail(id: id)
    }
}

extension AppRepository: DependencyKey {
    static var liveValue: AppRepository {
        AppRepository(network: AppNetwork())
    }
    
    static var testValue: AppRepository {
        AppRepository(network: MockAppNetwork())
    }
}
