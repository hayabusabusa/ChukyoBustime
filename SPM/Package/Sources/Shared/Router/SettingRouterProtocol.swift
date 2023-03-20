//
//  SettingRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/18.
//

import Foundation

public protocol SettingRouterProtocol: Routable {
    /// Web ページを `SFSafariViewController` で表示する.
    func transitionToSafariViewController(with url: URL)
}
