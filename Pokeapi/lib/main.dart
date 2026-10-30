// Jhian Mae Calumba

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon Card Studio',
      theme: ThemeData(
        scaffoldBackgroundColor:
            const Color(0xFF0A0F1D), // Deep dark navy background
      ),
      home: const PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  Pokemon? _pokemon;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Default load Zekrom as requested
    fetchPokemonData('zekrom');
  }

  Future<void> fetchPokemonData(String name) async {
    final queryName = name.trim().toLowerCase();
    if (queryName.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$queryName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _pokemon = Pokemon.fromJson(jsonData);
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Pokémon "$queryName" does not exist.';
          _isLoading = false;
          _pokemon = null;
        });
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
          _pokemon = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: Could not reach the service.';
        _isLoading = false;
        _pokemon = null;
      });
    }
  }

  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F1D),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bolt, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text(
              'POKÉMON CARD STUDIO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'YOUR POKÉMON COLLECTION',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Trading Card',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search Pokémon (e.g. zekrom, pikachu)',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF131C31),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (value) {
                      if (!_isLoading) fetchPokemonData(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => fetchPokemonData(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6), // Electric Blue
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Search',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Content Display Area
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(50.0),
                child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  _errorMessage!,
                  style:
                      const TextStyle(color: Color(0xFFEF4444), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            else if (_pokemon != null)
              buildTradingCard(_pokemon!),
          ],
        ),
      ),
    );
  }

  Widget buildTradingCard(Pokemon pokemon) {
    final formattedId = pokemon.id.toString().padLeft(3, '0');

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFF111827), // Slate dark card background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFF3B82F6),
              width: 3), // Electric blue border frame
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header (Basic Tag & Name & Pokedex Number)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB), // Blue badge
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BASIC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  capitalize(pokemon.name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '#$formattedId',
                      style: const TextStyle(
                        color: Color(0xFF38BDF8), // Cyan highlight
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'POKÉDEX',
                      style: TextStyle(color: Colors.white54, fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Artwork Screen Window
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1322),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: pokemon.spriteUrl.isNotEmpty
                        ? Image.network(
                            pokemon.spriteUrl,
                            height: 180,
                            width: 180,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 80, color: Colors.white54),
                          )
                        : const Icon(Icons.image_not_supported,
                            size: 80, color: Colors.white54),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      'SPECIMEN  #$formattedId',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (pokemon.types.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          capitalize(pokemon.types.first),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sub-info Bar (No., Height, Weight)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('No. $formattedId',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Text('HT: ${pokemon.height / 10} m',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Text('WT: ${pokemon.weight / 10} kg',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Base Experience
            Text(
              'Base experience: ${pokemon.baseExperience}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF38BDF8),
              ),
            ),
            const SizedBox(height: 16),

            // Abilities Section Header
            const Text(
              'ABILITIES',
              style: TextStyle(
                color: Color(0xFF38BDF8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),

            // Abilities List
            pokemon.abilities.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pokemon.abilities.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D4ED8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ABILITY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalize(pokemon.abilities[index]),
                                    style: const TextStyle(
                                      color: Color(0xFF38BDF8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Ability slot ${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Text('None',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 16),

            // Held Items Section Header
            const Text(
              'HELD ITEMS',
              style: TextStyle(
                color: Color(0xFF38BDF8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pokemon.heldItems.isNotEmpty
                  ? pokemon.heldItems.map(capitalize).join('   ')
                  : 'None',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),

            // Moves Section Header
            const Text(
              'MOVES',
              style: TextStyle(
                color: Color(0xFF38BDF8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pokemon.moves.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF60A5FA),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(
                          capitalize(pokemon.moves[index]),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
