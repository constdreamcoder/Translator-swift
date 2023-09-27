//
//  FavouriteViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

final class FavouriteViewController: UIViewController {
    private var favouriteList: [CustomCellModel] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Saved".localized
        navigationController?.navigationBar.prefersLargeTitles = true

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.favouriteList = UserDefaults.standard.favouriteList
        tableView.reloadData()
    }

}

private extension FavouriteViewController {
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


extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configureUI()
        cell.selectionStyle = .none
        cell.backgroundColor = .none
        
        cell.delegate = self
        
        cell.customCellData = favouriteList[indexPath.row]
        cell.setupCustomCellData()
        return cell
    }
}

extension FavouriteViewController: UITableViewDelegate {
    
}

extension FavouriteViewController: CustomTableViewCellDelegate {
    func favouriteButtonTapped(_ customCellData: CustomCellModel?, _ favouriteStarImageView: UIImageView) {
        guard let customCellData = customCellData,
              let isFavourite = customCellData.isFavourite
        else { return }
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        
        if isFavourite {
            UserDefaults.standard.favouriteList.removeAll { $0.uuid == customCellData.uuid }
            
            DispatchQueue.main.async {
                favouriteStarImageView.image = UIImage(systemName: "star",withConfiguration: imageConfiguration)
            }
            
            let historyIndex = UserDefaults.standard.historyList.firstIndex { $0.uuid == customCellData.uuid };
            guard let historyIndex = historyIndex else { return }
            UserDefaults.standard.historyList[historyIndex].isFavourite = false
            
            if historyIndex == 0 {
                NotificationCenter.default.post(name: .changeFavouriteStarImage, object: false)
            }
        } else {
            let historyIndex = UserDefaults.standard.historyList.firstIndex { $0.uuid == customCellData.uuid }
            guard let historyIndex = historyIndex else { return }
            UserDefaults.standard.favouriteList = [UserDefaults.standard.historyList[historyIndex]] + UserDefaults.standard.favouriteList
            
            DispatchQueue.main.async {
                favouriteStarImageView.image = UIImage(systemName: "star.fill",withConfiguration: imageConfiguration)
            }
            
            UserDefaults.standard.historyList[historyIndex].isFavourite = true
            
            if historyIndex == 0 {
                NotificationCenter.default.post(name: .changeFavouriteStarImage, object: true)
            }
        }
    }
    
}
