"use strict";

    document.getElementById("taskBtn").addEventListener("click", function () {
        // session 格納
        window.sessionStorage.setItem(["KEY"], ["VALUE"]);

        // session VALUEの取得
        window.sessionStorage.getItem(["KEY"]);

        // 指定session（KEYに基づく）の削除
        window.sessionStorage.removeItem(["KEY"]);

        // 全session 削除
        window.sessionStorage.clear();

        // sessionの数を取得
        window.sessionStorage.length;
    });