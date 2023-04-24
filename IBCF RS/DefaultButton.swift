//
//  DefaultButton.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 01/04/23.
//

import UIKit

final class DefaultButton: UIButton {
    enum buttonType {
        case filled
        case bordered
        case ghost
    }
    
    enum buttonSizeType: CGFloat {
        case regular = 48
        case small = 36
    }
    
    init(title: String, type: buttonType, size: buttonSizeType) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        configure(size: size.rawValue, type: type)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setImageButton(image: String) {
        self.configuration?.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        self.configuration?.imagePlacement = .leading
    }
}

private extension DefaultButton {
    func configure(size: CGFloat, type: buttonType) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        switch type {
        case .filled:
            configuration = .filled()
        case .bordered:
            configuration = .borderless()
            tintColor = .black
//            layer.borderColor = UIColor(rgb: 0x7126B5).cgColor
            layer.borderWidth = 1
        case .ghost:
            configuration = .plain()
        }
    }
}
