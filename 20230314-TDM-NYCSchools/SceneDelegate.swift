//
//  SceneDelegate.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/14/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = UINavigationController(rootViewController: SchoolsListViewController())
        self.window?.makeKeyAndVisible()
    }



}

