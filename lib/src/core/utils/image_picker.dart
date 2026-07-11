import 'package:fpdart/fpdart.dart';
import 'package:palpa_marketplace/src/core/utils/error_model.dart';
import 'package:image_picker/image_picker.dart';

Future<Either<ErrorModel, XFile>> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return Right(image);
    } else {
      return Left(ErrorModel(error: 'Something went wrong', statusCode: 0));
    }
  } catch (e) {
    return Left(ErrorModel(error: e.toString(), statusCode: 0));
  }
}
