//
//  TabBarController.swift
//  finess
//
//  Created by Elina Karapetyan on 20.04.2025.
//

import UIKit

enum Tabs: Int {
    case qr
}

class TabBarController: UITabBarController {

    private let mainCoordinator = MainCoordinator()
    private let beaconCoordinator = BeaconCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func resizeImage(_ image: UIImage?, to size: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    private func configure() {
        tabBar.tintColor = .tinkoffYellow
        tabBar.unselectedItemTintColor = .tinkoffBlack
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = .clear
        tabBar.isTranslucent = true
        tabBar.layer.backgroundColor = UIColor.clear.cgColor

        let customBackground = UIView()
        customBackground.backgroundColor = .white
        customBackground.layer.cornerRadius = 24
        customBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        customBackground.layer.shadowColor = UIColor.black.cgColor
        customBackground.layer.shadowOpacity = 0.08
        customBackground.layer.shadowOffset = CGSize(width: 0, height: -4)
        customBackground.layer.shadowRadius = 16
        customBackground.translatesAutoresizingMaskIntoConstraints = false
        tabBar.insertSubview(customBackground, at: 0)
        NSLayoutConstraint.activate([
            customBackground.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 0),
            customBackground.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: 0),
            customBackground.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -16),
            customBackground.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: 0)
        ])

        let qrNav = mainCoordinator.start()
        let qrImage = UIImage(named: "QR")?.withRenderingMode(.alwaysTemplate)
        qrNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("QR", comment: ""),
            image: qrImage,
            selectedImage: qrImage
        )

        let beaconVC = beaconCoordinator.start()
        beaconVC.view.backgroundColor = .white
        let iconSize = CGSize(width: 25, height: 25)
        let beaconImage = resizeImage(UIImage(named: "Beacon"), to: iconSize)?.withRenderingMode(.alwaysTemplate)
        beaconVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Beacon", comment: ""),
            image: beaconImage,
            selectedImage: beaconImage
        )

        setViewControllers([qrNav, beaconVC], animated: false)
    }

}
