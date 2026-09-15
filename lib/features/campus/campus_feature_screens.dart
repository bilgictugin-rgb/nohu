import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_states.dart';
import '../../data/models/campus_models.dart';

class CafeteriaScreen extends ConsumerStatefulWidget {
  const CafeteriaScreen({super.key});

  @override
  ConsumerState<CafeteriaScreen> createState() => _CafeteriaScreenState();
}

class _CafeteriaScreenState extends ConsumerState<CafeteriaScreen> {
  var _selectedDay = 0;
  var _rating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yemekhane')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<DiningMenu>>(
          future: ref.read(mockRepositoryProvider).getDiningWeek(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final menus = snapshot.data ?? [];
            final menu = menus[_selectedDay.clamp(0, menus.length - 1)];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < menus.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            selected: _selectedDay == i,
                            label: Text(menus[i].day),
                            onSelected: (_) => setState(() => _selectedDay = i),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  color: AppColors.coral,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${menu.day} · ${menu.date}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final item in menu.items)
                        Text(item, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    children: [
                      _InfoTile(
                        icon: Icons.local_fire_department_outlined,
                        title: 'Kalori',
                        subtitle: '${menu.calories} kcal',
                      ),
                      _InfoTile(
                        icon: Icons.warning_amber_outlined,
                        title: 'Alerjen',
                        subtitle: menu.allergens.join(', '),
                      ),
                      _InfoTile(
                        icon: Icons.eco_outlined,
                        title: 'Vejetaryen etiketi',
                        subtitle: menu.vegetarian ? 'Uygun' : 'Uygun değil',
                      ),
                      _InfoTile(
                        icon: Icons.schedule_outlined,
                        title: 'Yemek saatleri',
                        subtitle: menu.hours,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Öğün değerlendirme: ${_rating.round()}/5'),
                      Slider(
                        value: _rating,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: '${_rating.round()}',
                        onChanged: (value) => setState(() => _rating = value),
                      ),
                      FilledButton.icon(
                        onPressed: () => _showSnack(
                          context,
                          'Yemekhane değerlendirmen kaydedildi.',
                        ),
                        icon: const Icon(Icons.star_outline),
                        label: const Text('Değerlendir'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _search = TextEditingController();
  LibraryBook? _selectedBook;
  var _room = 'Oda 1';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kütüphane')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<Object>>(
          future: Future.wait([
            ref.read(mockRepositoryProvider).getLibraryBooks(),
            ref.read(mockRepositoryProvider).getBorrowedBooks(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final books = snapshot.data![0] as List<LibraryBook>;
            final borrowed = snapshot.data![1] as List<BorrowedBook>;
            final query = _search.text.toLowerCase();
            final filtered = books
                .where(
                  (book) =>
                      query.isEmpty ||
                      book.title.toLowerCase().contains(query) ||
                      book.author.toLowerCase().contains(query),
                )
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    labelText: 'Kitap arama',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                if (_selectedBook != null) ...[
                  AppCard(
                    color: AppColors.green.withValues(alpha: 0.10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedBook!.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(_selectedBook!.author),
                        Text(_selectedBook!.location),
                        const SizedBox(height: 8),
                        Text(_selectedBook!.summary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  'Kitap detayları',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final book in filtered) ...[
                  AppCard(
                    onTap: () => setState(() => _selectedBook = book),
                    child: _InfoTile(
                      icon: AppIcons.book,
                      title: book.title,
                      subtitle:
                          '${book.author} · ${book.available ? 'Rafta' : 'Ödünçte'}',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 8),
                Text(
                  'Ödünç aldıklarım',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final item in borrowed) ...[
                  AppCard(
                    child: Column(
                      children: [
                        _InfoTile(
                          icon: Icons.assignment_return_outlined,
                          title: item.title,
                          subtitle:
                              'İade tarihi: ${item.dueDate} · ${item.remainingDays} gün kaldı',
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FilledButton.tonalIcon(
                            onPressed: () => _showSnack(
                              context,
                              '${item.title} için süre uzatma talebi alındı.',
                            ),
                            icon: const Icon(Icons.update_outlined),
                            label: const Text('Süre uzat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Çalışma odası rezervasyonu',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _room,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.meeting_room_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Oda 1',
                            child: Text('Oda 1'),
                          ),
                          DropdownMenuItem(
                            value: 'Oda 2',
                            child: Text('Oda 2'),
                          ),
                          DropdownMenuItem(
                            value: 'Oda 3',
                            child: Text('Oda 3'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _room = value ?? _room),
                      ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: () => _showSnack(
                          context,
                          '$_room için 14:00-16:00 rezervasyonu oluşturuldu.',
                        ),
                        icon: const Icon(Icons.event_seat_outlined),
                        label: const Text('Rezervasyon yap'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TransportScreen extends ConsumerStatefulWidget {
  const TransportScreen({super.key});

  @override
  ConsumerState<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends ConsumerState<TransportScreen> {
  String? _favoriteLineId;
  TransportLine? _selectedLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ulaşım')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<TransportLine>>(
          future: ref.read(mockRepositoryProvider).getTransportLines(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final lines = snapshot.data ?? [];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                for (final line in lines) ...[
                  AppCard(
                    onTap: () => setState(() => _selectedLine = line),
                    child: Column(
                      children: [
                        _InfoTile(
                          icon: AppIcons.transport,
                          title: line.name,
                          subtitle:
                              '${line.duration} · ${line.stops.length} durak',
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            children: [
                              FilledButton.tonalIcon(
                                onPressed: () =>
                                    setState(() => _selectedLine = line),
                                icon: const Icon(Icons.route_outlined),
                                label: const Text('Rota göster'),
                              ),
                              IconButton(
                                tooltip: 'Favori hat',
                                onPressed: () => setState(() {
                                  _favoriteLineId = _favoriteLineId == line.id
                                      ? null
                                      : line.id;
                                }),
                                icon: Icon(
                                  _favoriteLineId == line.id
                                      ? Icons.star
                                      : Icons.star_border,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (_selectedLine != null)
                  AppCard(
                    color: AppColors.green.withValues(alpha: 0.10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rota önizlemesi',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Duraklar: ${_selectedLine!.stops.join(' → ')}'),
                        Text(
                          'Sefer saatleri: ${_selectedLine!.times.join(', ')}',
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CareerScreen extends ConsumerStatefulWidget {
  const CareerScreen({super.key});

  @override
  ConsumerState<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends ConsumerState<CareerScreen> {
  final _search = TextEditingController();
  var _filter = 'Tümü';
  final _favorites = <String>{};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kariyer ve Staj')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<CareerJob>>(
          future: ref.read(mockRepositoryProvider).getCareerJobs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final query = _search.text.toLowerCase();
            final jobs = (snapshot.data ?? [])
                .where(
                  (job) =>
                      (_filter == 'Tümü' || job.type == _filter) &&
                      (query.isEmpty ||
                          job.title.toLowerCase().contains(query) ||
                          job.company.toLowerCase().contains(query)),
                )
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    labelText: 'İlan ara',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final filter in const ['Tümü', 'Staj', 'Yarı zamanlı'])
                      FilterChip(
                        selected: _filter == filter,
                        label: Text(filter),
                        onSelected: (_) => setState(() => _filter = filter),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final job in jobs) ...[
                  AppCard(
                    onTap: () => context.goNamed(
                      'jobDetail',
                      pathParameters: {'jobId': job.id},
                    ),
                    child: Row(
                      children: [
                        const AppIconBadge(
                          icon: AppIcons.career,
                          color: AppColors.coral,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text('${job.company} · ${job.type}'),
                              Text('${job.location} · Son: ${job.deadline}'),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Favori',
                          onPressed: () => setState(() {
                            _favorites.contains(job.id)
                                ? _favorites.remove(job.id)
                                : _favorites.add(job.id);
                          }),
                          icon: Icon(
                            _favorites.contains(job.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Başvurularım',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 8),
                      Text('Mobil Uygulama Stajyeri · Ön değerlendirmede'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CareerJobDetailScreen extends ConsumerStatefulWidget {
  const CareerJobDetailScreen({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<CareerJobDetailScreen> createState() =>
      _CareerJobDetailScreenState();
}

class _CareerJobDetailScreenState extends ConsumerState<CareerJobDetailScreen> {
  final _note = TextEditingController();
  var _applied = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final job = ref.read(mockRepositoryProvider).getCareerJobById(widget.jobId);
    if (job == null) {
      return const _NotFoundScreen(
        title: 'İlan bulunamadı',
        icon: AppIcons.career,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('İlan Detayı')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('${job.company} · ${job.location}'),
                  Text('Son başvuru: ${job.deadline}'),
                  const SizedBox(height: 12),
                  Text(job.description),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Başvuru notu',
                prefixIcon: Icon(Icons.edit_note_outlined),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => setState(() => _applied = true),
              icon: const Icon(Icons.send_outlined),
              label: const Text('Başvur'),
            ),
            if (_applied) ...[
              const SizedBox(height: 12),
              const AppCard(child: Text('Başvurun kaydedildi.')),
            ],
          ],
        ),
      ),
    );
  }
}

class LostFoundScreen extends ConsumerStatefulWidget {
  const LostFoundScreen({super.key});

  @override
  ConsumerState<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends ConsumerState<LostFoundScreen> {
  final _search = TextEditingController();
  var _type = 'Tümü';
  var _showForm = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıp Eşya')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _showForm = !_showForm),
        icon: const Icon(Icons.add),
        label: const Text('Yeni ilan'),
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<LostFoundItem>>(
          future: ref.read(mockRepositoryProvider).getLostFoundItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final query = _search.text.toLowerCase();
            final items = (snapshot.data ?? [])
                .where(
                  (item) =>
                      (_type == 'Tümü' || item.type == _type) &&
                      (query.isEmpty ||
                          item.title.toLowerCase().contains(query) ||
                          item.location.toLowerCase().contains(query)),
                )
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    labelText: 'Eşya ara',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final type in const ['Tümü', 'Kayıp', 'Bulunan'])
                      FilterChip(
                        selected: _type == type,
                        label: Text(type),
                        onSelected: (_) => setState(() => _type = type),
                      ),
                  ],
                ),
                if (_showForm) ...[
                  const SizedBox(height: 12),
                  const _LostFoundForm(),
                ],
                const SizedBox(height: 12),
                for (final item in items) ...[
                  AppCard(
                    onTap: () => context.goNamed(
                      'lostFoundDetail',
                      pathParameters: {'itemId': item.id},
                    ),
                    child: _InfoTile(
                      icon: AppIcons.lostFound,
                      title: '${item.type}: ${item.title}',
                      subtitle: '${item.location} · ${item.date}',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class LostFoundDetailScreen extends ConsumerWidget {
  const LostFoundDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.read(mockRepositoryProvider).getLostFoundItemById(itemId);
    if (item == null) {
      return const _NotFoundScreen(
        title: 'İlan bulunamadı',
        icon: AppIcons.lostFound,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('İlan Detayı')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('${item.type} · ${item.location} · ${item.date}'),
                  const SizedBox(height: 12),
                  Text(item.description),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _showSnack(
                      context,
                      'Eşya ilanı için iletişim talebin iletildi.',
                    ),
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('İletişime geç'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  final _search = TextEditingController();
  var _category = 'Tümü';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Etkinlikler')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<CampusEvent>>(
          future: ref.read(mockRepositoryProvider).getEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final query = _search.text.toLowerCase();
            final events = (snapshot.data ?? [])
                .where(
                  (event) =>
                      (_category == 'Tümü' || event.category == _category) &&
                      (query.isEmpty ||
                          event.title.toLowerCase().contains(query) ||
                          event.location.toLowerCase().contains(query)),
                )
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    labelText: 'Etkinlik ara',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                _CategoryChips(
                  categories: const ['Tümü', 'Teknoloji', 'Kariyer', 'Kültür'],
                  selected: _category,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 12),
                for (final event in events) ...[
                  _EventCard(event: event),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  var _joined = false;
  var _favorite = false;

  @override
  Widget build(BuildContext context) {
    final event = ref.read(mockRepositoryProvider).getEventById(widget.eventId);
    if (event == null) {
      return const _NotFoundScreen(
        title: 'Etkinlik bulunamadı',
        icon: AppIcons.events,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Etkinlik Detayı')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              color: AppColors.lavender,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${event.date} · ${event.time} · ${event.location}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => setState(() => _joined = !_joined),
                  icon: Icon(_joined ? Icons.check : Icons.how_to_reg_outlined),
                  label: Text(_joined ? 'Katılacağım' : 'Katılım talebi'),
                ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _favorite = !_favorite),
                  icon: Icon(
                    _favorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(_favorite ? 'Favoride' : 'Favori'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _showSnack(
                    context,
                    '${event.title} için takvim kaydı oluşturuldu.',
                  ),
                  icon: const Icon(Icons.event_available_outlined),
                  label: const Text('Takvime ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommunitiesScreen extends ConsumerStatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  ConsumerState<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends ConsumerState<CommunitiesScreen> {
  final _search = TextEditingController();
  var _category = 'Tümü';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topluluklar')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<Community>>(
          future: ref.read(mockRepositoryProvider).getCommunities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final query = _search.text.toLowerCase();
            final communities = (snapshot.data ?? [])
                .where(
                  (community) =>
                      (_category == 'Tümü' ||
                          community.category == _category) &&
                      (query.isEmpty ||
                          community.name.toLowerCase().contains(query) ||
                          community.description.toLowerCase().contains(query)),
                )
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    labelText: 'Topluluk ara',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                _CategoryChips(
                  categories: const ['Tümü', 'Teknoloji', 'Kariyer', 'Kültür'],
                  selected: _category,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 12),
                for (final community in communities) ...[
                  AppCard(
                    onTap: () => context.goNamed(
                      'communityDetail',
                      pathParameters: {'communityId': community.id},
                    ),
                    child: _InfoTile(
                      icon: AppIcons.communities,
                      title: community.name,
                      subtitle:
                          '${community.category} · ${community.members} üye',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class CommunityDetailScreen extends ConsumerStatefulWidget {
  const CommunityDetailScreen({super.key, required this.communityId});

  final String communityId;

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends ConsumerState<CommunityDetailScreen> {
  var _following = false;

  @override
  Widget build(BuildContext context) {
    final community = ref
        .read(mockRepositoryProvider)
        .getCommunityById(widget.communityId);
    if (community == null) {
      return const _NotFoundScreen(
        title: 'Topluluk bulunamadı',
        icon: AppIcons.communities,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Topluluk Detayı')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('${community.category} · ${community.members} üye'),
                  const SizedBox(height: 12),
                  Text(community.description),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => setState(() => _following = !_following),
                  icon: Icon(
                    _following
                        ? Icons.notifications_active
                        : Icons.notifications_none_outlined,
                  ),
                  label: Text(_following ? 'Takip ediliyor' : 'Takip et'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showSnack(
                    context,
                    '${community.name} için katılım talebin iletildi.',
                  ),
                  icon: const Icon(Icons.how_to_reg_outlined),
                  label: const Text('Katılım talebi'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _EventCard(event: community.nextEvent),
          ],
        ),
      ),
    );
  }
}

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  var _building = 'Mühendislik Fakültesi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kampüs Haritası')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              color: AppColors.green.withValues(alpha: 0.12),
              child: SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.mist,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      top: 28,
                      child: _MapPin(label: 'Rektörlük'),
                    ),
                    const Positioned(
                      right: 28,
                      top: 56,
                      child: _MapPin(label: 'Kütüphane'),
                    ),
                    const Positioned(
                      left: 84,
                      bottom: 38,
                      child: _MapPin(label: 'Mühendislik'),
                    ),
                    const Positioned(
                      right: 36,
                      bottom: 28,
                      child: _MapPin(label: 'Yemekhane'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final building in const [
                  'Mühendislik Fakültesi',
                  'Merkez Kütüphane',
                  'Kongre Merkezi',
                  'Merkez Yemekhane',
                ])
                  ChoiceChip(
                    selected: _building == building,
                    label: Text(building),
                    onSelected: (_) => setState(() => _building = building),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            AppCard(
              child: _InfoTile(
                icon: AppIcons.map,
                title: _building,
                subtitle: 'Yürüme: 6 dk · En yakın durak: Kampüs ring hattı',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const announcements = [
      ('Bahar Şenliği kayıtları başladı', '15-17 Mayıs tarihleri arasında'),
      ('Kütüphane çalışma saatleri uzatıldı', 'Final haftasına özel duyuru'),
      (
        'Yemekhane turnike düzeni yenilendi',
        'Öğle yoğunluğu için ek geçiş açıldı',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Duyurular')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            for (final item in announcements) ...[
              AppCard(
                child: _InfoTile(
                  icon: AppIcons.notification,
                  title: item.$1,
                  subtitle: item.$2,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _LostFoundForm extends StatelessWidget {
  const _LostFoundForm();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'İlan başlığı',
              prefixIcon: Icon(Icons.title_outlined),
            ),
          ),
          const SizedBox(height: 10),
          const TextField(
            minLines: 2,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Açıklama',
              prefixIcon: Icon(Icons.edit_note_outlined),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () =>
                _showSnack(context, 'Fotoğraf seçme alanı açıldı.'),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Fotoğraf ekle'),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () =>
                _showSnack(context, 'Yeni ilan taslağı kaydedildi.'),
            icon: const Icon(Icons.save_outlined),
            label: const Text('İlanı kaydet'),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () =>
          context.goNamed('eventDetail', pathParameters: {'eventId': event.id}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoTile(
            icon: AppIcons.events,
            title: event.title,
            subtitle: '${event.date} · ${event.time} · ${event.location}',
          ),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () =>
                    _showSnack(context, '${event.title} favorilere eklendi.'),
                icon: const Icon(Icons.favorite_border),
                label: const Text('Favori'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => _showSnack(
                  context,
                  '${event.title} katılacağım listene eklendi.',
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Katılacağım'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in categories)
          FilterChip(
            selected: selected == category,
            label: Text(category),
            onSelected: (_) => onChanged(category),
          ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Object icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(icon: icon, color: AppColors.green, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppIcon(
          AppIcons.map,
          color: Theme.of(context).colorScheme.onSurface,
          size: 32,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.title, required this.icon});

  final String title;
  final Object icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: EmptyState(
          icon: icon,
          title: title,
          message: 'Seçilen kayıt bulunamadı.',
        ),
      ),
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
