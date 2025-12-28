//
//  SearchView.swift
//  AppStore
//
//  Created by Langpeu on 12/28/25.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

struct SearchView: View {
    @Bindable var store: StoreOf<SearchReducer>
    @Environment(\.modelContext) private var context
    @Query private var keywords: [Keyword]
    
    @FocusState private var isFocused: Bool
    var body: some View {
        TextField("키워드를 검색해보세요", text: $store.keyword.sending(\.inputText))
            .frame(height: 40)
            .font(.system(size: 15))
            .padding(.trailing, 32)
            .padding(.leading, 12)
            .padding(.vertical, 8)
            .focused($isFocused)
            .overlay(alignment: .topTrailing) {
                Button {
                    store.send(.clearText)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                
            }
            .onSubmit {
                //키워드 저장
                saveKeyword(keyword: store.keyword)
                print("keyword \(store.keyword)")
                //검색
            }
    }
    
    
    func saveKeyword(keyword: String) {
        let data = Keyword(title: keyword, date: .now)
        context.insert(data)
        try? context.save()
    }
}
