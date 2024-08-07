import 'package:flutter/material.dart';
import 'package:link/components/gpa_gauge.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/data_sources/grades_data_source.dart';
import 'package:link/models/course.dart';
import 'package:link/models/grade.dart';
import 'package:link/screens/forms/add_grade_form.dart';
import 'package:link/screens/data_grid_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GPAPage extends StatefulWidget {
  const GPAPage({super.key});

  @override
  State<GPAPage> createState() => _GPAPageState();
}

class _GPAPageState extends State<GPAPage> {
  final _gridController = DataGridController();
  late CrudController<Grade> _gradesController;
  late GradesDataSource _gradesSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _gradesController =
        Provider.of<CrudController<Grade>>(context, listen: false);
    _gradesSource = GradesDataSource(_gradesController,
        Provider.of<CrudController<Course>>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(title: 'GPAs'),
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CrudDataGrid<Grade>(
                controller: _gridController,
                dataSource: _gradesSource,
                crudController: _gradesController,
                showCheckboxColumn: true,
                addForm: const AddGradeForm(),
                keyColumnName: GPAColumns.code.name,
                columns: GPAColumns.values
                    .map((e) => buildGridColumn(
                          context,
                          e.name,
                          visible: e != GPAColumns.code,
                        ))
                    .toList(),
                buildSearchFilters: (searchText) => {
                  GPAColumns.course.name: FilterCondition(
                    type: FilterType.contains,
                    value: searchText,
                    filterBehavior: FilterBehavior.stringDataType,
                    filterOperator: FilterOperator.or,
                  ),
                  GPAColumns.grade.name: FilterCondition(
                    type: FilterType.contains,
                    value: searchText,
                    filterBehavior: FilterBehavior.stringDataType,
                    filterOperator: FilterOperator.or,
                  ),
                },
              ),
              const GPAGauge(),
            ],
          ),
        ),
      ],
    );
  }
}
