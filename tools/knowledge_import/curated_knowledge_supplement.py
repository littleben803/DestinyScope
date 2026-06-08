"""Curated DestinyScope knowledge supplement for five elements, stems, branches."""

from __future__ import annotations

from typing import Any


SOURCE_REFS: list[dict[str, str]] = [
    {
        "title": "《尚书·洪范》",
        "url": "https://zh.wikisource.org/zh-hans/%E5%B0%9A%E6%9B%B8/%E6%B4%AA%E7%AF%84",
        "note": "五行名称与润下、炎上、曲直、从革、稼穑等基础属性",
    },
    {
        "title": "《礼记·月令》",
        "url": "https://ctext.org/liji/yue-ling/ens",
        "note": "四时、月令、日干、音、味等对应关系",
    },
    {
        "title": "《淮南子·天文训》",
        "url": "https://ctext.org/text.pl?node=3060&if=gb&remap=gb&show=parallel",
        "note": "五方、五行、五星、五音、日干的系统对应",
    },
    {
        "title": "汉典：天干",
        "url": "https://zdic.net/hans/%E5%A4%A9%E5%B9%B2",
        "note": "天干定义、十干列表、与地支配合纪时",
    },
    {
        "title": "汉典：地支",
        "url": "https://zdic.net/hans/%E5%9C%B0%E6%94%AF",
        "note": "地支定义、十二支列表、与天干配合纪年纪月纪日纪时",
    },
    {
        "title": "维基百科：天干",
        "url": "https://zh.wikipedia.org/wiki/%E5%A4%A9%E5%B9%B2",
        "note": "天干作为循环计序符号、干支命名和五行阴阳配属的现代整理",
    },
    {
        "title": "维基百科：地支",
        "url": "https://zh.wikipedia.org/wiki/%E5%9C%B0%E6%94%AF",
        "note": "十二地支、十二辰、时辰、方位、阴阳五行配属的现代整理",
    },
]

SOURCE_SUMMARY = (
    "Curated DestinyScope supplement based on Shangshu Hongfan, Liji Yueling, "
    "Huainanzi Tianwenxun, ZDIC dictionary entries, and cross-checked modern reference summaries."
)

ELEMENTS: list[dict[str, str]] = [
    {
        "name": "木",
        "pinyin": "mu",
        "hongfan": "曲直",
        "plain": "生长、伸展、可曲可直",
        "season": "春",
        "direction": "东",
        "color": "青",
        "taste": "酸",
        "tone": "角",
        "stems": "甲乙",
        "branches": "寅卯辰",
        "image": "树木抽芽、枝条舒展",
    },
    {
        "name": "火",
        "pinyin": "huo",
        "hongfan": "炎上",
        "plain": "温热、明亮、向上",
        "season": "夏",
        "direction": "南",
        "color": "赤",
        "taste": "苦",
        "tone": "徵",
        "stems": "丙丁",
        "branches": "巳午未",
        "image": "火焰升腾、光热外显",
    },
    {
        "name": "土",
        "pinyin": "tu",
        "hongfan": "稼穑",
        "plain": "承载、培育、转化",
        "season": "长夏或四时之交",
        "direction": "中央",
        "color": "黄",
        "taste": "甘",
        "tone": "宫",
        "stems": "戊己",
        "branches": "辰戌丑未",
        "image": "土地承载作物、调和四方",
    },
    {
        "name": "金",
        "pinyin": "jin",
        "hongfan": "从革",
        "plain": "收敛、成形、变革",
        "season": "秋",
        "direction": "西",
        "color": "白",
        "taste": "辛",
        "tone": "商",
        "stems": "庚辛",
        "branches": "申酉戌",
        "image": "金属受火炼而成器",
    },
    {
        "name": "水",
        "pinyin": "shui",
        "hongfan": "润下",
        "plain": "滋润、流动、向下",
        "season": "冬",
        "direction": "北",
        "color": "黑",
        "taste": "咸",
        "tone": "羽",
        "stems": "壬癸",
        "branches": "亥子丑",
        "image": "水流就下、涵养万物",
    },
]

