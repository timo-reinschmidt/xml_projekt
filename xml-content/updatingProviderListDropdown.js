let firstLoad = true; // Verhindert den ersten automatischen Aufruf
let isUpdating = false; // Blockiert parallele Updates

/**
 * Aktualisiert die Liste der Anbieter basierend auf der ausgewählten Plant.
 * → JavaScript wird benötigt, da XSLT keine dynamischen DOM-Manipulationen oder asynchrone Serveranfragen ermöglicht.
 */
function updateProviders() {
    if (firstLoad) {
        firstLoad = false;
        return;
    }

    if (isUpdating) {
        return;
    }

    isUpdating = true; // Sperre, um parallele Aufrufe zu vermeiden

    const plantSelect = document.getElementById("plant");
    const providerSelect = document.getElementById("provider");

    if (!plantSelect || !providerSelect) return;

    providerSelect.innerHTML = ""; // Sicherstellen, dass das Dropdown geleert wird

    if (!plantSelect.value) {
        isUpdating = false; // Entsperren
        return;
    }

    fetch(`/getProviders?plant=${encodeURIComponent(plantSelect.value)}`)
        .then(response => response.json())
        .then(providers => {

            // Standardoption einfügen
            const defaultOption = document.createElement("option");
            defaultOption.value = "";
            defaultOption.textContent = "Bitte wählen";
            defaultOption.disabled = true;
            defaultOption.selected = true;
            providerSelect.appendChild(defaultOption);

            // Doppelte Anbieter verhindern
            const uniqueProviders = new Set();
            providers.forEach(providerName => {
                if (!uniqueProviders.has(providerName)) {
                    uniqueProviders.add(providerName);
                    const option = document.createElementNS("http://www.w3.org/1999/xhtml", "option");
                    option.value = providerName;
                    option.textContent = providerName;
                    providerSelect.appendChild(option);
                }
            });

            isUpdating = false; // Entsperren nach Abschluss
        })
        .catch(error => {
            isUpdating = false; // Entsperren auch bei Fehler
        });
}

/**
 * Aktualisiert die Anbieter-Liste für die Entfernen-Funktion.
 * → XSLT kann keine Events auslösen oder das DOM nachträglich anpassen, daher wird JS genutzt.
 */
// Funktion zum Aktualisieren der Anbieter für die Entfernung
let firstLoadRemove = true;
let isUpdatingRemove = false;

function updateProvidersForRemoval() {
    if (firstLoadRemove) {
        firstLoadRemove = false;
        return;
    }

    if (isUpdatingRemove) {
        return;
    }

    isUpdatingRemove = true; // Sperre, um parallele Aufrufe zu vermeiden

    const plantSelect = document.getElementById("remove-plant");
    const providerSelect = document.getElementById("remove-provider");

    if (!plantSelect || !providerSelect) return;

    providerSelect.innerHTML = ""; // Sicherstellen, dass das Dropdown geleert wird

    if (!plantSelect.value) {
        isUpdatingRemove = false; // Entsperren
        return;
    }

    fetch(`/getProviders?plant=${encodeURIComponent(plantSelect.value)}`)
        .then(response => response.json())
        .then(providers => {

            // Standardoption einfügen
            const defaultOption = document.createElement("option");
            defaultOption.value = "";
            defaultOption.textContent = "Bitte wählen";
            defaultOption.disabled = true;
            defaultOption.selected = true;
            providerSelect.appendChild(defaultOption);

            // Doppelte Anbieter verhindern
            const uniqueProviders = new Set();
            providers.forEach(providerName => {
                if (!uniqueProviders.has(providerName)) {
                    uniqueProviders.add(providerName);
                    const option = document.createElementNS("http://www.w3.org/1999/xhtml", "option");
                    option.value = providerName;
                    option.textContent = providerName;
                    providerSelect.appendChild(option);
                }
            });

            isUpdatingRemove = false; // Entsperren nach Abschluss
        })
        .catch(error => {
            isUpdatingRemove = false; // Entsperren auch bei Fehler
        });
}

/**
 * Initialisiert die Event-Listener für die Dropdowns.
 * → XSLT kann keine Event-Listener verarbeiten, daher wird JS verwendet.
 */
function initEventListeners() {

    const plantDropdown = document.getElementById("plant");
    if (plantDropdown) {
        plantDropdown.removeEventListener("change", updateProviders); // Vorherige Listener entfernen
        plantDropdown.addEventListener("change", updateProviders);
    }

    const removePlantDropdown = document.getElementById("remove-plant");
    if (removePlantDropdown) {
        removePlantDropdown.removeEventListener("change", updateProvidersForRemoval);
        removePlantDropdown.addEventListener("change", updateProvidersForRemoval);
    }
}

// Stelle sicher, dass der Event Listener nur einmal registriert wird
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initEventListeners);
} else {
    initEventListeners();
}