import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final providerOfFutureFacts = FutureProvider((ref) async {
  final foundFacts = await http.get(Uri.parse('https://catfact.ninja/facts'));

  return foundFacts;
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureCatFacts = ref.watch(providerOfFutureFacts);

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: futureCatFacts.when(
              data: (data) {
                final decodedData = json.decode(data.body);
                List catFactDetails = decodedData['data'];

                return ListView(
                  children: [
                    ...catFactDetails.map(
                      (singleCatFactDetails) {
                        return Container(
                          margin: const EdgeInsets.all(12.0),
                          child: Text(singleCatFactDetails['fact']),
                        );
                      },
                    )
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('some error here'),
            ),
          ),
        ),
      ),
    );
  }
}
