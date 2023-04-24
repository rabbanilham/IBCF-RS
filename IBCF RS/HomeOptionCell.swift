//
//  HomeOptionCell.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 29/03/23.
//

import UIKit

final class HomeOptionCell: UITableViewCell {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = false
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        view.addSubview(mainFrameView)
        mainFrameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var mainFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        
        view.addSubviews(mainImageView, titleLabel, descriptionLabel)
        
        mainImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mainContainerView.layer.shadowColor = UIColor.label.cgColor
    }
}

extension HomeOptionCell {
    func setContent(
        image: UIImage?,
        title: String,
        description: String
    ) {
        mainImageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
        descriptionLabel.setLineSpacing(to: 5)
    }
}

private extension HomeOptionCell {
    func makeUI() {
        contentView.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }
}
