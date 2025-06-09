func toRef*[T](value: T): ref T =
  result = new T
  result[] = value