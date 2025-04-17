import SwiftUI
import MapKit
import WebKit

class MapViewModel: ObservableObject {
    enum State {
        case loading, success(url: URL?)
    }
    @Published var state: State = .loading
    var url: URL? = nil
    
    func start() {
        Task { @MainActor in
            await FirebaseManager.shared.fetchMap()
            self.url = URL(string: FirebaseManager.shared.url) ?? nil
            state = .success(url:  URL(string: FirebaseManager.shared.url) ?? nil)
        }
    }
}
struct MapView: View {
//    let url: URL? = URL(string: "https://www.google.com/maps/d/u/2/edit?mid=1HDNBzc6_WrCfRP1fcPSiNAr7DYcIXmY&usp=sharing") ?? nil
    @ObservedObject var viewModel = MapViewModel()
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .success(let url):
                if let url {
                    WebView(url: url)
                } else {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.start()
        }
    }
    
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
}

#Preview {
    MapView()
}
