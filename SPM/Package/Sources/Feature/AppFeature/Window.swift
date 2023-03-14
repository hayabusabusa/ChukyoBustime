//
//  Window.swift
//  
//
//  Created by Shunya Yamada on 2022/11/03.
//

import UIKit

public final class Window: UIWindow {
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Window {
    func configure() {
        // Needle のセットアップ.
        registerProviderFactories()
        
        let rootComponent = RootComponent()
        rootViewController = rootComponent.rootViewController
    }
}
