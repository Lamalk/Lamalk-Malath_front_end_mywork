import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageCasesScreen extends StatefulWidget {
  const ManageCasesScreen({super.key});

  @override
  State<ManageCasesScreen> createState() => _ManageCasesScreenState();
}

class _ManageCasesScreenState extends State<ManageCasesScreen> {
  final Color primaryColor = const Color(0xFF4C5494);
  final supabase = Supabase.instance.client;

  final String tableName = 'legal_articles';
  final String primaryKey = 'id';

  bool isLoading = true;
  bool isSaving = false;

  List<Map<String, dynamic>> legalArticles = [];

  final Map<dynamic, Map<String, dynamic>> editedRows = {};

  @override
  void initState() {
    super.initState();
    fetchLegalArticles();
  }

  Future<void> fetchLegalArticles() async {
    try {
      setState(() => isLoading = true);

      final response = await supabase
          .from(tableName)
          .select()
          .order('id', ascending: true);

      setState(() {
        legalArticles = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء جلب البيانات: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void onFieldChanged({
    required dynamic rowId,
    required String column,
    required dynamic value,
  }) {
    editedRows.putIfAbsent(rowId, () => {});
    editedRows[rowId]![column] = value;
  }

  Future<void> updateDatabase() async {
    if (editedRows.isEmpty) {
      _showSnackBar('لا توجد تعديلات للحفظ');
      return;
    }

    try {
      setState(() => isSaving = true);

      for (final entry in editedRows.entries) {
        final rowId = entry.key;
        final updatedData = entry.value;

        if (updatedData.isNotEmpty) {
          await supabase.from(tableName).update(updatedData).eq(primaryKey, rowId);
        }
      }

      editedRows.clear();
      _showSnackBar('تم تحديث قاعدة البيانات بنجاح');
      await fetchLegalArticles();
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء التحديث: $e', isError: true);
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> deleteArticle(dynamic articleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه المادة القانونية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await supabase.from(tableName).delete().eq(primaryKey, articleId);

      legalArticles.removeWhere((row) => row[primaryKey] == articleId);
      editedRows.remove(articleId);

      setState(() {});
      _showSnackBar('تم حذف المادة بنجاح');
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء الحذف: $e', isError: true);
    }
  }

  Future<void> showAddArticleDialog() async {
    final articleNumberController = TextEditingController();
    final articleContentController = TextEditingController();
    final penaltyDetailsController = TextEditingController();
    final referenceUrlController = TextEditingController();
    final crimeCategoryIdController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة مادة قانونية'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: articleNumberController,
                      decoration: const InputDecoration(
                        labelText: 'رقم المادة',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: articleContentController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'نص المادة',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'أدخل نص المادة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: penaltyDetailsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'تفاصيل العقوبة',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: referenceUrlController,
                      decoration: const InputDecoration(
                        labelText: 'رابط المرجع',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: crimeCategoryIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'crime_category_id',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text(
                'إضافة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    try {
      final Map<String, dynamic> newArticle = {
        'article_number': articleNumberController.text.trim().isEmpty
            ? null
            : articleNumberController.text.trim(),
        'article_content': articleContentController.text.trim(),
        'penalty_details': penaltyDetailsController.text.trim().isEmpty
            ? null
            : penaltyDetailsController.text.trim(),
        'reference_url': referenceUrlController.text.trim().isEmpty
            ? null
            : referenceUrlController.text.trim(),
        'crime_category_id': crimeCategoryIdController.text.trim().isEmpty
            ? null
            : int.tryParse(crimeCategoryIdController.text.trim()),
      };

      await supabase.from(tableName).insert(newArticle);

      _showSnackBar('تمت إضافة المادة بنجاح');
      await fetchLegalArticles();
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء الإضافة: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : primaryColor,
      ),
    );
  }

  Widget buildEditableField({
    required dynamic rowId,
    required String column,
    required dynamic value,
  }) {
    final textValue = value?.toString() ?? '';

    int maxLines = 1;
    TextInputType keyboardType = TextInputType.text;

    if (column == 'article_content' || column == 'penalty_details') {
      maxLines = 4;
    }

    if (column == 'crime_category_id') {
      keyboardType = TextInputType.number;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: textValue,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: column,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (newValue) {
          dynamic parsedValue = newValue;

          if (column == 'crime_category_id') {
            parsedValue = newValue.trim().isEmpty ? null : int.tryParse(newValue);
          } else {
            parsedValue = newValue.trim().isEmpty ? null : newValue;
          }

          onFieldChanged(rowId: rowId, column: column, value: parsedValue);
        },
      ),
    );
  }

  Widget buildArticleCard(Map<String, dynamic> row) {
    final rowId = row[primaryKey];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'المادة ID: $rowId',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'حذف',
                  onPressed: () => deleteArticle(rowId),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _readOnlyField('created_at', row['created_at']?.toString() ?? ''),
            buildEditableField(
              rowId: rowId,
              column: 'article_number',
              value: row['article_number'],
            ),
            buildEditableField(
              rowId: rowId,
              column: 'article_content',
              value: row['article_content'],
            ),
            buildEditableField(
              rowId: rowId,
              column: 'penalty_details',
              value: row['penalty_details'],
            ),
            buildEditableField(
              rowId: rowId,
              column: 'reference_url',
              value: row['reference_url'],
            ),
            buildEditableField(
              rowId: rowId,
              column: 'crime_category_id',
              value: row['crime_category_id'],
            ),
            const Text(
              'embedding: غير قابل للتعديل من الواجهة',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C5494)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إدارة المواد القانونية',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: showAddArticleDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'إضافة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : legalArticles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('لا توجد مواد قانونية'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: showAddArticleDialog,
                        child: const Text('إضافة مادة جديدة'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : updateDatabase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'تحديث قاعدة البيانات',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: fetchLegalArticles,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: legalArticles.length,
                          itemBuilder: (context, index) {
                            return buildArticleCard(legalArticles[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}