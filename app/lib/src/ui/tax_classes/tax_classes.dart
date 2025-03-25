import 'package:admin/src/blocs/tax_classes/tax_classes_bloc.dart';
import 'package:admin/src/models/tax_class/tax_class.dart';
import 'package:admin/src/ui/tax_rates/add_tax_rate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaxClasses extends StatefulWidget {
  TaxClassesBloc taxClassesBloc = TaxClassesBloc();
  TaxClasses({Key? key}) : super(key: key);
  @override
  State<TaxClasses> createState() => _TaxClassesState();
}

class _TaxClassesState extends State<TaxClasses> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.taxClassesBloc.fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.taxClassesBloc.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: widget.taxClassesBloc.results,
          builder: (context, AsyncSnapshot<List<TaxClassModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return snapshot.data!.length > 0 ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            label: 'Delete',
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            onPressed: (context) {
                              widget.taxClassesBloc.deleteItem(snapshot.data![index]);
                            },
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(snapshot.data![index].name),
                      ),
                    );
                  }) : Center(child: Text('No Items Found'));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else return Center(child: CircularProgressIndicator());
          }),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          *//*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddTaxRate(taxClassesBloc: widget.taxClassesBloc)),
          );*//*
        },
        child: const Icon(CupertinoIcons.add),
      ),*/
    );
  }
}
