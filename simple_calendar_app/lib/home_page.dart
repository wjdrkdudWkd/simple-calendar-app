import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_calendar_app/category/category_drop_down.dart';
import 'package:simple_calendar_app/common/botton_navigator.dart';
import 'package:simple_calendar_app/common/common_app_bar.dart';
import 'app_database.dart';
import 'screens/category_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDate = DateTime.now();
  late DateTime _selectedDate;
  final List<Map<String, dynamic>> _events = [];
  int _currentPage = 0;
  final int _pageSize = 5;
  bool _isLoading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDate;
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadEvents(loadMore: true);
    }
  }

  Future<void> _loadEvents({bool loadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    if (!loadMore) {
      _currentPage = 0;
      _events.clear();
    }

    final db = AppDatabase.instance;
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final newEvents = await db.getEventsByDate(
      dateString,
      _pageSize,
      _currentPage * _pageSize,
    );

    setState(() {
      _events.addAll(newEvents);
      _currentPage++;
      _isLoading = false;
    });
  }

  Future<void> _addEvent() async {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final locationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('이벤트 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '제목'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: '시간'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: '위치'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                final db = AppDatabase.instance;
                final dateString =
                    DateFormat('yyyy-MM-dd').format(_selectedDate);
                await db.insertEvent({
                  'date': dateString,
                  'title': titleController.text,
                  'time': timeController.text,
                  'location': locationController.text,
                  'duration': timeController.text,
                });
                Navigator.pop(context);
                _loadEvents();
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('MMMM d, yyyy').format(_selectedDate);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Today', style: theme.textTheme.titleLarge),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.settings),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),

      // AppBar(
      //   title: Text(
      //     DateFormat('yyyy년 MM월').format(_focusedDate),
      //     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.arrow_back),
      //       onPressed: () => _changeMonth(-1),
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.arrow_forward),
      //       onPressed: () => _changeMonth(1),
      //     ),
      //   ],
      // ),
      // appBar: CommonAppBar(
      //   title: DropdownButton<String>(
      //     value: 'Categories',
      //     items: <String>['Categories', 'Favorites', 'All']
      //         .map<DropdownMenuItem<String>>((String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value),
      //       );
      //     }).toList(),
      //     onChanged: (String? newValue) {},
      //   ),
      //   actions: const [
      //     Icon(Icons.notifications),
      //     Icon(Icons.settings),
      //   ],
      // ),
      appBar: const CommonAppBar(
        title: CategoryDropdown(),
        actions: [
          Icon(Icons.notifications),
          Icon(Icons.settings),
        ],
      ),
      // body: Column(
      //   children: [
      //     _buildCalendar(),
      //     Expanded(child: _buildEventList()),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search schedules...',
                hintStyle: theme.textTheme.bodyMedium,
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            _buildCategoryChips(),
            const SizedBox(height: 10),
            _buildCalendar(),
            const SizedBox(height: 10),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   onTap: (index) {
      //     if (index == 1) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const CategoryScreen()),
      //       );
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today),
      //       label: 'Today',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.schedule),
      //       label: 'Schedule',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.task),
      //       label: 'Tasks',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   selectedItemColor: Colors.pink,
      //   unselectedItemColor: Colors.grey,
      // ),
      bottomNavigationBar: const BottomNavigator(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['All', 'Work', 'Personal', 'Family'];
    return Wrap(
      spacing: 8.0,
      children: categories.map((category) {
        return Chip(
          label: Text(category),
          backgroundColor: Colors.pink,
          labelStyle: const TextStyle(color: Colors.white),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar() {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    final daysInMonth = List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(_selectedDate.year, _selectedDate.month, index + 1),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days
              .map((day) => Text(day,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)))
              .toList(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            final day = daysInMonth[index];
            final isSelected = day.day == _selectedDate.day;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = day;
                  _loadEvents();
                });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.pink : Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return Card(
          color: Colors.grey[850],
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              event['time'],
              style: const TextStyle(
                  color: Colors.pink, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['title'],
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 4),
                Text(event['location'],
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            trailing: Text(event['duration'],
                style: const TextStyle(color: Colors.grey)),
          ),
        );
      },
    );
  }
}
