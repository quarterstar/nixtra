{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  fetchpatch,
  glib,
  gst_all_1,
  lib,
  mpv-unwrapped,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,
  sqlite,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tiagofmcosta";
    repo = "wayland-random-wallpaper";
    rev = "787b442fe84b4da1ad586ae5c384863f327c5dc1";
    hash = "sha256-58Ok3bDv6OfB6KGpYI19fSLk3YUbSOJE1Hs35K1OBDk=";
  };

  cargoPatches = [
  ];

  postPatch = ''
  '';

  cargoHash = "sha256-X2UzwdwOIsD7cHVIYqCxfi4rX3wAWguB7bLSmyD+Xqg=";

  useNextest = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      dbus
      glib
      gst_all_1.gstreamer
      mpv-unwrapped
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ];

  meta = {
    description = "Simple application to randomly apply a wallpaper from a given folder";
    homepage = "https://github.com/tiagofmcosta/wayland-random-wallpaper";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "random-wallpaper";
  };
}

