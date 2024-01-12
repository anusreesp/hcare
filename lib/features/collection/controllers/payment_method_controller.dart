import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentMethodSelectProvider = StateProvider<PaymentType?>((ref) => null);

enum PaymentType { cash, razorpay, card }
