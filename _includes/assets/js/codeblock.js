---
layout: blank
---
// Grab codeblock div
var codeblocks = document.getElementsByClassName('codeparent');

// Edit every codeblock div
for (var i = 0; i < codeblocks.length; i++) {
    // Add a div around the codeblock
    var codeblock = codeblocks[i];
    var infodiv = document.createElement("DIV");
    infodiv.classList.add("highlight")
    // get the language we use
    var code = codeblock.querySelector('[class^=language-]');
    var language = code.getAttribute("data-lang");
    // Create the language string to be included in the codeblock header
    infodiv.innerHTML = "Language: " + language.charAt(0).toUpperCase() + language.slice(1);
    code.insertBefore(infodiv, code.childNodes[0]);

    // Add offset to line number
    if (codeblock.dataset.offset) {
        var lineno = codeblock.getElementsByClassName("lineno")[0];
        var nums = lineno.innerHTML.split('\n');
        for (var j = 0; j < nums.length; j++) {
            nums[j] = (parseInt(nums[j]) + parseInt(codeblock.dataset.offset) - 1).toString();
        }
        lineno.innerHTML = nums.slice(0, nums.length-1).join("\n");

    }

    // Add highlight to specified line
    if (codeblock.dataset.highlight) {
        innercode = code.querySelector('td.code');
        lines = innercode.innerHTML.split('\n');
        j = parseInt(codeblock.dataset.highlight)
        lines[j] = "<span class = 'internal_highlight'>" + lines[j] + "</span>"; 
        innercode.innerHTML = lines.join("\n");
        var lineno = codeblock.getElementsByClassName("lineno")[0];
        var nums = lineno.innerHTML.split('\n');
        nums[j] = "<span class = 'internal_highlight'>" + nums[j] + "</span>"
        lineno.innerHTML = nums.join("\n")
    }

    // Add download button
    if (codeblock.dataset.download) {
        var result = "<a class='codeblock' href=" + codeblock.dataset.download + ">Download</a> " + infodiv.innerHTML;
        infodiv.innerHTML = result;
    }

    // Bold the given phrase
    if (codeblock.dataset.bold) {
        innercode = code.querySelector('td.code');
        lines = innercode.innerHTML.split('\n')
        for (var j = 0; j < lines.length; j++) {
            if (lines[j].includes(">" + codeblock.dataset.bold + "<")) {
                var newline = lines[j].replace(">" + codeblock.dataset.bold + "<", "><b>" + codeblock.dataset.bold + "</b><");
                lines[j] = newline;
            }
            //lines[j].replace('>'+codeblock.dataset.bold+'<', '><b>'+codeblock.dataset.bold'</b><');
        }
        innercode.innerHTML = lines.join('\n');
        //alert(codeblock.dataset.bold);
    }
}
