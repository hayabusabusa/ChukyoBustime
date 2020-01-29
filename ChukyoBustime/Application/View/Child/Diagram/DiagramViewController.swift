//
//  DiagramViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class DiagramViewController: UIViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func configure() -> DiagramViewController {
        let vc = Storyboard.DiagramViewController.instantiate(DiagramViewController.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
