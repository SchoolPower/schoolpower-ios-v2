//
//  CourseDetailView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct TermItem: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("F1")
                .foregroundColor(.primary)
                .font(.body)
                .bold()
            Text("84")
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .foregroundColor(.purple)
                )
        }
        .padding(16)
        .background(
            Rectangle()
                .foregroundColor(Color(red: 231/255, green: 224/255, blue: 236/255))
                .frame(width: 65, height: 80)
                .cornerRadius(12)
        )
        .frame(width: 65, height: 80)
    }
}

struct AssignmentItem: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Unit 7 Quiz")
                    .foregroundColor(.primary)
                    .font(.body)
                    .bold()
                Spacer().frame(height: 6).fixedSize()
                Text("2021/10/30")
                    .foregroundColor(.primary)
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("83.33%")
                    .foregroundColor(.purple)
                    .font(.title2)
                    .bold()
                Spacer().frame(height: 6).fixedSize()
                Text("5.0/6.0")
                    .foregroundColor(.purple)
                    .font(.caption)
            }
        }
        .frame(height: 70)
    }
}

struct AssignmentItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AssignmentItem()
        }
        .previewLayout(.fixed(width: 383, height: 80))
    }
}

struct CourseDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Block").font(.body).opacity(0.6).foregroundColor(.primary)
                    Text("1(A-E)").font(.body).bold().foregroundColor(.primary)
                    Text("Room").font(.body).opacity(0.6).padding(.leading, 8).foregroundColor(.primary)
                    Text("N-506").font(.body).bold().foregroundColor(.primary)
                }
                Spacer().frame(height: 6).fixedSize()
                HStack {
                    Text("Instructor").font(.body).opacity(0.6).foregroundColor(.primary)
                    Text("Laith Saied")
                        .foregroundColor(.primary)
                        .font(.body)
                        .bold()
                }
                Text("Grades")
                    .font(.headline)
                    .opacity(0.6)
                    .foregroundColor(.primary)
                    .padding(.top, 32)
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(1..<10) { _ in
                            NavigationLink(destination: TermDetailView()) {
                                TermItem()
                            }
                        }
                    }
                }
                Text("Assignments")
                    .font(.headline)
                    .opacity(0.6)
                    .foregroundColor(.primary)
                    .padding(.top, 32)
                LazyVStack {
                    ForEach(1..<10) { _ in
                        NavigationLink(destination: AssignmentDetailView()) {
                            AssignmentItem()
                        }
                        Divider()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Pre-Calculus 12")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView()
    }
}
