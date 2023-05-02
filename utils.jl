function hfun_loremipsum()
    s = """
    <span>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</span>
    """
end


function hfun_headshot()
    s = """
    <div id="headshot">
    <img src="/assets/images/Full_Logo_Colour5-01.svg" class="headshot_logo">
    <img src="/assets/images/Patrick_Armstrong_Headshot_small.jpg" class="headshot">
    </div>
    """
    return s
end

function hfun_getpage(params)
    list = get_pages(params)
    io = IOBuffer()
    write(io, """<div class="cardparent">""")
    for f in list
        write(io, """<div class="card">""")
        write(io, """<a href="$(replace(replace(f, "index.md"=>""), ".md"=>""))">""")
        write(io, """<div class="cardimg"><img src="$(get_param(f[2:end], "img"))"></div>""")
        write(io, """<div class="cardcontainer">""")
        write(io, """<div class="cardtitle">$(get_param(f[2:end], "title"))</div>""")
        write(io, """<div class="cardsubtitle">$(get_param(f[2:end], "subtitle"))</div>""")
        write(io, """<div class="carddate"><i>$(change_date(mtime(f[2:end])))</i></div>""")
        write(io, """</div>""")
        write(io, """</a>""")
        write(io, """</div>""")
    end
    write(io, "</div>")
    return String(take!(io))
end

function change_date(date)
    dt = Dates.unix2datetime(date)
    Dates.format(dt, "Y-u-d")
end

function get_pages(params)
    final = []
    for filepath in params
        list = readdir(filepath, join=true)
        for f in list
            if isdir(f)
                push!(final, joinpath(f, "index.md"))
            else
                if endswith(f, ".md") && !occursin("index.md", f)
                    push!(final, f)
                end
            end
        end
    end
    final = ["/" * f for f in final]
    dates = map(f -> mtime(f[2:end]), final)
    mask = sortperm(dates)
    final = reverse(final[mask])
    return final
end

function get_param(filename, param)
    raw = open(filename, "r") do io
        return readlines(io)
    end
    filter!(f -> occursin("@def", f), raw)
    filter!(f -> occursin(param, f), raw)
    if length(raw) == 0
        if param == "img"
            return "/assets/images/Logo_Only_Colour.svg"
        end
        return "$param not found"
    end
    rtn = split(raw[1], "=")[end]
    rtn = replace(rtn, "\""=>"")
    return rtn
end
