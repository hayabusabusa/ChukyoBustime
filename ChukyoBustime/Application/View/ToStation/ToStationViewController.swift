//
//  ToStationViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import Infra
import RxSwift

final class ToStationViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var layoutDiagramView: UIView!
    @IBOutlet private weak var layoutCountdownView: UIView!
    @IBOutlet private weak var layoutPdfButtonsView: UIView!
    @IBOutlet private weak var layoutBusListView: UIView!
    
    // MARK: Properties
    
    private var viewModel: ToStationViewModel!
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToStationViewController {
        return Storyboard.ToStationViewController.instantiate(ToStationViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupScrollView()
        setupChildren()
        bindViewModel()
    }
}

// MARK: - Setup

extension ToStationViewController {
    
    private func setupNavigation() {
        navigationItem.title = "浄水駅行き"
    }
    
    private func setupScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    private func setupChildren() {
        let diagram = DiagramViewController.configure()
        embed(diagram, to: layoutDiagramView)
        let countdown = CountdownViewController.configure()
        embed(countdown, to: layoutCountdownView)
        let pdfButtons = PdfButtonsViewController.configure()
        embed(pdfButtons, to: layoutPdfButtonsView)
        let busList = BusListViewController.configure()
        embed(busList, to: layoutBusListView)
    }
}

// MARK: - ViewModel

extension ToStationViewController {
    
    private func bindViewModel() {
        let viewModel = ToStationViewModel()
        self.viewModel = viewModel
        
        //let input = ToStationViewModel.Input()
        //let output = viewModel.transform(input: input)
    }
}
