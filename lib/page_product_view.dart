import 'dart:convert';
import 'dart:typed_data';

import 'package:desafio_voalle/apimodels/product.dart';
import 'package:desafio_voalle/page_product_createedit.dart';
import 'package:desafio_voalle/services/api.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class PageProductView extends StatefulWidget {
  static const routeName = '/pageproductview';

  @override
  _PageProductViewState createState() => _PageProductViewState();
}

class _PageProductViewState extends State<PageProductView> {
  Product? _product;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _product = ModalRoute.of(context)!.settings.arguments as Product?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              var res = await Navigator.of(context).pushNamed(PageProductCreateEdit.routeName, arguments: _product);
              if (res != null) {
                setState(() {
                  _product = res as Product;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _deleteModel(context);
            },
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _saving,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome:'),
                Text(
                  _product!.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text('Categoria:'),
                Text(
                  _product!.category,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text('Preço:'),
                Text(
                  _product!.price.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text('Imagens:'),
                GridView.count(
                  primary: false, // disables GridView scrolling
                  shrinkWrap: true,
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: _getGridImages(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getGridImages() {
    List<Widget> widgets = <Widget>[];

    var imgs = this._product!.imagesURL;
    widgets.addAll(imgs.map((url) => _GridImage(url)));

    return widgets;
  }

  _deleteModel(BuildContext context) {
    setState(() {
      this._saving = true;
    });

    API.of(context).productRemove(_product!.id).then((value) {
      final snackBar = SnackBar(content: Text('Produto removido com sucesso.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();

      setState(() {
        this._saving = false;
      });
    });
  }
}

class _GridImage extends StatelessWidget {
  const _GridImage(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    bool isbase64 = url.startsWith("data:");
    late Uint8List bytes;

    if (isbase64) {
      var data = url.split(',')[1];
      bytes = base64Decode(data);
    }

    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: isbase64
          ? Image.memory(
              bytes,
              fit: BoxFit.fitHeight,
            )
          : Image.network(
              this.url,
              fit: BoxFit.fitHeight,
            ),
    );

    return image;
  }
}
