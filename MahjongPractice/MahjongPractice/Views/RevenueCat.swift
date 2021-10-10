//
//  RevenueCat.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 9/25/21.
//

import UIKit
import Purchases

protocol GameDelegate {
    func redeal()
    func load2021()
    func enable2021()
    func changeYear(_ segment: Int)
}

public struct AppStoreHistory {
    public static let Patterns2020 = "com.eightbam.mahjong2019.patterns2020"
    public static let Patterns2021 = "com.eightbam.mahjong2019.patterns2021"
    private static let productIdentifiers: Set<ProductIdentifier> = [AppStoreHistory.Patterns2020, AppStoreHistory.Patterns2021]
    public static let store = IAPHelper(productIds: AppStoreHistory.productIdentifiers)
}


// -----------------------------------------------------------------------------------------
//
//  RevenueCat
//
// -----------------------------------------------------------------------------------------

class RevenueCat {
    let defaults = UserDefaults.standard
    var gameDelegate: GameDelegate!
    var package2021: Purchases.Package!
    var purchased2021 = false
    var purchaseMenu: PurchaseMenu!
    var price2021 = 0.0
    var responseTimeoutSeconds = 360.0
    var viewController: UIViewController!
    var waitFor2021Timer: Timer!
    
    init(viewController: UIViewController, gameDelegate: GameDelegate) {
        self.viewController = viewController
        self.gameDelegate = gameDelegate
        self.purchaseMenu = PurchaseMenu(revenueCat: self)
        purchased2021 = defaults.bool(forKey: "purchased2021")
    }
    
    func start() {
        print("RevenueCat.start")
        if is2021Purchased() {
            gameDelegate.enable2021()
            gameDelegate.redeal()
        } else {
            getPrice2021()
            showPurchaseMenu(viewController)
        }
    }
    
    func showPurchaseMenu(_ viewController: UIViewController) {
        viewController.show(purchaseMenu, sender: viewController)
    }
    
    func getPrice2021() {
        Purchases.shared.offerings { (offerings, error) in
            if let package = offerings?.current?.lifetime {
                self.package2021 = package
                self.price2021 = Double(truncating: package.product.price)
                self.purchaseMenu.updatePrice(self.price2021)
            }
        }
    }
    
    func purchase2021() {
        Purchases.shared.purchasePackage(package2021) { (transaction, purchaserInfo, error, userCancelled) in
            self.purchaseMenu.purchaseTimer.invalidate()
            if error != nil {
                self.purchaseMenu.alertForPurchase.dismiss(animated: false, completion: {
                    let message = (error! as NSError).localizedDescription
                    self.purchaseMenu.showRetryPurchase(error: message)
                })
            } else if transaction != nil {
                if transaction?.transactionState == .purchased {
                    self.completePurchase2021()
                }
            }
            if error == nil && purchaserInfo != nil && self.purchased2021 == false {
                if purchaserInfo?.entitlements["Patterns2021"]?.isActive == true {
                    self.completePurchase2021()
                } else {
                    self.purchaseMenu.showRetryPurchase(error: "Entitlement is not active. For help contact support@eightbam.com")
                }
            }
        }
    }
    
    func completePurchase2021() {
        purchased2021 = true
        defaults.set(purchased2021, forKey: "purchased2021")
        purchaseMenu.alertForPurchase.dismiss(animated: true, completion: {
            self.purchaseMenu.close()
        })
        gameDelegate.enable2021()
        gameDelegate.load2021()
    }
    
    func restore2021() {
        Purchases.shared.restoreTransactions { (info, error) in
            self.purchaseMenu.restoreTimer.invalidate()
            if let e = error {
                self.purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
                    self.purchaseMenu.showRetryRestore(error: (e as NSError).localizedDescription)
                })
            } else if info?.entitlements["Patterns2021"]?.isActive == true {
                self.completeRestore2021()
            } else {
                self.purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
                    self.purchaseMenu.showRetryRestore(error: "Entitlement is not active. For help contact support@eightbam.com")
                })
            }
        }
    }

    func completeRestore2021() {
        purchased2021 = true
        defaults.set(self.purchased2021, forKey: "purchased2021")
        purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
            self.purchaseMenu.close()
        })
        gameDelegate.enable2021()
        gameDelegate.load2021()
    }
    
    func is2021Purchased() -> Bool {
        let history2021 = AppStoreHistory.store.isProductPurchased(AppStoreHistory.Patterns2021)
        return history2021 || purchased2021
    }

    func is2020Purchased() -> Bool {
        let history2020 = AppStoreHistory.store.isProductPurchased(AppStoreHistory.Patterns2020)
        return history2020 || is2021Purchased()
    }
    
    func is2019Purchased() -> Bool { is2020Purchased() || is2021Purchased() }
    func is2018Purchased() -> Bool { is2020Purchased() || is2021Purchased() }
    func is2017Trial() -> Bool { return !is2020Purchased() && !is2021Purchased() }
    
    func changeYear(year: Int, settingsViewController: SettingsViewController) {
        purchaseMenu.settingsViewController = settingsViewController
        switch(year) {
            case Year.y2017:
                gameDelegate.changeYear(YearSegment.segment2017)
            case Year.y2018:
                if is2018Purchased() {
                    gameDelegate.changeYear(YearSegment.segment2018)
                } else {
                    purchaseMenu.oldYearMessage("2018")
                }
            case Year.y2019:
                if is2019Purchased() {
                    gameDelegate.changeYear(YearSegment.segment2019)
                } else {
                    purchaseMenu.oldYearMessage("2019")
                }
            case Year.y2020:
                if is2020Purchased() {
                    gameDelegate.changeYear(YearSegment.segment2020)
                } else {
                    purchaseMenu.oldYearMessage("2020")
                }
            case Year.y2021:
                if is2021Purchased() {
                    gameDelegate.changeYear(YearSegment.segment2021)
                } else {
                    showPurchaseMenu(settingsViewController)
                }
            default:
                gameDelegate.changeYear(YearSegment.segment2017)
        }
    }
}


