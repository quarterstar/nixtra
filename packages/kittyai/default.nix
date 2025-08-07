{ lib, python3, ... }:

python3.pkgs.buildPythonApplication {
  pname = "kittyai";
  version = "1.0.0";

  format = "pyproject";

  src = ./.;

  propagatedBuildInputs = with python3.pkgs; [
    openai
    python-dotenv
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/quarterstar/kittyai";
    description = "AI integration for Kitty terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ quarterstar ];
  };

  dontUseSetuptoolsCheck = true;
}
