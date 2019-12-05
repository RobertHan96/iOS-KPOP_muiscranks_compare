import UIKit
import Firebase
import FirebaseFirestore

class bugsView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genieArrary.count
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var bugsList: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bugsCell", for: indexPath) as! bugsCell
        let bugsStruct = self.genieArrary[indexPath.row]
        cell.labelTitle.text = bugsStruct.title
        cell.labelArtist.text = bugsStruct.artist
        cell.labeIndex.text = bugsStruct.rank
        
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
    
    struct bugsData {
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
    
    var genieArrary: Array<bugsData> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        bugsList.delegate = self
        bugsList.dataSource = self
        
        
        func getValueFromList() {
            genieArrary.removeAll()
            let db = Firestore.firestore()
            db.collection("bugs").getDocuments() {
                (querySnapshot, err) in
                if let error = err {
                    print("벅스 데이터 읽기 중 에러 발생")
                }else {
                    print("벅스 데이터 읽기 성공")
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
                            var bgus = bugsData()
                            bgus.title = title
                            bgus.artist = artist
                            bgus.rank = rank
                            self.genieArrary.append(bgus)
                        }
                    }
                    self.bugsList.reloadData()
                }
            }
        }
        getValueFromList()
        
        
        
        
        
    }
    
}
