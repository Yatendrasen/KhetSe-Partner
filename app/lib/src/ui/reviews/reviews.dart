import 'package:admin/src/blocs/reviews/reviews_bloc.dart';
import 'package:admin/src/blocs/settings/settings_bloc.dart';
import 'package:admin/src/models/product/reviews.dart';
import 'package:admin/src/models/settings/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html/parser.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewsPage extends StatefulWidget {
  ReviewsBloc reviewsBloc = ReviewsBloc();
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    widget.reviewsBloc.fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          widget.reviewsBloc.hasMoreItems) {
        widget.reviewsBloc.loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: StreamBuilder(
          stream: widget.reviewsBloc.allData,
          builder: (context, AsyncSnapshot<List<Reviews>> snapshot) {
            if (snapshot.data != null && snapshot.hasData) {
              return ListView(
                controller: _scrollController,
                children: buildList(snapshot),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<Widget> buildList(AsyncSnapshot<List<Reviews>> snapshot) {
    List<Widget> list = [];
    snapshot.data!.forEach((element) {
      list.add(Card(
        margin: EdgeInsets.all(0.2),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: InkWell(
          onTap: () {

          },
          child: buildListTile(context, element),
        ),
      ));
    });
    return list;
  }

  buildListTile(context, Reviews comment) {
    return Container(
      padding: EdgeInsets.fromLTRB(22.0, 16.0, 22.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(comment.reviewerAvatarUrls.entries.last.value),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(comment.reviewer,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400)),
                          RatingBar.builder(
                            initialRating: comment.rating,
                            itemSize: 15,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                      Text(timeago.format(comment.dateCreated),
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).textTheme.titleSmall!.color))
                    ]),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Html(data: comment.review),
        ],
      ),
    );
  }
}
