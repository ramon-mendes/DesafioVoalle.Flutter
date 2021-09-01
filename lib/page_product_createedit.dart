import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:desafio_voalle/apimodels/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'services/api.dart';

class PageProductCreateEdit extends StatefulWidget {
  static const routeName = '/pageproductcreateedit';

  @override
  _PageProductCreateEditState createState() => _PageProductCreateEditState();
}

class _PageProductCreateEditState extends State<PageProductCreateEdit> {
  bool _saving = false;
  bool _isedit = false;
  Product? _product;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtCategory = TextEditingController();
  final TextEditingController _txtPrice = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _product = ModalRoute.of(context)!.settings.arguments as Product?;
    if (_product == null) {
      _product = Product();
    }
  }

  @override
  void dispose() {
    _txtName.dispose();
    _txtCategory.dispose();
    _txtPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _saving,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                await _saveModel(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome:'),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _txtName,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira o nome.';
                      }
                      return null;
                    },
                  ),
                  //
                  SizedBox(height: 15),
                  //
                  Text('Categoria:'),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _txtCategory,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira a categoria.';
                      }
                      return null;
                    },
                  ),
                  //
                  SizedBox(height: 15),
                  //
                  Text('Preço:'),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _txtPrice,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira o preço.';
                      }
                      var val = double.tryParse(value);
                      if (val == null || val == 0) {
                        return 'Por favor insira um número maior que 0.';
                      }
                      return null;
                    },
                  ),
                  //
                  SizedBox(height: 15),
                  //
                  Text('Imagens:'),
                  SizedBox(height: 5),
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
      ),
    );
  }

  List<Widget> _getGridImages() {
    List<Widget> widgets = <Widget>[];

    var imgs = this._product!.imagesURL;
    widgets.addAll(imgs.map((url) => _GridImage(url)));

    widgets.add(Material(
      color: Color(0xff6fb6f8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: InkWell(
        onTap: () => _showPicker(context),
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
    ));

    return widgets;
  }

  final picker = ImagePicker();

  Future<String?> _imgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile == null) return null;
    return _file2base64(File(pickedFile.path));
  }

  Future<String?> _imgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return null;
    return _file2base64(File(pickedFile.path));
  }

  String _file2base64(File file) {
    var bytes = file.readAsBytesSync();
    return "data:image/jpeg;base64," + base64Encode(bytes);
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Galeria'),
                    onTap: () async {
                      var base64 = await _imgFromGallery();
                      if (base64 == null) return;

                      setState(() {
                        _product!.imagesURL.add(base64);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmera'),
                    onTap: () async {
                      var base64 = await _imgFromCamera();
                      if (base64 == null) return;

                      setState(() {
                        _product!.imagesURL.add(base64);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _saveModel(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _saving = true;
      });

      _product!.name = _txtName.text;
      _product!.category = _txtName.text;
      _product!.price = double.parse(_txtPrice.text);
      if (_isedit) {
        await API.of(context).productEdit(_product!);
      } else {
        await API.of(context).productCreate(_product!);
      }

      final snackBar = SnackBar(content: Text('Produto criado com sucesso.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
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
              fit: BoxFit.fill,
            )
          : Image.network(
              this.url,
              fit: BoxFit.fill,
            ),
    );

    return image;
  }
}
