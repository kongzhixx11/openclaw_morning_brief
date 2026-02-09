# Morning Brief

A daily morning brief generator that automatically fetches weather and V2EX tech hot topics.

## Background

As part of OpenClaw's Daily Routine task, this automatically generates a brief each morning containing:
- Today's weather info
- Tech community hot topics
- Clothing recommendations

Helped quickly check the weather and tech trends to start the day.

## Features

- ☁️ Weather info (via wttr.in, supports cities worldwide)
- 🔥 V2EX technology section hot topics (auto-filtered by interested tags)
- 👕 Smart clothing recommendations based on temperature

## Quick Start

### Install

```bash
mkdir -p ~/.openclaw/skills/morning-brief
cp * ~/.openclaw/skills/morning-brief/
```

### Configure

1. Copy the config example:
```bash
cp config.example.sh config.sh
```

2. Edit `config.sh` to set your weather location:
```bash
WEATHER_LOCATION="Your City"
```

3. Optional: Configure crontab for daily automatic execution

```bash
# Generate brief at 8:00 AM daily
0 8 * * * bash ~/.openclaw/skills/morning-brief/morning_brief.sh >> ~/.openclaw/logs/morning_brief.log 2>&1
```

### Usage

```bash
# Run manually
bash ~/.openclaw/skills/morning-brief/morning_brief.sh

# Or via OpenClaw command
/morning-brief
```

## File Overview

| File | Description |
|------|-------------|
| `morning_brief.sh` | Main script, Shell implementation |
| `morning_braft.py` | Backup script, Python implementation |
| `config.example.sh` | Configuration example file |
| `skill.json` | OpenClaw Skill configuration |
| `README.md` | This documentation |

## Dependencies

- `curl` - Fetch weather data
- `python3` - Parse V2EX RSS feed
- `requests` - Python HTTP library (if using morning_braft.py)
