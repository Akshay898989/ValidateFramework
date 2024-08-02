//
//  SSInAppViewController.swift
//  SurveySensumInApp
//
//  Created by akshaygupta on 20/07/24.
//

#if canImport(UIKit)
import Foundation
import WebKit
import UIKit
#endif

#if canImport(UIKit)
public class SSInAppViewController:UIViewController,WKNavigationDelegate,WKScriptMessageHandler {
    
    private var urlString: String?
    private var webView: WKWebView!
    private var spinner: UIActivityIndicatorView!
    private var viewModel:SSInAppViewModel!
    private var requestModel:SSInAppRequestModel!
    @objc public var webViewHandler: ((WKWebView?) -> Void)?
    @objc public var closeButtonHandler: (() -> Void)?
    @objc public var submitButtonHandler: (() -> Void)?
    
    @objc public init(requestModel:SSInAppRequestModel) {
        self.requestModel = requestModel
        super.init(nibName: nil, bundle: nil)
        viewModel = SSInAppViewModel(requestModel: requestModel)
        getConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func getConfiguration(){
        viewModel?.getConfiguration {[weak self] showSurvey in
            guard let self = self else{return}
            if showSurvey{
                viewModel?.loadSurvey(requestModel:requestModel){ surveyLink in
                    if !surveyLink.isEmpty{
                        self.urlString = surveyLink
                        self.setViews()
                    }
                }
            }
        }
    }
    
    private func setViews(){
        setupWebView()
        setupSpinner()
        loadWebView()
        let layoutType = viewModel.tokenData?.inApp.layout
        switch layoutType{
        case .embedInView:
            if (viewModel.tokenData?.inApp.hideCloseButton == false){
                setupCloseButton()
            }
        case .fullScreen, .popup:
            if layoutType == .popup{
                view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            }
            presentController()
            setupCloseButton()
        default:
            break
        }
        
    }
    
    private func presentController(){
        if let topViewController = UIApplication.topViewController() {
            self.modalPresentationStyle = viewModel.tokenData?.inApp.layout == .fullScreen ? .fullScreen : .overCurrentContext
            topViewController.present(self, animated: true, completion: nil)
        }
    }
    
    private func setupWebView() {
        
        let userScript = WKUserScript(source: """
            window.addEventListener("message", function(event) {
                if (event.data) {
                    window.webkit.messageHandlers.eventHandler.postMessage(event.data);
                }
            });
            """, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        userContentController.add(self, name: "eventHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        webView = WKWebView(frame:view.bounds,configuration: configuration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        switch viewModel.tokenData?.inApp.layout{
        case .fullScreen:
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0),
                webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0),
            ])
        case .popup:
            let width = (UIScreen.main.bounds.width) * (CGFloat(viewModel.tokenData?.inApp.popupSize.width ?? 90) / 100)
            let height = (UIScreen.main.bounds.height) * (CGFloat(viewModel.tokenData?.inApp.popupSize.height ?? 90) / 100)
            NSLayoutConstraint.activate([
                webView.heightAnchor.constraint(equalToConstant: height),
                webView.widthAnchor.constraint(equalToConstant: width),
                webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                webView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
        default:
            break
        }
        
    }
    
    private func setupCloseButton(){
        let closeButton = UIButton(type: .system)
#if SWIFT_PACKAGE
        let bundle = Bundle.module
        if let image = UIImage(named: "close.png", in: bundle, compatibleWith: nil) {
            closeButton.setImage(image, for: .normal)
            closeButton.tintColor = .black
        } else {
            //print("Image not found in bundle")
        }
#else
        let podBundle = Bundle(for: type(of: self))
        if let bundleURL = podBundle.url(forResource: "SurveySensumInApp", withExtension: "bundle"),
           let bundle = Bundle(url: bundleURL) {
            if let image = UIImage(named: "close.png", in: bundle, compatibleWith: nil) {
                closeButton.setImage(image, for: .normal)
                closeButton.tintColor = .black
            } else {
                //print("Image not found in bundle")
            }
        } else {
            //print("Pod bundle not found")
        }
#endif
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        webView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: webView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            closeButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc private func closeButtonTapped() {
        if SSInAppLocalStorage.shared.getSurveyStatus(forKey: viewModel.fetchedToken) != SurveyPerformedStatus.performed.rawValue{
            SSInAppLocalStorage.shared.surveyPerformedStatus[viewModel.fetchedToken] = SurveyPerformedStatus.declined.rawValue
            SSInAppLocalStorage.shared.surveyPerformTime[viewModel.fetchedToken] = Date()
        }
        if viewModel.tokenData?.inApp.layout != .embedInView{
            dismissController()
        }else{
            closeButtonHandler?()
        }
        
    }
    
    private func dismissController(){
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "eventHandler")
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSpinner() {
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(style: .large)
        } else {
            spinner = UIActivityIndicatorView(style: .whiteLarge)
        }
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    private func loadWebView() {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // WKNavigationDelegate methods
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        if viewModel.tokenData?.inApp.layout == .embedInView{
            webViewHandler?(webView)
        }
    }
    
    // WKScriptMessageHandler method
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "eventHandler" {
            guard let bodyDict = message.body as? [String: Any],
                  let eventType = bodyDict["eventType"] as? Int else {
                return
            }
            
            switch eventType {
            case 1:
                SSInAppLocalStorage.shared.surveyPerformedStatus[viewModel.fetchedToken] = SurveyPerformedStatus.performed.rawValue
                SSInAppLocalStorage.shared.surveyPerformTime[viewModel.fetchedToken] = Date()
                if let autoCloseSurvey = viewModel.tokenData?.inApp.autoCloseSurvey, autoCloseSurvey {
                    if viewModel.tokenData?.inApp.layout == .embedInView{
                        submitButtonHandler?()
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now()+5){
                            self.dismissController()
                        }
                        
                    }
                    
                }
            default:
                break
            }
        }
    }
    
    
}
#endif

