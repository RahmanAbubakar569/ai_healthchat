import 'package:flutter/material.dart';
import 'gemini_service.dart';

void main() {
  runApp(const HealthApp());
}


class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Health Assistant',
      debugShowCheckedModeBanner: false, 


      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), 
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF4F46E5),
          tertiary: const Color(0xFF7C3AED),
          surface: Colors.white,
          background: const Color(0xFFF9FAFB), 
          onPrimary: Colors.white,
        ),
        useMaterial3: true, 
        fontFamily: 'Roboto',
        
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), 
            ),
            elevation: 0, 
          ),
        ),
        
        
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: Colors.white,
        ),
      ),
      home: const SymptomChecker(),
    );
  }
}

// Main health assistant screen
class SymptomChecker extends StatefulWidget {
  const SymptomChecker({super.key});

  @override
  State<SymptomChecker> createState() => _SymptomCheckerState();
}

class _SymptomCheckerState extends State<SymptomChecker> {
  final GeminiService aiService = GeminiService();
  final TextEditingController symptomInputController = TextEditingController();
  String aiResponseText = "";
  bool isWaitingForResponse = false;

  @override
  void dispose() {
    
    symptomInputController.dispose();
    super.dispose();
  }


  void checkSymptoms() async {
    
    if (symptomInputController.text.isEmpty) 
      return;

   
    setState(() {
      isWaitingForResponse = true;
      aiResponseText = "";
    });

    
    String analysisResult = await aiService.getAIResponse(
        "Analyze these symptoms: ${symptomInputController.text}. What might be the cause?");
    
   
    setState(() {
      aiResponseText = analysisResult;
      isWaitingForResponse = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            
            SliverAppBar(
              expandedHeight: 150,
              pinned: true,
              backgroundColor: const Color(0xFF6366F1),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Health Assistant',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6366F1), 
                        Color(0xFF7C3AED), 
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Main content area
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Privacy message
                    const Text(
                      'Your privacy matters',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Conversations are not saved for your privacy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              children: [
                                const Icon(
                                  Icons.health_and_safety_rounded,
                                  color: Color(0xFF6366F1),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Tell me about your symptoms',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            
                            TextField(
                              controller: symptomInputController,
                              onChanged: (value) {
                                setState(() {});  
                              },
                              maxLines: 5,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF374151),
                              ),
                              decoration: InputDecoration(
                                hintText: 'For example: headache, fever, sore throat...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16,
                                ),
                                fillColor: const Color(0xFFF9FAFB),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Analyze button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: symptomInputController.text.isEmpty || isWaitingForResponse
                                    ? null  
                                    : checkSymptoms,
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  disabledForegroundColor: Colors.grey.shade500,
                                ),
                                child: isWaitingForResponse
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Analyze Symptoms',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // AI response box
                    if (aiResponseText.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Respinse
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.smart_toy_outlined,
                                      color: Color(0xFF6366F1),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'AI Assessment',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // content for the response
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE0E7FF),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // response from gemini
                                    Text(
                                      aiResponseText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF374151),
                                        height: 1.6,  
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Disclaimer
                                    const Text(
                                      'Disclaimer: This is not a medical diagnosis. Please consult a healthcare professional.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
