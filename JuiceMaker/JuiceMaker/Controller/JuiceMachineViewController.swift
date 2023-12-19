
import UIKit

// MARK: - JuiceMachineViewController init & deinit
final class JuiceMachineViewController: UIViewController {
    
    @IBOutlet var juiceMachineView: JuiceMachineView!
    private var reception = Reception()
    
    deinit { NotificationCenter.default.removeObserver(self) }
}

// MARK: - LifeCycle
extension JuiceMachineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        setupUI()
    }
}

// MARK: - Setup UI
private extension JuiceMachineViewController {
    
    func setupUI() {
        setupButtonAction()
        reception.applyCurrentStocks()
    }
    
    func setupButtonAction() {
        juiceMachineView.bananaOrderButton.addTarget(self, action: #selector(bananaJuiceOrderButtonTapped), for: .touchUpInside)
        juiceMachineView.strawberryOrderButton.addTarget(self, action: #selector(strawberryJuiceOrderButtonTapped), for: .touchUpInside)
        juiceMachineView.mangoOrderButton.addTarget(self, action: #selector(mangoJuiceButtonTapped), for: .touchUpInside)
        juiceMachineView.kiwiOrderButton.addTarget(self, action: #selector(kiwiJuiceOrderButtonTapped), for: .touchUpInside)
        juiceMachineView.pineappleOrderButton.addTarget(self, action: #selector(pineappleJuiceOrderButtonTapped), for: .touchUpInside)
        juiceMachineView.ddalbaOrderButton.addTarget(self, action: #selector(ddalbaJuiceOrderButtonTapped), for: .touchUpInside)
        juiceMachineView.mangkiOrderButton.addTarget(self, action: #selector(mangkiJuiceButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "재고 수정", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
}

// MARK: - Button Action Method
private extension JuiceMachineViewController {
    
    @objc func ddalbaJuiceOrderButtonTapped() {
        reception.acceptJuiceOrder(of: .ddalba)
        AlertHandler.shared.presentAlert(
            of: .successJuiceOrder("맛있게 드세요 :)")) { _ in
                print("딸바 주스 제조성공!")
            }
    }
    
    @objc func mangkiJuiceButtonTapped() {
        reception.acceptJuiceOrder(of: .mangki)
        AlertHandler.shared.presentAlert(
            of: .successJuiceOrder("맛있게 드세요 :)")) { _ in
                print("망키 주스 제조성공!")
            }
    }
    
    @objc func strawberryJuiceOrderButtonTapped() {
        reception.acceptJuiceOrder(of: .strawberry)
        AlertHandler.shared.presentAlert(
            of: .successJuiceOrder("맛있게 드세요 :)")) { _ in
                print("딸기 주스 제조성공!")
            }
    }
    
    @objc func bananaJuiceOrderButtonTapped() {
        reception.acceptJuiceOrder(of: .banana)
        AlertHandler.shared.presentAlert(
            of: .successJuiceOrder("맛있게 드세요 :)")) { _ in
                print("바나나 주스 제조성공!")
            }
    }
    
    @objc func pineappleJuiceOrderButtonTapped() {
        reception.acceptJuiceOrder(of: .pineapple)
        AlertHandler.shared.presentAlert(
            of: .successJuiceOrder("맛있게 드세요 :)")) { _ in
                print("파인애플 주스 제조성공!")
            }
    }
    
    @objc func kiwiJuiceOrderButtonTapped() {
        reception.acceptJuiceOrder(of: .kiwi)
        AlertHandler.shared.presentAlert(
            of: .successJuiceOrder("맛있게 드세요 :)")) { _ in
                print("키위 주스 제조성공!")
            }
    }
    
    @objc func mangoJuiceButtonTapped() {
        reception.acceptJuiceOrder(of: .mango)
        AlertHandler.shared.presentAlert(
            of: .successJuiceOrder("맛있게 드세요 :)")) { _ in
                print("망고 주스 제조성공!")
            }
    }
    
    @objc func rightBarButtonTapped() {
        pushStockManageViewController()
    }
}

// MARK: - SetUp Notification Center
private extension JuiceMachineViewController {
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFruitStock), name: .fruitStockDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleError), name: .errorOccured, object: nil)
    }
    
    @objc func updateFruitStock(notification: Notification) {
        guard let fruitStock =
                notification.userInfo?["fruitsStock"] as? [FruitStore.Fruits: Int] else {
            return
        }
        updateStockLabel(from: fruitStock)
    }
    
    func updateStockLabel(from fruitStock: [FruitStore.Fruits: Int]) {
        juiceMachineView.bananaStockLabel.text = String(fruitStock[.banana] ?? 0)
        juiceMachineView.strawberryStockLabel.text = String(fruitStock[.strawberry] ?? 0)
        juiceMachineView.mangoStockLabel.text = String(fruitStock[.mango] ?? 0)
        juiceMachineView.pineappleStockLabel.text = String(fruitStock[.pineapple] ?? 0)
        juiceMachineView.kiwiStockLabel.text = String(fruitStock[.kiwi] ?? 0)
    }
    
    @objc func handleError() {
        AlertHandler.shared.presentAlert(
            of: .fruitShortage("과일을 추가하시겠습니까?")) { [weak self] _ in
                self?.pushStockManageViewController()
            }
    }
}

// MARK: - ViewTransition Method
extension JuiceMachineViewController {
    private func pushStockManageViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let stockManageViewController = storyboard.instantiateViewController(identifier: "StockManageViewController") as? StockManageViewController {
            stockManageViewController.reception = reception
            self.navigationController?.pushViewController(stockManageViewController, animated: true)
        }
    }
}
