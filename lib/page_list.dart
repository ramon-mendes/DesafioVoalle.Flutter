import 'package:desafio_voalle/apimodels/product.dart';
import 'package:desafio_voalle/page_product_createedit.dart';
import 'package:desafio_voalle/page_product_view.dart';
import 'package:desafio_voalle/services/api.dart';
import 'package:desafio_voalle/services/login_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'color_loader_4.dart';

class PageList extends StatefulWidget {
  @override
  _PageListState createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  static List<Product>? _cache;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    API.of(context).productList().then((value) => this.setState(() {
          if (value != null) _cache = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(PageProductCreateEdit.routeName);
          _reloadData();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: 0,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      API.logout();
      Provider.of<LoginNotifier>(context, listen: false).logOut();
      return;
    }
    setState(() {
      //_selectedIndex = index;
    });
  }

  Widget _buildListView() {
    if (_cache == null) {
      return Center(
        child: new ColorLoader4(),
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: Text('Selecione um produto para visualizá-lo:'),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                ),
                itemCount: _cache!.length,
                itemBuilder: (BuildContext context, int index) => _buildListItem(_cache![index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(Product product, BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).pushNamed(PageProductView.routeName, arguments: product);
          _reloadData();
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(product.category),
                  Text(' - R\$ ' + product.price.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
