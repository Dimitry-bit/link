import 'package:flutter/material.dart';
import 'package:link/components/alert.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/personnel_data_source.dart';
import 'package:link/models/person.dart';
import 'package:link/screens/add_person_form.dart';
import 'package:link/screens/data_grid_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PersonnelPage extends StatefulWidget {
  const PersonnelPage({super.key});

  @override
  State<PersonnelPage> createState() => _PersonnelPageState();
}

class _PersonnelPageState extends State<PersonnelPage> {
  final _gridController = DataGridController();
  late CrudController<Person> _personnelController;
  late PersonnelDataSource _personnelSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _personnelController =
        Provider.of<CrudController<Person>>(context, listen: false);
    _personnelController.onUpdated.removeListener(_handleControllerError);
    _personnelController.onUpdated.addListener(_handleControllerError);

    _personnelSource = PersonnelDataSource(_personnelController);
  }

  @override
  void dispose() {
    _personnelController.onUpdated.removeListener(_handleControllerError);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Doctors/TAs'),
        DataGridPage(
          controller: _gridController,
          dataSource: _personnelSource,
          columns: PersonnelColumns.values
              .map((e) => buildGridColumn(context, e.name))
              .toList(),
          onPressDelete: () {
            String? email = _gridController.selectedRow
                ?.getCells()
                .elementAtOrNull(1)
                ?.value;

            if (email != null) {
              _personnelController.removeByKey(email);
            }
          },
          onPressAdd: () => showDialog(
            context: context,
            builder: (_) => const Dialog(child: AddPersonForm()),
          ),
          buildSearchFilters: (searchText) => {
            PersonnelColumns.name.name: FilterCondition(
              type: FilterType.contains,
              value: searchText,
              filterBehavior: FilterBehavior.stringDataType,
              filterOperator: FilterOperator.or,
            ),
            PersonnelColumns.email.name: FilterCondition(
              type: FilterType.contains,
              value: searchText,
              filterBehavior: FilterBehavior.stringDataType,
              filterOperator: FilterOperator.or,
            ),
          },
        ),
      ],
    );
  }

  void _handleControllerError(Person? oldOjb, Response<Person> newValue) {
    if (newValue.errorStr.isNotEmpty) {
      final SnackBar alert = alertSnackBar(
        context,
        newValue.errorStr,
        AlertTypes.error,
      );

      ScaffoldMessenger.of(context).showSnackBar(alert);
    }
  }
}
