#!/usr/bin/env python3
"""
Morning Brief - 早间简报

自动收集：
- ☁️ 天气（上海）
- 🔥 知乎/V2EX 热门话题
- 📻 播客更新

Usage:
  python3 morning_brief.py
"""

import os
import subprocess
from datetime import datetime

OUTPUT_DIR = os.path.expanduser("~/.openclaw/skills/morning-brief/")


def get_weather():
    """Get Shanghai weather."""
    try:
        result = subprocess.run(
            ["curl", "-s", "wttr.in/Shanghai?format=%l:+%c+%t"],
            capture_output=True, text=True, timeout=10
        )
        return result.stdout.strip()
    except:
        return "☁️ 天气获取失败"


def get_zhihu_hot():
    """Get V2EX hot topics."""
    try:
        result = subprocess.run(
            ["python3", "~/.openclaw/skills/zhihu-hot/zhihu_hot.py", "--hot"],
            capture_output=True, text=True, timeout=90,
            shell=True
        )
        # Extract top 3 topics
        lines = result.stdout.split("\n")
        topics = []
        for line in lines:
            if line.strip().startswith("http"):
                topics.append(line.strip())
                if len(topics) >= 3:
                    break
        return topics
    except:
        return []


def format_brief(weather, topics):
    """Format morning brief."""
    lines = []
    lines.append("=" * 50)
    lines.append("🌅 早间简报 - " + datetime.now().strftime("%Y-%m-%d %H:%M"))
    lines.append("=" * 50)
    lines.append("")
    
    # Weather
    lines.append(f"☁️ {weather}")
    lines.append("")
    
    # Hot topics
    lines.append("🔥 热门话题（Top 3）")
    for i, topic in enumerate(topics[:3], 1):
        lines.append(f"{i}. {topic}")
    lines.append("")
    
    lines.append("=" * 50)
    lines.append(datetime.now().strftime("生成时间: %H:%M"))
    
    return "\n".join(lines)


def main():
    print("🌅 生成早间简报...\n")
    
    # Get data
    weather = get_weather()
    print(f"☁️ {weather}")
    
    topics = get_zhihu_hot()
    print(f"🔥 获取到 {len(topics)} 个话题")
    
    # Format and save
    brief = format_brief(weather, topics)
    
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    filename = f"{OUTPUT_DIR}brief_{datetime.now().strftime('%Y-%m-%d')}.txt"
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(brief)
    
    print("\n" + brief)
    print(f"\n💾 已保存到: {filename}")


if __name__ == "__main__":
    main()
