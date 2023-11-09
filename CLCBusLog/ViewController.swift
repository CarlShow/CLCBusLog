//
//  ViewController.swift
//  CLCBusLog
//
//  Created by CARL SHOW on 10/31/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var busView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    var rows = 0
    var mid = 0
    var busBuilder = [(busTendancy, String, busTendancy, String)]()
    override func viewDidLoad()
    {
        busView.layer.cornerRadius = 20
        updateButton.layer.cornerRadius = 20
        fetch()
        busView.dataSource = self
        busView.delegate = self
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return busBuilder.count + 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(indexPath.row)
        switch indexPath.row
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Frontmost")!
            cell.layer.cornerRadius = 20
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3019238946)
            return cell
        case mid + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Middlemost")!
            cell.layer.cornerRadius = 20
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3019238946)
            return cell
        case busBuilder.count + 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Endmost")!
            cell.layer.cornerRadius = 20
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3019238946)
            return cell
        case _:
            let cell = tableView.dequeueReusableCell(withIdentifier: "busLane") as! customCell
            var cur = (busTendancy.Null, "", busTendancy.Null, "")
            if indexPath.row < mid + 1
            {
                cur = busBuilder[indexPath.row - 1]
            }
            else
            {
                cur = busBuilder[indexPath.row - 2]
            }
            switch(cur.0)
            {
            case busTendancy.Null:
                cell.busSlotA.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2992400085)
                break
            case busTendancy.Occupied:
                cell.busSlotA.backgroundColor = #colorLiteral(red: 0.9132722616, green: 0.2695424259, blue: 0.4834814668, alpha: 0.6500318878)
                break
            case busTendancy.Present:
                cell.busSlotA.backgroundColor = #colorLiteral(red: 0, green: 0.9909093976, blue: 0, alpha: 0.795838648)
                break
            case _:
                print("Catastrophic error! DIV0 OF DUPLE FAILED IN CELL INSTANCIATION")
            }
            cell.busNameA.text = cur.1
            switch(cur.2)
            {
            case busTendancy.Null:
                cell.busSlotB.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2992400085)
                break
            case busTendancy.Occupied:
                cell.busSlotB.backgroundColor = #colorLiteral(red: 0.9132722616, green: 0.2695424259, blue: 0.4834814668, alpha: 0.6500318878)
                break
            case busTendancy.Present:
                cell.busSlotB.backgroundColor = #colorLiteral(red: 0, green: 0.9909093976, blue: 0, alpha: 0.795838648)
                break
            case _:
                print("Catastrophic error! DIV1 OF DUPLE FAILED IN CELL INSTANCIATION")
            }
            cell.busNameB.text = cur.3
            cell.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3019238946)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cell.layer.cornerRadius = 20
            return cell
        }
    }
    @IBAction func update(_ sender: Any)
    {
        fetch()
    }
    func fetch()
    {
        let dir = Firestore.firestore()
        dir.collection("1lSaZbbzeqLm6e5JssNt").getDocuments { qShot, err in
            if let err = err
            {
                print("Error accessing firestore: \(err)")
            }
            else
            {
                self.rows = (qShot?.documents[0].data().count)!
                self.mid = Int((qShot?.documents[4].data().description)!)!
                var temp = [(busTendancy, String, busTendancy, String)]()
                var g = 0
                for e in 0...3
                {
                    let doc = qShot?.documents[e]
                    var t = 0
                    for item in doc!.data()
                    {
                        let prt = item.value as! String
                        var tek = busTendancy.Null
                        if g == 0 || g == 2
                        {
                            switch prt
                            {
                            case "Empty":
                                tek = busTendancy.Null
                            case "Occupied":
                                tek = busTendancy.Occupied
                            case "Present":
                                tek = busTendancy.Present
                            case _:
                                print("Alert! Reading garbage data!")
                            }
                        }
                        switch g
                        {
                        case 0:
                            temp[t].0 = tek
                        case 1:
                            temp[t].1 = prt
                        case 2:
                            temp[t].2 = tek
                        case 3:
                            temp[t].3 = prt
                        case _:
                            print("Alert! Reading garbage data!")
                        }
                        t += 1
                    }
                    g += 1
                }
                self.busBuilder = temp
            }
        }
    }
}
