//
//  CommentDetailsView.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 07.12.2020.
//

import SwiftUI

struct CommentDetailsView: View {
    
    // MARK: – Data
    var comment: RedditComment
    
    var body: some View {
        VStack {
            HStack {
                Text("u/\(comment.author ?? "")")
                    .padding(5)
                    .foregroundColor(.white)
                    .font(.subheadline)
                Divider()
                Text(String("\(self.formatRating(rawRating: comment.ups ?? 0)) points"))
                    .padding(5)
                    .foregroundColor(.white)
                    .frame(alignment: .leading)
                    .font(.subheadline)
                Divider()
                Text(String(self.formatDate(rawDate: comment.created_utc ?? 0)))
                    .padding(5)
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 25, alignment: .topLeading)
            Text(comment.body ?? "")
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity,/* minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity, */alignment: .topLeading)
                .padding(5)
                .foregroundColor(.white)
                .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            Button(action: {
                self.shareAction();
            }) {
                Text("Share")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(width: 300, height: 300, alignment: .center/* minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity,/* minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity, */alignment: .topLeading*/)
            }
            .frame(width: 300, height: 50)
            .background(Color(UIColor.systemOrange))
            .cornerRadius(5)
            .padding(10)
        }
        .listRowBackground(Color(UIColor.systemGray5))
        .background(Color(UIColor.separator))
        .cornerRadius(5)
        .padding(20)
    }
    
    func shareAction() {
        print(comment)
        let items = [URL(string: comment.permalink ?? "https://www.reddit.com")];
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil);
        UIApplication.shared.windows.first?.rootViewController?.present(ac, animated: true, completion: nil)
        
    }
    
    func formatRating(rawRating: Int) -> String {
        if (rawRating < 1000) {
            return String(rawRating)
        } else {
            return String(format: "%.1fk", (Float(rawRating) / 1000))
        }
    }
    
    func formatDate(rawDate: Int) -> String {
        let currTime = Int(NSDate().timeIntervalSince1970);
        let timeDiff = currTime - rawDate;
        var timePassed: String;
        
        switch timeDiff {
        case let td where td < 60:
            timePassed = "now";
        case let td where td < 3600:
            timePassed = "\(Int(td/60))m";
        case let td where td < 86400:
            timePassed = "\(Int(td/3600))h";
        case let td where td < 2678400:
            timePassed = "\(Int(td/86400))d";
        case let td where td < 31536000:
            timePassed = "\(Int(td/2678400))m";
        default:
            timePassed = "\(Int(timeDiff/31536000))y";
        }
        return timePassed;
    }
}

struct CommentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentRowView(comment: RedditComment(
                        id: "228",
                        author: "u/bruh_bruhson",
                        created_utc: 51346,
                        body: "Bruh bruh bruh bruh bruh bruh bruh rubh rubhrubh rubh Bruh bruh bruh bruh bruh bruh bruh rubh rubhrubh rubh Bruh bruh bruh bruh bruh bruh bruh rubh rubhrubh rubh Bruh bruh bruh bruh bruh bruh bruh rubh rubhrubh rubh Bruh bruh bruh bruh bruh bruh bruh rubh rubhrubh rubh Bruh bruh bruh bruh bruh bruh bruh rubh rubhrubh rubh Bruh bruh bruh bruh bruh bruh bruh rubh rubhrubh rubh ",
                        ups: 322,
                        downs: 0))
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
    }
}
