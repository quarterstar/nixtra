{ lib
, fetchFromGitHub
, buildDotnetModule
}:

buildDotnetModule rec {
  pname = "toolbox";
  version = "Final";

  src = fetchFromGitHub {
    owner = "KillzXGaming";
    repo = "Switch-Toolbox";
    rev = "v${version}";
    sha256 = "";
  };

  projectFile = "Toolbox/Toolbox.csproj";

  meta = with lib; {
    homepage = "https://github.com/KillzXGaming/Switch-Toolbox";
    description = "A tool to edit many video game file formats";
    license = licenses.gpl3;
  };
}
