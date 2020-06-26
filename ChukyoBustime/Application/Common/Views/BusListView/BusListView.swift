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
    @IBOutlet private weak var departurePointLabel: UILabel!
    @IBOutlet private weak var departureTimeLabel: UILabel!
    @IBOutlet private weak var centerIconImageView: UIImageView!
    @IBOutlet private weak var arrivalPointLabel: UILabel!
    @IBOutlet private weak var arrivalTimeLabel: UILabel!
    @IBOutlet private weak var opaqueButton: UIButton!
    @IBOutlet private weak var notificationIconImageView: UIImageView!
    
    // MARK: Properties
    
    var onTapOpaqueButton: (() -> Void)?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNib()
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadNib()
        commonInit()
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
    
    private func commonInit() {
        backgroundColor = .background
        opaqueButton.addTarget(self, action: #selector(onTapOpaqueButton(_:)), for: .touchUpInside)
    }
    
    // MARK: Setup
    
    func setupView(number: Int, centerIcon: UIImage? = UIImage(named: "ic_arrow_right"), departurePoint: String? = nil, departureTime: String? = nil, arrivalPoint: String? = nil, arrivalTime: String? = nil, isSetNotification: Bool = false) {
        numberLabel.text = "\(number)"
        centerIconImageView.image = centerIcon
        departurePointLabel.text = departurePoint
        departureTimeLabel.text = departureTime
        arrivalPointLabel.text = arrivalPoint
        arrivalTimeLabel.text = arrivalTime
        notificationIconImageView.isHidden = !isSetNotification
    }
    
    func show(departureTime: String, arrivalTime: String) {
        departurePointLabel.isHidden = false
        departureTimeLabel.text = departureTime
        centerIconImageView.image = UIImage(named: "ic_arrow_right")
        arrivalPointLabel.isHidden = false
        arrivalTimeLabel.text = arrivalTime
        opaqueButton.isUserInteractionEnabled = true
    }
    
    func hide() {
        departurePointLabel.isHidden = true
        departureTimeLabel.text = ""
        centerIconImageView.image = UIImage(named: "ic_hyphen")
        arrivalPointLabel.isHidden = true
        arrivalTimeLabel.text = ""
        opaqueButton.isUserInteractionEnabled = false
    }
    
    // MARK: Tap event
    
    @objc
    private func onTapOpaqueButton(_ sender: UIButton) {
        guard let onTapOpaqueButton = onTapOpaqueButton else { return }
        onTapOpaqueButton()
    }
}
