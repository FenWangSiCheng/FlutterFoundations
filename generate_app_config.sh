#!/bin/bash

# 定义输入和输出文件
input_file="dart_defines/dev.json"
output_file="lib/app_config.dart"

# Dart 类名称
class_name="AppConfig"

# 开始生成 Dart 类
echo "class $class_name {" > $output_file

# 读取 JSON 文件，逐行解析键值对
while read -r line; do
  # 使用正则表达式提取键和值
  if [[ $line =~ \"([^\"]+)\":\ (\"[^\"]+\"|true|false) ]]; then
    key="${BASH_REMATCH[1]}"
    value="${BASH_REMATCH[2]}"

    # 清理键名以符合 Dart 命名规则：移除非法字符并防止下划线出现在末尾
    key=$(echo "$key" | tr -c '[:alnum:]' '_')
    key=$(echo "$key" | sed 's/_$//')

    # 判断值类型并生成相应的 Dart 代码
    if [[ $value =~ ^[0-9]+$ ]]; then
      echo "  static const int $key = int.fromEnvironment('$key');" >> $output_file
    elif [[ $value =~ ^[0-9]+\.[0-9]+$ ]]; then
      echo "  static const double $key = double.fromEnvironment('$key');" >> $output_file
    elif [[ $value == "true" || $value == "false" ]]; then
      echo "  static const bool $key = bool.fromEnvironment('$key');" >> $output_file
    else
      # 移除字符串值的引号
      value=$(echo "$value" | tr -d '"')
      echo "  static const String $key = String.fromEnvironment('$key');" >> $output_file
    fi
  fi
done < "$input_file"

# 结束 Dart 类
echo "}" >> $output_file

echo "Generated $class_name in $output_file"