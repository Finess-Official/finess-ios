//
//  HistoryCollectionViewCell.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let accountNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "creditcard.fill")
        imageView.tintColor = .tinkoffYellow
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        contentView.addSubview(ownerNameLabel)
        contentView.addSubview(accountNumberLabel)
        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),


            ownerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ownerNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            accountNumberLabel.topAnchor.constraint(equalTo: ownerNameLabel.bottomAnchor, constant: 8),
            accountNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            accountNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            accountNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }

    func configure(with item: CreateAccountResponse) {
        ownerNameLabel.text = item.ownerName
        if item.accountNumber.count >= 4 {
            let lastFourDigits = String(item.accountNumber.suffix(4))
            accountNumberLabel.text = "Счёт **** \(lastFourDigits)"
        } else {
            accountNumberLabel.text = item.accountNumber
        }
    }
}