// -----------------------------------------------------------------------------------------
//
//  Purchase Menu
//
// -----------------------------------------------------------------------------------------

class PurchaseMenu: UIViewController {
    var alertForPurchase = UIAlertController()
    var alertForRestore = UIAlertController()
    var backgroundImageView: UIImageView!
    var loaded = false
    var purchaseButton = UIButton()
    var purchaseTimer = Timer()
    var purchaseView = UIView()
    var restoreTimer = Timer()
    var revenueCat: RevenueCat!
    var settingsViewController: SettingsViewController!
    
    init(revenueCat: RevenueCat) {
        super.init(nibName: nil, bundle: nil)
        self.revenueCat = revenueCat
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }
        
    override func loadView() {
        view = UIView()
     }

    func addPurchaseView() {
        purchaseView.backgroundColor = .white
        let x = Int(width() - 550) / 2
        let y = Int(height() - 300) / 2
        purchaseView.frame = CGRect(x: x, y: y, width: 550, height: 300)
        purchaseView.layer.cornerRadius = 20
        view.addSubview(purchaseView)
    }
    
    func setBackground(){
        view.backgroundColor = revenueCat.viewController.view.backgroundColor
        backgroundImageView?.removeFromSuperview()
        let background = UIImage(named: "TRANS-ICON-WHITE.png")
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = background
        backgroundImageView.center = view.center
        backgroundImageView.alpha = 0.15
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("PurchaseMeny.viewDidAppear")
        if loaded == false {
            let yOffset = Int(height() - 300) / 2
            setBackground()
            addPurchaseView()
            addCloseButton(y: yOffset + 20)
            addTitle("2021 Pattern Access", y: yOffset + 10)
            addLabel("Access to 2021 Patterns with suggested hands,\n filters, stats, and more. One time purchase for 2021.", y: yOffset + 55, height: 60)
            addPurchaseButton(y: yOffset + 120)
            addRestoreButton(y: yOffset + 180)
            addLabel("Contact support@eightbam.com", y: yOffset + 260, height: 30)
            loaded = true
        }
    }
    
