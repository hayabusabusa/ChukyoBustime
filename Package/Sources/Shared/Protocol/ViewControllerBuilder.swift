//
//  ViewControllerBuilder.swift
//  
//
//  Created by Shunya Yamada on 2023/03/15.
//

import UIKit

/// Needle の Component から ViewController を返す必要がある場合に適合させる Protocol.
public protocol ViewControllerBuilder {
    var viewController: UIViewController { get }
}
