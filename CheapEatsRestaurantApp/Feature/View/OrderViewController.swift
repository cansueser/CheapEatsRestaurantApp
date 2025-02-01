import UIKit

class OrderViewController: UIViewController {
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var foodAddButton: UIButton!
    
    var orderViewModel = OrderViewModel()
    //celli güncelleme
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        orderViewModel.delegate = self
        
        // Test verisi ekleme
        let testOrder = Order(name: "Pizza", description: "Kaşarlı pizza", oldPrice: 20, newPrice: 15, deliveryTypeTitle: "kurye", discountType: 1, endTime: Date(), foodImage: UIImage(named: "testImage")!, orderStatus: .preparing,mealTypes: ["Tavuk","Tatlı"])
        orderViewModel.addOrder(testOrder)
    }
    
    private func configureTableView() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.separatorStyle = .none
        orderTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }
    
    @IBAction func foodAddButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productVC = storyboard.instantiateViewController(withIdentifier: "ProductAddedViewController") as? ProductAddedViewController {
            productVC.orderViewModel = orderViewModel
            navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

extension OrderViewController: OrderViewModelOutputProtocol {
    func ordersDidUpdate() {
        orderTableView.reloadData()
    }
}
