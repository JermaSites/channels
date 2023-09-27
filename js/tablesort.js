window.onload = function() {
    // Pull value out of the cell we're comparing
    const getCellValue = (tr, idx) => idx === 0 ? 
        tr.children[idx].textContent : 
        parseFormattedInt(tr.children[idx].textContent);

    // Convert formatted number into sortable numeric one
    function parseFormattedInt(formattedInt) {
        if (formattedInt.includes(".")) {
            return formattedInt
                .replace(".", "")
                .replace("K", "00")
                .replace("M", "00000")
                .replace("B", "00000000");
        } else {
            return formattedInt
                .replace("K", "000")
                .replace("M", "000000")
                .replace("B", "000000000");
        };
    };

    // Compare function for each cell's value
    const comparer = (idx, asc) => (a, b) => ((v1, v2) =>
        v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2) ? v1 - v2 : v1.toString().localeCompare(v2)
    )(getCellValue(asc ? a : b, idx), getCellValue(asc ? b : a, idx));

    // Make clicking a header sort the contents
    document.querySelectorAll('th').forEach(th => th.addEventListener('click', (() => {
        const table = th.closest('table');
        const tbody = table.querySelector('tbody');
        Array.from(tbody.querySelectorAll('tr'))
            .sort(comparer(Array.from(th.parentNode.children).indexOf(th), this.asc = !this.asc))
            .forEach(tr => tbody.appendChild(tr));
    })));
}
