//
//  SettingViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/02/07.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols

protocol SettingViewModelInputs {
    /// Call when the view did load.
    func viewDidLoad()
    
    /// Call when the close bar button item is tapped.
    func closeButtonTapped()
    
    /// Call when cell on table view is selected.
    /// - Parameter cellType: type of cell.
    func didSelectRow(of cellType: SettingSectionType.SettingCellType)
}

protocol SettingViewModelOutputs {
    /// Emits `SettingSectionType` enum array that should be used as data source of table view.
    var sections: Driver<[SettingSectionType]> { get }
    
    /// Emits message that should be presented with alert controller.
    var message: Signal<String> { get }
    
    /// Emits event to dimiss this view controller.
    var dismiss: Signal<Void> { get }
    
    /// Emits url that should be used to present `SFSafariViewController`.
    var presentSafari: Signal<URL> { get }
}

protocol SettingViewModelType {
    var input: SettingViewModelInputs { get }
    var output: SettingViewModelOutputs { get }
}

// MARK: - ViewModel

final class SettingViewModel: SettingViewModelInputs, SettingViewModelOutputs {
    
    // MARK: Dependency
    
    private let model: SettingModel
    
    // MARK: Propreties
    
    private let dismissRelay: PublishRelay<Void>
    private let presentSafariRelay: PublishRelay<URL>
    
    // MARK: Outputs
    
    let sections: Driver<[SettingSectionType]>
    let message: Signal<String>
    let dismiss: Signal<Void>
    let presentSafari: Signal<URL>
    
    // MARK: Initializer
    
    init(model: SettingModel = SettingModelImpl()) {
        self.model = model
        self.dismissRelay = .init()
        self.presentSafariRelay = .init()
        
        sections = model.sectionsStream.asDriver(onErrorDriveWith: .empty())
        message = model.messageStream.asSignal(onErrorSignalWith: .empty())
        dismiss = dismissRelay.asSignal()
        presentSafari = presentSafariRelay.asSignal()
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        model.getSettings()
    }
    
    func closeButtonTapped() {
        dismissRelay.accept(())
    }
    
    func didSelectRow(of cellType: SettingSectionType.SettingCellType) {
        switch cellType {
        case.tabSetting(let current):
            let new = current == TabBarItem.toStation.title ? TabBarItem.toCollege : TabBarItem.toStation
            model.saveTabSetting(tabBarItem: new)
        case .app:
            presentSafariRelay.accept(Configurations.kAboutThisAppURL)
        case .precations:
            presentSafariRelay.accept(Configurations.kPrecautionsURL)
        case .privacyPolicy:
            presentSafariRelay.accept(Configurations.kPrivacyPolicyURL)
        default: break
        }
    }
}

extension SettingViewModel: SettingViewModelType {
    var input: SettingViewModelInputs { return self }
    var output: SettingViewModelOutputs { return self }
}
