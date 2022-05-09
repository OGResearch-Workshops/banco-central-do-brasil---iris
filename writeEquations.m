%% Write selected equations to markdown file 

close all
clear

load mat/createModel.mat m

file = string.empty(0, 1);

title = struct();
title.world = "World economy module";
title.trends = "Long-term trends module";
title.local = "Local economy module";

lhs = struct();
lhs.world = ["l_gdp_ww_gap=", "r_ww=", "dl_cpi_ww=+"];
lhs.trends = ["dl_gdp_tnd=+", "dl_rex_tnd=+", "rr_tnd=+", "rr_tnd-prem_tnd=", "rr_ww_tnd=", "r_tnd="];
lhs.local = ["l_gdp_gap=+", "dl_cpi=+", "dl_cpi_ste=+", "r_tar=+", "rr=", "r-prem+int=", "l_ex_ste="];

file = string.empty(0, 1);

file = [
    file
    "# Key model equations"
    ""
];


%% Loop over modules 

for module = ["trends", "local", "world"]
    file = [
        file
        "## " + title.(module)
    ];
    for n = lhs.(module)
        [e, d] = findEquation(m, @startsWith, n);
        file = [
            file
            "#### " + d
            ""
            "$$"
            convertEquation(m, e)
            "$$"
            ""
            "---"
            ""
        ];
    end
end

file = join(file, newline());
textual.write(file, "docs/key-model-equations.md");

return


function output = convertEquation(model, input)
    %(
    output = input;
    if contains(output, "!!")
        output = strip(extractBefore(output, "!!"));
    end
    tokens = regexp(output, "\<[a-zA-Z]\w*\>", "match");
    tokens = unique(tokens);
    aliases = access(model, "name-aliases-struct");
    for n = textual.stringify(tokens)
        if startsWith(n, "c")
            x = "c_{" + erase(extractBefore(n, "_"), "c") + "}";
        elseif startsWith(n, "shock_")
            x = "\varepsilon_t";
        elseif startsWith(n, "tune_")
            x = "\omega_t";
        elseif startsWith(n, "ss_")
            x = aliases.(extractAfter(n, "ss_")) + "_{\mathrm{ss}}";
        else
            x = aliases.(n)+"_{t}";
        end
        output = regexprep( ...
            output, "\<"+n+"\>" ...
            , regexptranslate("escape", x) ...
        );
    end
    output = replace(output, "*", "\,");
    output = replace(output, "=+", "=");
    output = replace(output, "(+", "(");
    output = replace(output, "[+", "[");
    output = replace(output, "}{-", "-");
    output = replace(output, "}{+", "+");
    output = replace(output, "}{", "+");
    output = replace(output, "(", "\left(");
    output = replace(output, ")", "\right)");
    output = replace(output, "[", "\left[");
    output = replace(output, "]", "\right]");
    output = erase(output, ";");
    %)
end%

