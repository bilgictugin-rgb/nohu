import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/academic/academic_detail_screens.dart';
import '../../features/academic/academic_screen.dart';
import '../../features/attendance/attendance_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/campus/campus_feature_screens.dart';
import '../../features/campus/campus_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_detail_screens.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/schedule/schedule_builder_screen.dart';
import '../../features/schedule/schedule_screen.dart';
import '../widgets/app_design.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/startup',
    errorBuilder: (context, state) => RouteErrorScreen(
      message: state.error?.toString() ?? 'Bu sayfa açılamadı.',
    ),
    routes: [
      GoRoute(
        path: '/startup',
        name: 'startup',
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/notifications',
                name: 'notifications',
                builder: (context, state) => const NotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/academic',
                name: 'academic',
                builder: (context, state) => const AcademicScreen(),
                routes: [
                  GoRoute(
                    path: 'schedule',
                    name: 'schedule',
                    builder: (context, state) => const ScheduleScreen(),
                  ),
                  GoRoute(
                    path: 'schedule-builder',
                    name: 'scheduleBuilder',
                    builder: (context, state) => const ScheduleBuilderScreen(),
                  ),
                  GoRoute(
                    path: 'grades',
                    name: 'grades',
                    builder: (context, state) => const GradesScreen(),
                  ),
                  GoRoute(
                    path: 'exams',
                    name: 'exams',
                    builder: (context, state) => const ExamsScreen(),
                  ),
                  GoRoute(
                    path: 'attendance',
                    name: 'attendance',
                    builder: (context, state) => const AttendanceScreen(),
                  ),
                  GoRoute(
                    path: 'calendar',
                    name: 'academicCalendar',
                    builder: (context, state) => const AcademicCalendarScreen(),
                  ),
                  GoRoute(
                    path: 'documents',
                    name: 'documents',
                    builder: (context, state) => const DocumentsScreen(),
                  ),
                  GoRoute(
                    path: 'advisor',
                    name: 'academicAdvisor',
                    builder: (context, state) => const AdvisorScreen(),
                  ),
                  GoRoute(
                    path: 'courses/:courseId',
                    name: 'courseDetail',
                    builder: (context, state) => CourseDetailScreen(
                      courseId: state.pathParameters['courseId'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/campus',
                name: 'campus',
                builder: (context, state) => const CampusScreen(),
                routes: [
                  GoRoute(
                    path: 'cafeteria',
                    name: 'cafeteria',
                    builder: (context, state) => const CafeteriaScreen(),
                  ),
                  GoRoute(
                    path: 'library',
                    name: 'library',
                    builder: (context, state) => const LibraryScreen(),
                  ),
                  GoRoute(
                    path: 'transport',
                    name: 'transport',
                    builder: (context, state) => const TransportScreen(),
                  ),
                  GoRoute(
                    path: 'career',
                    name: 'career',
                    builder: (context, state) => const CareerScreen(),
                    routes: [
                      GoRoute(
                        path: ':jobId',
                        name: 'jobDetail',
                        builder: (context, state) => CareerJobDetailScreen(
                          jobId: state.pathParameters['jobId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'lost-found',
                    name: 'lostFound',
                    builder: (context, state) => const LostFoundScreen(),
                    routes: [
                      GoRoute(
                        path: ':itemId',
                        name: 'lostFoundDetail',
                        builder: (context, state) => LostFoundDetailScreen(
                          itemId: state.pathParameters['itemId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'map',
                    name: 'campusMap',
                    builder: (context, state) => const CampusMapScreen(),
                  ),
                  GoRoute(
                    path: 'events',
                    name: 'events',
                    builder: (context, state) => const EventsScreen(),
                    routes: [
                      GoRoute(
                        path: ':eventId',
                        name: 'eventDetail',
                        builder: (context, state) => EventDetailScreen(
                          eventId: state.pathParameters['eventId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'communities',
                    name: 'communities',
                    builder: (context, state) => const CommunitiesScreen(),
                    routes: [
                      GoRoute(
                        path: ':communityId',
                        name: 'communityDetail',
                        builder: (context, state) => CommunityDetailScreen(
                          communityId:
                              state.pathParameters['communityId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'announcements',
                    name: 'announcements',
                    builder: (context, state) => const AnnouncementsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'editProfile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'advisor',
                    name: 'profileAdvisor',
                    builder: (context, state) => const AdvisorScreen(),
                  ),
                  GoRoute(
                    path: 'personal-info',
                    name: 'personalInfo',
                    builder: (context, state) => const PersonalInfoScreen(),
                  ),
                  GoRoute(
                    path: 'favorites',
                    name: 'favorites',
                    builder: (context, state) => const FavoritesScreen(),
                  ),
                  GoRoute(
                    path: 'notification-settings',
                    name: 'notificationSettings',
                    builder: (context, state) =>
                        const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'theme',
                    name: 'themeSettings',
                    builder: (context, state) => const ThemeSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'language',
                    name: 'language',
                    builder: (context, state) => const LanguageScreen(),
                  ),
                  GoRoute(
                    path: 'accessibility',
                    name: 'accessibility',
                    builder: (context, state) => const AccessibilityScreen(),
                  ),
                  GoRoute(
                    path: 'help',
                    name: 'help',
                    builder: (context, state) => const HelpScreen(),
                  ),
                  GoRoute(
                    path: 'feedback',
                    name: 'feedback',
                    builder: (context, state) => const FeedbackScreen(),
                  ),
                  GoRoute(
                    path: 'privacy',
                    name: 'privacy',
                    builder: (context, state) => const PrivacyScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sayfa açılamadı')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 52,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sayfa açılamadı',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => context.goNamed('home'),
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Ana Sayfaya Dön'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          context.goNamed('home');
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Geri Dön'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
