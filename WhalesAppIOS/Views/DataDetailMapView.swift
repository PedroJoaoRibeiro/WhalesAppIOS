//
//  DataDetailMapView.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 11/06/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import UIKit


class DataDetailMapView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var data: DataModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // setup list
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func configureWithData(data: DataModel) {
        self.data = data
        title.text = "Date: " + data.date.toString(withFormat: "yyyy-MM-dd HH:mm:ss")
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate/DataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomCell", owner: self, options: nil)?.first as! DataDetailCustomCell
        let item = data.array[indexPath.row]
        cell.configureWithItem(item: item)
        return cell
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("im here")
        
        // play button
        if let result = playButton.hitTest(convert(point, to: playButton), with: event) {
            return result
        }
        // stop
        if let result = stopButton.hitTest(convert(point, to: stopButton), with: event) {
            return result
        }
        
        // list
        if let result = tableView.hitTest(convert(point, to: tableView), with: event) {
            return result
        }
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
    
    
    @IBAction func stopMusic(_ sender: UIButton) {
        print("stop music")
    }
    @IBAction func playMusic(_ sender: UIButton) {
        print("start music")
    }

}


