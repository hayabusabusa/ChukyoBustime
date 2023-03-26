//
//  SettingRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/18.
//

import Foundation
import Shared

public protocol SettingRouterProtocol: Routable {
    /// Web ページを `SFSafariViewController` で表示する.
    func transitionToSafariViewController(with url: URL)
    /// タブ設定完了後のアラートを表示する.
    func presentAlert(with initialTab: Int)
}
