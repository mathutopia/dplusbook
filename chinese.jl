module PTTChinese

using Markdown
using PlutoTeachingTools
abstract type Chinese  <: AbstractLanguage end
struct China <: Chinese end

# computational_thinking.jl
PlutoTeachingTools.hint_str(lang::Lang) where {Lang <: Chinese} = "提示"
PlutoTeachingTools.tip_str(lang::Lang) where {Lang <: Chinese} = "注意"
PlutoTeachingTools.protip_invite_str(lang::Lang) where {Lang <: Chinese} = "想了解更多?"
PlutoTeachingTools.protip_boxlabel_str(lang::Lang) where {Lang <: Chinese} = "Pro Tip"
PlutoTeachingTools.answer_invite_str(lang::Lang) where {Lang <: Chinese} = "想要看答案?"
PlutoTeachingTools.answer_boxlabel_str(lang::Lang) where {Lang <: Chinese} = "答案"
PlutoTeachingTools.almost_str(lang::Lang) where {Lang <: Chinese} = "差不多了!"
PlutoTeachingTools.warning_box_str(lang::Lang) where {Lang <: Chinese} = "警告:"
PlutoTeachingTools.question_box_str(lang::Lang) where {Lang <: Chinese} = "问题:"
PlutoTeachingTools.danger_str(lang::Lang) where {Lang <: Chinese} = "危险:"
PlutoTeachingTools.keyconcept_str(lang::Lang) where {Lang <: Chinese} = "🎯 核心概念"
PlutoTeachingTools.still_missing_str(lang::Lang) where {Lang <: Chinese} = "缺少回应"
PlutoTeachingTools.still_missing_text_str(lang::Lang) where {Lang <: Chinese} = md"把`missing`替换为你的答案."
PlutoTeachingTools.still_nothing_str(lang::Lang) where {Lang <: Chinese} = "让我们开始吧!"
PlutoTeachingTools.still_nothing_text_str(lang::Lang) where {Lang <: Chinese} = md"把 `nothing` 替换为你的答案."
PlutoTeachingTools.wrong_type_str(lang::Lang) where {Lang <: Chinese} = "Type Error"
PlutoTeachingTools.wrong_type_text_str(lang::Lang) where {Lang <: Chinese} = md"Check the type of your response."
PlutoTeachingTools.wrong_type_text_str(lang::Lang, var, type) where {Lang <: Chinese} = md"$var 的类型应该是 $type"
PlutoTeachingTools.func_not_defined_str(lang::Lang) where {Lang <: Chinese} = "糟糕!"
PlutoTeachingTools.func_not_defined_text_str(func_name, lang::Lang) where {Lang <: Chinese} = md"请确定你定义了一个名为 **$(Markdown.Code(string(func_name)))** 的函数。"
PlutoTeachingTools.var_not_defined_str(lang::Lang) where {Lang <: Chinese} = "糟糕!"
PlutoTeachingTools.var_not_defined_text_str(variable_name, lang::Lang) where {Lang <: Chinese} = md"请确定你定义了一个名为 **$(Markdown.Code(string(variable_name)))** 的变量。"
PlutoTeachingTools.keep_working_str(lang::Lang) where {Lang <: Chinese} = "继续加油！"
PlutoTeachingTools.keep_working_text_str(lang::Lang) where {Lang <: Chinese} = md"答案还不太对."
PlutoTeachingTools.keep_working_update_str(var, lang::Lang) where {Lang <: Chinese} = md"确保更新单元格设置 $var."
PlutoTeachingTools.yays(lang::Lang) where {Lang <: Chinese} = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next part."]
PlutoTeachingTools.correct_str(lang::Lang) where {Lang <: Chinese} = "Got it!"
PlutoTeachingTools.todo_str(lang::Lang) where {Lang <: Chinese} = "TODO"

PlutoTeachingTools.check_type_isa_missing_text_str(sym, lang::Lang) where {Lang <: Chinese} = md"变量 $sym 仍然被设置为 missing."
PlutoTeachingTools.check_type_isa_wrong_type_text_str(sym, lang::Lang) where {Lang <: Chinese} = "The type of $sym is not correct.  It should be <: "
PlutoTeachingTools.check_type_isa_wrong_type_one_of_text_str(lang::Lang) where {Lang <: Chinese} = "one of"
PlutoTeachingTools.check_type_isa_wrong_type_or_text_str(lang::Lang) where {Lang <: Chinese} = "or"
PlutoTeachingTools.check_type_isa_not_missing_text_str(sym, lang::Lang) where {Lang <: Chinese} = md"$sym has the correct type."
PlutoTeachingTools.check_type_isa_type_error_str(sym, lang::Lang) where {Lang <: Chinese} = "Type Error"

PlutoTeachingTools.check_type_eq_missing_text_str(sym, lang::Lang) where {Lang <: Chinese} = md"The variable $sym is still set to missing."
PlutoTeachingTools.check_type_eq_wrong_type_single_text_str(sym, type, lang::Lang) where {Lang <: Chinese} = "The type of $sym should be $type."
PlutoTeachingTools.check_type_eq_wrong_type_multi_text_str(sym, lang::Lang) where {Lang <: Chinese} = "The type of $sym should be one of "
PlutoTeachingTools.check_type_eq_type_error_str(lang::Lang) where {Lang <: Chinese} = "Type Error"
PlutoTeachingTools.check_type_eq_correct_str(sym, lang::Lang) where {Lang <: Chinese} = md"$sym has the correct type."

# other.jl
PlutoTeachingTools.full_width_mode_str(lang::Lang) where {Lang <: Chinese} = "全屏模式"

# present.jl
PlutoTeachingTools.present_str(lang::Lang) where {Lang <: Chinese} = "演示"
PlutoTeachingTools.present_mode_str(lang::Lang) where {Lang <: Chinese} = "演示模式"

end
