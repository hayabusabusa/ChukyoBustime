//
//  BusListView.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

class BusListView: UIView {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var leaveDestLabel: UILabel!
    @IBOutlet private weak var leaveTimeLabel: UILabel!
    @IBOutlet private weak var arriveDestLabel: UILabel!
    @IBOutlet private weak var arriveTimeLabel: UILabel!
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle(for: type(of: self))
            .loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
           return
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
}
