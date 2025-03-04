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
    // xsl Transformation
    let xml = loadXMLDoc('../fo.xml')
    let xsl = loadXMLDoc('../feature-03/fo.xsl')
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    resultDocument = xsltProcessor.transformToFragment(xml, document);

    const serializer = new XMLSerializer();
    const document_fragment_string = serializer.serializeToString(resultDocument);

    // Hier wird die convertToPDF Funktion aufgerufen damit wir den Webservice der HSLU anzapfen können.
    // So können wir die FO Transformation für das PDF machen
    const response = await fetch('/convertToPdf', {
        method: 'POST',
        body: document_fragment_string
    })
    // Falls alles in Ordnung -> Download PDF-Datei
    if (response.status === 200) {
        const buffer = await response.arrayBuffer();
        const blob = new Blob([buffer], { type: 'application/pdf' });
        const link = document.getElementById('dummyLink')
        link.href = window.URL.createObjectURL(blob);
        link.download = "mypdfDocument.pdf";
        link.click()
    }
}

async function createCSV() {
    // xsl Transformation
    let xml = loadXMLDoc('../fo.xml')
    let xsl = loadXMLDoc('../feature-03/FOForCSV.xsl')
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    // Transformiertes Dokument
    resultDocument = xsltProcessor.transformToFragment(xml, document);

    const serializer = new XMLSerializer();
    const CSVData = serializer.serializeToString(resultDocument);

    // Hier wird die Transformierte XML als CSV für den Download zur verfügung gestellt.
    // Das uFEFF zwingt das CSV es als UTF-8 zu rendern, ohne das wird das Ü in Zürich nicht richtig dargestellt.
    const blob = new Blob(["\uFEFF" + CSVData], { type: 'text/csv;charset=utf-8' });
    const link = document.getElementById('dummyLinkCSV')
    link.href = window.URL.createObjectURL(blob);
    link.download = "myCSVDocument.CSV";
    link.click()

}
