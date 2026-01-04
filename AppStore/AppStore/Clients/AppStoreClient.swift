//
//  AppStoreClient.swift
//  AppStore
//
//  Created by Langpeu on 1/4/26.
//

import Dependencies
import Alamofire

struct AppStoreClient {
    var fetchAppList: (_ term: String, _ limit: Int) async -> Result<[AppListItem], NetworkError>
    var fetchAppDetail: (_ id: Int) async -> Result<[AppDetailItem], NetworkError>
}


extension AppStoreClient: DependencyKey {

    static let liveValue = AppStoreClient(
        fetchAppList: { term, limit in
            let manager = NetworkManager()
            let url = "https://itunes.apple.com/search?term=\(term)&country=kr&entity=software&limit=\(limit)"
            return await manager.fetchData(url: url, method: .get)
        },

        fetchAppDetail: { id in
            let manager = NetworkManager()
            let url = "https://itunes.apple.com/lookup?id=\(id)"
            return await manager.fetchData(url: url, method: .get)
        }
    )

    static let testValue = AppStoreClient(
        fetchAppList: { _, _ in
            .success([])
        },
        fetchAppDetail: { _ in
            .failure(.invalid)
        }
    )
}
