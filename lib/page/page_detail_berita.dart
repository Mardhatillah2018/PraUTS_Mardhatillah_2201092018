import 'package:flutter/material.dart';

import '../model/model_berita.dart';
import 'package:intl/intl.dart';

class PageDetailBerita extends StatelessWidget {

  final Datum? data;
  const PageDetailBerita(this.data, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Berita"),
        backgroundColor: Colors.grey,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, right:
            4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "http://192.168.208.154/edukasi_baru/gambar_berita/${data?.gambar}",
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Text(
              data?.judul ?? "",
              style: const TextStyle(fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            trailing: const Icon(
              Icons.star,
              color: Colors.red,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, bottom: 16,
                left: 16),
            child: Text(
              data?.konten ?? "",
              style: const TextStyle(fontSize: 14, fontWeight:
              FontWeight.w400),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}