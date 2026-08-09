import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

List<Todo> todoList = [];

class Todo {
  final String content;
  final String? description;
  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  bool isDone;

  Todo({
    required this.content,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.isDone = false,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(useMaterial3: true),
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
  @override
  Widget build(BuildContext context) {
    final grouped = groupTodosByCategory(todoList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemoRecordScreen(),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body:
          grouped.values.every((list) => list.isEmpty)
              ? const Center(child: Text('할 일이 없습니다'))
              : ListView(
                children:
                    grouped.entries.map((entry) {
                      final title = entry.key;
                      final todos = entry.value;
                      if (todos.isEmpty) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          ...todos.map(
                            (todo) => ListTile(
                              leading: Checkbox(
                                value: todo.isDone,
                                onChanged: (value) {
                                  setState(() {
                                    todo.isDone = value ?? false;
                                  });
                                },
                              ),
                              title: Text(
                                todo.content,
                                style: TextStyle(
                                  decoration:
                                      todo.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                ),
                              ),
                              subtitle: Text(
                                "${formatDate(todo.date)} / ${formatTime(todo.startTime)} ~ ${formatTime(todo.endTime)}",
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
    );
  }
}

class MemoRecordScreen extends StatefulWidget {
  const MemoRecordScreen({super.key});

  @override
  State<MemoRecordScreen> createState() => _MemoRecordScreenState();
}

class _MemoRecordScreenState extends State<MemoRecordScreen> {
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _explainController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveTodo() {
    final content = _memoController.text.trim();
    final desc = _explainController.text.trim();

    if (content.isEmpty) {
      _showDialog('입력 오류', '할 일을 입력해주세요.');
      return;
    }

    todoList.add(
      Todo(
        content: content,
        description: desc.isEmpty ? null : desc,
        date: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
      ),
    );

    Navigator.pop(context);
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('확인'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 할일이 무엇인가요?'),
        actions: [TextButton(onPressed: _saveTodo, child: const Text('완료'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _memoController,
                  decoration: const InputDecoration(
                    hintText: '할 일을 입력하세요',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('날짜', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 40),
                Text(
                  formatDate(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('선택'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('시간', style: TextStyle(fontSize: 18)),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickTime(isStart: true),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('시작 시간'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickTime(isStart: false),
                    icon: const Icon(Icons.stop),
                    label: const Text('종료 시간'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('시작: ${formatTime(_startTime)}'),
                const SizedBox(width: 24),
                Text('종료: ${formatTime(_endTime)}'),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('메모', style: TextStyle(fontSize: 18)),
            ),
            TextField(controller: _explainController),
          ],
        ),
      ),
    );
  }
}

Map<String, List<Todo>> groupTodosByCategory(List<Todo> todos) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final endOfWeek = today.add(Duration(days: 7 - now.weekday));
  final endOfMonth = DateTime(today.year, today.month + 1, 0);

  final Map<String, List<Todo>> grouped = {
    "오늘 할 일": [],
    "일주일 내 할 일": [],
    "이번 달 할 일": [],
    "지금 할 일": [],
  };

  for (var todo in todos) {
    if (todo.date == null) continue;
    final todoDate = DateTime(
      todo.date!.year,
      todo.date!.month,
      todo.date!.day,
    );
    final isNow =
        todoDate == today &&
        todo.startTime != null &&
        (todo.startTime!.hour > now.hour ||
            (todo.startTime!.hour == now.hour &&
                todo.startTime!.minute > now.minute));
    if (isNow) {
      grouped["지금 할 일"]!.add(todo);
    } else if (todoDate == today) {
      grouped["오늘 할 일"]!.add(todo);
    } else if (todoDate.isAfter(today) && todoDate.isBefore(endOfWeek)) {
      grouped["일주일 내 할 일"]!.add(todo);
    } else if (todoDate.isBefore(endOfMonth)) {
      grouped["이번 달 할 일"]!.add(todo);
    }
  }

  return grouped;
}

String formatDate(DateTime? date) {
  if (date == null) return '날짜 없음';
  return '${date.year}.${date.month}.${date.day}';
}

String formatTime(TimeOfDay? time) {
  if (time == null) return '--:--';
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
