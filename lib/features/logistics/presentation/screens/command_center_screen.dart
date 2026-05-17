import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Providers & Widgets ---
import '../providers/driver_dashboard_provider.dart';
import '../widgets/driver_widgets.dart';

// 🔥 NEW IMPORTS: Ye saari nayi screens hain jo humne abhi banai hain
import 'available_jobs_screen.dart';
import 'my_deliveries_screen.dart';
import 'driver_ancillary_screens.dart';

const Color _bgSecondary = Color(0xFFF8FAFC);
const Color _ink = Color(0xFF1E293B);

// Centralized Strings
class AppStrings {
  static const screenTitle = "Command Center";
  static const quickActions = "QUICK ACTIONS";
  static const financialOverview = "FINANCIAL OVERVIEW";
  static const currentAssignment = "CURRENT ASSIGNMENT";
  static const availableJobs = "Available Jobs";
  static const myDeliveries = "My Deliveries";
  static const earnings = "Earnings";
  static const support = "Support";
}

class CommandCenterScreen extends ConsumerStatefulWidget {
  const CommandCenterScreen({super.key});

  @override
  ConsumerState<CommandCenterScreen> createState() =>
      _CommandCenterScreenState();
}

class _CommandCenterScreenState extends ConsumerState<CommandCenterScreen> {
  final double _dropoffLat = 24.7981;
  final double _dropoffLng = 67.3406;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverDashboardProvider.notifier).loadDashboardData();
    });
  }

  // 🔥 CORE NAVIGATION ROUTER 🔥
  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverDashboardProvider);
    final notifier = ref.read(driverDashboardProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final gridRatio = screenWidth < 380 ? 1.1 : 1.35;

    ref.listen<DriverDashboardState>(driverDashboardProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
        notifier.resetError();
      }
    });

    return Scaffold(
      backgroundColor: _bgSecondary,
      appBar: AppBar(
        title: const Text(
          AppStrings.screenTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: _ink,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: _ink),
            onPressed: () {},
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF10B981)),
            )
          : RefreshIndicator(
              color: const Color(0xFF10B981),
              onRefresh: notifier.loadDashboardData,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.all(24),
                children: [
                  StatusCard(
                    isOnline: state.isOnline,
                    onToggle: (_) => notifier.toggleOnlineStatus(),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    AppStrings.quickActions,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔥 CONNECTED ACTION CARDS 🔥
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: gridRatio,
                    children: [
                      ActionCard(
                        icon: Icons.assignment_turned_in_rounded,
                        label: AppStrings.availableJobs,
                        onTap: () => _navigateTo(
                          const AvailableJobsScreen(),
                        ), // 👈 Routes to Available Jobs
                      ),
                      ActionCard(
                        icon: Icons.history_rounded,
                        label: AppStrings.myDeliveries,
                        onTap: () => _navigateTo(
                          const MyDeliveriesScreen(),
                        ), // 👈 Routes to My Deliveries
                      ),
                      ActionCard(
                        icon: Icons.account_balance_wallet_rounded,
                        label: AppStrings.earnings,
                        onTap: () => _navigateTo(
                          const EarningsScreen(),
                        ), // 👈 Routes to Earnings
                      ),
                      ActionCard(
                        icon: Icons.support_agent_rounded,
                        label: AppStrings.support,
                        onTap: () => _navigateTo(
                          const SupportScreen(),
                        ), // 👈 Routes to Support
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    AppStrings.financialOverview,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Weekly Earnings',
                          value:
                              'Rs. ${(state.weeklyEarnings / 1000).toStringAsFixed(1)}K',
                          icon: Icons.account_balance_wallet_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Today',
                          value: 'Rs. ${state.todayEarnings.toInt()}',
                          icon: Icons.trending_up_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    AppStrings.currentAssignment,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (!state.hasActiveShipment || state.totalTrips == 0)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Text(
                          "No active deliveries.\nGo online to accept jobs.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  else
                    ShipmentCard(
                      loadType: state.loadType,
                      pickup: state.pickupLocation,
                      dropoff: state.dropoffLocation,
                      eta: state.eta,
                      status: state.shipmentStatus,
                      onNavigate: () => notifier.launchNativeNavigation(
                        _dropoffLat,
                        _dropoffLng,
                      ),
                    ),

                  const SizedBox(height: 40),

                  // 🔥 CONNECTED PRIMARY BUTTON 🔥
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isOnline
                          ? () =>
                                _navigateTo(
                                  const AvailableJobsScreen(),
                                ) // 👈 Routes to Available Jobs
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _ink,
                        disabledBackgroundColor: const Color(0xFFE2E8F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        state.isOnline
                            ? 'Find New Load'
                            : 'Go online to accept jobs',
                        style: TextStyle(
                          color: state.isOnline
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
