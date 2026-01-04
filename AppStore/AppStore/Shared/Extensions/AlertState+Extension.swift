//
//  AlertState+Extension.swift
//  AppStore
//
//  Created by Langpeu on 12/28/25.
//

import ComposableArchitecture
import Foundation

enum AlertType {
    case error(message: String)
}

extension AlertState {
    static func creatAlert(type: AlertType) -> AlertState {
        switch type {
        case let .error(message):
            return AlertState(title: {
                TextState("에러")
            }, actions: {
                ButtonState {
                    TextState("확인")
                }
            }, message: {
                TextState("에러가 발생했습니다 \(message)")
            })
        }
    }
}
