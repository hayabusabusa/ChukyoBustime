//
//  ToDestinationViewController.swift
//  
//
//  Created by Shunya Yamada on 2023/03/05.
//

import Combine
import UIKit
import ServiceProtocol
import Shared
import SwiftUI

public final class ToDestinationViewController: UIViewController {

    // MARK: Properties

    private let viewModel: ToDestinationViewModelProtocol
    private var dataSource: ToDestinationView.DataSource = .empty
    private var subscriptions = Set<AnyCancellable>()

    // MARK: Lifecycle

    public init(destination: BusDestination,
                dateService: DateServiceProtocol,
                fileService: FileServiceProtocol,
                firestoreService: FirestoreServiceProtocol,
                remoteConfigService: RemoteConfigServiceProtocol,
                router: ToDestinationRouterProtocol) {
        let model = ToDestinationModel(destination: destination,
                                       dateService: dateService,
                                       fileService: fileService,
                                       firestoreService: firestoreService,
                                       remoteConfigService: remoteConfigService)
        self.viewModel = ToDestinationViewModel(model: model,
                                                router: router)
        super.init(nibName: nil, bundle: nil)
        router.start(with: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSubviews()
        configureView()
        configureSubscriptions()

        Task {
            await viewModel.input.viewDidLoad()
        }
    }
}

// MARK: Configuration

private extension ToDestinationViewController {
    func configureNavigation() {
        navigationItem.title = viewModel.output.destination == .toCollege ? "大学行き" : "浄水駅行き"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(didTapSettingButton))
    }

    func configureSubscriptions() {
        viewModel.output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.dataSource.isLoading = isLoading
            }
            .store(in: &subscriptions)
    }

    func configureSubviews() {
        view.backgroundColor = .systemGroupedBackground
    }

    func configureView() {
        let rootView = ToDestinationView(dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        hostingVC.view.backgroundColor = .systemGroupedBackground
        embed(hostingVC, to: view)
    }
}

// MARK: - Private

private extension ToDestinationViewController {
    @objc
    func didTapSettingButton() {
        viewModel.input.didTapSettingButton()
    }
}
