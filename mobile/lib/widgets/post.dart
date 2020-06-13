import 'package:flutter/material.dart';
import 'package:geol_recap/models/collection.dart';
import 'package:geol_recap/widgets/editor/editor.dart';

class PostCard extends StatelessWidget {
  Post post;
  User userRepository;

  PostCard({this.post, this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewPostFragment(
                        postId: post.id,
                        userRepository: userRepository,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 337.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: post.imageUrls.isNotEmpty
                          ? NetworkImage(post.imageUrls[0],
                          scale: 0.5)
                          : NetworkImage(
                        'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            post.title,
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.w500),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          Text(
            post.subTitle,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          Row(
            children: <Widget>[
              Text(
                '${post.toDateString}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${post.uidFavorite.length} Likes',
              ),
            ],
          )
        ],
      ),
    );
  }
}