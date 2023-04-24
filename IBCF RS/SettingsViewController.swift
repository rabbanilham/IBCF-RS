//
//  SettingsViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 02/04/23.
//

import UIKit

final class SettingsViewController: UITableViewController {
    private let settingsLabel = [
        [
            "Tampilkan nilai prediksi rating pada mata kuliah untuk semester 5 ke atas",
            "Update Data"
        ],
        [
            "Tentang Aplikasi Ini"
        ]
    ]
    
    private let settingsImages = [
        [
            UIImage(systemName: "checkmark.seal"),
            UIImage(systemName: "arrow.up.doc")
        ],
        [
            UIImage(systemName: "info.circle")
        ]
    ]
    
    private var showPredictionValueToggle: UISwitch = {
        let isPredictionValueShown: Bool = DefaultUtilities.shared.getIsPredictionValueShown()
        
        let toggle = UISwitch()
        toggle.setOn(isPredictionValueShown, animated: true)
        
        return toggle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsLabel.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsLabel[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        config.text = settingsLabel[section][row]
        config.image = settingsImages[section][row]
        
        if section == 0, row == 0 {
            cell.accessoryView = showPredictionValueToggle
        }
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            switch row{
            case 1 :
                let viewController = XLSXTestViewController(style: .insetGrouped)
                navigationController?.pushViewController(viewController, animated: true)
                
            default: break
            }
            
        default: break
        }
    }
}

private extension SettingsViewController {
    func makeUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        navigationItem.title = "Pengaturan"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        showPredictionValueToggle.addTarget(self, action: #selector(didChangeShowPredictionValueToggle), for: .valueChanged)
    }
    
    @objc func didChangeShowPredictionValueToggle() {
        let isShown = showPredictionValueToggle.isOn
        DefaultUtilities.shared.setIsPredictionValueShown(isShown)
    }
}