STEMS: list[dict[str, Any]] = [
    {"name": "甲", "pinyin": "jia", "order": 1, "yinYang": "阳", "element": "木", "direction": "东", "pair": "乙", "group": "甲乙", "image": "木气初发、序列开端"},
    {"name": "乙", "pinyin": "yi", "order": 2, "yinYang": "阴", "element": "木", "direction": "东", "pair": "甲", "group": "甲乙", "image": "木气柔和、承接初发"},
    {"name": "丙", "pinyin": "bing", "order": 3, "yinYang": "阳", "element": "火", "direction": "南", "pair": "丁", "group": "丙丁", "image": "火气明朗、光热外显"},
    {"name": "丁", "pinyin": "ding", "order": 4, "yinYang": "阴", "element": "火", "direction": "南", "pair": "丙", "group": "丙丁", "image": "火气内聚、光热有度"},
    {"name": "戊", "pinyin": "wu", "order": 5, "yinYang": "阳", "element": "土", "direction": "中央", "pair": "己", "group": "戊己", "image": "土气厚重、承载外向"},
    {"name": "己", "pinyin": "ji", "order": 6, "yinYang": "阴", "element": "土", "direction": "中央", "pair": "戊", "group": "戊己", "image": "土气含蓄、整理承接"},
    {"name": "庚", "pinyin": "geng", "order": 7, "yinYang": "阳", "element": "金", "direction": "西", "pair": "辛", "group": "庚辛", "image": "金气刚健、收敛成形"},
    {"name": "辛", "pinyin": "xin", "order": 8, "yinYang": "阴", "element": "金", "direction": "西", "pair": "庚", "group": "庚辛", "image": "金气精细、去粗取精"},
    {"name": "壬", "pinyin": "ren", "order": 9, "yinYang": "阳", "element": "水", "direction": "北", "pair": "癸", "group": "壬癸", "image": "水气开阔、流动涵养"},
    {"name": "癸", "pinyin": "gui", "order": 10, "yinYang": "阴", "element": "水", "direction": "北", "pair": "壬", "group": "壬癸", "image": "水气细密、归藏待发"},
]

BRANCHES: list[dict[str, Any]] = [
    {"name": "子", "pinyin": "zi", "order": 1, "yinYang": "阳", "element": "水", "season": "冬", "direction": "北", "time": "23:00-01:00", "month": "冬月", "zodiac": "鼠"},
    {"name": "丑", "pinyin": "chou", "order": 2, "yinYang": "阴", "element": "土", "season": "冬", "direction": "东北", "time": "01:00-03:00", "month": "腊月", "zodiac": "牛"},
    {"name": "寅", "pinyin": "yin", "order": 3, "yinYang": "阳", "element": "木", "season": "春", "direction": "东北", "time": "03:00-05:00", "month": "正月", "zodiac": "虎"},
    {"name": "卯", "pinyin": "mao", "order": 4, "yinYang": "阴", "element": "木", "season": "春", "direction": "东", "time": "05:00-07:00", "month": "二月", "zodiac": "兔"},
    {"name": "辰", "pinyin": "chen", "order": 5, "yinYang": "阳", "element": "土", "season": "春", "direction": "东南", "time": "07:00-09:00", "month": "三月", "zodiac": "龙"},
    {"name": "巳", "pinyin": "si", "order": 6, "yinYang": "阴", "element": "火", "season": "夏", "direction": "东南", "time": "09:00-11:00", "month": "四月", "zodiac": "蛇"},
    {"name": "午", "pinyin": "wu", "order": 7, "yinYang": "阳", "element": "火", "season": "夏", "direction": "南", "time": "11:00-13:00", "month": "五月", "zodiac": "马"},
    {"name": "未", "pinyin": "wei", "order": 8, "yinYang": "阴", "element": "土", "season": "夏", "direction": "西南", "time": "13:00-15:00", "month": "六月", "zodiac": "羊"},
    {"name": "申", "pinyin": "shen", "order": 9, "yinYang": "阳", "element": "金", "season": "秋", "direction": "西南", "time": "15:00-17:00", "month": "七月", "zodiac": "猴"},
    {"name": "酉", "pinyin": "you", "order": 10, "yinYang": "阴", "element": "金", "season": "秋", "direction": "西", "time": "17:00-19:00", "month": "八月", "zodiac": "鸡"},
    {"name": "戌", "pinyin": "xu", "order": 11, "yinYang": "阳", "element": "土", "season": "秋", "direction": "西北", "time": "19:00-21:00", "month": "九月", "zodiac": "狗"},
    {"name": "亥", "pinyin": "hai", "order": 12, "yinYang": "阴", "element": "水", "season": "冬", "direction": "西北", "time": "21:00-23:00", "month": "十月", "zodiac": "猪"},
]


