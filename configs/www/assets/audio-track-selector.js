(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory(require("Clappr"));
	else if(typeof define === 'function' && define.amd)
		define(["Clappr"], factory);
	else if(typeof exports === 'object')
		exports["AudioTrackSelector"] = factory(require("Clappr"));
	else
		root["AudioTrackSelector"] = factory(root["Clappr"]);
})(this, function(__WEBPACK_EXTERNAL_MODULE_2__) {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "<%=baseUrl%>/";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';Object.defineProperty(exports,'__esModule',{value:true});exports['default'] = __webpack_require__(1);module.exports = exports['default'];

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';Object.defineProperty(exports,'__esModule',{value:true});var _createClass=(function(){function defineProperties(target,props){for(var i=0;i < props.length;i++) {var descriptor=props[i];descriptor.enumerable = descriptor.enumerable || false;descriptor.configurable = true;if('value' in descriptor)descriptor.writable = true;Object.defineProperty(target,descriptor.key,descriptor);}}return function(Constructor,protoProps,staticProps){if(protoProps)defineProperties(Constructor.prototype,protoProps);if(staticProps)defineProperties(Constructor,staticProps);return Constructor;};})();var _get=function get(_x2,_x3,_x4){var _again=true;_function: while(_again) {var object=_x2,property=_x3,receiver=_x4;_again = false;if(object === null)object = Function.prototype;var desc=Object.getOwnPropertyDescriptor(object,property);if(desc === undefined){var parent=Object.getPrototypeOf(object);if(parent === null){return undefined;}else {_x2 = parent;_x3 = property;_x4 = receiver;_again = true;desc = parent = undefined;continue _function;}}else if('value' in desc){return desc.value;}else {var getter=desc.get;if(getter === undefined){return undefined;}return getter.call(receiver);}}};function _interopRequireDefault(obj){return obj && obj.__esModule?obj:{'default':obj};}function _classCallCheck(instance,Constructor){if(!(instance instanceof Constructor)){throw new TypeError('Cannot call a class as a function');}}function _inherits(subClass,superClass){if(typeof superClass !== 'function' && superClass !== null){throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass);}subClass.prototype = Object.create(superClass && superClass.prototype,{constructor:{value:subClass,enumerable:false,writable:true,configurable:true}});if(superClass)Object.setPrototypeOf?Object.setPrototypeOf(subClass,superClass):subClass.__proto__ = superClass;}var _Clappr=__webpack_require__(2);var _publicAudioTrackSelectorHtml=__webpack_require__(3);var _publicAudioTrackSelectorHtml2=_interopRequireDefault(_publicAudioTrackSelectorHtml);var _publicStyleScss=__webpack_require__(4);var _publicStyleScss2=_interopRequireDefault(_publicStyleScss);var AUTO=-1;var AudioTrackSelector=(function(_UICorePlugin){_inherits(AudioTrackSelector,_UICorePlugin);function AudioTrackSelector(){_classCallCheck(this,AudioTrackSelector);_get(Object.getPrototypeOf(AudioTrackSelector.prototype),'constructor',this).apply(this,arguments);}_createClass(AudioTrackSelector,[{key:'bindEvents',value:function bindEvents(){ //console.log(' Audio-Track bindEvents');
	this.listenTo(this.core,_Clappr.Events.CORE_READY,this.bindPlaybackEvents);this.listenTo(this.core.mediaControl,_Clappr.Events.MEDIACONTROL_CONTAINERCHANGED,this.reload);this.listenTo(this.core.mediaControl,_Clappr.Events.MEDIACONTROL_RENDERED,this.render);this.listenTo(this.core.mediaControl,_Clappr.Events.MEDIACONTROL_HIDE,this.hideSelectLevelMenu);}},{key:'unBindEvents',value:function unBindEvents(){ //console.log(' Audio-Track unBindEvents');
	this.stopListening(this.core,_Clappr.Events.CORE_READY);this.stopListening(this.core.mediaControl,_Clappr.Events.MEDIACONTROL_CONTAINERCHANGED);this.stopListening(this.core.mediaControl,_Clappr.Events.MEDIACONTROL_RENDERED);this.stopListening(this.core.mediaControl,_Clappr.Events.MEDIACONTROL_HIDE);this.stopListening(this.core.getCurrentPlayback(),_Clappr.Events.PLAYBACK_LEVELS_AVAILABLE);this.stopListening(this.core.getCurrentPlayback(),_Clappr.Events.PLAYBACK_LEVEL_SWITCH_START);this.stopListening(this.core.getCurrentPlayback(),_Clappr.Events.PLAYBACK_LEVEL_SWITCH_END);this.stopListening(this.core.getCurrentPlayback(),_Clappr.Events.PLAYBACK_BITRATE);}},{key:'bindPlaybackEvents',value:function bindPlaybackEvents(){ //console.log(' Audio-Track bindPlaybackEvents');
	var currentPlayback=this.core.getCurrentPlayback();this.listenTo(currentPlayback,_Clappr.Events.PLAYBACK_LEVELS_AVAILABLE,this.fillLevels); //this.listenTo(currentPlayback, Events.PLAYBACK_LEVEL_SWITCH_START, this.startLevelSwitch)
	//this.listenTo(currentPlayback, Events.PLAYBACK_LEVEL_SWITCH_END, this.stopLevelSwitch)
	this.listenTo(currentPlayback,_Clappr.Events.PLAYBACK_BITRATE,this.updateCurrentLevelVideo); //console.log(' Audio-Track bindPlaybackEvents'+currentPlayback);
	var playbackLevelsAvaialbeWasTriggered=currentPlayback.levels && currentPlayback.levels.length > 0;playbackLevelsAvaialbeWasTriggered && this.fillLevels(currentPlayback.levels);}},{key:'reload',value:function reload(){ //console.log(' Audio-Track reload');
	this.unBindEvents();this.bindEvents();this.bindPlaybackEvents();}},{key:'shouldRender',value:function shouldRender(){ //console.log(' Audio-Track shouldRender');
	if(!this.core.getCurrentContainer())return false;var currentPlayback=this.core.getCurrentPlayback();if(!currentPlayback)return false;var respondsToCurrentLevel=currentPlayback.currentLevel !== undefined; // Only care if we have at least 2 to choose from
	var hasLevels=!!(this.audiotrack && this.audiotrack.length > 1); //console.log(' Audio-Track shouldRender ('+respondsToCurrentLevel+')('+hasLevels+')');
	return respondsToCurrentLevel && hasLevels;}},{key:'render',value:function render(){ //console.log(' Audio-Track render');
	if(this.shouldRender()){var style=_Clappr.Styler.getStyleFor(_publicStyleScss2['default'],{baseUrl:this.core.options.baseUrl});this.$el.html(this.template({'levels':this.audiotrack,'title':this.getTitle()}));this.$el.append(style);this.core.mediaControl.$('.media-control-right-panel').append(this.el);this.highlightCurrentLevel();}return this;}},{key:'fillLevels',value:function fillLevels(levels){var initialLevel=arguments.length <= 1 || arguments[1] === undefined?AUTO:arguments[1]; //console.log(' Audio-Track fillLevels');
	if(this.core.getCurrentPlayback()._hls.audioTracks === undefined)return;if(this.core.getCurrentPlayback()._hls.audioTracks.length == 0)return; //console.log('start filling in audio tracks');
	if(this.selectedLevelId === undefined)this.selectedLevelId = initialLevel; //this.audiotrack = levels
	this.audiotrack = this.core.getCurrentPlayback()._hls.audioTracks; //console.log(this.audiotrack);
	for(var x=0;x < this.audiotrack.length;x++) {this.audiotrack[x].id = x;}for(var x=0;x < this.audiotrack.length;x++) { //console.log (x);
	if(this.audiotrack[x].groupId == this.core.getCurrentPlayback()._hls.streamController.levels[+this.core.getCurrentPlayback()._hls.streamController.level].attrs.AUDIO){ //console.log('a group match, selecting default('+this.audiotrack[x].groupId +')('+this.core.getCurrentPlayback()._hls.streamController.levels[+this.core.getCurrentPlayback()._hls.streamController.level].attrs.AUDIO+')');
	if(this.audiotrack[x]['default'] == true){ //console.log('selecting');
	//console.log(this.audiotrack[x]);
	this.selectedLevelId = x;this.currentLevel = this.audiotrack[this.selectedLevelId];this.core.getCurrentPlayback()._hls.audioTrack = this.selectedLevelId;this.highlightCurrentLevel();}}}this.configureLevelsLabels(); //
	this.render();var group=this.core.getCurrentPlayback()._hls.streamController.levels[this.core.getCurrentPlayback()._hls.streamController.level].attrs.AUDIO;this.agroupElement().addClass('hidden');this.$('.audio_track_selector ul a[data-level-group-selector-select="' + group + '"]').parent().removeClass('hidden');}},{key:'configureLevelsLabels',value:function configureLevelsLabels(){ //console.log(' Audio-Track configureLevelsLabels');
	if(this.core.options.AudioTrackSelectorConfig === undefined)return;for(var levelId in this.core.options.AudioTrackSelectorConfig.labels || {}) { //console.log(' Audio-Track configureLevelsLabels levelId:'+levelId);
	levelId = parseInt(levelId,10);var thereIsLevel=!!this.findLevelBy(levelId);thereIsLevel && this.changeLevelLabelBy(levelId,this.core.options.AudioTrackSelectorConfig.labels[levelId]);}}},{key:'findLevelBy',value:function findLevelBy(id){ //console.log(' Audio-Track findLevelBy');
	//console.log(id);
	//console.log(this.audiotrack);
	var foundLevel;this.audiotrack.forEach(function(level){if(level.id === id){foundLevel = level;}});return foundLevel;}},{key:'changeLevelLabelBy',value:function changeLevelLabelBy(id,newLabel){var _this=this; //console.log(' Audio-Track changeLevelLabelBy');
	this.audiotrack.forEach(function(level,index){if(level.id === id){_this.audiotrack[index].name = newLabel;}});}},{key:'onLevelSelect',value:function onLevelSelect(event){ //console.log(' Audio-Track onLevelSelect ('+event.target.dataset.audioTrackSelectorSelect+')');
	//console.log('||'+event.target.dataset.audioTrackSelectorSelect.substr(6)+'||');
	//     this.selectedLevelId = parseInt(event.target.dataset.audioTrackSelectorSelect.substr(6), 10)
	this.selectedLevelId = event.target.dataset.audioTrackSelectorSelect.substr(6); //console.log(''+this.currentLevel.id+' == '+this.selectedLevelId+'');
	if(this.currentLevel.id == this.selectedLevelId)return false;this.currentLevel = this.audiotrack[this.selectedLevelId]; //console.log(this.audiotrack[this.selectedLevelId]);        
	//console.log(this.core.getCurrentPlayback()._hls);
	//console.log(this.core.getCurrentPlayback()._hls.audioTracks);
	//this.core.getCurrentPlayback()._hls.audioTrack= this.audiotrack[this.selectedLevelId];
	this.core.getCurrentPlayback()._hls.audioTrack = this.selectedLevelId;this.toggleContextMenu();this.highlightCurrentLevel();event.stopPropagation();return false;}},{key:'onShowLevelSelectMenu',value:function onShowLevelSelectMenu(event){this.toggleContextMenu();}},{key:'hideSelectLevelMenu',value:function hideSelectLevelMenu(){this.$('.audio_track_selector ul').hide();}},{key:'toggleContextMenu',value:function toggleContextMenu(){this.$('.audio_track_selector ul').toggle();}},{key:'buttonElement',value:function buttonElement(){return this.$('.audio_track_selector button');}},{key:'levelElement',value:function levelElement(id){return this.$('.audio_track_selector ul a' + (!isNaN(id)?'[data-audio-track-selector-select="audio_' + id + '"]':'')).parent();}},{key:'agroupElement',value:function agroupElement(gid){return this.$('.audio_track_selector ul a' + (!isNaN(gid)?'[data-level-group-selector-select="' + gid + '"]':'')).parent();}},{key:'getTitle',value:function getTitle(){return (this.core.options.AudioTrackSelectorConfig || {}).name;}},{key:'startLevelSwitch',value:function startLevelSwitch(){this.buttonElement().addClass('changing');}},{key:'stopLevelSwitch',value:function stopLevelSwitch(){this.buttonElement().removeClass('changing');}},{key:'updateText',value:function updateText(level){ //console.log(' Audio-Track updateText ('+level+')' );
	if(level === -1){this.buttonElement().text(this.findLevelBy(this.audiotrack[0].id).name);this.selectedLevelId = this.audiotrack[0].id;}else {this.buttonElement().text(this.findLevelBy(this.audiotrack[level].id).name);}}},{key:'updateCurrentLevel',value:function updateCurrentLevel(info){ //    console.log(' Audio-Track updateCurrentLevel');
	//     console.log(info);
	var level=this.findLevelBy(info.id); //     console.log(level);
	this.currentLevel = level?level:null;this.highlightCurrentLevel();}},{key:'updateCurrentLevelVideo',value:function updateCurrentLevelVideo(info){ //console.log(' Audio-Track updateCurrentLevelVideo');
	if(this.audiotrack == undefined)return;if(this.audiotrack.length == 0)return; //console.log(' Audio-Track updateCurrentLevelVideo2');
	var group=this.core.getCurrentPlayback()._hls.streamController.levels[info.level].attrs.AUDIO;this.agroupElement().addClass('hidden');this.$('.audio_track_selector ul a[data-level-group-selector-select="' + group + '"]').parent().removeClass('hidden');for(var x=0;x < this.audiotrack.length;x++) {if(this.audiotrack[x].groupId == this.core.getCurrentPlayback()._hls.streamController.levels[info.level].attrs.AUDIO){ //this.agroupElement(this.audiotrack[x].groupId).removeClass('hidden')        
	//         console.log('a group match, selecting default('+this.audiotrack[x].groupId +')('+this.core.getCurrentPlayback()._hls.streamController.levels[info.level].attrs.AUDIO+')');
	if(this.audiotrack[x]['default'] == true){ //console.log('selecting');
	//console.log(this.audiotrack[x]);
	this.selectedLevelId = x;if(this.currentLevel.id == this.selectedLevelId)return false;this.currentLevel = this.audiotrack[this.selectedLevelId];this.core.getCurrentPlayback()._hls.audioTrack = this.selectedLevelId;this.highlightCurrentLevel();}}} //
	//
	}},{key:'highlightCurrentLevel',value:function highlightCurrentLevel(){ //console.log(' Audio-Track highlightCurrentLevel ('+this.currentLevel.id+')');
	//console.log(this.currentLevel);
	this.levelElement().removeClass('current');this.levelElement(this.currentLevel.id).addClass('current');this.updateText(this.selectedLevelId);}},{key:'name',get:function get(){return 'audio_track_selector';}},{key:'template',get:function get(){return (0,_Clappr.template)(_publicAudioTrackSelectorHtml2['default']);}},{key:'attributes',get:function get(){return {'class':this.name,'data-audio-track-selector':''};}},{key:'events',get:function get(){ //console.log(' Audio-Track events');
	return {'click [data-audio-track-selector-select]':'onLevelSelect','click [data-audio-track-selector-button]':'onShowLevelSelectMenu'};}}],[{key:'version',get:function get(){return VERSION;}}]);return AudioTrackSelector;})(_Clappr.UICorePlugin);exports['default'] = AudioTrackSelector;module.exports = exports['default'];

