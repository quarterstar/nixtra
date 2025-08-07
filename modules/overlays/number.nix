self: super: {
  floatToInt = float:
    super.runCommand "floatToInt" { } ''
      int=$(printf "%.f" "${float}
      echo "$TRUNCATED_VALUE" > $int
    '';
}