def source_refs_for(*keys: str) -> list[dict[str, str]]:
    selected: list[dict[str, str]] = []
    for source in SOURCE_REFS:
        title = source["title"]
        if any(key in title or key in source["note"] for key in keys):
            selected.append(source)
    return selected or SOURCE_REFS[:3]


def source_string(keys: tuple[str, ...]) -> str:
    titles = "；".join(source["title"] for source in source_refs_for(*keys))
    return f"{SOURCE_SUMMARY} Sources: {titles}"


def cleaned_body(body: str, boundary_text: str) -> str:
    value = body.strip()
    if value.startswith("问题："):
        parts = value.split("\n\n", 1)
        if len(parts) == 2 and parts[1].startswith("参考解读："):
            value = parts[1]
    value = value.replace(f"\n\n{boundary_text}", "").strip()
    return value


def article(
    *,
    article_id: str,
    category: str,
    title: str,
    summary: str,
    body: str,
    tags: list[str],
    scenes: list[str],
    source_keys: tuple[str, ...],
    boundary_text: str,
    source_version: str,
) -> dict[str, Any]:
    clean_body = cleaned_body(body, boundary_text)
    return {
        "id": article_id,
        "category": category,
        "title": title,
        "summary": summary,
        "body": clean_body,
        "tags": tags,
        "scenes": ["knowledge_library", "rag_retrieval", *[scene for scene in scenes if scene not in {"knowledge_library", "rag_retrieval"}], "usage_boundary"],
        "riskLevel": "safe",
        "qualityScore": 92,
        "usageBoundary": boundary_text,
        "source": source_string(source_keys),
        "sourceRefs": source_refs_for(*source_keys),
        "version": source_version,
    }


