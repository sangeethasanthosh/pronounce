"use strict";
(self["webpackChunkpronounce"] = self["webpackChunkpronounce"] || []).push([["common"],{

/***/ 4218:
/*!************************************************************!*\
  !*** ./src/main/webapp/app/config/pagination.constants.ts ***!
  \************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "ASC": () => (/* binding */ ASC),
/* harmony export */   "DESC": () => (/* binding */ DESC),
/* harmony export */   "ITEMS_PER_PAGE": () => (/* binding */ ITEMS_PER_PAGE),
/* harmony export */   "SORT": () => (/* binding */ SORT)
/* harmony export */ });
const ITEMS_PER_PAGE = 20;
const ASC = 'asc';
const DESC = 'desc';
const SORT = 'sort';


/***/ }),

/***/ 5929:
/*!**********************************************************!*\
  !*** ./src/main/webapp/app/core/request/request-util.ts ***!
  \**********************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "createRequestOption": () => (/* binding */ createRequestOption)
/* harmony export */ });
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/common/http */ 8784);

const createRequestOption = (req) => {
    let options = new _angular_common_http__WEBPACK_IMPORTED_MODULE_0__.HttpParams();
    if (req) {
        Object.keys(req).forEach(key => {
            if (key !== 'sort') {
                options = options.set(key, req[key]);
            }
        });
        if (req.sort) {
            req.sort.forEach((val) => {
                options = options.append('sort', val);
            });
        }
    }
    return options;
};


/***/ }),

/***/ 6037:
/*!****************************************************!*\
  !*** ./src/main/webapp/app/core/util/operators.ts ***!
  \****************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "filterNaN": () => (/* binding */ filterNaN),
/* harmony export */   "isPresent": () => (/* binding */ isPresent)
/* harmony export */ });
/*
 * Function used to workaround https://github.com/microsoft/TypeScript/issues/16069
 * es2019 alternative `const filteredArr = myArr.flatMap((x) => x ? x : []);`
 */
function isPresent(t) {
    return t !== undefined && t !== null;
}
const filterNaN = (input) => (isNaN(input) ? 0 : input);


/***/ })

}]);
//# sourceMappingURL=common.js.map