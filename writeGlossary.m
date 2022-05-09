%% Write glossary of variables and parameters to markdown file 

close all
clear

load mat/createModel.mat m

transition = access(m, "transition-variables");
parameters = access(m, "parameters");
s = access(m, "steady");
descriptions = access(m, "name-descriptions-struct");
stationary = access(m, "is-stationary");
tex = access(m, "name-aliases-struct");

title = struct();
title.world = "World economy module";
title.trends = "Long-term trends module";
title.local = "Local economy module";

file = string.empty(0, 1);


%% Write glossary of transition variables 

file = [
    file
    "# Glossary of model variables"
    ""
];

for attribute = ["trends", "local", "world"]
    file = [
        file
        ""
        "## " + title.(attribute)
        ""
        "Variable name | Docs | Description | S/S level | S/S Y/Y"
        "---|---|---|---:|---:"
    ];
    for n = intersect(transition, byAttributes(m, ":"+attribute), "stable")
        if strlength(tex.(n))==0
            tex.(n) = "\cdot";
        end
        if stationary.(n)
            level = sprintf("%.2f", real(s.(n)));
            change = "-";
        else
            level = "-";
            change = sprintf("%.2f", 4*imag(s.(n)));
        end
        file(end+1) = sprintf("`%s`|$%s$|%s|$%s$|$%s$", n, tex.(n), descriptions.(n), level, change);
    end
end


%% Write glossary of parameters 

file = [
    file
    "# Glossary of model parameters"
    ""
];

for attribute = ["world", "trends", "local"]
    file = [
        file
        ""
        "## " + title.(attribute)
        ""
        "Parameter name | Description | Value"
        "---|---|---:"
    ];

    for n = intersect(parameters, byAttributes(m, ":"+attribute), "stable")
        level = sprintf("%.2f", real(s.(n)));
        file(end+1) = sprintf("`%s`|%s|$%s$", n, descriptions.(n), level);
    end

end


%% Write to MD file

file = join(file, newline());
textual.write(file, "docs/glossary-variables-parameters.md");


