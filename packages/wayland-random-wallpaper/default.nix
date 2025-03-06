{ stdenv, fetchgit,
  cargo, ...
}:

stdenv.mkDerivation {
  name = "wayland-random-wallpaper";
  src = fetchgit { 
    url = "https://github.com/tiagofmcosta/wayland-random-wallpaper";
    rev = "9959cc0d17478d746cf2fb204ded389dac7bf7bb";
    sha256 = "";
  };

  buildInputs = [
    cargo
  ];

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
   cp -r ./* $out
  '';
}
