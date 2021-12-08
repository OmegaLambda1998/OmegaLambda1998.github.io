const { jsPDF } = window.jspdf;

function htmltopdf() {
    const pdf = document.getElementById("pdf");
    const pdfWidth = pdf.offsetWidth;
    var hide = document.getElementsByClassName("hide");

    if (pdf) {
        var doc = new jsPDF("portrait", "pt", "a4");
        var docWidth = doc.internal.pageSize.getWidth();
        var new_scale = docWidth / pdfWidth;
        for (var i = 0; i < hide.length; i++){
            hide[i].style.display = 'none';
        }
        doc.html(pdf, {
            callback: function (doc) {
                doc.save('PatrickArmstrongResume.pdf');
                for (var i = 0; i < hide.length; i++){
                    hide[i].style.display = 'inline-block';
                };
            },
            html2canvas: {
                scale: new_scale
            },
            filename: "PatrickArmstrongResume",
        });
    }
}