def five_elements_articles(boundary_text: str, source_version: str) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []

    core_topics = [
        ("五行是什么", "五行是以木、火、土、金、水为核心的传统分类框架。它先从日用材料和自然属性出发，后来扩展为观察季节、方位、色味、干支等关系的文化语言。"),
        ("五行为什么称为行", "“行”强调运行、流布和功能，而不只是静态物质。把五行理解为五类变化方式，比把它们当作五种单独物品更接近传统文本的用法。"),
        ("《洪范》中的五行次序", "《尚书·洪范》把五行列为水、火、木、金、土，并配以润下、炎上、曲直、从革、稼穑五种属性，这是理解五行的基础入口。"),
        ("五行与五材", "早期五行常和五材相通，强调水火木金土是民生日用和自然生产中不可缺少的材料。这个角度有助于避免把五行神秘化。"),
        ("五行从材料到分类框架", "五行后来被用来整理季节、方位、颜色、味道、声音和干支等资料，形成一套以五为单位的对应系统。"),
        ("五行与阴阳", "阴阳强调两类相对倾向，五行强调五类功能差异。两者合用时，可以把变化理解为既有开合明暗，也有生发、炎上、承载、收敛、润下等方向。"),
        ("五行与四时", "五行常以木配春、火配夏、金配秋、水配冬，土居中央或四时之交。这个结构用于说明季节节律，不应当被当作现实判断结论。"),
        ("五行与方位", "传统对应中，木多配东、火配南、金配西、水配北、土配中央。方位对应是文化象征和分类语言，不是物理因果规则。"),
        ("五行与五味", "《洪范》把润下作咸、炎上作苦、曲直作酸、从革作辛、稼穑作甘，说明五味对应来自属性类比。"),
        ("五行与五色", "青、赤、黄、白、黑常分别配木、火、土、金、水。颜色对应适合用于理解传统图像和文本组织。"),
        ("五行与五音", "角、徵、宫、商、羽常分别配木、火、土、金、水。五音对应体现古人把声音也纳入分类系统的思路。"),
        ("五行与数字", "五行可与一二三四五、生成数和方位数相连。学习时宜先理解这些数字是传统分类工具，再看具体文本如何使用。"),
        ("五行与天干", "甲乙常配木，丙丁配火，戊己配土，庚辛配金，壬癸配水。这个配属能帮助理解干支系统的五行层次。"),
        ("五行与地支", "地支也有五行配属，如寅卯属木、巳午属火、申酉属金、亥子属水，辰戌丑未多作土看。"),
        ("五行的使用边界", "五行适合说明传统文化文本中的分类方式和象征关系，不适合被用作现实决策、健康判断、经济判断或人际关系结论。"),
    ]
    for index, (title, summary) in enumerate(core_topics, start=1):
        rows.append(article(
            article_id=f"five_elements_curated_core_{index:02d}",
            category="五行",
            title=title,
            summary=summary,
            body=f"问题：{title}\n\n参考解读：{summary}学习五行时，建议先把它看成一种整理自然经验和文化文本的框架：它关心的是属性、方向和对应关系，而不是单条现实事件的预测。",
            tags=["五行", "传统文化", "自我探索"],
            scenes=["wuxing_foundation", "traditional_culture"],
            source_keys=("洪范", "月令", "天文训"),
            boundary_text=boundary_text,
            source_version=source_version,
        ))

    template_titles = [
        ("基础意象", "{name}的基础意象是什么", "{name}的基础意象可概括为{plain}，常用来说明{image}这一类变化方式。"),
        ("洪范属性", "{name}在《洪范》中的属性", "《洪范》以“{hongfan}”说明{name}，重点不是神秘判断，而是把自然材料的功能转化为文化分类。"),
        ("季节方位", "{name}与季节方位", "{name}常与{season}、{direction}相配，用来表达时序和空间中的一类象征位置。"),
        ("干支关系", "{name}与天干地支", "{name}在天干中常见于{stems}，在地支中常和{branches}相关，可作为学习干支五行配属的入口。"),
        ("色味声音", "{name}的色味声音对应", "{name}常配{color}色、{taste}味、{tone}音，这些对应用于理解古代分类表和礼乐文本。"),
        ("自我观察", "{name}在自我观察中的参考", "从自我观察角度看，{name}可作为理解{plain}的比喻，帮助描述状态倾向，而不是定义一个人的本质。"),
        ("边界", "{name}相关内容的使用边界", "学习{name}时，应把{hongfan}和{image}理解为传统文化中的象征语言，不应用来替代现实判断。"),
    ]
    serial = 1
    for element in ELEMENTS:
        for _, title_template, summary_template in template_titles:
            title = title_template.format(**element)
            summary = summary_template.format(**element)
            rows.append(article(
                article_id=f"five_elements_curated_{element['pinyin']}_{serial:02d}",
                category="五行",
                title=title,
                summary=summary,
            body=f"问题：{title}\n\n参考解读：{summary}在知识库中，这类条目用于帮助用户理解五行表中的名称、属性和配属。它强调文化说明和语言整理，不提供现实结论。",
                tags=["五行", element["name"], "传统文化"],
                scenes=["wuxing_foundation", "traditional_culture"],
                source_keys=("洪范", "月令", "天文训"),
                boundary_text=boundary_text,
                source_version=source_version,
            ))
            serial += 1

    generating = [("木", "火"), ("火", "土"), ("土", "金"), ("金", "水"), ("水", "木")]
    controlling = [("木", "土"), ("土", "水"), ("水", "火"), ("火", "金"), ("金", "木")]
    for index, (first, second) in enumerate(generating, start=1):
        title = f"{first}生{second}如何理解"
        summary = f"{first}生{second}是五行相生关系中的一组表达，强调一类属性对另一类属性的承接或助成。"
        rows.append(article(
            article_id=f"five_elements_curated_generating_{index:02d}",
            category="五行",
            title=title,
            summary=summary,
            body=f"问题：{title}\n\n参考解读：{summary}相生关系适合用来理解传统文本如何描述连续、转化和支持关系。它不是现实事件的保证，也不应被用作具体决策依据。",
            tags=["五行", "相生", first, second],
            scenes=["wuxing_foundation", "traditional_culture"],
            source_keys=("五行", "洪范"),
            boundary_text=boundary_text,
            source_version=source_version,
        ))
    for index, (first, second) in enumerate(controlling, start=1):
        title = f"{first}克{second}如何理解"
        summary = f"{first}克{second}是五行相克关系中的一组表达，强调约束、制衡和边界，而不是简单的好坏判断。"
        rows.append(article(
            article_id=f"five_elements_curated_controlling_{index:02d}",
            category="五行",
            title=title,
            summary=summary,
            body=f"问题：{title}\n\n参考解读：{summary}相克关系的文化价值在于说明事物之间也需要限制和调节。它适合做文本解释，不适合推导个人结果。",
            tags=["五行", "相克", first, second],
            scenes=["wuxing_foundation", "traditional_culture"],
            source_keys=("五行", "洪范"),
            boundary_text=boundary_text,
            source_version=source_version,
        ))

    return rows


