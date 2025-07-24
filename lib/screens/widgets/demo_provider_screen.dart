// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_app_with_rest_api/providers/demo_provider.dart';

// class DemoProviderScreen extends StatelessWidget {
//   const DemoProviderScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final demoProvider = context.watch<DemoProvider>();
//     // final counter = context.select(
//     //   (DemoProvider demoProvider) => demoProvider.counter,
//     // );
//     // final age = context.select((DemoProvider demoProvider) => demoProvider.age);
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CounterWithWatch(),
//           SizedBox(height: 20),
//           CounterWithRead(),
//           SizedBox(height: 20),
//           CounterWithSelect(),
//           SizedBox(height: 20),
//           Center(
//             child: TextButton(
//               onPressed: () {
//                 context.read<DemoProvider>().increment();
//               },
//               child: Icon(Icons.add),
//             ),
//           ),
//           // SizedBox(height: 20),
//           // Center(
//           //   child: TextButton(
//           //     onPressed: () {
//           //       context.read<DemoProvider>().increateAge();
//           //     },
//           //     child: Icon(Icons.add),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class CounterWithWatch extends StatelessWidget {
//   const CounterWithWatch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final demoProvider = context.watch<DemoProvider>();
//     return Center(child: Text("counter ${demoProvider.counter}"));
//   }
// }

// class CounterWithRead extends StatelessWidget {
//   const CounterWithRead({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final demoProvider = context.read<DemoProvider>();

//     return Center(child: Text("counter ${demoProvider.counter}"));
//   }
// }

// class CounterWithSelect extends StatelessWidget {
//   const CounterWithSelect({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final age = context.select(
//     //   (DemoProvider demoProvider) => demoProvider.counter,
//     // );
//     // final demoProvider = context.watch<DemoProvider>();
//     // return Center(child: Text("counter ${demoProvider.age}"));
//     // return Center(child: Text("counter $age"));

//     // return Consumer(
//     //   builder: (builder, DemoProvider demoProvider, child) {
//     //     return Center(child: Text("counter ${demoProvider.age}"));
//     //   },
//     // );

//     return Selector<DemoProvider, int>( // 0 -> 1
//       selector: (_, demoProvider) => demoProvider.counter,
//       builder: (_, data, __) {
//         return Text('$data');
//       },
//     );
//   }
// }
