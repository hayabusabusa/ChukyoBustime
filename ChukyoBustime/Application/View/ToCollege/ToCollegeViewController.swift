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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var layoutDiagramView: UIView!
    @IBOutlet private weak var layoutCountdownView: UIView!
    @IBOutlet private weak var layoutPdfButtonsView: UIView!
    @IBOutlet private weak var layoutBusListView: UIView!
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToCollegeViewController {
        return Storyboard.ToCollegeViewController.instantiate(ToCollegeViewController.self)
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

extension ToCollegeViewController {
    
    private func setupNavigation() {
        navigationItem.title = "大学行き"
    }
    
    private func setupScrollView() {
       scrollView.showsVerticalScrollIndicator = false
       scrollView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
   }
       
   private func setupChildren() {
       let pdfButtons = PdfButtonsViewController.configure()
       embed(pdfButtons, to: layoutPdfButtonsView)
   }
}

// MARK: - ViewModel

extension ToCollegeViewController {
    
    private func bindViewModel() {
        
    }
}
