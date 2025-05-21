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

    private var broadcastingModeActive = false
    private var scanningModeActive = false
    private var broadcastWaves: [UIView] = []
    private var stopButton: UIButton?
    private let beaconManager: BeaconManager

    init(beaconManager: BeaconManager) {
        self.beaconManager = beaconManager
        super.init(nibName: nil, bundle: nil)

        beaconManager.onBeaconFound = { [weak self] uuid, major, minor, rssi in
            print("Ураааа: \(uuid)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        if active {
            showCenterButton(title: "Стоп", color: UIColor.systemBlue, action: #selector(stopScanTapped))
            startBroadcastWaves(outward: false)
        } else {
            hideCenterButton()
            stopBroadcastWaves()
            buttonsStackView.isHidden = false
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
}
