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
        view.layer.cornerRadius = 12
        view.contentView.addSubview(loadingIndicatorView)
        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
    
//    override func viewWillAppear(_ animated: Bool) {
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainContainerView.fadeIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.fadeOut { isFinished in
            if isFinished {
                super.viewWillDisappear(animated)
            }
        }
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
    }
}