def heavenly_stem_articles(boundary_text: str, source_version: str) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    core_topics = [
        ("天干是什么", "天干是甲、乙、丙、丁、戊、己、庚、辛、壬、癸十个循环计序符号，常与地支配合使用。"),
        ("十天干的顺序", "十天干按甲乙丙丁戊己庚辛壬癸排列，循环使用时可表示序号、日序和干支组合位置。"),
        ("天干与地支的关系", "天干为十，地支为十二，两者按顺序相配形成六十组干支，用于传统历法和纪时表达。"),
        ("天干与纪日", "天干最常见的基础功能是计序，尤其在干支纪日和历法文本中承担循环标记作用。"),
        ("天干与阴阳", "十天干可分阴阳：甲丙戊庚壬多作阳干，乙丁己辛癸多作阴干。这里的阴阳是分类语言。"),
        ("天干与五行", "天干常按甲乙木、丙丁火、戊己土、庚辛金、壬癸水配入五行系统。"),
        ("甲乙与东方木", "甲乙常与木、东方、春的象征系统相连，适合用于理解天干与五行、方位的配属。"),
        ("丙丁与南方火", "丙丁常与火、南方、夏的象征系统相连，体现天干配属中的明亮和温热意象。"),
        ("戊己与中央土", "戊己常与土、中央、承载和调和的意象相连，是十干中承接四方的一组。"),
        ("庚辛与西方金", "庚辛常与金、西方、秋的象征系统相连，强调收敛、成形和整理。"),
        ("壬癸与北方水", "壬癸常与水、北方、冬的象征系统相连，强调流动、涵养和归藏。"),
        ("天干的使用边界", "天干条目用于学习传统历法和分类语言，不用于断定个人经历或现实结果。"),
    ]
    for index, (title, summary) in enumerate(core_topics, start=1):
        rows.append(article(
            article_id=f"heavenly_curated_core_{index:02d}",
            category="天干",
            title=title,
            summary=summary,
            body=f"问题：{title}\n\n参考解读：{summary}在 DestinyScope 中，天干内容只用于文化学习和概念解释，帮助用户认识传统文本中的计序符号。",
            tags=["天干", "干支", "传统文化"],
            scenes=["ganzhi_foundation", "traditional_culture"],
            source_keys=("天干", "天文训"),
            boundary_text=boundary_text,
            source_version=source_version,
        ))

    for stem in STEMS:
        per_stem = [
            (f"{stem['name']}在天干中的序位", f"{stem['name']}是十天干第{stem['order']}位，适合先作为循环计序符号理解。"),
            (f"{stem['name']}的阴阳属性", f"{stem['name']}常归为{stem['yinYang']}干。这里的阴阳用于说明分类倾向，不是现实评价。"),
            (f"{stem['name']}的五行方位", f"{stem['name']}常配{stem['element']}，方位上归入{stem['direction']}，可与{stem['group']}同组学习。"),
            (f"{stem['name']}与{stem['pair']}的同组关系", f"{stem['name']}与{stem['pair']}构成{stem['group']}一组，常共同表达{stem['element']}的阴阳两面。"),
            (f"{stem['name']}的文化意象边界", f"{stem['name']}可借{stem['image']}来辅助记忆，但这种意象只服务于学习，不给出现实判断。"),
        ]
        for sub_index, (title, summary) in enumerate(per_stem, start=1):
            rows.append(article(
                article_id=f"heavenly_curated_{stem['pinyin']}_{sub_index:02d}",
                category="天干",
                title=title,
                summary=summary,
                body=f"问题：{title}\n\n参考解读：{summary}学习时可以把序位、阴阳、五行、方位四个层次分开看：先记符号，再看配属，最后再读具体文本。",
                tags=["天干", stem["name"], stem["element"], stem["yinYang"]],
                scenes=["ganzhi_foundation", "traditional_culture"],
                source_keys=("天干", "天文训"),
                boundary_text=boundary_text,
                source_version=source_version,
            ))
    return rows


