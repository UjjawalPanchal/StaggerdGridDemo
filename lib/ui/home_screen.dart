/*
* Created by Ujjawal Panchal on 11/11/22.
*/
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:practice/api_helper/api_call.dart';
import 'package:practice/api_helper/common_api_call.dart';
import 'package:practice/model/image_response_pojo.dart';
import 'package:practice/ui/notification_screen.dart';
import 'package:practice/utils/utility.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ImageData> imageList = [];
  TextEditingController searchController = TextEditingController();
  late StreamController<int> streamSubject;
  ServiceState state = ServiceState.initial;

  @override
  void initState() {
    streamSubject = StreamController<int>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text("Ujjawal's Practical"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen()));
            },
            icon: const Icon(Icons.notifications),
            tooltip: 'Click to send notification',
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter Size',
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                      border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                    ),
                    onChanged: (content) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0123456789]'))],
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.deepPurple, backgroundColor: Colors.deepPurple),
                child: const Text('Get', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Utility.dismissKeyboard(context);
                  if (searchController.text.trim().isEmpty) {
                    Utility.showToastMessage(context, 'Please enter size count to get images');
                    return;
                  }
                  state = ServiceState.loading;
                  streamSubject.sink.add(0);
                  getImagesByCount();
                },
              )
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: StreamBuilder(
                stream: streamSubject.stream,
                builder: (context, snapshot) {
                  if (state == ServiceState.loading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                  }
                  if (imageList.isEmpty) {
                    return const Center(child: Text("Enter size to SearchBox"));
                  }
                  return GridView.custom(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 6,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      repeatPattern: QuiltedGridRepeatPattern.same,
                      pattern: [
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(3, 3),
                        const QuiltedGridTile(3, 3),
                      ],
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) => TileImage(item: imageList[index]),
                      childCount: imageList.length,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  getImagesByCount() {
    CommonServiceCall.getImagesBySize(searchController.text.trim()).then((value) {
      imageList = value;
      state = ServiceState.complete;
      streamSubject.sink.add(imageList.length);
    });
  }
}

class TileImage extends StatelessWidget {
  const TileImage({super.key, this.item});

  final ImageData? item;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: item!.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.deepOrange, strokeWidth: 2.5)),
    );
  }
}
