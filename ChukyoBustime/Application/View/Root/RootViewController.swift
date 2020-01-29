//
//  RootViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class RootViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    private lazy var onViewDidAppear: Void = {
        presentSafari()
    }()
    
    // MARK: Lifecycle
    
    static func instantiate() -> RootViewController {
        return Storyboard.RootViewController.instantiate(RootViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = onViewDidAppear
    }
}

// MARK: Transition

extension RootViewController {
    
    private func presentSafari() {
        let vc = SafariViewController(url: URL(string: "https://www.chukyo-u.ac.jp/support/pdf/studentlife/bustime.pdf")!)
        present(vc, animated: true, completion: nil)
    }
}
