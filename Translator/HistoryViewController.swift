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
        cell.customCellData = historyList[indexPath.row]
        cell.setupHistoryData()
        return cell
    }
    
    
}

extension HistoryViewController: UITableViewDelegate {
    
}
