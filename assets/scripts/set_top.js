window.onload = window.onresize =  function() {
    function update_top(sidebar, checkbox, franklin_content)  {
        const height = window.getComputedStyle(sidebar).getPropertyValue('height');
        if (checkbox.checked) {
            franklin_content.style.top = height;
            btn.style.top = height;
        } else {
            franklin_content.style.top = 0;
            btn.style.top = 0;
        };
    };

    const checkbox = document.getElementById("check");
    const sidebar = document.getElementsByClassName('sidebar')[0];
    const franklin_content = document.getElementsByClassName('franklin-content')[0];
    const btn = document.getElementById('btn');
    update_top(sidebar, checkbox, franklin_content);
    
    checkbox.addEventListener('change', function() {update_top(sidebar, checkbox, franklin_content)});
};
