//
//  StateViewable.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//
//  Inspiration: https://tech.toreta.in/entry/2018/12/24/163116

import UIKit

/// `StateView` を表示させる `UIViewController` に適合させる Protocol.
protocol StateViewable where Self: UIViewController {
    /// `StateView` を必ず保持.
    var stateView: StateView { get }
    /// `StateView` を制約付きで `addSubView()` する.
    func setupStateView()
}

extension StateViewable {
    func setupStateView() {
        stateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stateView)
        NSLayoutConstraint.activate([
            stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}
