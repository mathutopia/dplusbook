lianx(text) = Markdown.MD(Markdown.Admonition("tip", "❓ 动手试一试", [text])) # 绿色
fenge(text) = Markdown.MD(Markdown.Admonition("tip", "", [text])) # 绿色
attention(text) = Markdown.MD(Markdown.Admonition("warning", "⚡ 注 意", [text])) # 黄色
danger(text) = Markdown.MD(Markdown.Admonition("danger", "💣 危 险", [text])) # 红色
hint(text) = Markdown.MD(Markdown.Admonition("hint", "💡提示", [text])) # 蓝色
kuoz(text) = Markdown.MD(Markdown.Admonition("tip", "📗 扩展", [text])) # 绿色
