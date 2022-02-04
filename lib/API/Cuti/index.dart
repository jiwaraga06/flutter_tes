class API_CUTI {
  static departemenHR() {
    String url = 'http://bdg2.jasamedika.com:3322/api/cuti/combo/departemen-hrd';
    return url;
  }

  static statusPersetujuan() {
    String url = 'http://bdg2.jasamedika.com:3322/api/cuti/combo/status-persetujuan';
    return url;
  }

  static getDataPersetujuan(tgl_awal, tgl_akhir) {
    String url = 'http://bdg2.jasamedika.com:3322/api/cuti/daftar/persetujuan?tglAwal=${tgl_awal}&tglAkhir=${tgl_akhir}';
    return url;
  }

  static getDataPengajuan(tgl_awal, tgl_akhir) {
    String url = 'http://bdg2.jasamedika.com:3322/api/cuti/daftar/pengajuan?tglAwal=${tgl_awal}&tglAkhir=${tgl_akhir}';
    return url;
  }
  static mengajukanCuti(){
    String url = 'http://bdg2.jasamedika.com:3322/api/cuti/mengajukan';
    return url;
  }
  static menyetujuiCuti(){
    String url = 'http://bdg2.jasamedika.com:3322/api/cuti/menyetujui';
    return url;
  }
}
