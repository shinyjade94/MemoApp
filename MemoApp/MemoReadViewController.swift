//
//  MemoReadViewController.swift
//  MemoApp
//
//  Created by MyeongJin on 2021/03/09.
//

import UIKit

class MemoReadViewController: UIViewController {

    var param: MemoData?
    var memoDAO = MemoDAO()
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var contents: UILabel!
    
    @IBAction func Edit(_ sender: Any) {
        guard let memoFormVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoForm") as? MemoFormViewController else{ return }
        
        memoFormVC.formType = .EDIT
        memoFormVC.receivedData = param
        memoFormVC.memoRead = self
        
        self.navigationController?.pushViewController(memoFormVC, animated: true)
        
    }
}

extension MemoReadViewController {
    override func viewDidLoad() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [.paragraphStyle: style])
        
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.regdate)!)
        
        self.navigationItem.title = dateString
        
        // 배경 이미지 설정
        let bgImage =  UIImage(named: "memo-background.png")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        // 텍스트 뷰의 기본 속성
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [.paragraphStyle: style])
        
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.regdate)!)
        
        self.navigationItem.title = dateString
        
    }
}
