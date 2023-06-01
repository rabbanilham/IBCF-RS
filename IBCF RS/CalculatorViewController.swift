//
//  CalculatorViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 26/04/23.
//

import UIKit

final class CalculatorViewController: UIViewController {
    private lazy var choiceButton: DefaultButton = {
        let button = DefaultButton(
            title: "Pilih perhitungan",
            type: .bordered,
            size: .regular
        )
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    private lazy var firstItemPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private lazy var secondItemPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private lazy var calculateButton: DefaultButton = {
        let button = DefaultButton(
            title: "Hitung",
            type: .filled,
            size: .regular
        )
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "0"
        label.textAlignment = .center
        
        return label
    }()
    
    private let allCourses = FBCourse.allCourses()
    private var recommenderSystem: IBCFRecommenderSystem?
    private var currentMenu = ""
    private var currentFirstItemId = 0
    private var currentSecondItemId = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
        createChoiceMenu()
        createRecommenderSystem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        createChoiceMenu()
        createRecommenderSystem()
    }
}

private extension CalculatorViewController {
    func makeUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Calculator"
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubviews(choiceButton, firstItemPickerView, secondItemPickerView, calculateButton, resultLabel)
        choiceButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        firstItemPickerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(96)
            make.top.equalTo(choiceButton.snp.bottom).offset(16)
        }
        
        secondItemPickerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(96)
            make.top.equalTo(firstItemPickerView.snp.bottom).offset(16)
        }
        
        calculateButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(calculateButton.snp.top).offset(-16)
        }
        
        firstItemPickerView.delegate = self
        firstItemPickerView.dataSource = self
        secondItemPickerView.delegate = self
        secondItemPickerView.dataSource = self
        
        calculateButton.addTarget(self, action: #selector(didTapCalculateButton), for: .touchUpInside)
    }
    
    func createChoiceMenu() {
        let similarityValueMenu = UIAction(title: "Cosine Similarity") { [weak self] _ in
            guard let self = self else { return }
            self.choiceButton.setTitle("Cosine Similarity", for: .normal)
            self.currentMenu = "cosineSimilarity"
            self.firstItemPickerView.reloadAllComponents()
            self.secondItemPickerView.reloadAllComponents()
        }
        
        let adjustedSimilarityValueMenu = UIAction(title: "Adjusted Cosine Similarity") { [weak self] _ in
            guard let self = self else { return }
            self.choiceButton.setTitle("Adjusted Cosine Similarity", for: .normal)
            self.currentMenu = "adjustedCosineSimilarity"
            self.firstItemPickerView.reloadAllComponents()
            self.secondItemPickerView.reloadAllComponents()
        }
        
        let choiceButtonMenu = UIMenu(options: .displayInline, children: [similarityValueMenu, adjustedSimilarityValueMenu])
        choiceButton.menu = choiceButtonMenu
    }
    
    func createRecommenderSystem() {
        guard recommenderSystem == nil else { return }
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(loadingViewController, animated: true)
        
        FBUtilities.shared.getRatings { [weak self] ratings, error in
            guard let self = self, let ratings = ratings else {
                self?.navigationController?.dismiss(animated: false)
                return
            }
            self.navigationController?.dismiss(animated: false)
            self.recommenderSystem = IBCFRecommenderSystem(ratings: ratings)
        }
    }
}

extension CalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.currentMenu == "adjustedCosineSimilarity" ||
            self.currentMenu == "cosineSimilarity"
        {
            return 67
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case firstItemPickerView: currentFirstItemId = row
        case secondItemPickerView: currentSecondItemId = row
            
        default: return
        }
        
        if currentFirstItemId != 0 && currentSecondItemId != 0 { calculateButton.isEnabled = true }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let label = UILabel()
        view.addSubview(label)
        if row == 0 {
            label.text = "Pilih mata kuliah"
        } else {
            let course = allCourses[row - 1]
            label.text = "\(row): \(course.name ?? "")"
        }
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }
}

private extension CalculatorViewController {
    @objc func didTapCalculateButton() {
        switch currentMenu {
        case "adjustedCosineSimilarity":
            resultLabel.text = "\(recommenderSystem?.cosineSimilarity(item1: "\(currentFirstItemId)", item2: "\(currentSecondItemId)", isAdjusted: true) ?? 0)"
            
        case "cosineSimilarity":
            resultLabel.text = "\(recommenderSystem?.cosineSimilarity(item1: "\(currentFirstItemId)", item2: "\(currentSecondItemId)", isAdjusted: false) ?? 0)"
            
        default: return
        }
    }
}
