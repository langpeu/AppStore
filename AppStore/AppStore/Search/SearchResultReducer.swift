//
//  SearchResultReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import ComposableArchitecture
import SwiftUI
import Dependencies

@Reducer
struct SearchResultReducer {
    @Dependency(\.appRepository) var repository: AppRepository
    
    @ObservableState
    struct State {
        
    }
    
    enum Action {
        
    }
    
    func fetchList(keyword: String) async {
        //TODO: fetch List
        let result = await repository.fetchAppList(term: keyword, limit: 20)
    }
}
