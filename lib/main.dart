import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do & Counter Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    CounterPage(),
    TodoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State & Persistence Demo'),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.exposure_plus_1), label: 'Counter'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'To-Do'),
        ],
      ),
    );
  }
}

/// Simple counter page that persists the counter value using SharedPreferences.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  static const String _prefKey = 'counter_value';
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt(_prefKey) ?? 0;
    });
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, _counter);
  }

  void _increment() {
    setState(() {
      _counter++;
    });
    _saveCounter();
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) _counter--;
    });
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Use the buttons to change the counter value.'),
          const SizedBox(height: 12),
          Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _decrement,
                icon: const Icon(Icons.remove),
                label: const Text('Decrease'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _increment,
                icon: const Icon(Icons.add),
                label: const Text('Increase'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple to-do list page that persists tasks using SharedPreferences (as a list of strings).
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  static const String _prefKey = 'todo_tasks';
  final TextEditingController _controller = TextEditingController();
  final List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefKey) ?? <String>[];
    setState(() {
      _tasks.clear();
      _tasks.addAll(list);
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, _tasks);
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.insert(0, text);
      _controller.clear();
    });
    _saveTasks();
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Add a task',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addTask,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _tasks.isEmpty
              ? const Center(child: Text('No tasks yet — add one!'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Dismissible(
                      key: ValueKey(task + index.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _removeTask(index),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(task),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeTask(index),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
