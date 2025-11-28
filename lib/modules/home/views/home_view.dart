import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../user_list/views/user_list_view.dart';
import '../components/top_user_card.dart';
import '../view_models/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Here are our top users', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),

                  
                  Expanded(
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.errorMessage != null
                            ? Center(child: Text('Error: ${viewModel.errorMessage}'))
                            : ListView.builder(
                                itemCount: viewModel.topUsers.length,
                                itemBuilder: (context, index) {
                                  return TopUserCard(
                                    user: viewModel.topUsers[index],
                                    rank: index + 1,
                                    onTap: () {}, 
                                  );
                                },
                              ),
                  ),
                  const SizedBox(height: 20),

                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>  UserListView()),
                        );
                      },
                      child: const Text('View All Users'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}