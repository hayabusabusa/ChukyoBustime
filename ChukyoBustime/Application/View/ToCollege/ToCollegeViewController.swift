//
//  ToCollegeViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class ToCollegeViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToCollegeViewController {
        return Storyboard.ToCollegeViewController.instantiate(ToCollegeViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
}

// MARK: - Setup

extension ToCollegeViewController {
    
    private func setupNavigation() {
        navigationItem.title = "大学行き"
    }
}
