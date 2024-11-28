import 'package:flutter/material.dart';

class CardPromociones extends StatelessWidget {
  final List<Map<String, dynamic>> promociones = [
    {
      "titulo": "Cuidadores y Limpieza",
      "descuento": "45% OFF",
      "imagenes": [
        'assets/images/cuidador_combo.png',
        'assets/images/limpieza_combo.png',
      ],
    },
    {
      "titulo": "Mantenimiento y Jardinería",
      "descuento": "30% OFF",
      "imagenes": [
        'assets/images/mantenimiento_combo.png',
        'assets/images/jardineria_combo.png',
      ],
    },
    {
      "titulo": "Paseadores de Perros",
      "descuento": "15% OFF",
      "imagenes": [
        'assets/images/paseador_combo.png',
      ],
    },
  ];

  CardPromociones({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título general "Promociones"
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            'Promociones',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
        // const SizedBox(height: 2.0),
        // Scroll horizontal de tarjetas
        SizedBox(
          height: 150.0, // Altura fija para las tarjetas
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: promociones.length,
            itemBuilder: (context, index) {
              final promo = promociones[index];
              return Container(
                width: 300.0, // Ancho de cada tarjeta
                margin: const EdgeInsets.only(left: 10.0),
                child: Card(
                  elevation: 8.0,
                  color: Colors.red,
                  shadowColor: Colors.black26,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Texto descriptivo
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo['titulo'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                promo['descuento'],
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        // Imágenes dinámicas
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              promo['imagenes'].length,
                              (imgIndex) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Image.asset(
                                  promo['imagenes'][imgIndex],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error,
                                          color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
