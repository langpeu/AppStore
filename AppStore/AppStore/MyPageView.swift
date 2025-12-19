//
//  MyPageView.swift
//  AppStore
//
//  Created by Langpeu on 12/20/25.
//

import SwiftUI
import Alamofire
import ComposableArchitecture

// 이름변경,이메일변경, 이미지변경
enum MyPagePath: CaseIterable {
    case name
    case email
    case image
    
    var title: String {
        switch self {
        case .name:
            "이름"
        case .email:
            "이메일"
        case .image:
            "프로필 이미지"
        }
    }
}


struct MyPageView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                ForEach(MyPagePath.allCases, id: \.self) { option in
                    listItem(option: option)
                }
            }
        }
    }
    
    func listItem(option: MyPagePath) -> some View {
        Button {
            //TODO: 버튼 클릭 액션
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .bold))
                    Text("유저 정보")
                        .foregroundStyle(Color(UIColor.lightGray))
                        .font(.system(size: 16))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(UIColor.darkGray))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
}

#Preview {
    MyPageView()
}
