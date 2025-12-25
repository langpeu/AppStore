//
//  EditEmailReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/24/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditEmailReducer {
    struct State {
        var email: String
        
    }
    
    enum Action {
        
    }
}

struct EditEmailView: View {
    @Bindable var store: StoreOf<EditEmailReducer>
    
    var body: some View {
        Text("EditEmailView")
    }
}
