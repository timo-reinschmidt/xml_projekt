function loadXMLDoc(filename) {
    if (window.ActiveXObject) {
        xhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } else {
        xhttp = new XMLHttpRequest();
    }
    xhttp.open("GET", filename, false);
    xhttp.send("");
    return xhttp.responseXML;
}

async function createPdf() {
    // xsl transformation
    let xml = loadXMLDoc('../fo.xml')
    let xsl = loadXMLDoc('../feature-03/fo.xsl')
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    resultDocument = xsltProcessor.transformToFragment(xml, document);

    const serializer = new XMLSerializer();
    const document_fragment_string = serializer.serializeToString(resultDocument);

    // send transformed xml (fo) to backend for api request
    const response = await fetch('/convertToPdf', {
        method: 'POST',
        body: document_fragment_string
    })
    // if request ok -> download pdf-file
    if (response.status === 200) {
        const buffer = await response.arrayBuffer();
        const blob = new Blob([buffer], { type: 'application/pdf' });
        const link = document.getElementById('dummyLink')
        link.href = window.URL.createObjectURL(blob);
        link.download = "mypdfDocument.pdf";
        link.click()
    }
}
