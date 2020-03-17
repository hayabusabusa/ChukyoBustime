//
//  TodayViewController.swift
//  Today
//
//  Created by 山田隼也 on 2020/03/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import NotificationCenter

final class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var parentButton: UIButton!
    @IBOutlet private weak var parentStackView: UIStackView!
    @IBOutlet private weak var collegeTimeLabel: UILabel!
    @IBOutlet private weak var stationTimeLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParentStackViews()
        setupMessageLabel()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: Tap event
    
    @objc
    private func onTapParentButton(_ sender: UIButton) {
        guard let url = URL(string: Configurations.kApplicationUrlScheme) else { return }
        extensionContext?.open(url, completionHandler: nil)
    }
    
}

// MARK: - Setup

extension TodayViewController {
    
    private func setupParentStackViews() {
        parentButton.addTarget(self, action: #selector(onTapParentButton(_:)), for: .touchUpInside)
        parentStackView.alpha = 0
        lineView.alpha = 0
    }
    
    private func setupMessageLabel() {
        messageLabel.text = "データがありません。\nアプリを起動してデータを取得してください。"
        //messageLabel.alpha = 0
    }
}

// MARK: - Animation

extension TodayViewController {
    
    private func showParentStackViewAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.parentStackView.alpha = 1
            self.lineView.alpha = 1
        }
    }
}
