//
//  SceneDelegate.swift
//  CGImageSourceAnimationBlock-Bug
//
//  Created by Jesse Halley on 21/11/20.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: ViewController(nibName: nil, bundle: nil))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