    func addCloseButton(y: Int) {
        let x = Int(purchaseView.frame.maxX - 50)
        let closeButton = UIButton(frame: CGRect(x: x, y: y, width: 30, height: 30))
        let image = UIImage(named: "iconfinder_circle-02_600789.png")
        closeButton.setImage(image, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        if revenueCat.is2017Trial() {
            show2017Trial()
        } else {
            validateYear()
            revenueCat.gameDelegate.redeal()
            close()
        }
    }
    
    func validateYear() {
        if settingsViewController != nil {
            if settingsViewController.is2021Selected() && !revenueCat.is2021Purchased() {
                settingsViewController.select2020()
            }
            if settingsViewController.is2020Selected() && !revenueCat.is2020Purchased() {
                settingsViewController.select2017()
            }
            if settingsViewController.is2019Selected() && !revenueCat.is2020Purchased() {
                settingsViewController.select2017()
            }
            if settingsViewController.is2018Selected() && !revenueCat.is2020Purchased() {
                settingsViewController.select2017()
            }
        }
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func closeAlert() {
        alertForPurchase.dismiss(animated: true, completion: nil)
    }
    
    func closeAlertForRestore() {
        alertForRestore.dismiss(animated: true, completion: nil)
    }
    
    func width() -> Int {
        Int(view.frame.width)
    }
    
    func height() -> Int {
        Int(view.frame.height)
    }
    
    func show2017Trial() {
        let alert = UIAlertController(title: "2017 is available as a free trial with limited feautures", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "2017", style: .default, handler: {(action:UIAlertAction) in
            if self.settingsViewController != nil {
                self.settingsViewController.select2017()
            }
            self.revenueCat.gameDelegate.redeal()
            self.dismiss(animated: true, completion: nil)
        }));
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func addTitle(_ text: String, y: Int) {
        let offset = (width() - 400) / 2
        let title = UILabel(frame: CGRect(x: offset, y: y, width: 400, height: 55))
        title.text = text
        title.font = UIFont.boldSystemFont(ofSize: 24)
        title.textAlignment = .center
        title.textColor = .black
        title.backgroundColor = .white
        view.addSubview(title)
    }
    
    func addLabel(_ text: String, y: Int, height: Int) {
        let offset = (width() - 490) / 2
        let label = UITextView(frame: CGRect(x: offset, y: y, width: 490, height: height))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.isUserInteractionEnabled = false
        view.addSubview(label)
    }
    
    func addPurchaseButton(y: Int) {
        purchaseButton = UIButton(frame: CGRect(x: (width()-300)/2, y: y, width: 300, height: 50))
        purchaseButton.layer.cornerRadius = 5
        purchaseButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        if revenueCat.price2021 == 0.0 {
            purchaseButton.setTitle("Connecting...", for: .normal)
            purchaseButton.isEnabled = false
        } else {
            purchaseButton.setTitle("$\(revenueCat.price2021)", for: .normal)
            purchaseButton.isEnabled = true
        }
        purchaseButton.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 0, alpha: 1.0);
        purchaseButton.setTitleColor(.black, for: .normal)
        purchaseButton.addTarget(self, action: #selector(purchaseButtonAction), for: .touchUpInside)
        view.addSubview(purchaseButton)
    }

    @objc func purchaseButtonAction(sender: UIButton!) {
        showConnectMessageForPurchase()
        revenueCat.purchase2021()
    }
    
    func updatePrice(_ price: Double) {
        purchaseButton.setTitle("$\(price)", for: .normal)
        purchaseButton.isEnabled = true
    }

    func showConnectMessageForPurchase() {
        purchaseTimer = Timer.scheduledTimer(timeInterval: revenueCat.responseTimeoutSeconds, target: self, selector: #selector(purchaseTimeout), userInfo: nil, repeats: false)
        let title = "App Store Connect"
        let message = "Please Wait...\n"
        alertForPurchase = UIAlertController(title: title, message: message, preferredStyle: .alert)
        addActivityIndicator(alert: alertForPurchase)
        present(alertForPurchase, animated: false, completion: nil)
    }
    
    func addRestoreButton(y: Int) {
        let button = UIButton(frame: CGRect(x: (width()-300)/2, y: y, width: 300, height: 50))
        button.layer.cornerRadius = 5
        button.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("Restore Purchase", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(showRestoreMenu), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func showConnectMessageForRestore() {
        restoreTimer = Timer.scheduledTimer(timeInterval: revenueCat.responseTimeoutSeconds, target: self, selector: #selector(restoreTimeout), userInfo: nil, repeats: false)
        let title = "App Store Connect"
        let message = "Please Wait...\n"
        alertForRestore = UIAlertController(title: title, message: message, preferredStyle: .alert)
        addActivityIndicator(alert: alertForRestore)
        present(alertForRestore, animated: false, completion: nil)
    }
 
    func showErrorMessage(error: NSError) {
        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action:UIAlertAction) in }));
        present(alert, animated: false, completion: nil)
    }
    
    func showRetryRestore(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForRestore()
            self.revenueCat.restore2021()
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func showRetryPurchase(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForPurchase()
            self.revenueCat.purchase2021()
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func showErrorMessage(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action:UIAlertAction) in }));
        present(alert, animated: false, completion: nil)
    }
    
    @objc func showRestoreMenu() {
        let message = "Restore after deleting or to run on your iPhone and iPad. If you purchased 2020 you need to purchase 2021 separately. Be patient and retry if the App Store is busy. For help contact support@eightbam.com."
        let alert = UIAlertController(title: "Restore Purchase", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "2021", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForRestore()
            self.revenueCat.restore2021()
        }));
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: false, completion: nil)
    }

    @objc func purchaseTimeout() {
        alertForPurchase.dismiss(animated: true, completion: {
            self.showErrorMessage(error: "Purchase Timeout")
        })
    }
    
    @objc func restoreTimeout() {
        alertForRestore.dismiss(animated: true, completion: {
            self.showErrorMessage(error: "Restore Timeout")
        })
    }
    
    func addActivityIndicator(alert: UIAlertController) {
        var activityIndicator = UIActivityIndicatorView(style: .gray)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                activityIndicator = UIActivityIndicatorView(style: .white)
            }
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        alert.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
    }
    
    func oldYearMessage(_ year: String) {
        let message = year + " is included with 2021"
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action:UIAlertAction) in
            self.settingsViewController.select2021()
            self.settingsViewController.show(self, sender: self.settingsViewController)
        }));
        self.settingsViewController.present(alert, animated: false, completion: nil)
    }
    
    
}
