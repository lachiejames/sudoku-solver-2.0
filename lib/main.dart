import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/reducers.dart';
import 'package:sudoku_solver_2/screens/solve_with_touch_screen.dart';
import 'package:sudoku_solver_2/state/model.dart';
import 'package:redux/redux.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: Store<AppState>(
        appStateReducer,
        initialState: AppState.initialState(),
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),

        //SolveWithTouchScreen(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux items'),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Column(
          children: <Widget>[
            AddItemWidget(viewModel),
            Expanded(child: ItemListWidget(viewModel)),
            RemoveItemsButton(viewModel),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;

  _ViewModel({
    this.items,
    this.onAddItem,
    this.onRemoveItem,
    this.onRemoveItems,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    return _ViewModel(
      items: store.state.items,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems,
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;
  AddItemWidget(this.model);
  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(hintText: 'add an item'),
      onSubmitted: (String s) {
        widget.model.onAddItem(s);
        textEditingController.text = '';
      },
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;

  ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: model.items
          .map(
            (Item item) => ListTile(
              title: Text(item.body),
              leading: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => model.onRemoveItem(item),
              ),
            ),
          )
          .toList(),
    );
  }
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  RemoveItemsButton(this.model);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Delete all items'),
      onPressed: () => model.onRemoveItems(),
    );
  }
}