/***/ },
/* 2 */
/***/ function(module, exports) {

	module.exports = __WEBPACK_EXTERNAL_MODULE_2__;

/***/ },
/* 3 */
/***/ function(module, exports) {

	module.exports = "<button data-audio-track-selector-button>\n  Auto\n</button>\n<ul>\n  <% if (title) { %>\n  <li data-title><%= title %></li>\n  <% }; %>\n  <% for (var i = 0; i < levels.length; i++) { %>\n    <li><a href=\"#\" data-audio-track-selector-select=\"audio_<%= i %>\" data-level-group-selector-select=\"<%= levels[i].groupId %>\"><%= levels[i].name %></a></li>\n  <% }; %>\n</ul>\n";

/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	exports = module.exports = __webpack_require__(5)();
	// imports


	// module
	exports.push([module.id, ".audio_track_selector[data-audio-track-selector] {\n  float: right;\n  margin-top: 5px;\n  position: relative; }\n  .audio_track_selector[data-audio-track-selector] button {\n    background-color: transparent;\n    color: #fff;\n    font-family: Roboto,\"Open Sans\",Arial,sans-serif;\n    -webkit-font-smoothing: antialiased;\n    border: none;\n    font-size: 10px; }\n    .audio_track_selector[data-audio-track-selector] button:hover {\n      color: #c9c9c9; }\n    .audio_track_selector[data-audio-track-selector] button.changing {\n      -webkit-animation: pulse 0.5s infinite alternate; }\n  .audio_track_selector[data-audio-track-selector] > ul {\n    list-style-type: none;\n    position: absolute;\n    bottom: 25px;\n    border: 1px solid black;\n    display: none;\n    background-color: #e6e6e6;\n    white-space: nowrap; }\n  .audio_track_selector[data-audio-track-selector] li {\n    font-size: 10px; }\n    .audio_track_selector[data-audio-track-selector] li[data-title] {\n      background-color: #c3c2c2;\n      padding: 5px; }\n    .audio_track_selector[data-audio-track-selector] li a {\n      color: #444;\n      padding: 2px 10px;\n      display: block;\n      text-decoration: none; }\n      .audio_track_selector[data-audio-track-selector] li a:hover {\n        background-color: #555;\n        color: white; }\n        .audio_track_selector[data-audio-track-selector] li a:hover a {\n          color: white;\n          text-decoration: none; }\n    .audio_track_selector[data-audio-track-selector] li.current a {\n      color: #f00; }\n\n.hidden {\n  display: none; }\n\n@-webkit-keyframes pulse {\n  0% {\n    color: #fff; }\n  50% {\n    color: #ff0101; }\n  100% {\n    color: #B80000; } }\n", ""]);

	// exports


/***/ },
/* 5 */
/***/ function(module, exports) {

	/*
		MIT License http://www.opensource.org/licenses/mit-license.php
		Author Tobias Koppers @sokra
	*/ // css base code, injected by the css-loader
	"use strict";module.exports = function(){var list=[]; // return the list of modules as css string
	list.toString = function toString(){var result=[];for(var i=0;i < this.length;i++) {var item=this[i];if(item[2]){result.push("@media " + item[2] + "{" + item[1] + "}");}else {result.push(item[1]);}}return result.join("");}; // import a list of modules into the list
	list.i = function(modules,mediaQuery){if(typeof modules === "string")modules = [[null,modules,""]];var alreadyImportedModules={};for(var i=0;i < this.length;i++) {var id=this[i][0];if(typeof id === "number")alreadyImportedModules[id] = true;}for(i = 0;i < modules.length;i++) {var item=modules[i]; // skip already imported module
	// this implementation is not 100% perfect for weird media query combinations
	//  when a module is imported multiple times with different media queries.
	//  I hope this will never occur (Hey this way we have smaller bundles)
	if(typeof item[0] !== "number" || !alreadyImportedModules[item[0]]){if(mediaQuery && !item[2]){item[2] = mediaQuery;}else if(mediaQuery){item[2] = "(" + item[2] + ") and (" + mediaQuery + ")";}list.push(item);}}};return list;};

/***/ }
/******/ ])
});
;