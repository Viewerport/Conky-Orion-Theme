require 'cairo'
require 'cairo_xlib'

function conky_preDraw()
    if conky_window == nil then
        return
    end
    
    local cairo_surface = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)

    local cr = cairo_create(cairo_surface)

    local w = conky_window.width
    local h = conky_window.height
    local margins = conky_window.border_inner_margin
    local yoff = -26

    local pat = cairo_pattern_create_linear(0, 0, 0, h)
    cairo_pattern_add_color_stop_rgba(pat, 0, 216 / 255, 89 / 255, 241 / 255, 1)
    cairo_pattern_add_color_stop_rgba(pat, 1, 243 / 255, 178 / 255, 145 / 255, 1)

    cairo_set_line_width(cr, conky_window.border_width)
    cairo_set_source_rgba(cr, 0, 0, 0, 1)
    cairo_rectangle(cr, margins + 1, margins + 1, w - margins * 2, h - margins * 2)
    cairo_stroke(cr)

    cairo_set_source(cr, pat)
    cairo_rectangle(cr, margins, margins, w - margins * 2, h - margins * 2)
    cairo_stroke(cr)

    cairo_pattern_destroy(pat)
    cairo_destroy(cr)
    cairo_surface_destroy(cairo_surface)
end

function conky_postDraw()
    if conky_window == nil then
        return
    end
    
    local cairo_surface = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    local cr = cairo_create(cairo_surface)

    local w = conky_window.width - conky_window.border_inner_margin * 2 - conky_window.border_outer_margin * 2 - conky_window.border_width * 2
    local margins = conky_window.border_inner_margin + conky_window.border_outer_margin + conky_window.border_width
    local yoff = -26
    local ymult = 43

    cpus = {conky_parse("${cpu cpu1}"), conky_parse("${cpu cpu2}"), conky_parse("${cpu cpu3}"), conky_parse("${cpu cpu4}"), conky_parse("${cpu cpu5}"), conky_parse("${cpu cpu6}"), conky_parse("${cpu cpu7}"), conky_parse("${cpu cpu8}"), conky_parse("${cpu cpu9}"), conky_parse("${cpu cpu10}"), conky_parse("${cpu cpu11}"), conky_parse("${cpu cpu12}")}

    ringR = 20
    ringW = 4

    ringBG = {243 / 255, 178 / 255, 145 / 255, 1}

    ringCLR = {245 / 255, 103 / 255, 32 / 255, 1}

    for i = 1, 6 do
        for j = 1, 2 do
            --Background
            cairo_set_source_rgba(cr, 1, 85 / 255, 0, 0.5)
            cairo_arc(cr, (i - 1) * (((w - ringR - ringW / 2) - (ringR + ringW / 2)) / 5) + ringR + ringW / 2 + margins, j * ymult + 210 + margins + yoff, ringR, math.pi, 0)
            cairo_fill(cr)

            --Background ring
            cairo_set_line_width(cr, ringW)
            cairo_set_source_rgba(cr, ringBG[1], ringBG[2], ringBG[3], ringBG[4])
            cairo_arc(cr, (i - 1) * (((w - ringR - ringW / 2) - (ringR + ringW / 2)) / 5) + ringR + ringW / 2 + margins, j * ymult + 210 + margins + yoff, ringR, math.pi, 0)
            cairo_stroke(cr)

            --CPU ring
            cairo_set_source_rgba(cr, ringCLR[1], ringCLR[2], ringCLR[3], ringCLR[4])
            cairo_arc(cr, (i - 1) * (((w - ringR - ringW / 2) - (ringR + ringW / 2)) / 5) + ringR + ringW / 2 + margins, j * ymult + 210 + margins + yoff, ringR, math.pi, (cpus[i] / 100) * math.pi - math.pi)
            cairo_stroke(cr)

            --Outline
            cairo_select_font_face(cr, "DejaVu Sans Mono", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
            cairo_set_font_size(cr, 10)

            cairo_set_source_rgba(cr, 0, 0, 0, 1)

            local text3 = "CPU" .. tostring(i + ((j - 1) * 6))
            local extents = cairo_text_extents_t:create()
            cairo_text_extents(cr, text3, extents)

            cairo_move_to(cr, (i - 1) * (((w - ringR - ringW / 2) - (ringR + ringW / 2)) / 5) + ringR + ringW / 2 - extents.width / 2 + margins + 1, j * ymult + 216 + margins + yoff)
            cairo_show_text(cr, text3)
            cairo_stroke(cr)

            local text4 = tostring(cpus[i + ((j - 1) * 6)]) .. "%"
            local extents = cairo_text_extents_t:create()
            cairo_text_extents(cr, text4, extents)

            cairo_move_to(cr, (i - 1) * (((w - ringR - ringW / 2) - (ringR + ringW / 2)) / 5) + ringR + ringW / 2 - extents.width / 2 + margins + 1, j * ymult + 206 + margins + yoff)
            cairo_show_text(cr, text4)
            cairo_stroke(cr)

            --Text
            cairo_set_source_rgba(cr, ringBG[1], ringBG[2], ringBG[3], ringBG[4])

            local text1 = "CPU" .. tostring(i + ((j - 1) * 6))
            local extents = cairo_text_extents_t:create()
            cairo_text_extents(cr, text1, extents)

            cairo_move_to(cr, (i - 1) * (((w - ringR - ringW / 2) - (ringR + ringW / 2)) / 5) + ringR + ringW / 2 - extents.width / 2 + margins, j * ymult + 215 + margins + yoff)
            cairo_show_text(cr, text1)
            cairo_stroke(cr)

            local text2 = tostring(cpus[i + ((j - 1) * 6)]) .. "%"
            local extents = cairo_text_extents_t:create()
            cairo_text_extents(cr, text2, extents)

            cairo_move_to(cr, (i - 1) * (((w - ringR - ringW / 2) - (ringR + ringW / 2)) / 5) + ringR + ringW / 2 - extents.width / 2 + margins, j * ymult + 205 + margins + yoff)
            cairo_show_text(cr, text2)
            cairo_stroke(cr)
        end
    end
    
    cairo_destroy(cr)
    cairo_surface_destroy(cairo_surface)
end

function conky_cpuIndividual()
    output = ""
    for i = 1, 12 do
        local value = "${CPU cpu " .. i .. "}"
        local bar = "$alignr${cpubar cpu" .. i .. " 6, 210}\n"

        output = output .. "CPU " .. tostring(i) .. ": " .. conky_parse(value) .. "% " .. tostring(bar)
    end

    return output
end

function conky_top5CPU()
    output = ""
    for i = 1, 5 do
        local value = "${top name " .. i .. "}${top pid " .. i .. "}${top cpu " .. i .. "}% ${top mem_res " .. i .. "}"
        if i < 5 then
            output = output .. value .. "\n"
        else
            output = output .. value
        end
    end
    return output
end
