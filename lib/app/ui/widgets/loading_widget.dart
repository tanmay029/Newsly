import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  final LoadingType type;

  const LoadingWidget({
    Key? key,
    this.type = LoadingType.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.list:
        return _buildListLoading();
      case LoadingType.card:
        return _buildCardLoading();
      case LoadingType.circular:
        return _buildCircularLoading();
    }
  }

  Widget _buildListLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => _buildCardLoading(),
    );
  }

  Widget _buildCardLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 14,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 150,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

enum LoadingType { list, card, circular }
