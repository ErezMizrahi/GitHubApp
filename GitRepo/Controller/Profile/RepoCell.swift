//
//  RepoCell.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

protocol SelfConfigureCell: class {
    static var identifier: String { get }
    func configure(with dataSource : Repo)
    func configure(with dataSource : UserViewModel)
}
extension SelfConfigureCell {
    func configure(with dataSource: Repo) { }
    func configure(with dataSource : UserViewModel) { }

}

class RepoCell: UITableViewCell, SelfConfigureCell {
    static var identifier: String = "cellID"
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    
    private func dateFormatter(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        
        if let date: Date = formatter.date(from: dateString) {
            return String(formatter.string(from: date).split(separator: "T")[0])
        }else {
            return ""
        }
        
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with dataSource: Repo) {
        self.repoName.text = dataSource.name
        self.createdAt.text = dataSource.language
    }
    
    
}
