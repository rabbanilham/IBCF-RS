//
//  ErrorDetailCell.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 28/04/23.
//

import UIKit

final class ErrorDetailCell: UITableViewCell {
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
}

private extension ErrorDetailCell {
    func makeUI() {
        selectionStyle = .none
        contentView.addSubviews(mainLabel, valueLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}

extension ErrorDetailCell {
    func setContent(
        description: String,
        value: String
    ) {
        mainLabel.text = description.uppercased()
        valueLabel.text = value
    }
}
