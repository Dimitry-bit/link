import 'package:flutter/material.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/page_header.dart';
import 'package:link/controllers/crud_controller.dart';
import 'package:link/dtos/course_dto.dart';
import 'package:link/models/course.dart';
import 'package:link/screens/forms/add_form.dart';
import 'package:link/validators/int_validator.dart';
import 'package:link/validators/not_empty_validator.dart';
import 'package:provider/provider.dart';

class AddCourseForm extends StatefulWidget {
  const AddCourseForm({super.key});

  @override
  State<AddCourseForm> createState() => _AddCourseFormState();
}

class _AddCourseFormState extends State<AddCourseForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _deptController = TextEditingController();
  final _creditHourController = TextEditingController();
  final _yearController = TextEditingController();
  bool _hasLecture = false;
  bool _hasLab = false;
  bool _hasSection = false;

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<CrudController<Course>>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 600,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PageHeader(title: 'Add Course'),
          AddForm.crud(
            formKey: _formKey,
            crudController: course,
            dtoBuilder: () => CourseDTO(
              code: _codeController.text,
              name: _nameController.text,
              department: _deptController.text,
              creditHours: int.tryParse(_creditHourController.text),
              year: int.tryParse(_yearController.text),
              hasLecture: _hasLecture,
              hasLab: _hasLab,
              hasSection: _hasSection,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedTextFieldForm(
                        controller: _codeController,
                        labelText: 'Code',
                        maxLines: 1,
                        validator: (value) =>
                            NotEmptyValidator('Code').validate(value),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      flex: 2,
                      child: OutlinedTextFieldForm(
                        controller: _nameController,
                        labelText: 'Name',
                        maxLines: 1,
                        validator: (value) =>
                            NotEmptyValidator('Name').validate(value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedTextFieldForm(
                        controller: _deptController,
                        labelText: 'Department',
                        maxLines: 1,
                        validator: (value) =>
                            NotEmptyValidator('Department').validate(value),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: OutlinedTextFieldForm(
                        controller: _creditHourController,
                        labelText: 'CreditHours',
                        hintText: '0',
                        maxLines: 1,
                        validator: (value) {
                          String? validation =
                              IntValidator('CreditHours').validate(value);

                          if (validation != null) {
                            return validation;
                          } else if (int.parse(value!) < 0) {
                            return 'CreditHours must be >= 0';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: OutlinedTextFieldForm(
                        controller: _yearController,
                        labelText: 'Year',
                        hintText: '1',
                        maxLines: 1,
                        validator: (value) {
                          String? validation =
                              IntValidator('Year').validate(value);
                          if (validation != null) {
                            return validation;
                          } else if (int.parse(value!) <= 0) {
                            return 'Year must be > 0';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        value: _hasLecture,
                        onChanged: (value) =>
                            setState(() => _hasLecture = value!),
                        title: const Text('Lecture'),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        value: _hasLab,
                        onChanged: (value) => setState(() => _hasLab = value!),
                        title: const Text('Lab'),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        value: _hasSection,
                        onChanged: (value) =>
                            setState(() => _hasSection = value!),
                        title: const Text('Section'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
