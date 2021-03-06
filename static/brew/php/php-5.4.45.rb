class PhpAT5445 < Formula
  desc "General-purpose scripting language"
  homepage "https://www.php.net/"
  # Should only be updated if the new version is announced on the homepage, https://www.php.net/
  url "http://mirrors.sohu.com/php/php-5.4.45.tar.gz"
  sha256 "25bc4723955f4e352935258002af14a14a9810b491a19400d76fcdfa9d04b28f"

  bottle do
    sha256 "ddd14746138f0212dfd8d2c0944d573ce05c3ba900c2579440f7e8defa63b0c7" => :catalina
    sha256 "fcc85c9f550df021a7f505d57c43e19672940c37ef7a1f909eec2d1d13202cef" => :mojave
    sha256 "edfcefb109b356338ed324305f7317659df02bb5a8252b67a696180e75e81b1c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "argon2"
  depends_on "aspell"
  depends_on "autoconf"
  depends_on "freetds"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "libffi"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libsodium"
  depends_on "libzip"
  depends_on "oniguruma"
  depends_on "openldap"
  depends_on "sqlite"
  depends_on "tidy-html5"
  depends_on "unixodbc"
  depends_on "webp"
  depends_on "zlib"
  depends_on "libiconv"
  depends_on "curl-openssl"
  depends_on "openssl@1.0.2u"
  depends_on "icu4c@56.2"

  # PHP build system incorrectly links system libraries
  # see https://github.com/php/php-src/pull/3472
  patch :DATA

  def install
    # Ensure that libxml2 will be detected correctly in older MacOS
    if MacOS.version == :el_capitan || MacOS.version == :sierra
      ENV["SDKROOT"] = MacOS.sdk_path
    end
#     ENV["PHP_AUTOCONF"] = "#{HOMEBREW_CELLAR}/autoconf@2.13/2.13/bin/autoconf213"

    # buildconf required due to system library linking bug patch
    system "./buildconf", "--force"

    inreplace "ext/tidy/tidy.c", '#include "buffio.h"', '#include "tidybuffio.h"'

    # Prevent homebrew from harcoding path to sed shim in phpize script
    ENV["lt_cv_path_SED"] = "sed"

    # system pkg-config missing
    ENV["KERBEROS_CFLAGS"] = " "
    ENV["KERBEROS_LIBS"] = "-lkrb5"
    ENV["EDIT_CFLAGS"] = " "
    ENV["EDIT_LIBS"] = "-ledit"

    # Each extension that is built on Mojave needs a direct reference to the
    # sdk path or it won't find the headers
    headers_path = "=#{MacOS.sdk_path_if_needed}/usr"
    args = %W[
           --prefix=#{prefix}
           --exec-prefix=#{prefix}
           --localstatedir=#{prefix}/var
           --sysconfdir=#{prefix}/conf
           --with-config-file-path=#{prefix}/conf
           --with-os-sdkpath=#{MacOS.sdk_path_if_needed}
           --enable-bcmath
           --enable-calendar
           --enable-dba
           --enable-exif
           --enable-ftp
           --enable-cgi
           --enable-fpm
           --enable-gd
           --enable-intl
           --enable-mbregex
           --enable-mbstring
           --enable-mysqlnd
           --enable-pcntl
           --enable-phpdbg
           --enable-phpdbg-webhelper
           --enable-shmop
           --enable-soap
           --enable-sockets
           --enable-sysvmsg
           --enable-sysvsem
           --enable-sysvshm
           --with-bz2#{headers_path}
           --with-ffi
           --with-fpm-user=_www
           --with-fpm-group=_www
           --with-freetype-dir=#{Formula["freetype"].opt_prefix}
           --with-gd
           --with-jpeg-dir=#{Formula["jpeg"].opt_prefix}
           --with-png-dir=#{Formula["libpng"].opt_prefix}
           --with-gettext=#{Formula["gettext"].opt_prefix}
           --with-gmp=#{Formula["gmp"].opt_prefix}
           --with-iconv=#{Formula["libiconv"].opt_prefix}
           --with-kerberos
           --with-layout=GNU
           --with-ldap=#{Formula["openldap"].opt_prefix}
           --with-libxml
           --with-libedit=#{Formula["libedit"].opt_prefix}
           --with-mhash#{headers_path}
           --with-mysql-sock=/tmp/mysql.sock
           --with-mysqli=mysqlnd
           --with-ndbm#{headers_path}
           --with-curl=#{Formula["curl-openssl"].opt_prefix}
           --with-password-argon2=#{Formula["argon2"].opt_prefix}
           --with-pdo-dblib=#{Formula["freetds"].opt_prefix}
           --with-pdo-mysql=mysqlnd
           --with-pdo-odbc=unixODBC,#{Formula["unixodbc"].opt_prefix}
           --with-pdo-pgsql=#{Formula["libpq"].opt_prefix}
           --with-pdo-sqlite
           --with-pgsql=#{Formula["libpq"].opt_prefix}
           --with-pic
           --with-pspell=#{Formula["aspell"].opt_prefix}
           --with-sodium
           --with-sqlite3
           --with-tidy=#{Formula["tidy-html5"].opt_prefix}
           --with-unixODBC
           --with-webp
           --with-xmlrpc
           --with-xsl
           --with-zip
           --with-zlib=#{Formula["zlib"].opt_prefix}
           --with-icu-dir=#{Formula["icu4c@56.2"].opt_prefix}
           --with-openssl=#{Formula["openssl@1.0.2u"].opt_prefix}
         ]
    libiconv_path = "#{Formula['libiconv'].opt_prefix}"
    system "./configure", *args

    system "sed -i.bak '/^BUILD_/ s/\\$(CC)/\\$(CXX)/g' Makefile"
    system "sed -i.bak '/EXTRA_LIBS = /s|$| -lstdc++|' Makefile"
    system "make", "ZEND_EXTRA_LIBS='#{libiconv_path}/lib/libiconv.2.dylib'"
    ENV["MAKEFLAGS"] = "-j1"
    system "make", "install"
    phpsbin = Pathname.new("#{prefix}/sbin")
        if (phpsbin/"php-fpm.dSYM").exist? && !(phpsbin/"php-fpm").exist?
           FileUtils.ln_s phpsbin/"php-fpm.dSYM", phpsbin/"php-fpm"
        end
  end

  def caveats
     <<~EOS
          install success !!!!!!
        EOS
        Homebrew.failed = false
  end

end
