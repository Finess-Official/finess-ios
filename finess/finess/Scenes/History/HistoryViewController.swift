//
//  HistoryViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import UIKit

class HistoryViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .tinkoffTitle1()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Счета"
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .tinkoffTitle2()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "История операций"
        return label
    }()

    private let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Filter")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    private var collectionView: UICollectionView!
    private let provider = QRProvider()
    private var items: [CreateAccountResponse]? = nil
    private var filteredItems: [PaymentResponse]? = nil
    private let loggingService = APILoggingService()
    private var horizontalCollectionView: UICollectionView!
    private let horizontalLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAccounts()
        fetchHistory(startDate: nil, endDate: nil, minAmount: nil, maxAmount: nil, status: nil)
    }

    private func fetchAccounts() {
        provider.getAccounts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    self?.items = success.accounts
                    self?.collectionView.reloadData()
                }
            case .failure(let failure):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    showError(failure, loggingService: loggingService)
                }
            }
        }
    }

    private func fetchHistory(startDate: Date?, endDate: Date?, minAmount: Float?, maxAmount: Float?, status: CheckStatus?) {
        provider.getChecks(
            startDate: startDate,
            endDate: endDate,
            minAmount: minAmount,
            maxAmount: maxAmount,
            status: status) { result in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async { [weak self] in
                        self?.filteredItems = success
                    }
                case .failure(let failure):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        showError(failure, loggingService: loggingService)
                    }
                }
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(filterButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
        ])

        setupCollectionView()
        setupHorizontalCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 140)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryCollectionViewCell")
        collectionView.register(ActionButtonCollectionViewCell.self, forCellWithReuseIdentifier: "ActionButtonCollectionViewCell")

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 180),

            filterButton.centerYAnchor.constraint(equalTo: subtitleLabel.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            filterButton.widthAnchor.constraint(equalToConstant: 20),
            filterButton.heightAnchor.constraint(equalToConstant: 20),

            subtitleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
        ])

        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }

    private func setupHorizontalCollectionView() {
        horizontalLayout.scrollDirection = .horizontal
        horizontalLayout.itemSize = CGSize(width: 80, height: 40)
        horizontalLayout.minimumLineSpacing = 10
        horizontalLayout.sectionInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)

        horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView.backgroundColor = .clear
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        horizontalCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalCollectionViewCell")

        view.addSubview(horizontalCollectionView)

        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func filterButtonTapped() {
        let filterViewController = FilterViewController()
        filterViewController.onFiltersApplied = { filters in
            print("Received filters: \(filters)")
        }
        present(filterViewController, animated: true, completion: nil)
    }
}

extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizontalCollectionView {
            return 10
        } else {
            return (items?.count ?? 0) + 1 // +1 for the action button
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath)
            cell.backgroundColor = .lightGray
            cell.layer.cornerRadius = 15 // Устанавливаем cornerRadius равным половине высоты ячейки
            cell.layer.masksToBounds = true // Убедитесь, что закругление применяется
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionButtonCollectionViewCell", for: indexPath) as! ActionButtonCollectionViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
                if let item = items?[indexPath.item - 1] {
                    cell.configure(with: item)
                }
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            return CGSize(width: 80, height: 30)
        } else {
            if indexPath.item == 0 {
                return CGSize(width: 60, height: 140)
            } else {
                return CGSize(width: 200, height: 140)
            }
        }
    }
}
