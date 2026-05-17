import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/driver_jobs_provider.dart';

const Color _green = Color(0xFF10B981);
const Color _ink = Color(0xFF1E293B);

class MyDeliveriesScreen extends ConsumerWidget {
  const MyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driverJobsProvider);

    final active = state.myDeliveries
        .where(
          (j) =>
              j.status != JobStatus.delivered &&
              j.status != JobStatus.cancelled,
        )
        .toList();
    final completed = state.myDeliveries
        .where((j) => j.status == JobStatus.delivered)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: _ink),
          title: const Text(
            'My Deliveries',
            style: TextStyle(color: _ink, fontWeight: FontWeight.w800),
          ),
          bottom: const TabBar(
            indicatorColor: _green,
            labelColor: _green,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildList(active, true), _buildList(completed, false)],
        ),
      ),
    );
  }

  Widget _buildList(List<JobModel> jobs, bool isActive) {
    if (jobs.isEmpty)
      return const Center(
        child: Text(
          'No deliveries found.',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        ),
      );
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) =>
          _DeliveryCard(job: jobs[index], isActive: isActive),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final JobModel job;
  final bool isActive;
  const _DeliveryCard({required this.job, required this.isActive});

  int _getStatusIndex() {
    switch (job.status) {
      case JobStatus.assigned:
        return 0;
      case JobStatus.picked:
        return 1;
      case JobStatus.inTransit:
        return 2;
      case JobStatus.delivered:
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusIndex = _getStatusIndex();
    final statuses = ['Assigned', 'Picked', 'In Transit', 'Delivered'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${job.loadType} • ${job.weight.toInt()}T',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              Text(
                'Rs. ${job.price.toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: _green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${job.pickup}  ➔  ${job.dropoff}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (isActive) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Row(
              children: List.generate(4, (index) {
                final isCompleted = index <= statusIndex;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isCompleted ? _green : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Current Status: ${statuses[statusIndex]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
