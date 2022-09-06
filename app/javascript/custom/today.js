"use strict";

if (document.getElementById("today")) {
    window.location.reload();

    window.addEventListener("DOMContentLoaded", () => {
        let today = new Date();
        today.setDate(today.getDate());
        let year = today.getFullYear();
        let month = ("0" + (today.getMonth() + 1)).slice(-2);
        let day = ("0" + today.getDate()).slice(-2);
        document.getElementById("today").value = `${year}-${month}-${day}`;
    });
}
