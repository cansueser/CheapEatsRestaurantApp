import UIKit
import NVActivityIndicatorView

final class HomeViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var foodAddButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var productStatuView: UIView!
    @IBOutlet weak var orderStatuView: UIView!
    @IBOutlet weak var waitView: UIView!
    
    private var loadIndicator: NVActivityIndicatorView!
    var homeViewModel: HomeViewModelProtocol = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        initLoad()
        configureTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(restaurantProfileUpdated), name: NSNotification.Name("RestaurantProfileUpdated"), object: nil)
    }
    
    private func initLoad() {
        homeViewModel.delegate = self
        homeViewModel.startListeningOrders()
        
        welcomeLabel.text = "Hello, \(RestaurantManager.shared.getRestaurantName())"
        
        tableView.addRoundedBorder(borderWidth: 1, borderColor: .button)
        tableView.backgroundColor = .BG
        addShadow(tableView)
        
        orderTableView.addRoundedBorder(borderWidth: 1, borderColor: .button)
        orderTableView.backgroundColor = .BG
        addShadow(orderTableView)
        
        if homeViewModel.getProductStatu() {
            productStatuView.isHidden = false
        } else {
            productStatuView.isHidden = true
        }
    }
    
    private func updateUserInfo() {
        welcomeLabel.text = "Hello, \(RestaurantManager.shared.getRestaurantName())"
    }
    
    @objc private func restaurantProfileUpdated() {
        updateUserInfo()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.separatorStyle = .none
        orderTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.fetchRestaurantProducts()
        homeViewModel.fetchRestaurantOrders()
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    @IBAction func foodAddButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productVC = storyboard.instantiateViewController(withIdentifier: "ProductAddedViewController") as? ProductManageViewController {
            //productVC.orderViewModel = orderViewModel
            productVC.productManageViewModel.goSource = .addProduct
            navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

extension HomeViewController: HomeViewModelOutputProtocol {
    func update() {
        tableView.reloadData()
        if homeViewModel.getProductStatu() {
            productStatuView.isHidden = false
        } else {
            productStatuView.isHidden = true
        }
        print("Update")
    }
    
    func updateOrder() {
        if !homeViewModel.orders.isEmpty {
            UIView.transition(with: orderTableView,
                              duration: 0.25,
                              options: .curveLinear,
                              animations: {
                self.orderTableView.reloadData()
            })
        }
        if homeViewModel.getOrderStatu() {
            orderStatuView.isHidden = false
        } else {
            orderStatuView.isHidden = true
        }
    }
    
    
    func error() {
        if homeViewModel.getProductStatu() {
            productStatuView.isHidden = false
        } else {
            productStatuView.isHidden = true
        }
        
        if homeViewModel.getOrderStatu() {
            orderStatuView.isHidden = false
        } else {
            orderStatuView.isHidden = true
        }
        print("Error")
    }
    
    func startLoading() {
        waitView.isHidden = false
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
}
