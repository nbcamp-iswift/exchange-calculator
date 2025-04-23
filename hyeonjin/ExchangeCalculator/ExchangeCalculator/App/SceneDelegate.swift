//
//  SceneDelegate.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/14/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate를 가져올 수 없습니다.")
        }

        window = UIWindow(windowScene: windowScene)
        let diContainer = DIContainer(context: appDelegate.persistentContainer.viewContext)
        let coordinator = Coordinator(
            navigationController: UINavigationController(),
            DIContainer: diContainer,
            sceneUseCase: diContainer.makeSceneUseCase()
        )

        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()
        coordinator.start()
    }
}
