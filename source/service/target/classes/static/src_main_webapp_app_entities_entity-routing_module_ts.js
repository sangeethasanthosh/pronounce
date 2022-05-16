"use strict";
(self["webpackChunkpronounce"] = self["webpackChunkpronounce"] || []).push([["src_main_webapp_app_entities_entity-routing_module_ts"],{

/***/ 1094:
/*!***************************************************************!*\
  !*** ./src/main/webapp/app/entities/entity-routing.module.ts ***!
  \***************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "EntityRoutingModule": () => (/* binding */ EntityRoutingModule)
/* harmony export */ });
/* harmony import */ var _angular_router__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/router */ 2816);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ 3184);



class EntityRoutingModule {
}
EntityRoutingModule.ɵfac = function EntityRoutingModule_Factory(t) { return new (t || EntityRoutingModule)(); };
EntityRoutingModule.ɵmod = /*@__PURE__*/ _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵdefineNgModule"]({ type: EntityRoutingModule });
EntityRoutingModule.ɵinj = /*@__PURE__*/ _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵdefineInjector"]({ imports: [[
            _angular_router__WEBPACK_IMPORTED_MODULE_1__.RouterModule.forChild([
                {
                    path: 'pronounce',
                    data: { pageTitle: 'Pronounces' },
                    loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("common"), __webpack_require__.e("src_main_webapp_app_entities_pronounce_pronounce_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./pronounce/pronounce.module */ 129)).then(m => m.PronounceModule),
                },
                /* jhipster-needle-add-entity-route - JHipster will add entity modules routes here */
            ]),
        ]] });
(function () { (typeof ngJitMode === "undefined" || ngJitMode) && _angular_core__WEBPACK_IMPORTED_MODULE_0__["ɵɵsetNgModuleScope"](EntityRoutingModule, { imports: [_angular_router__WEBPACK_IMPORTED_MODULE_1__.RouterModule] }); })();


/***/ })

}]);
//# sourceMappingURL=src_main_webapp_app_entities_entity-routing_module_ts.js.map