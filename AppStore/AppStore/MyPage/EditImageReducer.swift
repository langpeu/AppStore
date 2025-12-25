//
//  EditImageReducer.swift
//  AppStore
//
//  Created by Langpeu on 12/24/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditImageReducer {
    struct State {
        var image: Image?
        
    }
    
    enum Action {
        
    }
}

struct EditImageView: View {
    @Bindable var store: StoreOf<EditImageReducer>
    
    var body: some View {
        Text("EditImageView")
    }
    
}
