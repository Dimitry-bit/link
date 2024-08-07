import 'package:flutter/material.dart';
import 'package:link/controllers/response.dart';
import 'package:link/data_sources/data_grid_source_base.dart';
import 'package:link/dtos/course_dto.dart';
import 'package:link/models/course.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum CourseColumns {
  code,
  name,
  department,
  creditHours,
  year,
  lecture,
  lab,
  section,
}

class CoursesDataSource extends DataGridSourceBase<Course> {
  dynamic _newCellValue;

  CoursesDataSource(super.controller);

  @override
  DataGridRow buildDataGridRow(Course v) {
    return DataGridRow(
      cells: [
        DataGridCell<String>(
          columnName: CourseColumns.code.name,
          value: v.code,
        ),
        DataGridCell<String>(
          columnName: CourseColumns.name.name,
          value: v.name,
        ),
        DataGridCell<String>(
          columnName: CourseColumns.department.name,
          value: v.department,
        ),
        DataGridCell<int>(
          columnName: CourseColumns.creditHours.name,
          value: v.creditHours,
        ),
        DataGridCell<int>(
          columnName: CourseColumns.year.name,
          value: v.year,
        ),
        DataGridCell<bool>(
          columnName: CourseColumns.lecture.name,
          value: v.hasLecture,
        ),
        DataGridCell<bool>(
          columnName: CourseColumns.lab.name,
          value: v.hasLab,
        ),
        DataGridCell<bool>(
          columnName: CourseColumns.section.name,
          value: v.hasSection,
        ),
      ],
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: () {
              if ((cell.columnName == CourseColumns.lecture.name) ||
                  (cell.columnName == CourseColumns.lab.name) ||
                  (cell.columnName == CourseColumns.section.name)) {
                return Checkbox(
                  value: cell.value,
                  onChanged: (value) {
                    _newCellValue = value;
                    directCellEdit(row, cell);
                    _newCellValue = null;
                  },
                );
              } else {
                return Text(
                  cell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                );
              }
            }());
      }).toList(),
    );
  }

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    final dynamic oldValue = dataGridRow.getCells()[rowColumnIndex.columnIndex];
    if ((_newCellValue == null) || (oldValue == _newCellValue)) {
      return;
    }

    CourseDTO dto = CourseDTO();
    if (column.columnName == CourseColumns.code.name) {
      dto.code = _newCellValue.toString();
    } else if (column.columnName == CourseColumns.name.name) {
      dto.name = _newCellValue.toString();
    } else if (column.columnName == CourseColumns.department.name) {
      dto.department = _newCellValue.toString();
    } else if (column.columnName == CourseColumns.creditHours.name) {
      dto.creditHours = _newCellValue;
    } else if (column.columnName == CourseColumns.year.name) {
      dto.year = _newCellValue;
    } else if (column.columnName == CourseColumns.lecture.name) {
      dto.hasLecture = _newCellValue;
    } else if (column.columnName == CourseColumns.lab.name) {
      dto.hasLab = _newCellValue;
    } else if (column.columnName == CourseColumns.section.name) {
      dto.hasSection = _newCellValue;
    }

    final int dataRowIndex = rows.indexOf(dataGridRow);
    String? code = dataGridRow.getCells().first.value;

    if (code != null) {
      Response<Course> res = controller.update(code, dto);

      if (!res.error()) {
        rows[dataRowIndex] = buildDataGridRow(res.data!);
      }
    }
  }

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    _newCellValue = null;

    // Disable edit mode for checkbox widgets (Handled by onChange() instead)
    if ((column.columnName == CourseColumns.lecture.name) ||
        (column.columnName == CourseColumns.lab.name) ||
        (column.columnName == CourseColumns.section.name)) {
      return null;
    }

    final editingController = TextEditingController();
    final String displayText =
        dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString();

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 16.0),
        ),
        keyboardType: TextInputType.text,
        onChanged: (text) {
          if ((column.columnName == CourseColumns.creditHours.name) ||
              (column.columnName == CourseColumns.year.name)) {
            int? n = int.tryParse(text);

            if (n != null) {
              _newCellValue = n;
            }
          } else {
            _newCellValue = text;
          }
        },
      ),
    );
  }
}
