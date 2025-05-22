//
//  BeaconViewController.swift
//  finess
//
//  Created by Elina Karapetyan on 21.05.2025.
//

import UIKit

protocol BeaconViewControllerDelegate: AnyObject {
    func didTapBroadcastButton()
    func didTapScanButton()
    func didTapStopBroadcasting()
}

class BeaconViewController: UIViewController {
    weak var delegate: BeaconViewControllerDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("BeaconTitle", comment: "")
        label.font = .tinkoffTitle1()
        label.textAlignment = .center
        label.textColor = .tinkoffBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.mediumSpacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var broadcastButton: MainViewButton = {
        let button = MainViewButton(title: NSLocalizedString("broadcast", comment: ""), image: UIImage(systemName: "dot.radiowaves.left.and.right"))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTinkoffShadow()
        button.addTarget(self, action: #selector(broadcastButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var scanButton: MainViewButton = {
        let button = MainViewButton(title: NSLocalizedString("scan", comment: ""), image: UIImage(systemName: "wave.3.right"))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTinkoffShadow()
        button.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        return button
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var beaconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.mediumSpacing
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var broadcastingModeActive = false
    private var scanningModeActive = false
    private var broadcastWaves: [UIView] = []
    private var stopButton: UIButton?
    private let beaconManager: BeaconManager
    private let provider: BeaconProvider
    private let loggingService = APILoggingService()
    private var uniqueBeacons = Set<String>()

    init(beaconManager: BeaconManager, provider: BeaconProvider) {
        self.beaconManager = beaconManager
        self.provider = provider
        super.init(nibName: nil, bundle: nil)

        beaconManager.onBeaconFound = { [weak self] uuid, major, minor, rssi in
            guard let self = self else { return }
            let beaconKey = "\(uuid)-\(major)-\(minor)"
            if !self.uniqueBeacons.contains(beaconKey) {
                self.uniqueBeacons.insert(beaconKey)
                self.provider.getPaymentInfo(major: major, minor: minor) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let success):
                        self.addBeacon(name: success.account.ownerName)
                    case .failure(let failure):
                        self.showError(failure, loggingService: self.loggingService)
                    }
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBeaconsStackView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateUIElements()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setBroadcastingMode(false)
        setScanningMode(false)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(broadcastButton)
        buttonsStackView.addArrangedSubview(scanButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),

            buttonsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            broadcastButton.heightAnchor.constraint(equalToConstant: 80),
            scanButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupBeaconsStackView() {
        view.addSubview(scrollView)
        scrollView.addSubview(beaconsStackView)

        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),

            beaconsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            beaconsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            beaconsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            beaconsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            beaconsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func animateUIElements() {
        titleLabel.alpha = 0
        buttonsStackView.alpha = 0
        UIView.animate(withDuration: 0.6, delay: 0, options: [], animations: {
            self.titleLabel.alpha = 1
        })
        UIView.animate(withDuration: 0.6, delay: 0, options: [], animations: {
            self.buttonsStackView.alpha = 1
        })
    }

    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        })
    }

    @objc private func broadcastButtonTapped() {
        animateButtonTap(broadcastButton)
        delegate?.didTapBroadcastButton()
    }

    @objc private func scanButtonTapped() {
        animateButtonTap(scanButton)
        delegate?.didTapScanButton()
    }

    func setBroadcastingMode(_ active: Bool) {
        broadcastingModeActive = active
        scanningModeActive = false
        buttonsStackView.isHidden = active
        if active {
            showCenterButton(title: "Стоп", color: UIColor(red: 0.22, green: 0.78, blue: 0.36, alpha: 1), action: #selector(stopBroadcastTapped))
            startBroadcastWaves(outward: true)
        } else {
            hideCenterButton()
            stopBroadcastWaves()
            buttonsStackView.isHidden = false
        }
    }

    func setScanningMode(_ active: Bool) {
        scanningModeActive = active
        broadcastingModeActive = false
        buttonsStackView.isHidden = active
        scrollView.isHidden = !active 
        if active {
            showCenterButton(title: "Стоп", color: UIColor.systemBlue, action: #selector(stopScanTapped))
            startBroadcastWaves(outward: false)
        } else {
            hideCenterButton()
            stopBroadcastWaves()
            buttonsStackView.isHidden = false
            scrollView.isHidden = true
            beaconsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
    }

    private func showCenterButton(title: String, color: UIColor, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .tinkoffHeading()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 50
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
        stopButton = button
    }

    @objc private func stopBroadcastTapped() {
        setBroadcastingMode(false)
        delegate?.didTapStopBroadcasting()
    }

    @objc private func stopScanTapped() {
        setScanningMode(false)
    }

    private func hideCenterButton() {
        stopButton?.removeFromSuperview()
        stopButton = nil
    }

    private func startBroadcastWaves(outward: Bool) {
        guard let stopButton = stopButton else { return }
        let waveDiameter: CGFloat = max(view.bounds.width, view.bounds.height) * 1.1
        for i in 0..<3 {
            let wave = UIView()
            let color: UIColor = broadcastingModeActive ? UIColor(red: 0.22, green: 0.78, blue: 0.36, alpha: 0.15) : UIColor.systemBlue.withAlphaComponent(0.15)
            wave.backgroundColor = color
            wave.layer.cornerRadius = waveDiameter / 2
            wave.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(wave, belowSubview: stopButton)
            NSLayoutConstraint.activate([
                wave.centerXAnchor.constraint(equalTo: stopButton.centerXAnchor),
                wave.centerYAnchor.constraint(equalTo: stopButton.centerYAnchor),
                wave.widthAnchor.constraint(equalToConstant: waveDiameter),
                wave.heightAnchor.constraint(equalToConstant: waveDiameter)
            ])
            wave.isUserInteractionEnabled = false
            broadcastWaves.append(wave)
            animateWave(wave, delay: Double(i) * 0.5, outward: outward)
        }
    }

    private func animateWave(_ wave: UIView, delay: Double, outward: Bool) {
        if outward {
            wave.alpha = 0.7
            wave.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            UIView.animate(withDuration: 2.0, delay: delay, options: [.repeat, .curveEaseOut], animations: {
                wave.alpha = 0.0
                wave.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else {
            wave.alpha = 0.0
            wave.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 2.0, delay: delay, options: [.repeat, .curveEaseOut], animations: {
                wave.alpha = 0.7
                wave.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            })
        }
    }

    private func stopBroadcastWaves() {
        for wave in broadcastWaves {
            wave.removeFromSuperview()
        }
        broadcastWaves.removeAll()
    }

    private func addBeacon(name: String) {
        let beaconButton = createBeaconButton(name: name)
        DispatchQueue.main.async {
            self.beaconsStackView.addArrangedSubview(beaconButton)
        }
    }

    private func createBeaconButton(name: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\(name)", for: .normal)
        button.titleLabel?.font = .tinkoffHeading()
        button.setTitleColor(.tinkoffBlack, for: .normal)
        button.backgroundColor = .tinkoffYellow
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.animateButtonTap(button)
        }), for: .touchUpInside)
        return button
    }
}

