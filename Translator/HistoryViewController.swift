//
//  HistoryViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    private var historyList: [CustomCellModel] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "히스토리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "모두 지우기",
            style: .done,
            target: self,
            action: #selector(clearAllHistoryRecords)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.historyList = UserDefaults.standard.historyList
        tableView.reloadData()
    }
    
    @objc func clearAllHistoryRecords() {
        print("클리어 눌림!!")
        UserDefaults.standard.historyList = []
        self.historyList = UserDefaults.standard.historyList
        tableView.reloadData()
    }
}

private extension HistoryViewController {
    func setupViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}


extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configureUI()
        
        cell.delegate = self
        
        cell.customCellData = historyList[indexPath.row]
        cell.setupCustomCellData()
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
}

extension HistoryViewController: CustomTableViewCellDelegate {
    func favouriteButtonTapped(_ customCellData: CustomCellModel?, _ favouriteStarImageView: UIImageView) {
        guard let customCellData = customCellData,
              let isFavourite = customCellData.isFavourite
        else { return }
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        
        if !isFavourite {
            let historyIndex = UserDefaults.standard.historyList.firstIndex { $0.uuid == customCellData.uuid }
            guard let historyIndex = historyIndex else { return }
            UserDefaults.standard.historyList[historyIndex].isFavourite = true
            
            DispatchQueue.main.async {
                favouriteStarImageView.image = UIImage(systemName: "star.fill",withConfiguration: imageConfiguration)
            }
            
            UserDefaults.standard.favouriteList = [UserDefaults.standard.historyList[historyIndex]] + UserDefaults.standard.favouriteList
            
            if historyIndex == 0 {
                NotificationCenter.default.post(name: .changeFavouriteStarImage, object: true)
            }
            
        } else {
            
            let historyIndex = UserDefaults.standard.historyList.firstIndex { $0.uuid == customCellData.uuid }
            guard let historyIndex = historyIndex else { return }
            UserDefaults.standard.historyList[historyIndex].isFavourite = false
            
            DispatchQueue.main.async {
                favouriteStarImageView.image = UIImage(systemName: "star",withConfiguration: imageConfiguration)
            }
            
            UserDefaults.standard.favouriteList.removeAll { $0.uuid == customCellData.uuid }
            
            if historyIndex == 0 {
                NotificationCenter.default.post(name: .changeFavouriteStarImage, object: false)
            }
        }
        
        
    }
}
