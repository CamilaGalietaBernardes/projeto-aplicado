// lib/features/views/children/user_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/user_view_model.dart';

class UserListView extends ConsumerStatefulWidget {
  const UserListView({super.key});

  @override
  ConsumerState<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends ConsumerState<UserListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userListAsyncValue = ref.watch(userViewModelProvider);
    final searchQuery = ref.watch(userSearchQueryProvider);
    final selectedSetor = ref.watch(userSetorFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        title: const Text('Gestão de Usuários'),
        backgroundColor: AppColors.accentWhite,
        foregroundColor: AppColors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: () {
              ref.read(userViewModelProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          _buildTopBar(context),
          SizedBox(height: 10.h),
          _buildSearchBar(),
          SizedBox(height: 10.h),
          _buildSetorFilter(userListAsyncValue),
          const Divider(color: AppColors.metallicGray, thickness: 1),
          Expanded(
            child: userListAsyncValue.when(
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
                    Text('Erro ao carregar usuários: $err'),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(userViewModelProvider.notifier).refresh();
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return const Center(
                    child: Text('Nenhum usuário cadastrado.'),
                  );
                }

                // Filtrar por busca e setor
                final filteredUsers = users.where((user) {
                  final query = searchQuery.toLowerCase();
                  final matchesSearch =
                      (user.nome.toLowerCase().contains(query)) ||
                      (user.email.toLowerCase().contains(query)) ||
                      (user.funcao?.toLowerCase().contains(query) ?? false);

                  final matchesSetor =
                      selectedSetor == 'Todos' || user.setor == selectedSetor;

                  return matchesSearch && matchesSetor;
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text('Nenhum resultado para a busca.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(userViewModelProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return _buildUserCard(user);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showUserFormDialog(context, isEdit: false);
        },
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Novo Usuário',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Text(
            'Gerenciar Usuários',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
          hintText: 'Buscar por nome, email ou função...',
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
          ref.read(userSearchQueryProvider.notifier).state = value;
        },
      ),
    );
  }

  Widget _buildSetorFilter(AsyncValue<List<UserModel>> userListAsyncValue) {
    final selectedSetor = ref.watch(userSetorFilterProvider);

    // Extrair setores únicos da lista de usuários
    final setores = <String>{'Todos'};
    userListAsyncValue.whenData((users) {
      for (var user in users) {
        setores.add(user.setor!);
      }
    });

    final setorList = setores.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: setorList.map((setor) {
          final isSelected = setor == selectedSetor;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(setor),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  ref.read(userSetorFilterProvider.notifier).state = setor;
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

  Widget _buildUserCard(UserModel user) {
    return Card(
      color: AppColors.lightGray,
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryGreen,
          child: Text(
            user.nome.isNotEmpty ? user.nome[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.nome,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Row(
              children: [
                const Icon(Icons.email, size: 14, color: Colors.grey),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    user.email,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                const Icon(Icons.work, size: 14, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  user.funcao ?? 'N/A',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                ),
                SizedBox(width: 10.w),
                const Icon(Icons.business, size: 14, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  user.setor ?? 'N/A',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showUserFormDialog(context, isEdit: true, user: user);
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, user);
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

  void _showUserFormDialog(
    BuildContext context, {
    required bool isEdit,
    UserModel? user,
  }) {
    final nomeController = TextEditingController(text: user?.nome ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final funcaoController = TextEditingController(text: user?.funcao ?? '');
    final setorController = TextEditingController(text: user?.setor ?? '');
    final senhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Editar Usuário' : 'Novo Usuário'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: funcaoController,
                decoration: const InputDecoration(
                  labelText: 'Função',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: setorController,
                decoration: const InputDecoration(
                  labelText: 'Setor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: isEdit
                      ? 'Nova Senha (deixe vazio para manter)'
                      : 'Senha',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nome = nomeController.text.trim();
              final email = emailController.text.trim();
              final funcao = funcaoController.text.trim();
              final setor = setorController.text.trim();
              final senha = senhaController.text.trim();

              // Validações
              if (nome.isEmpty ||
                  email.isEmpty ||
                  funcao.isEmpty ||
                  setor.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preencha todos os campos obrigatórios'),
                  ),
                );
                return;
              }

              if (!isEdit && senha.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Senha é obrigatória para novo usuário'),
                  ),
                );
                return;
              }

              bool success;
              if (isEdit) {
                success = await ref
                    .read(userViewModelProvider.notifier)
                    .updateUser(
                      id: user!.id,
                      nome: nome,
                      email: email,
                      funcao: funcao,
                      setor: setor,
                      senha: senha.isNotEmpty ? senha : null,
                    );
              } else {
                success = await ref
                    .read(userViewModelProvider.notifier)
                    .createUser(
                      nome: nome,
                      email: email,
                      funcao: funcao,
                      setor: setor,
                      senha: senha,
                    );
              }

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? isEdit
                                ? 'Usuário atualizado!'
                                : 'Usuário criado!'
                          : 'Erro ao salvar usuário',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: Text(
              isEdit ? 'Salvar' : 'Criar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o usuário "${user.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref
                  .read(userViewModelProvider.notifier)
                  .deleteUser(user.id);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Usuário excluído!' : 'Erro ao excluir usuário',
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
