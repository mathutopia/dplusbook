
function generate_html_index()
    # 读取 CSS 文件内容
    css_content = read("styles.css", String)

    # 读取简介文件内容
    intro_content = read("intro.md", String)

    # 获取当前目录下的所有项
    items = readdir(".")

    # 过滤出所有子目录并排序
    subdirs = sort(filter(item -> isdir(item) && item != "." && item != "..", items))

    # 开始构建 HTML 内容
    html_content = """<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset=\"UTF-8\">\n
    <title>Julia数据分析与挖掘</title>\n
    <style>\n$css_content\n</style>\n
    </head>\n<body>\n<div class=\"container\">\n
    <h1>数据分析与挖掘：基于Julia语言</h1>\n$intro_content\n"""

    github = "https://mathutopia.github.io/dplusbook/"

    # 遍历子目录
    for subdir in subdirs
        # 获取子目录下的所有 `.jl` 文件并排序
        jl_files = sort(filter(file -> endswith(file, ".jl"), readdir(subdir)))

        # 如果子目录中有 `.jl` 文件，添加到 HTML 内容中
        if !isempty(jl_files)
            # 添加子目录标题
            html_content *= "<h2>$(basename(subdir))</h2>\n<ul>\n"

            # 为每个 `.jl` 文件创建超链接
            for jl_file in jl_files
                jl_file = jl_file[1:end-3]
                # 创建相对路径链接
                relative_path = github*"$(basename(subdir))/$(jl_file)"
                # 添加超链接到 HTML 内容
                html_content *= "<li><a href=\"$(relative_path)\">$(jl_file)</a></li>\n"
            end
            html_content *= "</ul>\n"
        end
    end

    # 结束 HTML 内容
    html_content *= "</div>\n</body>\n</html>"

    # 写入到 HTML 文件
    open("index.html", "w") do file
        write(file, html_content)
    end

    println("HTML index generated: index.html")
end

# 调用函数
generate_html_index()
