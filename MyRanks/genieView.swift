import UIKit
import Firebase
import FirebaseFirestore

class genieView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genieArrary.count
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
    }
    @IBOutlet weak var genieList: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genieCell", for: indexPath) as! genieCell
        let melonStruct = self.genieArrary[indexPath.row]
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
    
    struct genieData {
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
    
    var genieArrary: Array<genieData> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        genieList.delegate = self
        genieList.dataSource = self
        
        
        func getValueFromList() {
            genieArrary.removeAll()
            let db = Firestore.firestore()
            db.collection("genie").getDocuments() {
                (querySnapshot, err) in
                if let error = err {
                    print("지니 데이터 읽기 중 에러 발생")
                }else {
                    print("지니 데이터 읽기 성공")
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID)=> \(document.data())")
                        let dataDic = document.data() as NSDictionary
                        for i in 1...100 {
                            let title = dataDic["title\(i)"] as? String ?? ""
//                            print("title : ", title)
                            let artist = dataDic["artist\(i)"] as? String ?? ""
//                            print("artist :", artist)
                            let rank = dataDic["rank\(i)"] as? String ?? ""
//                            print("rank :", rank)
                            
                            //dic을 스트럭트로 바꿔서 배열에 넣어줌
                            var genie = genieData()
                            genie.title = title
                            genie.artist = artist
                            genie.rank = rank
                            self.genieArrary.append(genie)
                        }
                    }
                    self.genieList.reloadData()
                }
            }
        }
        getValueFromList()
        
        
        
        
        
    }
    
}
