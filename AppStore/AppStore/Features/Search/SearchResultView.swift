//
//  SearchResultView.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import SwiftUI
import ComposableArchitecture

struct SearchResultView: View {
    
    @Bindable var store: StoreOf<SearchResultFeature>
    
    
    var body: some View {
        LazyVStack {
            ForEach(store.list) { item in
                SearchResultListView(item: item)
                    .padding(.bottom, 40)
            }
        }
        .padding(20)
    }
}

struct SearchResultListView: View {
    let item: AppListItem
    var body: some View {
        VStack {
            HStack {
                getImage(url: item.iconUrl)
                    .frame(width: 60, height: 60)
                
                Text(item.name)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            
            getStar(rating: item.averageUserRating, count: item.userRatingCount)
            getScreenshots(urls: item.screenshotUrls)
                
        }
    }
    
    func getScreenshots(urls: [String]) -> some View {
        let prefix = urls
        
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(prefix, id:\.self) { url in
                    getImage(url: url)
                        .frame(width: 113, height: 200)
                }
            }
        }
        .padding(.top, 10)
    }
    
    func getStar(rating: Float, count: Int) -> some View {
        HStack {
            ForEach(0..<5) { index in
                let currentValue = rating - Float(index) //3.5 - 3 = 0.5
                PartialStartView(fillRatio: CGFloat(currentValue))
            }
            Text("\(count)")
                .font(.system(size: 12))
            Spacer()
        }
    }
    
    struct PartialStartView: View {
        let fillRatio: CGFloat
        
        var body: some View {
            ZStack {
                Image(systemName: "star")
                    .resizable()
                    .foregroundColor(.gray)
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundColor(.yellow)
                    .mask {
                        Rectangle()
                            .scaleEffect(x: fillRatio, y:1, anchor: .leading)
                    }
                    
            }.frame(width: 12, height: 12)
        }
    }
    
    func getImage(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
        } placeholder: {
            Color.gray
        }
        .cornerRadius(8)
    }
}
