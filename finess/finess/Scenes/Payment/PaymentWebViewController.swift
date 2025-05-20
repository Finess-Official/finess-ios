import UIKit
import WebKit

class PaymentWebViewController: UIViewController {
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .tinkoffBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
        loadPaymentForm()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(webView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
    }
    
    private func loadPaymentForm() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

extension PaymentWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           url.scheme == "finesspay" {
            // Закрываем WebView
            dismiss(animated: true) {
                // Открываем диплинк через URL Scheme
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
} 