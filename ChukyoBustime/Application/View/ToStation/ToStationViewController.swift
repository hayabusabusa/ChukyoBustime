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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var layoutDiagramView: UIView!
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToStationViewController {
        return Storyboard.ToStationViewController.instantiate(ToStationViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupScrollView()
        setupChildren()
    }
}

// MARK: - Setup

extension ToStationViewController {
    
    private func setupNavigation() {
        navigationItem.title = "浄水駅行き"
    }
    
    private func setupScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func setupChildren() {
        let diagram = DiagramViewController.configure()
        embed(diagram, to: layoutDiagramView)
    }
}
