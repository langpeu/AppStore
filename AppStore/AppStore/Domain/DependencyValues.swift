//
//  DependencyValues.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import Dependencies


extension DependencyValues {
    var appRepository: AppRepository {
        get {
            self[AppRepository.self]
        } set {
            self[AppRepository.self] = newValue
        }
    }
}
