class API_ABSENSI{
  static statusAbsen(){
    String url ='http://bdg2.jasamedika.com:3322/api/presensi/combo/status-absen';
    return url;
  }
  static dataAdmin(tgl_awal,tgl_akhir){
    String url ='http://bdg2.jasamedika.com:3322/api/presensi/daftar/admin?tglAwal=${tgl_awal}&tglAkhir=${tgl_akhir}';
    return url;
  }
  static dataPegawai(tgl_awal,tgl_akhir){
    String url ='http://bdg2.jasamedika.com:3322/api/presensi/daftar/pegawai?tglAwal=${tgl_awal}&tglAkhir=${tgl_akhir}';
    return url;
  }
  static checkIN(){
    String url = 'http://bdg2.jasamedika.com:3322/api/presensi/in';
    return url;
  }
  static checkOUT(){
    String url = 'http://bdg2.jasamedika.com:3322/api/presensi/out';
    return url;
  }
  static absen(){
    String url = 'http://bdg2.jasamedika.com:3322/api/presensi/absensi';
    return url;
  }
}