//
//  CountdownViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class CountdownViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func configure() -> CountdownViewController {
        let vc = Storyboard.CountdownViewController.instantiate(CountdownViewController.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
