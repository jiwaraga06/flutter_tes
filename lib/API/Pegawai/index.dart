class API_PEGAWAI{
  static getDaftar(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/daftar';
    return url;
  }
  static getJabatan(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/combo/jabatan';
    return url;
  }
  static getDepartemen(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/combo/departemen';
    return url;
  }
  static getUnitkerja(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/combo/unit-kerja';
    return url;
  }
  static getPendidikan(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/combo/pendidikan';
    return url;
  }
  static getJeniskelamin(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/combo/jenis-kelamin';
    return url;
  }
  static getDepartemnHrd(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/combo/departemen-hrd';
    return url;
  }
  static tambahPegawai(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/admin-tambah-pegawai';
    return url;
  }
  static ubahPegawai(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/admin-ubah-pegawai';
    return url;
  }
  static adminUbahPoto(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/admin-ubah-photo';
    return url;
  }
  static pegawaiUbahPoto(){
    String url = 'http://bdg2.jasamedika.com:3322/api/pegawai/ubah-photo';
    return url;
  }
}