def earthly_branch_articles(boundary_text: str, source_version: str) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    core_topics = [
        ("地支是什么", "地支是子、丑、寅、卯、辰、巳、午、未、申、酉、戌、亥十二个循环计序符号。"),
        ("十二地支的顺序", "十二地支按子丑寅卯辰巳午未申酉戌亥排列，循环使用，可用于传统历法和时辰表达。"),
        ("地支与十二辰", "地支与十二辰有关，反映古人用十二分位整理时间和空间的方式。"),
        ("地支与十二时辰", "十二时辰以地支标记一天中的十二个时段，是传统计时语言，不等于现代精密时钟制度。"),
        ("地支与月建", "地支可用于表示月令位置，如寅常与春初相连。学习时应理解其为历法分类。"),
        ("地支与方位", "地支可配十二方位或二十四方位，帮助古人把时间节律和空间方向放在同一套符号中。"),
        ("地支与季节", "寅卯辰多归春，巳午未多归夏，申酉戌多归秋，亥子丑多归冬，是学习地支的基础分组。"),
        ("地支与五行", "地支可配五行：寅卯木、巳午火、申酉金、亥子水，辰戌丑未多作土看。"),
        ("地支与天干组合", "十天干与十二地支按顺序相配，形成六十组干支，体现两个循环周期的组合。"),
        ("地支与生肖的边界", "生肖常借地支表示，但知识库只把它作为传统文化对应，不把生肖用作现实判断。"),
        ("地支与六十甲子", "地支参与六十甲子组合，是传统纪年纪日的重要基础。理解组合规则比记结论更重要。"),
        ("地支的使用边界", "地支条目用于学习传统计时、方位和分类语言，不用于预测个人经历或替代现实判断。"),
    ]
    for index, (title, summary) in enumerate(core_topics, start=1):
        rows.append(article(
            article_id=f"earthly_curated_core_{index:02d}",
            category="地支",
            title=title,
            summary=summary,
            body=f"问题：{title}\n\n参考解读：{summary}在 DestinyScope 中，地支用于帮助用户理解传统文化符号和历法表达，不生成现实结论。",
            tags=["地支", "干支", "传统文化"],
            scenes=["ganzhi_foundation", "traditional_culture"],
            source_keys=("地支", "天干"),
            boundary_text=boundary_text,
            source_version=source_version,
        ))

    for branch in BRANCHES:
        per_branch = [
            (f"{branch['name']}在地支中的序位", f"{branch['name']}是十二地支第{branch['order']}位，适合作为循环序号和传统时空符号学习。"),
            (f"{branch['name']}与十二时辰", f"{branch['name']}时通常对应{branch['time']}这一传统时段，用于理解古代时辰表达。"),
            (f"{branch['name']}的季节方位五行", f"{branch['name']}常配{branch['season']}、{branch['direction']}、{branch['element']}，阴阳属性多记为{branch['yinYang']}。"),
            (f"{branch['name']}与生肖对应的边界", f"{branch['name']}常与生肖{branch['zodiac']}相配，但这里仅作传统符号对应，不用来推断个人现实情况。"),
        ]
        for sub_index, (title, summary) in enumerate(per_branch, start=1):
            rows.append(article(
                article_id=f"earthly_curated_{branch['pinyin']}_{sub_index:02d}",
                category="地支",
                title=title,
                summary=summary,
                body=f"问题：{title}\n\n参考解读：{summary}学习地支时，可把顺序、时辰、季节、方位、五行分层记忆，避免把符号对应当作确定性判断。",
                tags=["地支", branch["name"], branch["element"], branch["season"]],
                scenes=["ganzhi_foundation", "traditional_culture"],
                source_keys=("地支", "天干"),
                boundary_text=boundary_text,
                source_version=source_version,
            ))
    return rows


def curated_supplement_articles(boundary_text: str, source_version: str) -> list[dict[str, Any]]:
    return [
        *five_elements_articles(boundary_text, source_version),
        *heavenly_stem_articles(boundary_text, source_version),
        *earthly_branch_articles(boundary_text, source_version),
    ]
