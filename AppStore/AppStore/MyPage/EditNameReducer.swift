//
//  EditNameReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/24/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditNameReducer {
    struct State {
        var name: String
    }
    
    enum Action {
        
    }
}


struct EditNameView: View {
    @Bindable var store: StoreOf<EditNameReducer>
    
    var body: some View {
        Text("EditNameView")
    }
}
