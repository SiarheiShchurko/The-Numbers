//
//  RecordViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 14.03.22.
//

import UIKit


final class RecordViewController: UIViewController {
    
     var recordVM: RecordProtocolVM = RecordVM()
    
    
    //MARK: TableView
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self }
    }
    
    //MARK: Label
    @IBOutlet private weak var RecordLabelOut: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordVM.loadInfo()
        recordVM.update = {
        self.tableView.reloadData()
        }
        
    }
    
    //MARK: Button cancel action (hide display)
    @IBAction func CancelButtonAct(_ sender: Any) {
        dismiss(animated: true) 
    }
}

//MARK: Cell methods
extension RecordViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordVM.recordObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecordTableCell.self)", for: indexPath) as? RecordTableCell
        cell?.setRecordCell(recordVM.recordObjects[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
