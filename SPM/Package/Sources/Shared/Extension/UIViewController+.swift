//
//  UIViewController+.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import UIKit

public extension UIViewController {
    /// 対象の ViewController を子の ViewController として埋め込む.
    /// - Parameters:
    ///   - childViewController: 埋め込み対象の ViewController.
    ///   - view: 埋め込み先の ViewController 上の View.
    func embed(_ childViewController: UIViewController, to view: UIView) {
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// 埋め込んだ ViewController を削除する.
    /// - Parameter childViewController: 削除する ViewController.
    func remove(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}
