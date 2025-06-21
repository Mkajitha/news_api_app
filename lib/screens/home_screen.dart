import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/article_model.dart';
import '../widgets/news_card.dart';
import '../widgets/category_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'general';
  late Future<List<Article>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsService.fetchNews(selectedCategory);
  }

  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
      futureNews = NewsService.fetchNews(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['general', 'business', 'entertainment', 'health', 'science', 'sports', 'technology'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter News App'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 55,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _changeCategory(categories[index]),
                child: CategoryTab(
  category: categories[index],
  isSelected: selectedCategory == categories[index],
  onTap: () => _changeCategory(categories[index]),
),

                
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: futureNews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No news available."));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => NewsCard(article: snapshot.data![index]),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
