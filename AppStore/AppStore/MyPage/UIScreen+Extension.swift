//
//  UIScreen+Extension.swift
//  AppStore
//
//  Created by Langpeu on 12/28/25.
//

import UIKit

extension UIScreen {
    static var currentWidth: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.screen.bounds.width ?? 0
    }
}
