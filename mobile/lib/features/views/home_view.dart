// lib/presentation/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/domain/models/order_service_model.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/order_service_view_model.dart';
import 'package:mobile/presentation/widgets/order_service_card.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  // Controlador para o campo de busca
  final TextEditingController _searchController = TextEditingController();

  // A lista de status que você forneceu
  final List<String> statusOptions = [
    'Aberta',
    'Em andamento',
    'Concluída',
    'Atrasada',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o provedor da lista de ordens de serviço
    final orderListAsyncValue = ref.watch(orderListProvider);
    // Escuta o provedor do termo de busca
    final searchQuery = ref.watch(searchQueryProvider);
    // Escuta o provedor do filtro de status
    final selectedStatus = ref.watch(statusFilterProvider);

    // Adiciona "Todos" à lista de opções para o filtro
    final allStatusOptions = ['Todos', ...statusOptions];

    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      body: Column(
        children: [
          _buildTopBar(context),
          SizedBox(height: 10.h),
          _buildSearchBar(),
          SizedBox(height: 10.h),
          _buildStatusFilterRow(allStatusOptions),
          const Divider(color: AppColors.metallicGray, thickness: 1),
          Expanded(
            child: orderListAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erro: $err')),
              data: (orders) {
                if (orders.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma ordem de serviço encontrada.'),
                  );
                }

                final filteredOrders = orders.where((order) {
                  final query = searchQuery.toLowerCase();
                  final matchesSearch =
                      (order.tipo?.toLowerCase().contains(query) ?? false) ||
                      (order.setor?.toLowerCase().contains(query) ?? false) ||
                      (order.recorrencia?.toLowerCase().contains(query) ??
                          false) ||
                      (order.detalhes?.toLowerCase().contains(query) ?? false);

                  final matchesStatus =
                      selectedStatus == 'Todos' ||
                      order.status == selectedStatus;

                  return matchesSearch && matchesStatus;
                }).toList();

                if (filteredOrders.isEmpty) {
                  return const Center(
                    child: Text('Nenhum resultado para a busca.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return OrderServiceCard(order: order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/home/childA');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.accentWhite,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              child: const Text('Nova Ordem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por tipo, setor, recorrência...',
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
          ref.read(searchQueryProvider.notifier).state = value;
        },
      ),
    );
  }

  Widget _buildStatusFilterRow(List<String> statusList) {
    final selectedStatus = ref.watch(statusFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: statusList.map((status) {
          final isSelected = status == selectedStatus;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  ref.read(statusFilterProvider.notifier).state = status;
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
}
