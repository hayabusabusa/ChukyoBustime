//
//  Routable.swift
//  
//
//  Created by Shunya Yamada on 2023/03/13.
//

import UIKit

/// 各ルーターに準拠させる Protocol.
public protocol Routable {
    var viewController: UIViewController? { get }
}
