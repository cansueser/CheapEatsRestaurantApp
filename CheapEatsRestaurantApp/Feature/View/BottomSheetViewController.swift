import UIKit

class BottomSheetViewController: UIViewController {
    private var viewModel: BottomSheetViewModel
    private var tableView: UITableView!
    var onDismissWithSelectedMeals: (([String]) -> Void)? // Yeni closure
    
    init(viewModel: BottomSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchMealTypes()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Navigation bar'a "Tamam" butonu ekle
        let doneButton = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = UIColor(named: "ButtonColor") // "Tamam" butonu yeşil
        navigationItem.rightBarButtonItem = doneButton
        
        // Navigation bar'a "İptal" butonu ekle
        let cancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor(named: "CutColor") // "İptal" butonu kırmızı
        navigationItem.leftBarButtonItem = cancelButton
        
        // TableView'i ayarla
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func doneButtonTapped() {
        let selectedMeals = viewModel.selectedMealIndices.map { viewModel.mealType[$0].description }
        onDismissWithSelectedMeals?(selectedMeals) // Seçilenleri iletiyoruz
        print("Seçilen yemekler: \(selectedMeals)")
        dismiss(animated: true)
        
    }
    
    @objc private func cancelButtonTapped() {
        viewModel.selectedMealIndices.removeAll()
        tableView.reloadData()
        onDismissWithSelectedMeals?([]) // ProductAddedViewController'a boş array gönder
        dismiss(animated: true)
    }
}
extension BottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mealType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let mealType = viewModel.mealType[indexPath.row].description
        cell.textLabel?.text = mealType
        
        // Seçili mi kontrolü DOĞRUDAN ViewModel'den alın
        if viewModel.selectedMealIndices.contains(indexPath.row) {
            let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
            let imageView = UIImageView(image: checkmarkImage)
            imageView.tintColor = UIColor(named: "ButtonColor")
            cell.accessoryView = imageView
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}

extension BottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         
         // Seçilen satırın indeksini toggle et
         viewModel.toggleSelection(at: indexPath.row)
         
         // SADECE o satırı yenile
         tableView.reloadRows(at: [indexPath], with: .automatic)
        //  print("Seçilen yemekler: \(selectedMeals)")
    }
}
