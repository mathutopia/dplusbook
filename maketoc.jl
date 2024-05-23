
function split_num_name(str)
	m = match(r"(\d+)(.*)", str)
	if isnothing(m)
		return nothing
	else
		return m.captures[1], m.captures[2]
    end
end

	
render_row(chpn, secn, title, url) = """
      <li class="level-2"> <a href=$(url)> $(chpn).$(secn)  $title </a> </li>
    """


	"""
    is_pluto_file
判断一个文件是否是一个pluto写的文件
"""

function is_pluto_file(fl)
    firstline = readline(fl)
    return occursin("Pluto.jl", firstline)
end


"""
    extract_title->title
从一个pluto写的文件中提取其标题。默认情况下， 把正文的第一个md字符串中第一个#符号之后的内容当成是标题
"""
function extract_title(fl)
    @assert is_pluto_file(fl) "这不是一个Pluto写的jl文件"
    mdfind = false
    poundfind = false
    for line in eachline(fl)
        if !mdfind && startswith( line, "md\"\"\"")
            mdfind = true
            continue
        end
        
        if mdfind && !poundfind
            poundfind = startswith(line, "# ")
            if poundfind
                # 为什么会匹配到空格， 暂时没明白
               m = match(r"^\s*(?:#\s*(.*?)\s*$|$)", line)
               if m === nothing || m.match === ""  
                    ### 应该还要判断是否一个md结束了，结束的话要重新设置mdfind。
                    continue
               else
                    return m.captures[1]
               end
            end
        end
    end    
end

function make_toc(dir = ".")
	git = "https://mathutopia.github.io/dplusbook/"
	toc="""
	<!DOCTYPE html>
    <html lang="zh-CN">
    <head>
    <meta charset="UTF-8">
    <title>书籍目录</title>
	<style>
        /* 简单的样式，用于区分一级和二级目录 */
        #toc ul {
            list-style-type: none; /* 移除默认的列表符号 */
            padding-left: 0;
        }
        #toc li {
            margin-bottom: 5px;
        }
        #toc .level-1 {
            font-weight: bold;
        }
        #toc .level-2 {
            margin-left: 20px;
            font-weight: normal;
        }
    </style>
    </head>
    <body>
	<h1>数据挖掘</h1>
    <h2>目录</h2>
	<div id="toc">
        <ul>
            <li class="level-1">
	"""
	fls = readdir(dir)
	chpnames = filter(startswith(r"\d+"), fls)
	for chp in chpnames
		println(chp)
		chpnum, chpname = split_num_name(chp)
		toc *= "第$(chpnum)章 $(chpname) \n <ul>"
		fls = readdir(joinpath(dir, chp))
		for file in fls 
			if is_pluto_file(joinpath(dir, chp, file))
				fn = file[1:end-3]
				secnum, secname = split_num_name(fn)
				title = extract_title(joinpath(dir, chp, file))
				url = joinpath(git, chp, fn)
				toc *= render_row(chpnum, secnum, title, url)
			end
		end
		toc *="""</ul>
            </li>""" # 结束每一章
	end
	
	toc *= """
		</ul>
	    </div>
	</body>
</html>
	"""
	toc
end

write("index.html", make_toc());
