import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- MODELS ---
enum JobStatus { available, assigned, picked, inTransit, delivered, cancelled }

enum Urgency { normal, high }

class JobModel {
  final String id;
  final String loadType;
  final double weight;
  final String pickup;
  final String dropoff;
  final double distance;
  final double price;
  final DateTime timePosted;
  final Urgency urgency;
  final JobStatus status;

  JobModel({
    required this.id,
    required this.loadType,
    required this.weight,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.price,
    required this.timePosted,
    required this.urgency,
    this.status = JobStatus.available,
  });

  JobModel copyWith({JobStatus? status}) {
    return JobModel(
      id: id,
      loadType: loadType,
      weight: weight,
      pickup: pickup,
      dropoff: dropoff,
      distance: distance,
      price: price,
      timePosted: timePosted,
      urgency: urgency,
      status: status ?? this.status,
    );
  }
}

class TransactionModel {
  final String id;
  final String jobId;
  final double amount;
  final DateTime date;
  TransactionModel({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.date,
  });
}

// --- STATE ---
class DriverJobsState {
  final bool isLoading;
  final String? error;
  final List<JobModel> availableJobs;
  final List<JobModel> myDeliveries;
  final List<TransactionModel> transactions;

  const DriverJobsState({
    this.isLoading = false,
    this.error,
    this.availableJobs = const [],
    this.myDeliveries = const [],
    this.transactions = const [],
  });

  DriverJobsState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<JobModel>? availableJobs,
    List<JobModel>? myDeliveries,
    List<TransactionModel>? transactions,
  }) {
    return DriverJobsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      availableJobs: availableJobs ?? this.availableJobs,
      myDeliveries: myDeliveries ?? this.myDeliveries,
      transactions: transactions ?? this.transactions,
    );
  }
}

// --- NOTIFIER ---
class DriverJobsNotifier extends Notifier<DriverJobsState> {
  bool _mounted = true;

  @override
  DriverJobsState build() {
    _mounted = true;
    ref.onDispose(() => _mounted = false);
    Future.microtask(loadInitialData);
    return const DriverJobsState();
  }

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await Future.delayed(
        const Duration(milliseconds: 1000),
      ); // Mock API Latency
      if (!_mounted) return;

      final mockJobs = [
        JobModel(
          id: 'J1',
          loadType: 'Premium Wheat',
          weight: 50,
          pickup: 'Multan Grain Market',
          dropoff: 'Bin Qasim Port, Karachi',
          distance: 850,
          price: 85000,
          timePosted: DateTime.now().subtract(const Duration(minutes: 2)),
          urgency: Urgency.high,
        ),
        JobModel(
          id: 'J2',
          loadType: 'Fresh Apples',
          weight: 15,
          pickup: 'Quetta Orchards',
          dropoff: 'Lahore Central Market',
          distance: 720,
          price: 60000,
          timePosted: DateTime.now().subtract(const Duration(minutes: 45)),
          urgency: Urgency.normal,
        ),
      ];

      final mockDeliveries = [
        JobModel(
          id: 'D1',
          loadType: 'Basmati Rice',
          weight: 30,
          pickup: 'Gujranwala',
          dropoff: 'Faisalabad',
          distance: 180,
          price: 25000,
          timePosted: DateTime.now(),
          urgency: Urgency.normal,
          status: JobStatus.inTransit,
        ),
      ];

      final mockTrans = [
        TransactionModel(
          id: 'T1',
          jobId: 'D9',
          amount: 42500,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TransactionModel(
          id: 'T2',
          jobId: 'D8',
          amount: 38000,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      state = state.copyWith(
        isLoading: false,
        availableJobs: mockJobs,
        myDeliveries: mockDeliveries,
        transactions: mockTrans,
      );
    } catch (e) {
      if (_mounted)
        state = state.copyWith(isLoading: false, error: 'Failed to load data');
    }
  }

  Future<void> acceptJob(String jobId) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800)); // API call
    if (!_mounted) return;

    final jobIndex = state.availableJobs.indexWhere((j) => j.id == jobId);
    if (jobIndex != -1) {
      final job = state.availableJobs[jobIndex].copyWith(
        status: JobStatus.assigned,
      );
      final newAvailable = List<JobModel>.from(state.availableJobs)
        ..removeAt(jobIndex);
      final newDeliveries = List<JobModel>.from(state.myDeliveries)
        ..insert(0, job);

      state = state.copyWith(
        isLoading: false,
        availableJobs: newAvailable,
        myDeliveries: newDeliveries,
      );
    }
  }
}

final driverJobsProvider =
    NotifierProvider<DriverJobsNotifier, DriverJobsState>(
      DriverJobsNotifier.new,
    );
