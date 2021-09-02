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
              await Navigator.of(context).pushNamed(PageProductCreateEdit.routeName, arguments: _product);
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
          child: Column(
            children: [],
          ),
        ),
      ),
    );
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
