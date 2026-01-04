//
//  DependencyValues.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import Dependencies

extension DependencyValues {
    var appStoreClient: AppStoreClient {
        get { self[AppStoreClient.self] }
        set { self[AppStoreClient.self] = newValue }
    }
}
