//
//  MemoListTableViewController.swift
//  MemoApp
//
//  Created by MyeongJin on 2021/03/09.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var dao = MemoDAO()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = self.appDelegate.memolist.count
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.appDelegate.memolist[indexPath.row]
        
        let cellId = rowData.image == nil ? "memoCell" : "memoCellWithImage"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MemoCell

        cell?.subject?.text = rowData.title
        cell?.contents?.text = rowData.contents
        cell?.img?.image = rowData.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        cell?.regdate?.text = formatter.string(from: rowData.regdate!)

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = self.appDelegate.memolist[indexPath.row]
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "MemoRead") as? MemoReadViewController else {
            return
        }
        
        viewController.param = rowData
        viewController.param?.memoIdx = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memolist[indexPath.row]
        
        if dao.delete(data.objectID!) {
            self.appDelegate.memolist.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Life Cycle
extension MemoListTableViewController {
    
    override func viewDidLoad() {
        // ?????? ?????? ??????????????? ?????? ?????? ?????? ?????????
        searchBar.enablesReturnKeyAutomatically = false
        
        // SWRevealViewController ?????????????????? revealViewController ?????? load
        if let revealVC = self.revealViewController() {
            
            // bar ?????? ????????? ????????? ??????
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")  // ???????????? sidemenu.png???
            btn.target = revealVC // ?????? ?????? ??? ????????? ???????????? ????????? ????????? ??????
            btn.action = #selector(revealVC.revealToggle(_:)) // ?????? ?????? ??? revealToggle(_:) ??????
            
            // ????????? ??? ????????? ??????????????? ?????? ?????? ??????????????? ??????
            self.navigationItem.leftBarButtonItem = btn
            
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = self.instanceTutorialVC(name: "MasterVC")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: false, completion: nil)
            return 
        }
        
        self.appDelegate.memolist = self.dao.fetch()
        
        self.tableView.reloadData()
    }
}

extension MemoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text // ?????? ?????? ????????? ???????????? ????????????.
        
        // ???????????? ???????????? ???????????? ??????, ???????????? ??????
        self.appDelegate.memolist = self.dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
}
