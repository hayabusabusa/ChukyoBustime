//
//  ToDestinationRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/13.
//

import Foundation

public protocol ToDestinationRouterProtocol: Routable {
    /// 設定画面に遷移する.
    func transitionToSettings()
}
