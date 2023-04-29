import SwiftUI
import AVFoundation

struct VoiceMemoView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            
//            RecordingsList(audioRecorder: audioRecorder)
            
            if audioRecorder.isDoneRecording {
                if audioPlayer.isPlaying == false {
                    Button(action: {
                        self.audioPlayer.startPlayback(audio: (audioRecorder.recordings.last?.fileURL ?? URL(string: "google"))!)
                    }) {
                        Image(systemName: "play.circle")
                            .imageScale(.large)
                    }
                } else {
                    Button(action: {
                        self.audioPlayer.stopPlayback()
                        self.audioRecorder.deleteAllButFirst()
                        self.audioRecorder.isDoneRecording.toggle()
                    }) {
                        Image(systemName: "stop.fill")
                            .imageScale(.large)
                    }
                }
            }
            
            Spacer()
            
//            if homeViewModel.isGetResponse {
//                AudioPlayerView(url: homeViewModel.respondedAudio[0])
//            }
            
            if audioRecorder.recording == false {
                Button(action: {self.audioRecorder.startRecording()}) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            } else {
                Button {
                    self.audioRecorder.stopRecording()
                    let fileUrl = audioRecorder.recordings.last?.fileURL ?? URL(string: "google")!
                    let audioData = try? Data(contentsOf: fileUrl)
                    let audioName = fileUrl.lastPathComponent
                    
                    homeViewModel.loadData(data: audioData ?? Data(), name: audioName)
                    homeViewModel.sendAudio()
                } label: {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitle("Voice Recorder")
        .sheet(isPresented: $homeViewModel.isGetResponse) {
            let _ = print(homeViewModel.respondedAudio[0])
//            AudioPlayerView(url: "https://storage.googleapis.com/translate_headphone/output-files/output0-20230429-204704.mp3")
            AudioPlayerView(url: homeViewModel.respondedAudio[0])
        }
    }
}


struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceMemoView(audioRecorder: AudioRecorder())
    }
}


struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
            }
        .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRow: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    
    var body: some View {
        HStack {
            Text("\(audioURL.lastPathComponent)")
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}
