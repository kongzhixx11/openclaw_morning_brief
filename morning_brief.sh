#!/bin/bash
# Morning Brief - 早间简报
# 天气 + V2EX 热门 + 穿衣推荐
#
# 配置说明：
#   天气位置可在 ~/.openclaw/skills/morning-brief/config.sh 中配置
#   默认使用 wttr.in 获取天气（支持全球城市）

# 加载配置（如果存在）
CONFIG_FILE="$HOME/.openclaw/skills/morning-brief/config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# 默认天气位置
WEATHER_LOCATION="${WEATHER_LOCATION:-Beijing}"
WEATHER_FORMAT="${WEATHER_FORMAT:-%l:%c+%t+%h}"

CURRENT_DATE=$(date +%Y-%m-%d)
echo "🌅 早间简报 - $CURRENT_DATE"
echo "================================"

# 天气获取
echo ""
WEATHER=$(curl -s --max-time 10 "wttr.in/${WEATHER_LOCATION}?format=${WEATHER_FORMAT}" 2>/dev/null || echo "${WEATHER_LOCATION}:+??°C")
echo "☁️ ${WEATHER:-获取失败}"

# 穿衣推荐（基于温度）
TEMP=$(curl -s --max-time 10 "wttr.in/${WEATHER_LOCATION}?format=%t" 2>/dev/null | tr -d '+°C')
if [ -n "$TEMP" ]; then
    if [ "$TEMP" -ge 25 ]; then
        echo "👕 推荐：短袖/薄款，适合凉爽天气"
    elif [ "$TEMP" -ge 18 ]; then
        echo "👕 推荐：长袖/薄外套，舒适气温"
    elif [ "$TEMP" -ge 10 ]; then
        echo "🧥 推荐：外套/毛衣，注意保暖"
    elif [ "$TEMP" -ge 5 ]; then
        echo "🧥 推荐：厚外套/羽绒服，保暖为主"
    else
        echo "🧥 推荐：保暖内衣+厚外套，非常冷！"
    fi
else
    echo "👕 推荐：外套/毛衣（天气获取超时）"
fi

# V2EX 热门 - 使用RSS + 关注话题过滤
echo ""
echo "🔥 V2EX 热门 (Top 5):"
echo ""

python3 - << 'PYTHON'
import re
import sys
import warnings
warnings.filterwarnings('ignore')

# 用户关注的话题（可在配置中修改）
INTERESTED_TAGS = {'程序员', 'AI', 'Python', '编程', 'OpenAI', 'ChatGPT', 'LLM', '人工智能'}

def fetch_rss():
    """获取V2EX技术区RSS - 使用requests库（自动使用系统代理）"""
    try:
        import requests
        r = requests.get(
            'https://www.v2ex.com/feed/tab/tech.xml',
            timeout=15,
            headers={'User-Agent': 'Mozilla/5.0'}
        )
        return r.text
    except Exception as e:
        print(f"  获取失败: {e}", file=sys.stderr)
        return ''

def extract_tags_from_title(title):
    """从标题中提取可能的话题标签"""
    tags = []
    # 常见话题关键词
    keywords = {'程序员', 'AI', 'Python', '编程', 'OpenAI', 'ChatGPT', 'LLM', '人工智能',
                'Go', 'JavaScript', 'Rust', 'Java', 'C++', '机器学习', '深度学习', 'VPS',
                '服务器', 'Linux', 'Docker', 'K8s', '云原生', '前端', '后端', '全栈',
                '数据库', 'Redis', 'MySQL', 'PostgreSQL', 'MongoDB'}
    title_lower = title.lower()
    for kw in keywords:
        if kw.lower() in title_lower:
            tags.append(kw)
    return tags

# 获取RSS
rss_content = fetch_rss()
if not rss_content:
    print("  (RSS获取失败)")
    sys.exit(1)

# 解析RSS条目
entries = []
entry_pattern = r'<entry>(.*?)</entry>'
for match in re.finditer(entry_pattern, rss_content, re.DOTALL):
    entry_text = match.group(1)
    title = re.search(r'<title>(.*?)</title>', entry_text)
    link = re.search(r'<link[^>]*href="([^"]+)"[^>]*>', entry_text)
    if title and link:
        entries.append({
            'title': title.group(1),
            'url': link.group(1).strip(),
            'tags': extract_tags_from_title(title.group(1))
        })

# 过滤：优先显示匹配关注话题的帖子
filtered = []
other = []
for e in entries:
    matched = any(tag in INTERESTED_TAGS for tag in e['tags'])
    if matched:
        filtered.append(e)
    else:
        other.append(e)

# 合并：关注的放前面
filtered.extend(other[:len(filtered)])

# 显示前5个
count = 0
for e in filtered[:5]:
    count += 1
    tags_str = ', '.join(e['tags'][:2]) if e['tags'] else ''
    if tags_str:
        print(f"  {count}. [{tags_str}] {e['title']}")
    else:
        print(f"  {count}. {e['title']}")
    print(f"     {e['url']}")
    print()

if count == 0:
    print("  (暂无热门内容)")
PYTHON

echo ""
echo "================================"
echo "生成时间: $(date '+%H:%M')"
