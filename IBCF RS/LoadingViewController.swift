//
//  LoadingViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 24/03/23.
//

import UIKit

final class LoadingViewController: UIViewController {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.addSubview(loadingIndicatorWrapperView)
        loadingIndicatorWrapperView.snp.makeConstraints { make in
            make.height.width.equalTo(200)
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var loadingIndicatorWrapperView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        
        let view = UIVisualEffectView()
        view.clipsToBounds = true
        view.effect = blurEffect
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.contentView.addSubviews(loadingIndicatorView, dismissButton)
        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .label
        view.hidesWhenStopped = true
        view.style = .large
        
        return view
    }()
    
    private lazy var dismissButton: DefaultButton = {
        let button = DefaultButton(
            title: "Batalkan",
            type: .ghost,
            size: .small
        )
        button.tintColor = .secondaryLabel
        button.alpha = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainContainerView.fadeIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.fadeOut()
    }
}

extension LoadingViewController {
    func makeUI() {
        view.backgroundColor = .clear
        view.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingIndicatorView.startAnimating()
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        perform(#selector(showDismissButton), with: nil, afterDelay: 3.0)
    }
    
    @objc func didTapDismissButton() {
        self.dismiss(animated: false)
    }
    
    @objc func showDismissButton() {
        dismissButton.fadeIn()
    }
}
