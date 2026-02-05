//
//  FetchView.swift
//  BBQuotes
//
//  Created by Mario Duarte on 02/02/26.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String
    
    @State var showCharacterInfo = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(show.removeCaseAndSpaces())
                    .resizable()
                    .frame(width: geometry.size.width * 2.7, height: geometry.size.height * 1.2)
                
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                if let url = vm.character.images.first {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ZStack {
                                                Color.gray.opacity(0.3)
                                                ProgressView()
                                                    .tint(.white)
                                                    .scaleEffect(1.3)
                                            }
                                            
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                            
                                        case .failure:
                                            VStack(spacing: 8) {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundStyle(.gray)
                                                Text("Imagem não disponível")
                                                    .font(.caption)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(Color.gray.opacity(0.2))
                                            
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    
                                    Text(vm.quote.character)
                                        .foregroundStyle(.white)
                                        .padding(10)
                                        .frame(maxWidth: .infinity)
                                        .background(.ultraThinMaterial)
                                } else {
                                    // Sem imagens ou array vazio
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(1.5)
                                }
                            }
                            .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 1.7)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                            
                        case .failure(let error):
                            Text("Error: \(error.localizedDescription)")
                                .foregroundStyle(.red)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    
                    HStack {
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                        } label: {
                            Text("Get Random Quote")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 25))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.getEpisodeData(for: show)
                            }
                        } label: {
                            Text("Get Random Episode")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 25))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer(minLength: 95)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: vm.character, show: show)
        }
        .task {
            await vm.getQuoteData(for: show)
        }
    }
}

#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
