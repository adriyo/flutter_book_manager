class Result<T> {
  final T? data;
  final Exception? error;

  Result._({this.data, this.error});

  static Result<T> success<T>(T data) {
    return Result._(data: data);
  }

  static Result<T> failure<T>(Exception error) {
    return Result._(error: error);
  }

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}