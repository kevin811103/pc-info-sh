#!/bin/bash

# 获取CPU信息
get_cpu_info() {
  cpu_model=$(grep -m 1 'model name' /proc/cpuinfo | awk -F: '{print $2}' | xargs)
  cpu_cores=$(grep -c '^processor' /proc/cpuinfo)
  cpu_freq=$(grep -m 1 'cpu MHz' /proc/cpuinfo | awk -F: '{print $2}' | xargs)

  echo "\"cpu\": {"
  echo "\"model\": \"$cpu_model\","
  echo "\"cores\": \"$cpu_cores\","
  echo "\"frequency_mhz\": \"$cpu_freq\""
  echo "}"
}

# 获取内存信息，并转换为GB
get_ram_info() {
  total_mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  free_mem_kb=$(grep MemFree /proc/meminfo | awk '{print $2}')

  # 将KB转换为GB，结果保留两位小数
  total_mem_gb=$(awk "BEGIN {printf \"%.2f\", $total_mem_kb/1024/1024}")
  free_mem_gb=$(awk "BEGIN {printf \"%.2f\", $free_mem_kb/1024/1024}")

  echo "\"ram\": {"
  echo "\"total_gb\": \"$total_mem_gb\","
  echo "\"free_gb\": \"$free_mem_gb\""
  echo "}"
}

# 获取硬盘信息
get_hd_info() {
  hd_total=$(df -h --total | grep 'total' | awk '{print $2}')
  hd_used=$(df -h --total | grep 'total' | awk '{print $3}')
  hd_available=$(df -h --total | grep 'total' | awk '{print $4}')

  echo "\"hard_drive\": {"
  echo "\"total\": \"$hd_total\","
  echo "\"used\": \"$hd_used\","
  echo "\"available\": \"$hd_available\""
  echo "}"
}

# 获取操作系统信息
get_os_info() {
  os_name=$(grep '^PRETTY_NAME' /etc/os-release | awk -F= '{print $2}' | tr -d '"')

  echo "\"os\": {"
  echo "\"name\": \"$os_name\""
  echo "}"
}

# 获取外部IP地址信息
get_ip_info() {
  ip_address=$(curl -s https://ipinfo.io/ip)

  echo "\"ip\": {"
  echo "\"address\": \"$ip_address\""
  echo "}"
}

# 生成JSON输出
generate_json() {
  echo "{"
  get_cpu_info
  echo ","
  get_ram_info
  echo ","
  get_hd_info
  echo ","
  get_os_info
  echo ","
  get_ip_info
  echo "}"
}

# 执行生成JSON函数
generate_json
