function generatePDF() {
    var element = document.getElementById("pdf");
    var opt = {
        margin: [0.5, 0.2, 0, 0.2],
        filename: "PatrickArmstrongResume.pdf",
        html2canvas: { scale: 2 },
        jsPDF: { orientation: "portrait", unit: "in", format: "a4" },
        pagebreak: { before: ".break", mode: "avoid-all" }
    }
    html2pdf().set(opt).from(element).save()
}
