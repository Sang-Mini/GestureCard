//
//  Home.swift
//  GestureCard
//
//  Created by 유상민 on 2023/09/14.
//

import SwiftUI

struct Home: View {
    // MARK: Gesture Properties
    // 사용자가 이미지를 드래그하면 해당 드래그 값이 저장
    @State var offset: CGSize = .zero
    
    var body: some View {
        // 화면 크기 정보를 읽어오는 뷰
        GeometryReader {
            let size = $0.size
            let imageSize = size.width * 0.7
            VStack {
                Image("Shoe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize)
                    // 기울이기
                    .rotationEffect(.init(degrees: -30))
                    .zIndex(1)
                    .offset(x: -20)
                    .offset(x: offset2Angle().degrees * 5, y: offset2Angle(true).degrees * 5)
                
                Text("NIKE AIR")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .padding(.top, -70)
                    .padding(.bottom, 55)
                    .zIndex(0)
                
                // 수직 스택으로 여러 뷰를 세로로 배열
                VStack(alignment: .leading, spacing: 10) {
                    Text("NIKE")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .fontWidth(.compressed)
                    
                    HStack {
                        BlendedText("AIR JORDAN 1 RETRO")
                        
                        Spacer(minLength: 0)
                        
                        BlendedText("$130")
                    }
                    
                    HStack {
                        BlendedText("YOUR NEXT SHOES")
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            
                        } label: {
                            Text("BUY")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style:
                                            .continuous)
                                    .fill(.yellow)
                                    .brightness(-0.1)
                                }
                        }
                    }
                    .padding(.top, 14)
                    
                    // Nike Logo
                    Image("nike")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .padding(.top, 65)
            .padding(.horizontal, 15)
            .frame(width: imageSize)
            .background(content: {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(.black)
                    
                    Circle()
                        .fill(.yellow)
                        .frame(width: imageSize, height: imageSize)
                        .scaleEffect(1.2, anchor: .leading)
                        .offset(x: imageSize * 0.3, y: -imageSize * 0.1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            })
            // 제스처에 따라 이미지를 3D 회전시키는 효과를 부여 axis 매개변수를 통해 회전 축 설정.
            .rotation3DEffect(offset2Angle(true), axis: (x: -1, y: 0, z: 0))
            .rotation3DEffect(offset2Angle(), axis: (x: 1, y: 1, z: 0))
            .rotation3DEffect(offset2Angle(true) * 0.1, axis: (x: 0, y: 0, z: 1))
            // 이미지의 크기를 조절하여 화면에서 보다 작게 표시
            .scaleEffect(0.9)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // 뷰의 제스처 영역을 사각형으로 설정
            .contentShape(Rectangle())
            // 드래그 제스처를 뷰에 추가하여 제스처를 허용, 제스처 동작에 따라 offset 업데이트하고 애니메이션 적용.
            .gesture(
                // 드래그 제스처를 설정
                DragGesture()
                    // 제스처의 변경사항을 감지 후 업데이트
                    .onChanged({ value in
                        offset = value.translation
                        // 제스처 종료 시 애니메이션과 함께 원래 위치로 복귀
                    }).onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.32, blendDuration: 0.32)){
                            offset = .zero
                        }
                    })
            )
        }
    }
    
    // MARK: Converting Offset Into X,Y Angles
    // 제스처로 인한 offset 값을 각도로 변환하여 이미지를 회전시키는 함수
    func offset2Angle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? offset.height : offset.width) / (isVertical ? screenSize.height : screenSize.width)
        return .init(degrees: progress * 10)
    }
    
    // MARK: Device Screen Size
    // 기기 화면의 크기를 가져오는 계산 속성
    var screenSize: CGSize = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        return window.screen.bounds.size
    }()
    
    // 텍스트에 블렌딩 모드를 적용한 사용자 지정 뷰
    @ViewBuilder
    func BlendedText(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.condensed)
            .blendMode(.difference)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
