"use strict";

if (document.querySelectorAll(".today")) {
    window.addEventListener('DOMContentLoaded', () => {
        let today = new Date();
        today.setDate(today.getDate());
        let year = today.getFullYear();
        let month = ("0" + (today.getMonth() + 1)).slice(-2);
        let day = ("0" + today.getDate()).slice(-2);
        let target = document.querySelectorAll(".today");
        target.forEach((t) => {
            t.value = `${year}-${month}-${day}`;
        });
    });
}
