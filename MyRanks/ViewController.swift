import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.MelonArray.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        let melonStruct = self.MelonArray[indexPath.row]
        cell.labelTitle.text = melonStruct.title
        cell.labelArtist.text = melonStruct.artist
        cell.labeIndex.text = melonStruct.rank
        
        return cell
        func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
            let collectionViewCellWidth = collectionView.frame.width /  2
            return CGSize(width: collectionViewCellWidth, height: collectionViewCellWidth)
        }
        
        // 좌우 양옆 간격 조정 함수
        func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout, minimumLineSpaceForSectionAtsection:Int) -> CGFloat {
            return 1
        }
    }
    
    var db: Firestore!
    @IBOutlet weak var melonList: UICollectionView!

    @IBAction func btnBack(_ sender: Any) {
    }
    struct MelonData {
        var title:String = " "
        var artist:String = ""
        var rank:String = ""
        
        
        func  getDic() -> [String:String] {
            let dic = ["title" : self.title,
                       "artist" : self.artist,
                       "rank" : self.rank
                
            ]
            return dic
        }
        
    }
    
    var MelonArray: Array<MelonData> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        melonList.delegate = self
        melonList.dataSource = self
        

    func getValueFromList() {
        MelonArray.removeAll()
        let db = Firestore.firestore()
        db.collection("melon").getDocuments() {
            (querySnapshot, err) in
            if let error = err {
                print("멜론 데이터 읽기 중 에러 발생")
            }else {
                print("멜론 데이터 읽기 성공")
                for document in querySnapshot!.documents {
//                    print("\(document.documentID)=> \(document.data())")
                    let dataDic = document.data() as NSDictionary
                    for i in 1...100 {
                        let title = dataDic["title\(i)"] as? String ?? ""
//                        print("title : ", title)
                        let artist = dataDic["artist\(i)"] as? String ?? ""
//                        print("artist :", artist)
                        let rank = dataDic["rank\(i)"] as? String ?? ""
//                        print("rank :", rank)
                        
                        //dic을 스트럭트로 바꿔서 배열에 넣어줌
                        var melon = MelonData()
                        melon.title = title
                        melon.artist = artist
                        melon.rank = rank
                        self.MelonArray.append(melon)
                    }
                }
                self.melonList.reloadData()
            }
        }
    }
        getValueFromList()
    

 
 

}

}
