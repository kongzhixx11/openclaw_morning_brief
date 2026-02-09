# Morning Brief

[English Version](README_EN.md)

每日早间简报生成器，自动收集天气和 V2EX 技术区热门话题。

## 背景

作为 OpenClaw 的每日例行任务（Daily Routine），每天早上自动生成简报，包含：
- 当日天气信息
- 技术社区热门话题
- 穿衣建议

帮助快速了解当天天气和技术动态，开启新的一天。

## 功能

- ☁️ 天气信息（使用 wttr.in，支持全球城市）
- 🔥 V2EX 技术区热门话题（自动过滤关注标签）
- 👕 根据温度智能推荐穿衣搭配

## 快速开始

### 安装

```bash
mkdir -p ~/.openclaw/skills/morning-brief
cp * ~/.openclaw/skills/morning-brief/
```

### 配置

1. 复制配置示例：
```bash
cp config.example.sh config.sh
```

2. 编辑 `config.sh` 自定义天气位置：
```bash
WEATHER_LOCATION="你的城市"
```

3. 可选：配置 crontab 每天自动运行

```bash
# 每天早上 8:00 生成简报
0 8 * * * bash ~/.openclaw/skills/morning-brief/morning_brief.sh >> ~/.openclaw/logs/morning_brief.log 2>&1
```

### 使用

```bash
# 手动运行
bash ~/.openclaw/skills/morning-brief/morning_brief.sh

# 或通过 OpenClaw 命令
/morning-brief
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `morning_brief.sh` | 主脚本，Shell 实现 |
| `morning_braft.py` | 备用脚本，Python 实现 |
| `config.example.sh` | 配置示例文件 |
| `skill.json` | OpenClaw Skill 配置 |
| `README.md` | 本文档 |

## 依赖

- `curl` - 获取天气数据
- `python3` - 解析 V2EX RSS 订阅
- `requests` - Python HTTP 库（如使用 morning_braft.py）
