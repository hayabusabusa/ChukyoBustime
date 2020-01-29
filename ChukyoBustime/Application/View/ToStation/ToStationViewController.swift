//
//  ToStationViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class ToStationViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToStationViewController {
        return Storyboard.ToStationViewController.instantiate(ToStationViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
}

// MARK: - Setup

extension ToStationViewController {
    
    private func setupNavigation() {
        navigationItem.title = "浄水駅行き"
    }
}
