//
//  ViewController.swift
//  QuotesApp
//
//  Created by MacBook Pro on 16/04/2025.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteTV: UITableView!
    
    let quote: [QuoteModel] = [
        QuoteModel(image: "4", quote: "Stay hungry, stay foolish.", author: "Steve Jobs"),
        QuoteModel(image: "2", quote: "Be yourself; everyone else is taken.", author: "Oscar Wilde"),
        QuoteModel(image: "3", quote: "Inhale courage, exhale fear.", author: "Unknown"),
        QuoteModel(image: "5", quote: "Whatever you are, be a good one.", author: "Abraham Lincoln"),
        QuoteModel(image: "6", quote: "Dream big. Start small. Act now.", author: "Robin Sharma"),
        QuoteModel(image: "7", quote: "Turn wounds into wisdom.", author: "Oprah Winfrey")
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteTV.dataSource = self
        quoteTV.delegate = self
        quoteTV.register(UINib(nibName: "QuoteCell", bundle: nil), forCellReuseIdentifier: "QuoteCell")
        quoteTV.isPagingEnabled = true
        quoteTV.separatorStyle = .none
        quoteTV.showsVerticalScrollIndicator = false
        quoteTV.contentInset = .zero
        quoteTV.contentInsetAdjustmentBehavior = .never
    }

    @IBAction func setWidget(_ sender: UIButton) {
        if let visibleRow = quoteTV.indexPathsForVisibleRows?.first {
            let currentQuote = quote[visibleRow.row]
            guard let defaults = UserDefaults(suiteName: "group.quotationAppp") else {
                print("Failed to initialize UserDefaults with suiteName: group.quotationAppp")
                return
            }

            guard let image = UIImage(named: currentQuote.image),
                  let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Failed to load or convert image: \(currentQuote.image)")
                return
            }
            
            defaults.set(imageData, forKey: "imageName")
            defaults.set("\(currentQuote.quote)", forKey: "quote")
            defaults.set("\(currentQuote.author)", forKey: "author")
            
            print(currentQuote.quote)
            
            WidgetCenter.shared.reloadTimelines(ofKind: "QuotesWidget")
        }
    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as? QuoteCell else { return UITableViewCell() }
        
        let item = quote[indexPath.row]
        
        cell.img.image = UIImage(named: item.image)
        cell.quoteLabel.text = item.quote
        cell.authorLabel.text = "- \(item.author)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return tableView.frame.height
        }
}
