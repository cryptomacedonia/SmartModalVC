//
//  IgorBottomSheetOptionsController.swift
//  templates1
//
//  Created by Igor Jovcevski on 23.7.22.
//

import UIKit


public protocol OptionsCompatibleVC {
    var options: [BottomSheetOptionsStruct]? {get set}
    var header:String? { get set }
}


class IgorBottomSheetOptionsController: UIViewController, OptionsCompatibleVC {
    
    var options: [BottomSheetOptionsStruct]?
    
    var header: String?
    
   
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        header = header ?? "Options"
        tableView.register(UINib(nibName: "OptionCel", bundle: Bundle(for: IgorBottomSheetOptionsController.self)), forCellReuseIdentifier: "OptionCel")
        tableView.delegate = self
        tableView.dataSource = self
        headerLabel.text = header
        
    }
    
    
}

extension IgorBottomSheetOptionsController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCel", for: indexPath) as! OptionCel
        cell.iconImageView.image = UIImage(named: options![indexPath.row].icon) ?? UIImage(systemName: options![indexPath.row].icon)
        cell.optionTitleLabel.text = options![indexPath.row].title
        
        //        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        options![indexPath.row].action?(options![indexPath.row].title)
        
    }
    
}

