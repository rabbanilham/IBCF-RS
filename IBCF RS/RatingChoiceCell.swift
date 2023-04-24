//
//  RatingChoiceCell.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 23/02/23.
//

import UIKit

final class RatingChoiceCell: UICollectionViewCell {
    private lazy var frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        
        view.addSubviews(emojiLabel, valueLabel)
        
        emojiLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.centerX.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(emojiLabel)
            make.bottom.equalToSuperview().offset(-4)
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RatingChoiceCell {
    func makeUI() {
        contentView.addSubview(frameView)
        
        frameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RatingChoiceCell {
    func setBackgroundColor(to color: UIColor) {
        UIView.animate(withDuration: 0.125) { [weak self] in
            guard let self = self else { return }
            self.frameView.backgroundColor = color
        }
    }
    
    func setContent(emoji: String, value: String) {
        emojiLabel.text = emoji
        valueLabel.text = value
    }
}
