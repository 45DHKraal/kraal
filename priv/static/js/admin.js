!function(t){function e(r){if(n[r])return n[r].exports;var o=n[r]={i:r,l:!1,exports:{}};return t[r].call(o.exports,o,o.exports,e),o.l=!0,o.exports}var n={};e.m=t,e.c=n,e.d=function(t,n,r){e.o(t,n)||Object.defineProperty(t,n,{configurable:!1,enumerable:!0,get:r})},e.n=function(t){var n=t&&t.__esModule?function(){return t.default}:function(){return t};return e.d(n,"a",n),n},e.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},e.p="",e(e.s=4)}([function(t,e,n){"use strict";!function(){function t(t,e){var n=document.createElement("input");return n.type="hidden",n.name=t,n.value=e,n}function e(e){var n=e.getAttribute("data-confirm");if(!n||window.confirm(n)){var r=e.getAttribute("data-to"),o=t("_method",e.getAttribute("data-method")),i=t("_csrf_token",e.getAttribute("data-csrf")),u=document.createElement("form");u.method="get"===e.getAttribute("data-method")?"get":"post",u.action=r,u.style.display="hidden",u.appendChild(i),u.appendChild(o),document.body.appendChild(u),u.submit()}}window.addEventListener("click",function(t){for(var n=t.target;n&&n.getAttribute;){if(n.getAttribute("data-method"))return e(n),t.preventDefault(),!1;n=n.parentNode}},!1)}()},,,,function(t,e,n){n(5),t.exports=n(6)},function(t,e,n){"use strict";n(0)},function(t,e){}]);
//# sourceMappingURL=admin.js.map