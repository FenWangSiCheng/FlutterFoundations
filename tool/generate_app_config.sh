#!/bin/bash

input_file="dart_defines/dev.json"
output_file="lib/app_config.dart"

class_name="AppConfig"

echo "class $class_name {" > $output_file

while read -r line; do
  if [[ $line =~ \"([^\"]+)\":\ (\"[^\"]+\"|true|false) ]]; then
    key="${BASH_REMATCH[1]}"
    value="${BASH_REMATCH[2]}"

    key=$(echo "$key" | tr -c '[:alnum:]' '_')
    key=$(echo "$key" | sed 's/_$//')

    if [[ $value =~ ^[0-9]+$ ]]; then
      echo "  static const int $key = int.fromEnvironment('$key');" >> $output_file
    elif [[ $value =~ ^[0-9]+\.[0-9]+$ ]]; then
      echo "  static const double $key = double.fromEnvironment('$key');" >> $output_file
    elif [[ $value == "true" || $value == "false" ]]; then
      echo "  static const bool $key = bool.fromEnvironment('$key');" >> $output_file
    else
      value=$(echo "$value" | tr -d '"')
      echo "  static const String $key = String.fromEnvironment('$key');" >> $output_file
    fi
  fi
done < "$input_file"

echo "}" >> $output_file

echo "Generated $class_name in $output_file"
