import 'package:dart_frog/dart_frog.dart';
// import 'package:crypto_alert_backend/core/exceptions/conflict_exception.dart';
import 'package:crypto_alert_backend/core/exceptions/not_found_exception.dart';
import 'package:crypto_alert_backend/core/exceptions/validation_exception.dart';

Handler middleware(Handler handler){
  return (context) async{
    try{
      return await handler(context);
    } on ValidationException catch (e){
      return Response.json(
        statusCode: 400,
        body: {
          'error': e.message,
        },
      );
    } on NotFoundException catch (e){
      return Response.json(
        statusCode: 404,
        body: {
          'error': e.message,
        },
      );
    }catch (e, stackTrace) {
      print(e);
      print(stackTrace);

      return Response.json(
        statusCode: 500,
        body: {
          'error': e.toString(),
        },
      );
    // } catch (e){
    //   return Response.json(
    //     statusCode: 500,
    //     body: {
    //       'error': 'Internal server error',
    //     },
    //   );
    }
  };
}