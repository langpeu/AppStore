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
    @Query(sort: \Keyword.date, order: .reverse) private var keywords: [Keyword]
    
    @FocusState private var isFocused: Bool
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    textField
                    contentView
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("검색")
                        .font(.title)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //MyPage 진입
                        store.send(.onTapMyPage)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.black)
                    }
                    
                }
            }
            .sheet(item: $store.scope(state: \.myPage, action: \.myPage)) { store in
                MyPageView(store: store )
            }
            //            .fullScreenCover(item: $store.scope(state: \.myPage, action: \.myPage)) { store in
            //                MyPageView(store: store )
            //            }
            
        }
        
    }
    
    private var textField: some View {
        TextField("키워드를 검색해보세요", text: $store.keyword.sending(\.inputText))
            .frame(height: 40)
            .font(.system(size: 15))
            .padding(.trailing, 32)
            .padding(.leading, 12)
            .padding(.vertical, 8)
            .focused($isFocused)
            .overlay(alignment: .trailing) {
                Button {
                    store.send(.clearText)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 12)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                
            }
            .onSubmit {
                saveKeyword(keyword: store.keyword)
                store.send(.onSubmit)
            }
            .padding(.horizontal, 20)
    }
    
    private var contentView: some View {
        //분기
        Group {
            if let store = store.scope(state: \.result, action: \.result) {
                //2. 검색 결과 리스트
                SearchResultView()
            }else {
                //1. 키워드 리스트
                keywordList
            }
        }
    }
    
    var keywordList: some View {
        ForEach(keywords, id:\.id) { keyword in
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.black)
                    
                    Text(keyword.title)
                        .font(.system(size: 16))
                        .padding(.leading, 10)
                        .lineLimit(1)
                    Spacer()
                }
                .onTapGesture {
                    //TODO: 검색
                    
                }
                
                
                Button {
                    //TODO: delete keyword
                    deleteKeyword(keyword: keyword)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
            .padding(20)
            
        }
    }
    
    func saveKeyword(keyword: String) {
        let data = Keyword(title: keyword, date: .now)
        context.insert(data)
        try? context.save()
    }
    
    func deleteKeyword(keyword: Keyword) {
        //        let descriptor = FetchDescriptor<Keyword>(predicate: #Predicate { $0.title == keyword })
        //        if let model = try? context.fetch(descriptor).first {
        //            context.delete(model)
        //        }
        
        context.delete(keyword)
        try? context.save()
        
    }
}
