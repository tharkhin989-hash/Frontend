import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {



  late final List<PlutoColumn> columns;
  late final List<PlutoRow> rows;

  @override
  void initState() {
    super.initState();

    columns = [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Email',
        field: 'email',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Role',
        field: 'role',
        type: PlutoColumnType.text(),
      ),
    ];
      rows = [
        PlutoRow(cells: {
          'id': PlutoCell(value: 1),
          'name': PlutoCell(value: 'Aung Aung'),
          'email': PlutoCell(value: 'aung@gmail.com'),
          'role': PlutoCell(value: 'Admin'),
        }),
          PlutoRow(cells: {
          'id': PlutoCell(value: 1),
          'name': PlutoCell(value: 'kyaw kyaw'),
          'email': PlutoCell(value: 'kyaw@gmail.com'),
          'role': PlutoCell(value: 'Author'),

        }),
      ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          
          configuration: const PlutoGridConfiguration(),
            
            ),
          ),
        );  
    
  }
}



 