import 'package:flutter/Material.dart';

import 'BlocProvider.dart';
import 'Customer.dart';

class CustomerWidget extends StatelessWidget {
  final Customer _customer;
  CustomerWidget(this._customer);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    Text text = Text(
      _customer.name,
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black45),
    );
    IconButton upButton = IconButton(
      icon: Icon(Icons.arrow_drop_up, color: Colors.blue),
      onPressed: () => bloc.upAction.add(_customer),
    );
    IconButton downButton = IconButton(
      icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
      onPressed: () => bloc.downAction.add(_customer),
    );
    List<Widget> children = [];
    children.add(Expanded(child: Padding(padding: EdgeInsets.only(left: 20.0), child: text)));
    if (_customer.downButton) children.add(downButton);
    if (_customer.upButton) children.add(upButton);

    return Padding(
      padding: EdgeInsets.all(6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.amber[200]),
          child: Row(
            children: children,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}
