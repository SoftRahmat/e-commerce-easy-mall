import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;


class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = "https://api.stripe.com/v1";
  static String paymentApiUrl = "${StripeService.apiBase}/payment_intents";
  static Uri paymentApiUri = Uri.parse(paymentApiUrl);
  static String secret =
      "sk_test_51JKeTeHpsHuwX7B7Q5oFwwkCn4eMfwDK3BFRyv0FE1QL3Nt3AN8GTpsVCf0tRIkMK3pI4OZNE2inxZ6tKcM2R99i002HgC1kg1";

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-type': 'application/x-www-form-urlencoded',
  };

  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
        'pk_test_51JKeTeHpsHuwX7B7ZdSCXWwqpw8yDhNwiqIGPEx9kNVF94hv0Lm5BVYjU0TyIxnPzsAJZlC5NkBoqYTLAfKagiIK00H4m3JSyb',
        merchantId: 'test',
        androidPayMode: 'test',
      ),
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount,
      String currency) async {
    try {
      Map<String, dynamic> body = {'amount': amount, 'currency': currency};
      var response =
      await http.post(paymentApiUri, headers: headers, body: body);
      return jsonDecode(response.body);
    } catch (error) {
      print('Error occurred in the payment intent $error');
    }
    return null;
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
      await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        ),
      );
      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (error) {
      return StripeService.getPlatformExceptionResult(error);
    }
    catch (error) {
      return StripeTransactionResponse(
          message: 'Transaction failed : $error', success: false);
    }
  }

  static getPlatformExceptionResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }
    return new StripeTransactionResponse(message: message, success: false);
  }
}