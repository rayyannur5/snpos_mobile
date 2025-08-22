import 'dart:io';

class DeletePhoto {
  static Future<void> deletePhoto(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      try {
        await file.delete();
        print('File berhasil dihapus.');
      } catch (e) {
        print('Gagal menghapus file: $e');
      }
    } else {
      print('File tidak ditemukan.');
    }
  }
}