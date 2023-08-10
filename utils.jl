import GitHub

function get_repos()
    api = GitHub.DEFAULT_API
    auth = GitHub.authenticate(ENV["GITHUB_TOKEN"])
    user = GitHub.whoami(api; auth=auth)
    repos = GitHub.repos(api, user; auth=auth)
    return repos
end

function hfun_getrepos()
    repos = [repo for repo in get_repos()[1] if (!repo.fork && !repo.private)]

    reverse!(sort!(repos; lt=(x, y) -> x.created_at < y.created_at))
    io = IOBuffer()
    write(io, """<div class="cardparent">""")
    for repo in repos
        write(io, """<div class="card">""")
        if repo.has_pages && (repo.name != "OmegaLambda1998.github.io")
            write(io, """<a href="/$(repo.name)/">""")
        else
            write(io, """<a href="$(repo.html_url)">""")
        end
        write(io, """<div class="cardimg"><img src="$(get_default_img())"></div>""")
        write(io, """<div class="cardcontainer">""")
        write(io, """<div class="cardtitle">$(repo.name)</div>""")
        if !isnothing(repo.description)
            write(io, """<div class="cardsubtitle">$(repo.description)</div>""")
        end
        write(io, """<div class="carddate"><i>$(Dates.format(repo.created_at, "Y-u-d"))</i></div>""")
        write(io, """</div>""")
        write(io, """</a>""")
        write(io, """</div>""")
    end
    write(io, "</div>")
    return String(take!(io))
end


function hfun_gettalks()
    archive_dir = "$(@__DIR__)/_assets/archive/"
    files = readdir(archive_dir, join=true)
    io = IOBuffer()
    write(io, """<div class="cardparent">""")
    for f in files
        if splitext(f)[end] in [".pdf"]
            fname = splitext(basename(f))[1]
            oname = "$(@__DIR__)/_assets/archive/$(replace(basename(f), ".pdf" => "-%03d.png"))"
            name = replace(fname, "_" => " ")
            cardimg = "/assets/archive/$(replace(basename(f), ".pdf" => "-001.png"))"
            if !isfile(replace(oname, "-%03d" => "-001"))
                cmd = string.(split("gs -sDEVICE=pngalpha -sPageList=1 -o $(oname) -r144 $(f)"))
                run(Cmd(cmd))
            end
            write(io, """<div class="card">""")
            write(io, """<a href="/assets/archive/$(basename(f))">""")
            write(io, """<div class="cardimg"><img src="$(cardimg)"></div>""")
            write(io, """<div class="cardcontainer">""")
            write(io, """<div class="cardtitle">$(name)</div>""")
            write(io, """<div class="carddate"><i>$(change_date(mtime(f)))</i></div>""")
            write(io, """</div>""")
            write(io, """</a>""")
            write(io, """</div>""")
        end
    end
    write(io, "</div>")
    return String(take!(io))
end


function hfun_loremipsum()
    s = """
    <span>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</span>
    """
    return s
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
        write(io, """<a href="$(replace(replace(f, "index.md" => ""), ".md" => ""))/">""")
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
            return get_default_img()
        end
        return "$param not found"
    end
    rtn = split(raw[1], "=")[end]
    rtn = replace(rtn, "\"" => "")
    return rtn
end

function get_default_img()
    return "/assets/images/Logo_Only_Colour.svg"
end
