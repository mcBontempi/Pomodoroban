import AVKit

class LandscapeAVPlayerController: AVPlayerViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }
}
