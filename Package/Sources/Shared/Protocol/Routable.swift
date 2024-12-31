//
//  Routable.swift
//  
//
//  Created by Shunya Yamada on 2023/03/13.
//

import UIKit

/// 各ルーターに準拠させる Protocol.
public protocol Routable: AnyObject {
    var viewController: UIViewController? { get set }
}

public extension Routable {
    func start(with viewController: UIViewController) {
        self.viewController = viewController
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
