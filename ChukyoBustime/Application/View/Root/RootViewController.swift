//
//  RootViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import Crashlytics

final class RootViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    private lazy var onViewDidAppear: Void = {
        replaceRootToTabBar()
    }()
    
    // MARK: Lifecycle
    
    static func instantiate() -> RootViewController {
        return Storyboard.RootViewController.instantiate(RootViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().crash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = onViewDidAppear
    }
}

// MARK: Transition

extension RootViewController {
    
    private func replaceRootToTabBar() {
        let vc = TabBarController.instantiate()
        replaceRoot(to: vc)
    }
}
