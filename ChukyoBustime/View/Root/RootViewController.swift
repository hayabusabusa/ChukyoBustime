//
//  RootViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func instantiate() -> RootViewController {
        return Storyboard.RootViewController.instantiate(RootViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
