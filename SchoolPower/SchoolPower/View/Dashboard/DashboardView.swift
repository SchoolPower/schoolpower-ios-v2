//
//  DashboardView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ corners: UIRectCorner, _ radius: CGFloat) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct DashboardCourseItem: View {
    
    var title: String
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text("B")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .foregroundColor(.purple)
                    )
                VStack(alignment: .leading) {
                    Text("Pre-Calculus 12")
                        .foregroundColor(.primary)
                        .font(.body)
                        .bold()
                    Spacer().frame(height: 8).fixedSize()
                    HStack {
                        Text("Block").font(.caption).opacity(0.6).foregroundColor(.primary)
                        Text("1(A-E)").font(.caption).bold().foregroundColor(.primary)
                        Text("Room").font(.caption).opacity(0.6).padding(.leading, 8).foregroundColor(.primary)
                        Text("N-506").font(.caption).bold().foregroundColor(.primary)
                    }
                }
                .padding(.leading, 8)
                Spacer()
            }
            .padding(16)
            .background(
                Rectangle()
                    .foregroundColor(Color(red: 231/255, green: 224/255, blue: 236/255))
                    .frame(height: 80)
                    .cornerRadius(.topLeft, 12)
                    .cornerRadius(.bottomLeft, 12)
            )
            Text("84")
                .font(.title2)
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
                .background(
                    Rectangle()
                        .foregroundColor(.purple)
                        .cornerRadius(.topRight, 12)
                        .cornerRadius(.bottomRight, 12)
                )
        }
        .frame(height: 80)
    }
}

struct DashboardCourseItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardCourseItem(title: "a")
        }
        .previewLayout(.fixed(width: 383, height: 80))
    }
}

struct DashboardView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(1..<10) { _ in
                        NavigationLink(destination: CourseDetailView()) {
                            DashboardCourseItem(title: "a")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
        .navigationViewStyle(.columns)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
