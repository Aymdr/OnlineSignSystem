function  cancelPDF() {
    document.getElementById("flag").value="resetPDF";
    document.forms[0].submit();
}

function  previewPDF() {
    document.getElementById("flag").value="previewPDF";
    document.forms[0].submit();
}
function downloadPDF() {
    document.getElementById("flag").value="downloadPDF";
    document.forms[0].submit();
}