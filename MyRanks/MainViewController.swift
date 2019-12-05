import UIKit
import Firebase
import FirebaseFirestore


class MainViewController: UIViewController {
    @IBOutlet weak var melonTitle1: UILabel!
    @IBOutlet weak var melonArtist1: UILabel!
    @IBOutlet weak var melonTitle2: UILabel!
    @IBOutlet weak var melonArtist2: UILabel!
    @IBOutlet weak var melonTitle3: UILabel!
    @IBOutlet weak var melonArtist3: UILabel!
    
    @IBOutlet weak var bugsTitle1: UILabel!
    @IBOutlet weak var bugsArtist1: UILabel!
    @IBOutlet weak var bugsTitle2: UILabel!
    @IBOutlet weak var bugsArtist2: UILabel!
    @IBOutlet weak var bugsTitle3: UILabel!
    @IBOutlet weak var bugsArtist3: UILabel!
    
    @IBOutlet weak var genieTitle1: UILabel!
    @IBOutlet weak var genieArtist1: UILabel!
    @IBOutlet weak var genieTitle2: UILabel!
    @IBOutlet weak var genieArtist2: UILabel!
    @IBOutlet weak var genieTitle3: UILabel!
    @IBOutlet weak var genieArtist3: UILabel!
    
    
    @IBAction func melonBtn(_ sender: Any) {
        
    }
    @IBAction func bugsBtn(_ sender: Any) {
    }
    
    @IBAction func genieBtn(_ sender: Any) {
    }
    

 
    @IBOutlet weak var melonFirstRank: UILabel!
    @IBOutlet weak var melonSecondRank: UILabel!
    @IBOutlet weak var melonThirdRank: UILabel!
    
    @IBOutlet weak var bugsFirstRank: UILabel!
    @IBOutlet weak var bugsSecondRank: UILabel!
    @IBOutlet weak var bugsThirdRank: UILabel!
    
    @IBOutlet weak var genieFirstRank: UILabel!
    @IBOutlet weak var genieSecondRank: UILabel!
    @IBOutlet weak var genieThirdRank: UILabel!
    
    
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
    
    // 지니 데이터 저장용 컬렉션 생성
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
    
    // 벅스 데이터 저장용 컬렉션 생성
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
    
    var bugsArrary: Array<bugsData> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 음원순위 레이블에 이미지를 추가하는 함수
        func labelimgAppend(labelName : UILabel, ImageName : String) {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: ImageName)
            let attachmentString = NSAttributedString(attachment: attachment)
            attachment.bounds = CGRect(x: 0, y: 0, width: 32, height: 20)
            labelName.attributedText = attachmentString
            
    }
        // 음원 랭킹용 레이블에 이미지 추가
        labelimgAppend(labelName: bugsFirstRank, ImageName: "first.png")
        labelimgAppend(labelName: bugsSecondRank, ImageName: "second.png")
        labelimgAppend(labelName: bugsThirdRank, ImageName: "third.png")
        
        labelimgAppend(labelName: melonFirstRank, ImageName: "first.png")
        labelimgAppend(labelName: melonSecondRank, ImageName: "second.png")
        labelimgAppend(labelName: melonThirdRank, ImageName: "third.png")
        
        labelimgAppend(labelName: genieFirstRank, ImageName: "first.png")
        labelimgAppend(labelName: genieSecondRank, ImageName: "second.png")
        labelimgAppend(labelName: genieThirdRank, ImageName: "third.png")
        
        
        func getGenieTop3() {
            genieArrary.removeAll()
            let db = Firestore.firestore()
            db.collection("genie").getDocuments() {
                (querySnapshot, err) in
                if let error = err {
                    print("지니 TOP3 데이터 읽기 중 에러 발생")
                }else {
                    print("지니 TOP3 데이터 읽기 성공")
                    for document in querySnapshot!.documents {
                        //                    print("\(document.documentID)=> \(document.data())")
                        let dataDic = document.data() as NSDictionary
                        for i in 1...3 {
                            let title = dataDic["title\(i)"] as? String ?? ""
                            //                        print("title : ", title)
                            let artist = dataDic["artist\(i)"] as? String ?? ""
                            //                        print("artist :", artist)
                            let rank = dataDic["rank\(i)"] as? String ?? ""
                            //                        print("rank :", rank)
                            
                            //dic을 스트럭트로 바꿔서 배열에 넣어줌
                            var genie = genieData()
                            genie.title = title
                            genie.artist = artist
                            genie.rank = rank
                            self.genieArrary.append(genie)
                        }
                    }
                    let grank1 = self.genieArrary[0]
                    let grank2 = self.genieArrary[1]
                    let grank3 = self.genieArrary[2]
                    self.genieTitle1.text = grank1.title
                    self.genieTitle2.text = grank2.title
                    self.genieTitle3.text = grank3.title
                    self.genieArtist1.text = grank1.artist
                    self.genieArtist2.text = grank2.artist
                    self.genieArtist3.text = grank3.artist
                    
                }
            }
        }
        getGenieTop3()
        
        
        func getBugsTop3() {
            bugsArrary.removeAll()
            let db = Firestore.firestore()
            db.collection("bugs").getDocuments() {
                (querySnapshot, err) in
                if let error = err {
                    print("벅스 TOP3 데이터 읽기 중 에러 발생")
                }else {
                    print("벅스 TOP3 데이터 읽기 성공")
                    for document in querySnapshot!.documents {
                        //                    print("\(document.documentID)=> \(document.data())")
                        let dataDic = document.data() as NSDictionary
                        for i in 1...3 {
                            let title = dataDic["title\(i)"] as? String ?? ""
                            //                        print("title : ", title)
                            let artist = dataDic["artist\(i)"] as? String ?? ""
                            //                        print("artist :", artist)
                            let rank = dataDic["rank\(i)"] as? String ?? ""
                            //                        print("rank :", rank)
                            
                            //dic을 스트럭트로 바꿔서 배열에 넣어줌
                            var bugs = bugsData()
                            bugs.title = title
                            bugs.artist = artist
                            bugs.rank = rank
                            self.bugsArrary.append(bugs)
                        }
                    }
                    let brank1 = self.bugsArrary[0]
                    let brank2 = self.bugsArrary[1]
                    let brank3 = self.bugsArrary[2]
                    self.bugsTitle1.text = brank1.title
                    self.bugsTitle2.text = brank2.title
                    self.bugsTitle3.text = brank3.title
                    self.bugsArtist1.text = brank1.artist
                    self.bugsArtist2.text = brank2.artist
                    self.bugsArtist3.text = brank3.artist
                    
                }
            }
        }
        getBugsTop3()
        
     func getMelonTop3() {
        MelonArray.removeAll()
        let db = Firestore.firestore()
        db.collection("melon").getDocuments() {
            (querySnapshot, err) in
            if let error = err {
                print("멜론 TOP3 데이터 읽기 중 에러 발생")
            }else {
                print("멜론 TOP3 데이터 읽기 성공")
                for document in querySnapshot!.documents {
                    //                    print("\(document.documentID)=> \(document.data())")
                    let dataDic = document.data() as NSDictionary
                    for i in 1...3 {
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
                let mrank1 = self.MelonArray[0]
                let mrank2 = self.MelonArray[1]
                let mrank3 = self.MelonArray[2]
                self.melonTitle1.text = mrank1.title
                self.melonTitle2.text = mrank2.title
                self.melonTitle3.text = mrank3.title
                self.melonArtist1.text = mrank1.artist
                self.melonArtist2.text = mrank2.artist
                self.melonArtist3.text = mrank3.artist

            }
        }
    }
    getMelonTop3()


    }
    

}

