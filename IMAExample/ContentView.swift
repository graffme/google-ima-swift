import AVFoundation
import GoogleInteractiveMediaAds
import SwiftUI

struct ContentView: View {
    var body: some View {
        AdView()
    }
}

/* AD VIEW */

struct AdView: UIViewRepresentable {
  func updateUIView(
    _ uiView: UIView,
    context: UIViewRepresentableContext<AdView>
  ) {}
    
  func makeUIView(context: Context) -> UIView {
    return AdUIView(frame: .zero)
  }
}

class AdUIView: UIView {
    static let AdTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator="
    
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = UIColor.black
      print("Init AdUIView")
      setUpAdsLoader()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
    }
    
    func setUpAdsLoader() {
        print("Set up AdsLoader")
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
        requestAds()
    }
    
    func requestAds() {
        print("Request Ad")
        // Create ad display container for ad rendering.
        let adContainer = IMAAdDisplayContainer(adContainer: self, viewController: .init())
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: AdUIView.AdTagURLString,
            adDisplayContainer: adContainer,
            contentPlayhead: nil,
            userContext: nil)
        
        print("Request: \(String(describing: request))")

        adsLoader.requestAds(with: request)
      }
}

extension AdUIView: IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    // MARK: - IMAAdsManagerDelegate
    func adsManager(
        _ adsManager: IMAAdsManager!,
        didReceive event: IMAAdEvent!
    ) {
        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
            print("AD STARTED")
            adsManager.start()
        }
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        print("Ad Manager recieved error: \(String(describing: error))")
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        print("DidRequestContentResume")
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        print("DidRequestContentPause")
    }
    
    // MARK: - IMAAdsLoaderDelegate
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        adsManager.initialize(with: nil)
        print("AD LOADED !!!! \(String(describing: adsLoadedData))")
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        print("Error loading ads: " + adErrorData.adError.message)
    }
}

/* PLAYER */

struct PlayerView: UIViewRepresentable {
  func updateUIView(
    _ uiView: UIView,
    context: UIViewRepresentableContext<PlayerView>
  ) {}
    
  func makeUIView(context: Context) -> UIView {
    return PlayerUIView(frame: .zero)
  }
}


class PlayerUIView: UIView {
  private let playerLayer = AVPlayerLayer()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let url = URL(string:"https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!
    let player = AVPlayer(url: url)
    player.play()
    
    playerLayer.player = player
    layer.addSublayer(playerLayer)
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer.frame = bounds
  }
}

/* PREVIEW */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
