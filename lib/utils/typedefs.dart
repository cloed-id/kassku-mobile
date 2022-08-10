import 'package:kassku_mobile/models/base_response.dart';

/// Simplify of Map<String, dynamic>
typedef MapString = Map<String, dynamic>;

typedef MapStringValue = Map<String, String>;

/// Simplify of BaseResponse<T> with T is Map<String, dynamic>
typedef BaseResponseMap = BaseResponse<MapString>;

/// Simplify of ResponseOfRequest<T> with T is Map<String, dynamic>
typedef ResponseOfRequestMap = ResponseOfRequest<MapString>;
