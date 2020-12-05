String getFileNameFrom(String path) {
  return path.substring(path.lastIndexOf('\\') + 1);
}
