// lib/features/views/children/stock_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/stock_view_model.dart';

class StockView extends ConsumerStatefulWidget {
  const StockView({super.key});

  @override
  ConsumerState<StockView> createState() => _StockViewState();
}

class _StockViewState extends ConsumerState<StockView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockListAsyncValue = ref.watch(stockViewModelProvider);
    final searchQuery = ref.watch(stockSearchQueryProvider);
    final selectedCategory = ref.watch(stockCategoryFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      body: Column(
        children: [
          _buildTopBar(context),
          SizedBox(height: 10.h),
          _buildSearchBar(),
          SizedBox(height: 10.h),
          _buildCategoryFilter(stockListAsyncValue),
          const Divider(color: AppColors.metallicGray, thickness: 1),
          Expanded(
            child: stockListAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.h),
                    Text('Erro ao carregar estoque: $err'),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(stockViewModelProvider.notifier).refresh();
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
              data: (parts) {
                if (parts.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma peça cadastrada no estoque.'),
                  );
                }

                // Filtrar por busca e categoria
                final filteredParts = parts.where((part) {
                  final query = searchQuery.toLowerCase();
                  final matchesSearch =
                      part.peca.toLowerCase().contains(query) ||
                      part.categoria.toLowerCase().contains(query);

                  final matchesCategory =
                      selectedCategory == 'Todas' ||
                      part.categoria == selectedCategory;

                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredParts.isEmpty) {
                  return const Center(
                    child: Text('Nenhum resultado para a busca.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(stockViewModelProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    itemCount: filteredParts.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    itemBuilder: (context, index) {
                      final part = filteredParts[index];
                      return _buildStockCard(part);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              _showAddPartDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.accentWhite,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Nova Peça'),
          ),
          SizedBox(width: 10.w),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/stock/alerts');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: AppColors.accentWhite,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            icon: const Icon(Icons.warning_amber),
            label: const Text('Alertas'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por nome ou categoria...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
        ),
        onChanged: (value) {
          ref.read(stockSearchQueryProvider.notifier).state = value;
        },
      ),
    );
  }

  Widget _buildCategoryFilter(
    AsyncValue<List<StockModel>> stockListAsyncValue,
  ) {
    final selectedCategory = ref.watch(stockCategoryFilterProvider);

    // Extrair categorias únicas da lista de peças
    final categories = <String>{'Todas'};
    stockListAsyncValue.whenData((parts) {
      for (var part in parts) {
        categories.add(part.categoria);
      }
    });

    final categoryList = categories.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: categoryList.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  ref.read(stockCategoryFilterProvider.notifier).state =
                      category;
                }
              },
              selectedColor: AppColors.primaryGreen,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.black,
              ),
              backgroundColor: Colors.grey[200],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStockCard(StockModel part) {
    final isLowStock = part.qtd < part.qtdMin;

    return Card(
      color: AppColors.lightGray,
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: isLowStock
            ? const BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: isLowStock
                ? Colors.red.shade100
                : AppColors.primaryGreen.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            isLowStock ? Icons.warning_amber : Icons.inventory_2,
            color: isLowStock ? Colors.red : AppColors.primaryGreen,
            size: 28,
          ),
        ),
        title: Text(
          part.peca,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              'Categoria: ${part.categoria}',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  'Qtd: ${part.qtd}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isLowStock ? Colors.red : Colors.black87,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Mín: ${part.qtdMin}',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            if (isLowStock)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'ESTOQUE BAIXO!',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          shadowColor: AppColors.accentWhite,
          surfaceTintColor: AppColors.accentWhite,
          onSelected: (value) {
            if (value == 'edit') {
              _showEditPartDialog(context, part);
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, part);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialogs de adicionar, editar e excluir
  void _showAddPartDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final categoriaController = TextEditingController();
    final qtdController = TextEditingController();
    final qtdMinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: const Text('Nova Peça')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Peça',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: qtdController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: qtdMinController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade Mínima',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nome = nomeController.text.trim();
                  final categoria = categoriaController.text.trim();
                  final qtd = int.tryParse(qtdController.text);
                  final qtdMin = int.tryParse(qtdMinController.text);

                  if (nome.isEmpty ||
                      categoria.isEmpty ||
                      qtd == null ||
                      qtdMin == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha todos os campos corretamente',
                          ),
                        ),
                      );
                    }
                    return;
                  }

                  final success = await ref
                      .read(stockViewModelProvider.notifier)
                      .createPart(
                        nome: nome,
                        categoria: categoria,
                        qtd: qtd,
                        qtdMin: qtdMin,
                      );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Peça criada com sucesso!'
                              : 'Erro ao criar peça',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: const Text(
                  'Criar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditPartDialog(BuildContext context, StockModel part) {
    final nomeController = TextEditingController(text: part.peca);
    final categoriaController = TextEditingController(text: part.categoria);
    final qtdController = TextEditingController(text: part.qtd.toString());
    final qtdMinController = TextEditingController(
      text: part.qtdMin.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Peça'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Peça',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: qtdController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: qtdMinController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade Mínima',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          // Envolve os botões em um Row para alinhá-los horizontalmente.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nome = nomeController.text.trim();
                  final categoria = categoriaController.text.trim();
                  final qtd = int.tryParse(qtdController.text);
                  final qtdMin = int.tryParse(qtdMinController.text);

                  if (nome.isEmpty ||
                      categoria.isEmpty ||
                      qtd == null ||
                      qtdMin == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Preencha todos os campos corretamente',
                          ),
                        ),
                      );
                    }
                    return;
                  }

                  final success = await ref
                      .read(stockViewModelProvider.notifier)
                      .updatePart(
                        id: part.id,
                        nome: nome,
                        categoria: categoria,
                        qtd: qtd,
                        qtdMin: qtdMin,
                      );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Peça atualizada com sucesso!'
                              : 'Erro ao atualizar peça',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, StockModel part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a peça "${part.peca}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref
                  .read(stockViewModelProvider.notifier)
                  .deletePart(part.id);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Peça excluída com sucesso!'
                          : 'Erro ao excluir peça',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
