//
//  UILabel+Extension.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 19/03/23.
//

import UIKit

extension UILabel {
    func setLineSpacing(
        to lineSpacing: CGFloat,
        lineHeightMultiple: CGFloat = 0.0,
        alignment: NSTextAlignment = .left
    ) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value:paragraphStyle,
            range:NSMakeRange(0, attributedString.length)
        )
        // (Swift 4.1 and 4.0) Line spacing attribute
//        attributedString.addAttribute(
//            NSAttributedString.Key.paragraphStyle,
//            value:paragraphStyle,
//            range:NSMakeRange(0, attributedString.length)
//        )
        self.attributedText = attributedString
    }
}
