function htmltopdf() {
var doc = new jsPDF();
var elementHTML = $('#pdf').html();

doc.fromHTML(elementHTML, 15, 15)

doc.save("PatrickArmstrongResume.pdf")
}
