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
    func enable2021(_ enable: Bool)
    func enable2020(_ enable: Bool)
    func changeYear(_ segment: Int)
    func override2021() -> Bool
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
    var monthlyActive = false
    var monthlyTrialActive = false
    var package2021: Purchases.Package!
    var packageMonthly: Purchases.Package!
    var packageMonthlyTrial: Purchases.Package!
    var purchased2021 = false
    var purchaseMenu: PurchaseMenu!
    var price2021 = 0.0
    var priceMonthly = 0.0
    var priceMonthlyTrial = 0.0
    var responseTimeoutSeconds = 360.0
    var viewController: UIViewController!
    var monthlyTrialOption = false
    
    init(viewController: UIViewController, gameDelegate: GameDelegate) {
        self.viewController = viewController
        self.gameDelegate = gameDelegate
        self.purchaseMenu = PurchaseMenu(revenueCat: self)
        purchased2021 = defaults.bool(forKey: "purchased2021")
        monthlyActive = defaults.bool(forKey: "monthlyActive")
        monthlyTrialActive = defaults.bool(forKey: "monthlyTrialActive")
    }
    
    func start() {
        print("RevenueCat.start")
        if is2021Purchased() || monthlyActive {
            gameDelegate.enable2021(true)
            gameDelegate.enable2020(true)
            gameDelegate.redeal()
        } else {
            showPurchaseMenu(viewController)
        }
        getPrice2021()
        refreshPurchaseInfo()
    }
    
    func showPurchaseMenu(_ viewController: UIViewController) {
        viewController.show(purchaseMenu, sender: viewController)
    }
    
    func getPrice2021() {
        Purchases.shared.offerings { (offerings, error) in
            if let packages = offerings?.offering(identifier: "default")?.availablePackages {
                for package in packages {
                    if package.product.productIdentifier == "com.eightbam.mahjong2019.patterns2021" {
                        self.package2021 = package
                        self.price2021 = Double(truncating: package.product.price)
                        self.purchaseMenu.updatePrice2021(self.price2021)
                    }
                    if package.product.productIdentifier == "com.eightbam.mahjongpractice.monthly" {
                        self.packageMonthly = package
                        self.priceMonthly = Double(truncating: package.product.price)
                        if self.priceMonthly > 1.50 && self.priceMonthly < 2.00 {
                            self.priceMonthly = 1.99
                        }
                        self.purchaseMenu.updatePriceMonthly(self.priceMonthly)
                    }
                    //if package.product.productIdentifier == "com.eightbam.mahjongpractice.monthlyTrial" {
                    //    self.packageMonthlyTrial = package
                    //    self.priceMonthlyTrial = Double(truncating: package.product.price)
                    //    self.monthlyTrialOption = true
                    //}
                }
            }
        }
    }
    
    func refreshPurchaseInfo() {
        print("refresh")
        Purchases.shared.purchaserInfo { (info, error) in
            if info != nil {
                if info?.entitlements["Monthly"]?.isActive == true {
                    self.monthlyActive = true
                    self.gameDelegate.enable2021(true)
                    self.gameDelegate.enable2020(true)
                } else {
                    self.monthlyActive = false
                    self.gameDelegate.enable2021(self.is2021Purchased())
                    self.gameDelegate.enable2020(self.is2020Purchased())
                }
                if info?.entitlements["MonthlyTrial"]?.isActive == true {
                    self.monthlyTrialActive = true
                    self.gameDelegate.enable2021(true)
                    self.gameDelegate.enable2020(true)
                }
                self.defaults.set(self.monthlyActive, forKey: "monthlyActive")
                self.defaults.set(self.monthlyTrialActive, forKey: "monthlyTrialActive")
                print("MonthlyActive \(self.monthlyActive)")
            }
        }
    }
    
    func purchase2021() {
        Purchases.shared.purchasePackage(package2021) { (transaction, info, error, userCancelled) in
            self.purchaseMenu.purchaseTimer.invalidate()
            if error != nil {
                self.purchaseMenu.alertForPurchase.dismiss(animated: false, completion: {
                    let message = (error! as NSError).localizedDescription
                    self.purchaseMenu.showRetryPurchase2021(error: message)
                })
            } else if transaction != nil {
                if transaction?.transactionState == .purchased {
                    self.completePurchase2021()
                }
            }
            if error == nil && info != nil && self.purchased2021 == false {
                if info?.entitlements["Patterns2021"]?.isActive == true {
                    self.completePurchase2021()
                } else {
                    self.purchaseMenu.showRetryPurchase2021(error: "The in-app purchase for 2021 Access is not active. For help contact support@eightbam.com")
                }
            }
        }
    }

    func purchaseMonthly() {
        Purchases.shared.purchasePackage(packageMonthly) { (transaction, purchaserInfo, error, userCancelled) in
            self.purchaseMenu.purchaseTimer.invalidate()
            if error != nil {
                self.purchaseMenu.alertForPurchase.dismiss(animated: false, completion: {
                    let message = (error! as NSError).localizedDescription
                    self.purchaseMenu.showRetryPurchaseMonthly(error: message)
                })
            } else if transaction != nil {
                if transaction?.transactionState == .purchased {
                    self.completePurchaseMonthly()
                }
            }
            if error == nil && purchaserInfo != nil && self.monthlyActive == false {
                if purchaserInfo?.entitlements["Monthly"]?.isActive == true {
                    self.completePurchaseMonthly()
                } else {
                    self.purchaseMenu.showRetryPurchaseMonthly(error: "The in-app purchase for Monthly Access is not active. For help contact support@eightbam.com")
                }
            }
        }
    }
    
    func purchaseMonthlyTrial() {
        Purchases.shared.purchasePackage(packageMonthlyTrial) { (transaction, purchaserInfo, error, userCancelled) in
            self.purchaseMenu.purchaseTimer.invalidate()
            if error != nil {
                self.purchaseMenu.alertForPurchase.dismiss(animated: false, completion: {
                    let message = (error! as NSError).localizedDescription
                    self.purchaseMenu.showRetryPurchaseMonthlyTrial(error: message)
                })
            } else if transaction != nil {
                if transaction?.transactionState == .purchased {
                    self.completePurchaseMonthlyTrial()
                }
            }
            if error == nil && purchaserInfo != nil && self.monthlyTrialActive == false {
                if purchaserInfo?.entitlements["MonthlyTrial"]?.isActive == true {
                     self.completePurchaseMonthlyTrial()
                } else {
                     self.purchaseMenu.showRetryPurchaseMonthlyTrial(error: "The in-app purchase for Free Trial Monthly Access is not active. For help contact support@eightbam.com")
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
        gameDelegate.enable2021(true)
        gameDelegate.enable2020(true)
        gameDelegate.load2021()
    }
    
    func completePurchaseMonthly() {
        monthlyActive = true
        defaults.set(monthlyActive, forKey: "monthlyActive")
        purchaseMenu.alertForPurchase.dismiss(animated: true, completion: {
            self.purchaseMenu.close()
        })
        gameDelegate.enable2021(true)
        gameDelegate.enable2020(true)
        gameDelegate.load2021()
    }
    
    func completePurchaseMonthlyTrial() {
        monthlyTrialActive = true
        defaults.set(monthlyTrialActive, forKey: "monthlyTrialActive")
        purchaseMenu.alertForPurchase.dismiss(animated: true, completion: {
            self.purchaseMenu.close()
        })
        gameDelegate.enable2021(true)
        gameDelegate.enable2020(true)
        gameDelegate.load2021()
    }
    
    func restore2021() {
        Purchases.shared.restoreTransactions { (info, error) in
            self.purchaseMenu.restoreTimer.invalidate()
            if let e = error {
                self.purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
                    self.purchaseMenu.showRetryRestore2021(error: (e as NSError).localizedDescription)
                })
            } else if info?.entitlements["Patterns2021"]?.isActive == true {
                self.completeRestore2021()
            } else {
                self.purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
                    self.purchaseMenu.showRetryRestore2021(error: "The in-app purchase for 2021 Access is not active. For help contact support@eightbam.com")
                })
            }
        }
    }
    
    func restoreMonthly() {
        Purchases.shared.restoreTransactions { (info, error) in
            self.purchaseMenu.restoreTimer.invalidate()
            if let e = error {
                self.purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
                    self.purchaseMenu.showRetryRestoreMonthly(error: (e as NSError).localizedDescription)
                })
            } else if info?.entitlements["Monthly"]?.isActive == true {
                self.completeRestoreMonthly()
            } else {
                self.purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
                    self.purchaseMenu.showRetryRestoreMonthly(error: "The in-app purchase for Monthly Access is not active. For help contact support@eightbam.com")
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
        gameDelegate.enable2021(true)
        gameDelegate.enable2020(true)
        gameDelegate.load2021()
    }
    
    func completeRestoreMonthly() {
        monthlyActive = true
        defaults.set(self.monthlyActive, forKey: "monthlyActive")
        purchaseMenu.alertForRestore.dismiss(animated: true, completion: {
            self.purchaseMenu.close()
        })
        gameDelegate.enable2021(true)
        gameDelegate.enable2020(true)
        gameDelegate.load2021()
    }
    
    func is2021Purchased() -> Bool {
        let history2021 = AppStoreHistory.store.isProductPurchased(AppStoreHistory.Patterns2021)
        return history2021 || purchased2021 || gameDelegate.override2021()
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
                if is2018Purchased() || monthlyActive {
                    gameDelegate.changeYear(YearSegment.segment2018)
                } else {
                    purchaseMenu.oldYearMessage("2018")
                }
            case Year.y2019:
                if is2019Purchased() || monthlyActive {
                    gameDelegate.changeYear(YearSegment.segment2019)
                } else {
                    purchaseMenu.oldYearMessage("2019")
                }
            case Year.y2020:
                if is2020Purchased() || monthlyActive {
                    gameDelegate.changeYear(YearSegment.segment2020)
                } else {
                    purchaseMenu.oldYearMessage("2020")
                }
            case Year.y2021:
                if is2021Purchased() || monthlyActive {
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
    var monthlyButton = UIButton()
    var planText = UITextView()
    var purchaseButton = UIButton()
    var purchaseTimer = Timer()
    var purchaseView = UIView()
    var restoreButton = UIButton()
    var restoreTimer = Timer()
    var revenueCat: RevenueCat!
    var settingsViewController: SettingsViewController!
    var yOffset = 0
    
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
            yOffset = Int(height() - 300) / 2
            setBackground()
            addPurchaseView()
            addTitle("2021 Pattern Access", y: yOffset)
            planText = addText("Buy 2021 Pattern Access with a one time purchase.", y: yOffset + 37, height: 65)
            addPurchaseButton(y: yOffset + 95)
            addRestoreButton(y: yOffset + 155)
            addMonthlyButton(y: yOffset + 155)
            let _ = addText("support@eightbam.com", y: yOffset + 265, height: 30)
            addCloseButton(y: yOffset + 20)
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
            showTrialMenu()
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
    
    func showTrialMenu() {
        var title = "2017 is available as a free trial with limited feautures"
        var message = ""
        if revenueCat.monthlyTrialOption {
            title = "Free Trial\nMonthly Subscription"
            message = "A free trial is available for 3 days then $\(revenueCat.priceMonthlyTrial) per month. Cancel anytime."
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if revenueCat.monthlyTrialOption {
            alert.addAction(UIAlertAction(title: "Free Trial", style: .default, handler: {(action:UIAlertAction) in
                self.showConnectMessageForPurchase()
                self.revenueCat.purchaseMonthlyTrial()
            }));
        } else {
            alert.addAction(UIAlertAction(title: "2017", style: .default, handler: {(action:UIAlertAction) in
                if self.settingsViewController != nil {
                    self.settingsViewController.select2017()
                }
                self.revenueCat.gameDelegate.redeal()
                self.dismiss(animated: true, completion: nil)
            }));
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in
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
    
    func addText(_ text: String, y: Int, height: Int) -> UITextView {
        let offset = (width() - 455) / 2
        let label = UITextView(frame: CGRect(x: offset, y: y, width: 455, height: height))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.isUserInteractionEnabled = false
        view.addSubview(label)
        return label
    }
    
    func addPurchaseButton(y: Int) {
        purchaseButton = UIButton(frame: CGRect(x: (width()-220)/2, y: y, width: 220, height: 44))
        purchaseButton.layer.cornerRadius = 5
        purchaseButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        if revenueCat.price2021 == 0.0 {
            purchaseButton.setTitle("Connecting...", for: .normal)
            purchaseButton.isEnabled = false
        } else {
            purchaseButton.setTitle("$\(revenueCat.price2021) for 2021", for: .normal)
            purchaseButton.isEnabled = true
        }
        purchaseButton.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 0, alpha: 1.0);
        purchaseButton.setTitleColor(.black, for: .normal)
        purchaseButton.addTarget(self, action: #selector(purchase2021ButtonAction), for: .touchUpInside)
        view.addSubview(purchaseButton)
    }
    
    func addMonthlyButton(y: Int) {
        monthlyButton = UIButton(frame: CGRect(x: (width()-220)/2, y: y, width: 220, height: 44))
        monthlyButton.layer.cornerRadius = 5
        monthlyButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        if revenueCat.priceMonthly == 0.0 {
            monthlyButton.setTitle("Connecting...", for: .normal)
            monthlyButton.isEnabled = false
            monthlyButton.isHidden = true
        } else {
            updatePriceMonthly(revenueCat.priceMonthly)
        }
        monthlyButton.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 0, alpha: 1.0);
        monthlyButton.setTitleColor(.black, for: .normal)
        monthlyButton.addTarget(self, action: #selector(purchaseMonthlyButtonAction), for: .touchUpInside)
        view.addSubview(monthlyButton)
    }

    @objc func purchase2021ButtonAction(sender: UIButton!) {
        showConnectMessageForPurchase()
        revenueCat.purchase2021()
    }
    
    @objc func purchaseMonthlyButtonAction(sender: UIButton!) {
        showConnectMessageForPurchase()
        revenueCat.purchaseMonthly()
    }
    
    func updatePrice2021(_ price: Double) {
        purchaseButton.setTitle("$\(price) for 2021", for: .normal)
        purchaseButton.isEnabled = true
    }
    
    func updatePriceMonthly(_ price: Double) {
        monthlyButton.setTitle("$\(price) Per Month", for: .normal)
        monthlyButton.isEnabled = true
        monthlyButton.isHidden = false
        planText.text = "Buy 2021 with a one time purchase OR pay per month and cancel anytime. Both plans include all features."
        restoreButton.removeFromSuperview()
        addRestoreButton(y: yOffset + 215)
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
        restoreButton = UIButton(frame: CGRect(x: (width()-220)/2, y: y, width: 220, height: 44))
        restoreButton.layer.cornerRadius = 5
        restoreButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        restoreButton.setTitle("Restore Purchase", for: .normal)
        restoreButton.backgroundColor = .lightGray
        restoreButton.addTarget(self, action: #selector(showRestoreMenu), for: .touchUpInside)
        view.addSubview(restoreButton)
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
    
    func showRetryRestore2021(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForRestore()
            self.revenueCat.restore2021()
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func showRetryRestoreMonthly(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForRestore()
            self.revenueCat.restoreMonthly()
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func showRetryPurchase2021(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForPurchase()
            self.revenueCat.purchase2021()
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func showRetryPurchaseMonthly(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForPurchase()
            self.revenueCat.purchaseMonthly()
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func showRetryPurchaseMonthlyTrial(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForPurchase()
            self.revenueCat.purchaseMonthlyTrial()
        }));
        present(alert, animated: false, completion: nil)
    }
    
    func showErrorMessage(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action:UIAlertAction) in }));
        present(alert, animated: false, completion: nil)
    }
    
    @objc func showRestoreMenu() {
        let message = "Restore 2021 Access or Monthly Access on a new device, a second device or after deleting. For help  support@eightbam.com."
        let alert = UIAlertController(title: "Restore Purchase", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "2021 Access", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForRestore()
            self.revenueCat.restore2021()
        }));
        alert.addAction(UIAlertAction(title: "Monthly Access", style: .default, handler: {(action:UIAlertAction) in
            self.showConnectMessageForRestore()
            self.revenueCat.restoreMonthly()
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
