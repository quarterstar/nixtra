{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, bison
, cmake
, flex
, fop
, git
, gnused
, libxslt
, pkg-config
, qttools
, apr
, aprutil
, boost
, bzip2
, cairo
, expat
, fontconfig
, freetype
, fribidi
, gd
, gmp
, graphite2
, harfbuzzFull
, hunspell
, icu
, libjpeg
, log4cxx
, lzma
, mpfr
, libmspack
, libressl
, pixman
, libpng
, poppler
, popt
, potrace
, qtdeclarative
, qtscript
, uriparser
, zziplib
, libsForQt5
}:

stdenv.mkDerivation rec {
  pname = "miktex";
  version = "24.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-Vqn+Qyb8S2q9qLJzTm0GJeNwdc+3Ws2gawM6yDlBH7w=";
  };

  postPatch = ''
    substituteInPlace Programs/TeXAndFriends/omega/otps/source/outocp.c \
      --replace 'fprintf(stderr, s);' 'fprintf(stderr, "%s", s);'
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    bison
    cmake
    flex
    fop
    git
    gnused
    libxslt
    pkg-config
    qttools
  ];

  buildInputs = [
    apr
    aprutil
    boost
    bzip2
    cairo
    expat
    fontconfig
    freetype
    fribidi
    gd
    gmp
    graphite2
    harfbuzzFull
    hunspell
    icu
    libjpeg
    log4cxx
    lzma
    mpfr
    libmspack
    libressl
    pixman
    libpng
    poppler
    popt
    potrace
    qtdeclarative
    qtscript
    uriparser
    zziplib
    libsForQt5.poppler
  ];

  cmakeFlags = [
    "-DWITH_BOOTSTRAPPING=FALSE"
    "-DUSE_SYSTEM_POPPLER=TRUE"
    "-DUSE_SYSTEM_POPPLER_QT5=TRUE"
    "-DWITH_MAN_PAGES=FALSE"
  ];

  preBuild = ''
    export HOME=$TMPDIR
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/sandbox/miktex/bin/linux-x86_64
  '';

  meta = with lib; {
    description = "A modern TeX distribution";
    homepage = "https://miktex.org";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
