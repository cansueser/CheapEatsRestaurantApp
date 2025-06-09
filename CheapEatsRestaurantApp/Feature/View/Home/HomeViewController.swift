import UIKit
import NVActivityIndicatorView

final class HomeViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodAddButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var productStatuView: UIView!
    @IBOutlet weak var waitView: UIView!
    
    private var loadIndicator: NVActivityIndicatorView!
    var homeViewModel: HomeViewModelProtocol = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initLoad()
        configureTableView()
        setupLoadingIndicator()
    }
    
    private func initLoad() {
        homeViewModel.delegate = self
        
        welcomeLabel.text = "Hello, \(RestaurantManager.shared.getRestaurantName())"
        
        tableView.addRoundedBorder(borderWidth: 1, borderColor: .button)
        tableView.backgroundColor = .BG
        
        if homeViewModel.getProductStatu() {
            productStatuView.isHidden = false
        } else {
            productStatuView.isHidden = true
        }
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeViewModel.fetchRestaurantProducts()
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
    
    func error() {
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
