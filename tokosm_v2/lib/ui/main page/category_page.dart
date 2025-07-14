import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tokosm_v2/shared/themes.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
            left: 16,
            right: 16,
          ),
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "Kategori Produk",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  children: [
                    ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                      ),
                      header: Text(
                        "Makanan & Minuman",
                        style: TextStyle(
                          fontWeight: bold,
                        ),
                      ),
                      expanded: const SingleChildScrollView(
                        child: Row(
                          children: [
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Makanan",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Makanan",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Makanan",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Makanan",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      collapsed: const SizedBox(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
