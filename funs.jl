hint(text) = Markdown.MD(Markdown.Admonition("tip", "💡 提 示", [text])) # 绿色
attention(text) = Markdown.MD(Markdown.Admonition("warning", "⚡ 注 意", [text])) # 黄色
danger(text) = Markdown.MD(Markdown.Admonition("danger", "💣 危 险", [text])) # 红色
note(text) = Markdown.MD(Markdown.Admonition("hint", "📘 笔 记", [text])) # 蓝色

datapath = "data/";