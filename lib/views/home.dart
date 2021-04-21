import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newshub/helper/data.dart';
import 'package:newshub/helper/news.dart';
import 'package:newshub/models/article_model.dart';
import 'package:newshub/models/categori_model.dart';
import 'package:newshub/views/article_view.dart';
import 'package:newshub/views/category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: deprecated_member_use
  List<CategorieModel> categories = new List<CategorieModel>();
  // ignore: deprecated_member_use
  List<ArticleModel> aritcles = new List<ArticleModel>();
  bool _loading =true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }
  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    aritcles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // status bar color
        brightness: Brightness.light,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('News'),
            Text(
              'Hub',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        elevation: 0.0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ): SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal:16 ),

          child: Column(
            children: <Widget>[
              Container(
                height: 70,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryTile(
                        imageUrl: categories[index].imageAssetUrl,
                        categoryName: categories[index].categorieName,
                      );
                    }),
              ),
              /// Blog
              Container(
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemCount:aritcles.length ,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index ){
                    return BlogTile(
                        imageUrl: aritcles[index].urlToImage,
                        title: aritcles[index].title,
                        desc: aritcles[index].description,
                        url: aritcles[index].url,
                    );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl;
  final String categoryName;
  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CategoryNews(
              category: categoryName.toLowerCase(),
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage( imageUrl: imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26 ,
              ),
              width: 120,
              height: 60,
              child: Text(categoryName, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }
}
class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile({@required this.imageUrl,@required this.title,@required this.desc,@required this.url});
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ArticleView(
            blogUrl: url,
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column (
          children: <Widget> [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl)),
            Text(title, style: TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.bold ),),
            SizedBox(height: 8,),
            Text(desc,style: TextStyle(color: Colors.black54),)

          ],
        ),
      ),
    );
  }
}

