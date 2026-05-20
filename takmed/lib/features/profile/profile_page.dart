import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/injection_container.dart';
import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/auth_event.dart';
import '../learning/presentation/bloc/home_bloc.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'presentation/bloc/profile_event.dart';
import 'presentation/bloc/profile_state.dart';
import 'presentation/widgets/profile_stats_card.dart';
import 'presentation/widgets/quiz_dynamics_chart.dart';

/// Екран профілю — редагування + статистика + графік.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>()..add(const ProfileLoaded());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Оновлюємо stats щоразу, коли сторінка стає видимою (зміна роуту)
    _profileBloc.add(const ProfileStatsRequested());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>.value(
      value: _profileBloc,
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.errorRed),
            tooltip: AppStrings.logout,
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.savedJustNow) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Профіль збережено'),
                backgroundColor: AppColors.successGreen,
              ),
            );
            // Перезавантажуємо HomeBloc щоб курси відфільтрувались за новим треком
            context.read<HomeBloc>().add(const HomeStarted());
          } else if (state.status == ProfileStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading ||
              state.status == ProfileStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          final draft = state.draft;
          if (draft == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.errorRed, size: 48),
                  const SizedBox(height: AppDimensions.spacerMedium),
                  Text(
                    state.errorMessage ?? 'Не вдалося завантажити профіль',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppDimensions.spacerMedium),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ProfileBloc>()
                        .add(const ProfileLoaded()),
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            children: [
              _Avatar(url: draft.avatarUrl, name: draft.name),
              const SizedBox(height: AppDimensions.spacerMedium),
              Center(
                child: Text(
                  draft.email,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppDimensions.fontSizeMedium,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacerLarge),
              _SectionLabel(text: 'Особисті дані'),
              const SizedBox(height: AppDimensions.spacerSmall),
              _ProfileForm(state: state),
              const SizedBox(height: AppDimensions.spacerLarge),
              _SectionLabel(text: 'Статистика'),
              const SizedBox(height: AppDimensions.spacerSmall),
              ProfileStatsCard(stats: state.stats),
              const SizedBox(height: AppDimensions.spacerLarge),
              _SectionLabel(text: 'Динаміка за 30 днів'),
              const SizedBox(height: AppDimensions.spacerSmall),
              const QuizDynamicsChart(),
              const SizedBox(height: AppDimensions.spacerXLarge),
            ],
          );
        },
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: const Text('Вийти з облікового запису?'),
        content: const Text('Ваші локальні дані залишаться на пристрої.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<AuthBloc>().add(const AuthLogoutSubmitted());
              context.go(AppRoutes.login);
            },
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.name});
  final String? url;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).take(2).map((s) => s[0].toUpperCase()).join();

    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cardColor,
          border: Border.all(color: AppColors.primaryRed, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: (url != null && url!.startsWith('http'))
            ? CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) => _initialsAvatar(initials),
              )
            : _initialsAvatar(initials),
      ),
    );
  }

  Widget _initialsAvatar(String initials) => Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: AppDimensions.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      );
}

class _ProfileForm extends StatefulWidget {
  const _ProfileForm({required this.state});
  final ProfileState state;

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  late final TextEditingController _name;
  late final TextEditingController _avatar;

  @override
  void initState() {
    super.initState();
    final draft = widget.state.draft!;
    _name = TextEditingController(text: draft.name);
    _avatar = TextEditingController(text: draft.avatarUrl ?? '');
  }

  @override
  void didUpdateWidget(covariant _ProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Якщо після Save сервер повернув новий draft — синхронізуємо контролери
    final draft = widget.state.draft!;
    if (_name.text != draft.name) _name.text = draft.name;
    final avatar = draft.avatarUrl ?? '';
    if (_avatar.text != avatar) _avatar.text = avatar;
  }

  @override
  void dispose() {
    _name.dispose();
    _avatar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final draft = state.draft!;
    final isSaving = state.status == ProfileStatus.saving;
    final canSave = state.hasUnsavedChanges && !isSaving;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: "Ім'я *",
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: (v) =>
                context.read<ProfileBloc>().add(ProfileNameChanged(v)),
          ),
          const SizedBox(height: AppDimensions.spacerMedium),
          TextField(
            controller: _avatar,
            decoration: const InputDecoration(
              labelText: 'URL аватара (опційно)',
              prefixIcon: Icon(Icons.link),
              hintText: 'https://...',
            ),
            keyboardType: TextInputType.url,
            onChanged: (v) =>
                context.read<ProfileBloc>().add(ProfileAvatarUrlChanged(v)),
          ),
          const SizedBox(height: AppDimensions.spacerMedium),
          const Text(
            'Навчальний трек',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeMedium,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacerSmall),
          Row(
            children: [
              Expanded(
                child: _TrackButton(
                  label: 'Військовий',
                  icon: Icons.shield_outlined,
                  color: AppColors.primaryRed,
                  selected: draft.track == 'military',
                  onTap: () => context
                      .read<ProfileBloc>()
                      .add(const ProfileTrackChanged('military')),
                ),
              ),
              const SizedBox(width: AppDimensions.spacerSmall),
              Expanded(
                child: _TrackButton(
                  label: 'Цивільний',
                  icon: Icons.local_hospital_outlined,
                  color: AppColors.accentGreen,
                  selected: draft.track == 'civilian',
                  onTap: () => context
                      .read<ProfileBloc>()
                      .add(const ProfileTrackChanged('civilian')),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacerLarge),
          SizedBox(
            height: AppDimensions.buttonHeightLarge,
            child: ElevatedButton.icon(
              onPressed: canSave
                  ? () => context
                      .read<ProfileBloc>()
                      .add(const ProfileSaveRequested())
                  : null,
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(isSaving ? 'Зберігаємо...' : 'Зберегти зміни'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackButton extends StatelessWidget {
  const _TrackButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animationShort,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: selected ? color : AppColors.borderColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : AppColors.textSecondary, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: AppDimensions.fontSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
