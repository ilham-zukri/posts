import 'package:flutter/material.dart';

import '../data_classes/post.dart';

Widget postContainerBuilder({required Post post, required Size size}) {
  return Container(
    width: size.width,
    height: 150,
    decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
              color: Colors.black26,
            ),
            top: BorderSide(color: Colors.black26))),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.creator,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                post.createdAt,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            post.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            post.content,
            maxLines: 4,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ),
  );
}
