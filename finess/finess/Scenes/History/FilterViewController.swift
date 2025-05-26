//
//  FilterViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import UIKit

class FilterViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .tinkoffTitle1()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Фильтрация"
        return label
    }()

    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .tinkoffTitle2()
        label.textAlignment = .left
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Дата"
        return label
    }()

    private let dateToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    private let summTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .tinkoffTitle2()
        label.textAlignment = .left
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Сумма"
        return label
    }()

    private let summToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .tinkoffTitle2()
        label.textAlignment = .left
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Статус"
        return label
    }()

    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "От"
        return label
    }()

    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "До"
        return label
    }()

    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        return picker
    }()

    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        return picker
    }()

    private let minAmountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Минимальная сумма"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()

    private let maxAmountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Максимальная сумма"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()

    private let statusSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Failed", "Completed", "All"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 2
        return segmentedControl
    }()

    private let applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Применить", for: .normal)
        button.backgroundColor = .tinkoffYellow
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.setTitleColor(.tinkoffBlack, for: .normal)
        return button
    }()

    private let startDateViewsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private let endDateViewsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private let dateViewsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isHidden = true
        return stackView
    }()

    private let minAmountViewsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private let maxAmountViewsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private let summViewsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isHidden = true
        return stackView
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        startDateViewsContainer.addArrangedSubview(startDateLabel)
        startDateViewsContainer.addArrangedSubview(startDatePicker)
        endDateViewsContainer.addArrangedSubview(endDateLabel)
        endDateViewsContainer.addArrangedSubview(endDatePicker)
        dateViewsContainer.addArrangedSubview(startDateViewsContainer)
        dateViewsContainer.addArrangedSubview(endDateViewsContainer)

        minAmountViewsContainer.addArrangedSubview(minAmountTextField)
        maxAmountViewsContainer.addArrangedSubview(maxAmountTextField)
        summViewsContainer.addArrangedSubview(minAmountViewsContainer)
        summViewsContainer.addArrangedSubview(maxAmountViewsContainer)

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(dateTitleLabel)
        mainStackView.addArrangedSubview(dateViewsContainer)
        mainStackView.addArrangedSubview(summTitleLabel)
        mainStackView.addArrangedSubview(summViewsContainer)
        mainStackView.addArrangedSubview(statusTitleLabel)
        mainStackView.addArrangedSubview(statusSegmentedControl)
        mainStackView.addArrangedSubview(applyButton)

        view.addSubview(mainStackView)
        view.addSubview(dateToggleButton)
        view.addSubview(summToggleButton)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            dateToggleButton.centerYAnchor.constraint(equalTo: dateTitleLabel.centerYAnchor),
            dateToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateToggleButton.widthAnchor.constraint(equalToConstant: 40),
            dateToggleButton.heightAnchor.constraint(equalToConstant: 40),

            summToggleButton.centerYAnchor.constraint(equalTo: summTitleLabel.centerYAnchor),
            summToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summToggleButton.widthAnchor.constraint(equalToConstant: 40),
            summToggleButton.heightAnchor.constraint(equalToConstant: 40),

            applyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])

        dateToggleButton.addTarget(self, action: #selector(dateToggleButtonTapped), for: .touchUpInside)
        summToggleButton.addTarget(self, action: #selector(summToggleButtonTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }

    @objc private func dateToggleButtonTapped() {
        let isHidden = dateViewsContainer.isHidden
        self.dateViewsContainer.isHidden = !isHidden
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func summToggleButtonTapped() {
        let isHidden = summViewsContainer.isHidden
        self.summViewsContainer.isHidden = !isHidden
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func applyButtonTapped() {
        // Handle filter application here
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        let minAmount = Double(minAmountTextField.text ?? "0") ?? 0
        let maxAmount = Double(maxAmountTextField.text ?? "0") ?? 0
        let statusIndex = statusSegmentedControl.selectedSegmentIndex
        let status: String
        switch statusIndex {
        case 0:
            status = "Failed"
        case 1:
            status = "Completed"
        case 2:
            status = "All"
        default:
            status = "All"
        }

        print("Start Date: \(startDate)")
        print("End Date: \(endDate)")
        print("Min Amount: \(minAmount)")
        print("Max Amount: \(maxAmount)")
        print("Status: \(status)")

        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
}


