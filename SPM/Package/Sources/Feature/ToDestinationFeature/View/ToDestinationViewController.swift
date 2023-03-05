//
//  ToDestinationViewController.swift
//  
//
//  Created by Shunya Yamada on 2023/03/05.
//

import UIKit
import Shared
import SwiftUI

public final class ToDestinationViewController: UIViewController {

    // MARK: Properties

    private let dependency: Dependency
    private var dataSource: ToDestinationView.DataSource = .empty

    // MARK: Lifecycle

    public init(dependency: Dependency) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSubviews()
        configureView()
    }
}

// MARK: Configuration

private extension ToDestinationViewController {
    func configureNavigation() {
        navigationItem.title = dependency.destination == .toCollege ? "大学行き" : "浄水駅行き"
    }

    func configureSubviews() {
        view.backgroundColor = .systemBackground
    }

    func configureView() {
        let rootView = ToDestinationView(dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        embed(hostingVC, to: view)
    }
}

public extension ToDestinationViewController {
    struct Dependency {
        public let destination: BusDestination

        public init(destination: BusDestination) {
            self.destination = destination
        }
    }
}
