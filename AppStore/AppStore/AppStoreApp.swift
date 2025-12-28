//
//  AppStoreApp.swift
//  AppStore
//
//  Created by Langpeu on 12/20/25.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct AppStoreApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(store: Store(initialState: SearchReducer.State(), reducer: {
                SearchReducer()
            }))
            //MyPageView(store: Store(initialState: MyPageReducer.State(),reducer: { MyPageReducer() } ))
        }
        .modelContainer(modelContainer)
    }
}

private var modelContainer: ModelContainer = {
    let schema = Schema([User.self, Keyword.self])
    let modelConfiguration = ModelConfiguration(schema: schema)
    
    do {
        let container = try ModelContainer(for: schema, configurations: modelConfiguration)
        Task { @MainActor in
            setInitialData(context: container.mainContext)
        }
        return container
    } catch {
       fatalError("ModelContainer 실행 실패")
    }
                        
}()

private func setInitialData(context: ModelContext) {
    let descriptor = FetchDescriptor<User>()
    if let isEmpty = try? context.fetch(descriptor).isEmpty, isEmpty {
        let user = User(name: "Langpeu", email: "icopy@langpeu.com")
        context.insert(user)
        try? context.save()
    }
}
