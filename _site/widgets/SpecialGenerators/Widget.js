// javascript for controlling Special Generator WebMap
// written by Bill Hereth February 2022

var dChartX = [2019, 2030, 2040, 2050];

var dMapDisplayZones = [
  { label: "TAZ"            , value: "CO_TAZID"    , minScaleForLabels:   80000 },
  { label: "Medium District", value: "COFIPS_DMED" , minScaleForLabels: 1280000 },
  { label: "Large District" , value: "COFIPS_DLRG" , minScaleForLabels: 1920000 }
];

var dVolumeOrPercent = [
  { label: "Trips Ends", value: "V"},
  { label: "Percent"   , value: "P" }
];

var dTableValues = [
  { label: "Trips Ends", value: "V"},
  { label: "Factors"   , value: "F"}
];

var dDayPartColors = ["#0ea7b5","#e8702a","#ffbe4f"];

var sDayType = "1"; // 1:Weekdays
var sDayPart = "0"; // 1:All Day
var sDataPer = "1"; // 1:All Year
var sSpecGen = "UOFU_MAIN";
var sMapDisp = "COFIPS_DMED";
var sVol_Per = "P";
var sTablVal = "V";


var wSG;

// ATO Variables
var curSpecGen = sSpecGen;
var curMapDisp = sMapDisp;
var curDayType = sDayType;
var curDataPer = sDataPer;
var curDayPart = sDayPart;
var curVol_Per = sVol_Per;
var curTablVal = sTablVal;
var lyrTAZ;
var lyrDispLayers = []      ;
var sDispLayers   = []      ; // layer name for all display layers (filled programatically)
var sTAZLayer   = "TAZ"     ; // layer name for TAZs
var sCDefaultGrey = "#CCCCCC"   ; // color of default line
var sFNSGTAZID  = "SA_TAZID"  ; // field name for TAZID
var chartkey    = []      ;
var chartdata   = []      ;

var specgen = [];
var daypart = [];
var daytype = [];
var dataper = [];

var minScaleForLabels = 87804;
var labelClassOn;
var labelClassOff;
var sCWhite     = "#FFFFFF";
var sCHighlight = "#FFB6C1";
var dHaloSize = 2.0;

var bindata;

var iPixelSelectionTolerance = 5;

var WIDGETPOOLID_LEGEND = 0;

define(['dojo/_base/declare',
    'jimu/BaseWidget',
    'jimu/LayerInfos/LayerInfos',
    'dijit/registry',
    'dojo/dom',
    'dojo/dom-style',
    'dijit/dijit',
    'dojox/charting/Chart',
    'dojox/charting/themes/Claro',
    'dojox/charting/SimpleTheme',
    'dojox/charting/plot2d/Markers',
    'dojox/charting/plot2d/Columns',
    'dojox/charting/plot2d/ClusteredColumns',
    'dojox/charting/widget/Legend',
    'dojox/charting/action2d/Tooltip',
    'jimu/PanelManager',
    'dijit/form/TextBox',
    'dijit/form/ToggleButton',
    'jimu/LayerInfos/LayerInfos',
    'esri/tasks/query',
    'esri/tasks/QueryTask',
    'esri/layers/FeatureLayer',
    'esri/dijit/FeatureTable',
    'esri/symbols/SimpleFillSymbol',
    'esri/symbols/SimpleLineSymbol',
    'esri/symbols/SimpleMarkerSymbol',
    'esri/symbols/TextSymbol',
    'esri/symbols/Font',
    'esri/layers/LabelClass',
    'esri/InfoTemplate',
    'esri/Color',
    'esri/map',
    'esri/renderers/ClassBreaksRenderer',
    'esri/geometry/Extent',
    'esri/geometry/Point',
    'dojo/store/Memory',
    'dojox/charting/StoreSeries',
    'dijit/Dialog',
    'dijit/form/Button',
    'dijit/form/RadioButton',
    'dijit/form/MultiSelect',
    'dojox/form/CheckedMultiSelect',
    'dijit/form/Select',
    'dijit/form/ComboBox',
    'dijit/form/CheckBox',
    'dojo/store/Observable',
    'dojox/charting/axis2d/Default',
    'dojox/grid/DataGrid',
    'dojo/data/ObjectStore',
    'dojo/domReady!'],
function(declare, BaseWidget, LayerInfos, registry, dom, domStyle, dijit, Chart, Claro, SimpleTheme,  Markers, Columns, ClusteredColumns, Legend, Tooltip, PanelManager, TextBox, ToggleButton, LayerInfos, Query, QueryTask, FeatureLayer, FeatureTable, SimpleFillSymbol, SimpleLineSymbol, SimpleMarkerSymbol, TextSymbol, Font, LabelClass, InfoTemplate, Color, Map, ClassBreaksRenderer, Extent, Point, Memory, StoreSeries, Dialog, Button, RadioButton, MutliSelect, CheckedMultiSelect, Select, ComboBox, CheckBox, Observable, DataGrid, ObjectStore) {
  // To create a widget, you need to derive from BaseWidget.
  
  return declare([BaseWidget], {
    // DemoWidget code goes here

    // please note that this property is be set by the framework when widget is loaded.
    // templateString: template,

    baseClass: 'jimu-widget-demo',
    
    postCreate: function() {
      this.inherited(arguments);
      console.log('postCreate');
    },

    startup: function() {
      console.log('startup');
      
      this.inherited(arguments);
      this.map.setInfoWindowOnClick(false); // turn off info window (popup) when clicking a feature
      
      // Widen the widget panel to provide more space for charts
      // var panel = this.getPanel();
      // var pos = panel.position;
      // pos.width = 500;
      // panel.setPosition(pos);
      // panel.panelManager.normalizePanel(panel);
      
      wSG = this;

      // when zoom finishes run changeZoom to update label display
      wSG.map.on("zoom-end", function (){  
        wSG._changeZoom();  
      });  


      // Get Special Generators
      dojo.xhrGet({
        url: "widgets/SpecialGenerators/data/specgen.json",
        handleAs: "json",
        load: function(obj) {
          /* here, obj will already be a JS object deserialized from the JSON response */
          console.log('specgen.json');
          specgen = obj;
          var cmbSpecGen = new Select({
            id: "selectSpecGen",
            name: "selectSpecGenName",
            options: specgen,
            onChange: function(){
              curSpecGen = this.value;
              wSG._panToSpecGen();
              wSG._updateDisplayLayer();
              wSG._setLegendBar();
              wSG._updateSeason();
              wSG._updateTimeOfDay();
            }
          }, "cmbSpecGen");
          cmbSpecGen.startup();
          cmbSpecGen.set("value",sSpecGen);
          wSG._initializeDisplayLayers();
        },
        error: function(err) {
            /* this will execute if the response couldn't be converted to a JS object,
                or if the request was unsuccessful altogether. */
        }
      });

      // Map display zones
      var _cmbMapDisplayZone = new Select({
        id: "selectMapDisplayZone",
        name: "selectMapDisplayZoneName",
        options: dMapDisplayZones,
        onChange: function(){
          curMapDisp = this.value;
          wSG._updateDisplayLayer();
          wSG._setLegendBar();
        }
      }, "cmbMapDisplayZone");
      _cmbMapDisplayZone.startup();
      _cmbMapDisplayZone.set("value",sMapDisp);

      // Table value type
      var _cmbTableValues = new Select({
        id: "selectValue",
        name: "selectValueName",
        options: dTableValues,
        onChange: function(){
          curTablVal = this.value;
          wSG._updateSeason();
          wSG._updateTimeOfDay();
        }
      }, "cmbTableValues");
      _cmbTableValues.startup();
      _cmbTableValues.set("value",sTablVal);

      // create radio buttons for both display of labels and symbology
      wSG._createRadioButtons(dVolumeOrPercent,"divVolumeOrPercentSection"   ,"vol_per"    , sVol_Per    );

      // Get DayType
      dojo.xhrGet({
        url: "widgets/SpecialGenerators/data/codes_daytype.json",
        handleAs: "json",
        load: function(obj) {
          /* here, obj will already be a JS object deserialized from the JSON response */
          console.log('codes_daytype.json');
          daytype = obj;
          wSG._createRadioButtons(daytype,"divDayTypeSection","daytype",sDayType);
          wSG._updateSeason();
          wSG._updateTimeOfDay();
        },
        error: function(err) {
            /* this will execute if the response couldn't be converted to a JS object,
                or if the request was unsuccessful altogether. */
        }
      });
      // Get DataPer
      dojo.xhrGet({
        url: "widgets/SpecialGenerators/data/codes_dataper.json",
        handleAs: "json",
        load: function(obj) {
          /* here, obj will already be a JS object deserialized from the JSON response */
          console.log('codes_dataper.json');
          dataper = obj;
          wSG._createRadioButtons(dataper,"divDataPerSection","dataper",sDataPer);
          wSG._updateSeason();
          wSG._updateTimeOfDay();
        },
        error: function(err) {
            /* this will execute if the response couldn't be converted to a JS object,
                or if the request was unsuccessful altogether. */
        }
      });
      // Get DayParts
      dojo.xhrGet({
        url: "widgets/SpecialGenerators/data/codes_daypart.json",
        handleAs: "json",
        load: function(obj) {
          /* here, obj will already be a JS object deserialized from the JSON response */
          console.log('codes_daypart.json');
          daypart = obj;
          wSG._createRadioButtons(daypart,"divDayPartSection","daypart",sDayPart);
          wSG._updateSeason();
          wSG._updateTimeOfDay();
        },
        error: function(err) {
            /* this will execute if the response couldn't be converted to a JS object,
                or if the request was unsuccessful altogether. */
        }
      });

      // Populate BinData Object
      dojo.xhrGet({
        url: "widgets/SpecialGenerators/data/bindata.json",
        handleAs: "json",
        load: function(obj) {
          /* here, obj will already be a JS object deserialized from the JSON response */
          console.log('bindata.json');
          bindata = obj;
          // _CurDisplayItem = dDisplayOptions.filter( function(dDisplayOptions){return (dDisplayOptions['value']==curDisplay);} );
          wSG._setLegendBar();
          wSG._updateDisplayLayer();
        },
        error: function(err) {
          /* this will execute if the response couldn't be converted to a JS object,
            or if the request was unsuccessful altogether. */
        }
      });

      
      // Check box change events
      dom.byId("chkLabels").onchange = function(isChecked) {
        wSG._checkLabel();
      };
      

      // Create the chart within it's "holding" node
      // Global so users can hit it from the console
      chartDaily = new Chart("chartDaily", {
        title: "Average Daily Trip Ends by Season",
        subtitle: "for Selected Zone",
        titlePos: "top",
        titleFont: "normal normal bold 9pt Verdana",
        titleGap: 5
      });
  

      
      // Set the theme
      //chartDaily.setTheme(myTheme);
  
      // Add the only/default plot 
      chartDaily.addPlot("default", {type: "ClusteredColumns", gap:5})
        .addAxis("x",
          { 
            minorTickStep: 1,
            majorTickStep: 1,
            font: "normal normal normal 6.5pt Verdana",
            //title: "Season",
            //titleOrientation: "away",
            //titleFont: "normal normal normal 10pt Verdana",
            //titleGap: 5,
            clusterGap: 10,
            labels: [
              {value:1, text:"All Year"},
              {value:2, text:"Fall"},
              {value:3, text:"Winter"},
              {value:4, text:"Spring"},
              {value:5, text:"Summer"}
            ]
          }
        )
        .addAxis("y",
          {
            vertical: true,
            min: 0 ,
            title : "Trip Ends"
          }
        )

        // color table legend
        if (typeof dDayPartColors !== 'undefined') {
          for (var i=0; i<=2; i++) {
            dom.byId("divLegend_DayType" + i.toString()).style.backgroundColor = dDayPartColors[i];
          }
        }
        dom.byId("divTableHighlightLegend").style.backgroundColor = sCHighlight;

      // hover over bar to get value
      //var anim_a = new Tooltip(chartDaily, "default");

      // Create the legend
      //legendDaily = new Legend({ chart: chartDaily, horizontal: false }, "legendDaily");

      //get dat for table
      dojo.xhrGet({
        url: "widgets/SpecialGenerators/data/SpecGenTAZ_SLDailyTotals.json",
        handleAs: "json",
        load: function(obj) {
          /* here, obj will already be a JS object deserialized from the JSON response */
          console.log('SpecGenTAZ_SLDailyTotals.json');
          dlytot = obj;

          //Populate dowFactors DataStore
          storedlytot = Observable(new Memory({
          data: {
            identifier: "SpecGen",
            items: dlytot
          }
          }));

          wSG._updateSeason();
          wSG._updateTimeOfDay();
        },
        error: function(err) {
          /* this will execute if the response couldn't be converted to a JS object,
            or if the request was unsuccessful altogether. */
        }
      }); 
      wSG._changeZoom();
       

      //get dat for table - time of day
      dojo.xhrGet({
        url: "widgets/SpecialGenerators/data/SpecGenTAZ_SLTimeOfDayVolumes.json",
        handleAs: "json",
        load: function(obj) {
          /* here, obj will already be a JS object deserialized from the JSON response */
          console.log('SpecGenTAZ_SLTimeOfDayVolumes.json');
          todtot = obj;

          //Populate dowFactors DataStore
          storetodtot = Observable(new Memory({
          data: {
            identifier: "SpecGen",
            items: todtot
          }
          }));
          wSG._updateSeason();
          wSG._updateTimeOfDay();
        },
        error: function(err) {
          /* this will execute if the response couldn't be converted to a JS object,
            or if the request was unsuccessful altogether. */
        }
      }); 
      wSG._changeZoom();
    },


    _updateSeason: function(){
      console.log('_updateSeason');

      var _arrayDayTypeSeries = [];
      var _arrayDayTypeXDataPerVolumes = [];

      var _normalizevolume;

      //TPR CODE type, part, period
      //get data for entire day, daypart_code = 0
      if (specgen.length>0 && daytype.length>0 && dataper.length>0 && daypart.length>0 && typeof dlytot !== 'undefined') {
        _normalizevolume = 1;
        daytype.forEach((T) => {
          _ssVolume = new StoreSeries(storedlytot, { query: { SpecGen: curSpecGen, daytype_code: T.daytype_code, daypart_code: 0}}, "Volume");
          _arrayDayTypeSeries.push(_ssVolume)

          // Add the series of data
          chartDaily.addSeries(T.daytype_code,_ssVolume,{stroke: {color:"white", width : "1"}, fill: dDayPartColors[T.daytype_code]});

          _arrayTPRVolume = [];
          dataper.forEach((R) => {
            var _tprcode = "divTPR" + T.daytype_code.toString() + "0" + R.dataper_code.toString();
            var _volumerecord = dlytot.filter( function(dlytot){return (dlytot.SpecGen==curSpecGen && dlytot.daytype_code==T.daytype_code && dlytot.dataper_code==R.dataper_code);} );
            // should only be one value
            if (_volumerecord.length>0) {
              _tpr_volume = _volumerecord[0]['Volume'];
              if (T.daytype_code==0 && R.dataper_code==1) {
                _normalizevolume = _tpr_volume
              }
              if (curTablVal=="V") {
                dom.byId(_tprcode).innerHTML = this._numberWithCommas(Math.round(_tpr_volume/100)*100);
              } else if (curTablVal=="F") {
                dom.byId(_tprcode).innerHTML = (_tpr_volume / _normalizevolume).toFixed(2);
              }
              if (T.daytype_code==curDayType && curDayPart==0 && R.dataper_code==curDataPer) {
                dom.byId(_tprcode).style.backgroundColor = sCHighlight;
              } else {
                dom.byId(_tprcode).style.backgroundColor = sCWhite;
              }
            }
          });
        });
      }
      chartDaily.title = "2019 Average Daily Trip to/from " + curSpecGen + " TAZ";
      chartDaily.resize(330, 250);
      chartDaily.render();
      //legendDaily.refresh();
    },

    _updateTimeOfDay: function(){
      console.log('_updateTimeOfDay');
      //TPR CODE type, part, period
      //get data for time of day by each season

      if (specgen.length>0 && daytype.length>0 && dataper.length>0 && daypart.length>0 && typeof todtot !== 'undefined' && typeof dlytot !== 'undefined') {
        daytype.forEach((T) => {
          //_ssVolume = new StoreSeries(storedlytot, { query: { SpecGen: curSpecGen, daytype_code: T.daytype_code, daypart_code: 0}}, "Volume");
          //_arrayDayTypeSeries.push(_ssVolume)
          daypart.forEach((P) => {
            dataper.forEach((R) => {
              if (R.dataper_code==curDataPer) {
                dom.byId("tblDataPer" + R.dataper_code.toString()).style.display = 'block';
                dom.byId("divDataPerTitle").innerHTML = "<strong>Average Period Trips to/from " + curSpecGen +  " TAZ - " + R.data_period.substring(3) + "</strong>";
              } else {
                dom.byId("tblDataPer" + R.dataper_code.toString()).style.display = 'none';
              }
              var _volumerecord = todtot.filter( function(todtot){return (todtot.SpecGen==curSpecGen && todtot.daytype_code==T.daytype_code && todtot.daypart_code==P.daypart_code && todtot.dataper_code==R.dataper_code);} );
              // should only be one value
              if (_volumerecord.length>0) {
                _tprcode    = "divTPR" + T.daytype_code.toString() + P.daypart_code.toString() + R.dataper_code.toString();
                _tpr_volume = _volumerecord[0]['Volume'];
                if (curTablVal=="V") {
                  dom.byId(_tprcode).innerHTML = this._numberWithCommas(Math.round(_tpr_volume/100)*100);
                } else if (curTablVal=="F") {
                  var _volumerecord_day = dlytot.filter( function(dlytot){return (dlytot.SpecGen==curSpecGen && dlytot.daytype_code==T.daytype_code && dlytot.dataper_code==R.dataper_code);} );
                  _tpr_volume_day = _volumerecord_day[0]['Volume'];
                  dom.byId(_tprcode).innerHTML = (100*_tpr_volume/_tpr_volume_day).toFixed(0) + "%";
                }
                if (T.daytype_code==curDayType && P.daypart_code==curDayPart && R.dataper_code==curDataPer) {
                  dom.byId(_tprcode).style.backgroundColor = sCHighlight;
                } else {
                  dom.byId(_tprcode).style.backgroundColor = sCWhite;
                }
              }
            });
          });
        });
      }
    },

    _initializeDisplayLayers: function(){
      console.log('_initializeDisplayLayers');

      for (_specgen in specgen) {
        for (_mapdisp in dMapDisplayZones) {
          _name = specgen[_specgen]['value'] + "_gdb - "  + (specgen[_specgen]['value'] + " " + dMapDisplayZones[_mapdisp]['value']).replace(/_/g, ' ');
          sDispLayers.push(_name);
        }
      }

      // Initialize Selection Layer, FromLayer, and ToLayer and define selection colors
      var layerInfosObject = LayerInfos.getInstanceSync();
      for (var j=0, jl=layerInfosObject._layerInfos.length; j<jl; j++) {
        var currentLayerInfo = layerInfosObject._layerInfos[j];    
        if (currentLayerInfo.title == sTAZLayer) {
          lyrTAZ = layerInfosObject._layerInfos[j].layerObject;
        }
      }
      // populate arrays of layers for display
      for (s in sDispLayers) {
        var layerInfosObject = LayerInfos.getInstanceSync();
        for (var j=0, jl=layerInfosObject._layerInfos.length; j<jl; j++) {
          var currentLayerInfo = layerInfosObject._layerInfos[j];    
          if (currentLayerInfo.title == (sDispLayers[s])) { // must mach layer title
            // push layer into array
            lyrDispLayers.push(layerInfosObject._layerInfos[j].layerObject);
          }
        }
      }
      wSG._updateDisplayLayer();
    },

    _createRadioButtons: function(dData,sDiv,sName,sCheckedValue) {
      console.log('_createRadioButtons');
      
      var _divRBDiv = dom.byId(sDiv);
          
      for (d in dData) {
    
        // define if this is the radio button that should be selected
        if (dData[d].value == sCheckedValue) {
          bChecked = true;
        } else {
          bChecked = false;
        }
        
        // radio button id
        _rbID = "rb_" + sName + dData[d].value

        // radio button object
        var _rbRB = new RadioButton({ name:sName, label:dData[d].label, id:_rbID, value: dData[d].value, checked: bChecked});
        _rbRB.startup();
        _rbRB.placeAt(_divRBDiv);

        // radio button label
        var _lblRB = dojo.create('label', {
          innerHTML: dData[d].label,
          for: _rbID
        }, _divRBDiv);
        
        // place radio button
        dojo.place("<br/>", _divRBDiv);
    
        // Radio Buttons Change Event
        dom.byId(_rbID).onchange = function(isChecked) {
          console.log("radio button onchange");
          if(isChecked) {
            _strValue = this.id.charAt(this.id.length - 1);
            // check which group radio button is in and assign cur value accordingly
            switch(this.name) {
              case 'daytype'    : curDayType     = _strValue; break;
              case 'dataper'    : curDataPer     = _strValue; break;
              case 'daypart'    : curDayPart     = _strValue; break;
              case 'vol_per'    : curVol_Per     = _strValue; break;
            }
            wSG._updateRenderer();
            wSG._updateSeason();
            wSG._updateTimeOfDay();
            wSG._setLegendBar();
          }
        }
      }
    },

    _numberWithCommas: function(x) {
      return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },

    _updateRenderer: function() {
      console.log('_updateRenderer');

      if (typeof bindata !== 'undefined') {

        curLayer = this._getCurDispLayerLoc();

        var _defaultLine;
        // create renderer for display layers
        switch(curMapDisp) {
          case 'CO_TAZID'    : defaultLine =  new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, Color.fromHex(sCDefaultGrey), 0.5) ; break;
          case 'COFIPS_DMED' : defaultLine =  new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, Color.fromHex(sCDefaultGrey), 3.0) ; break;
          case 'COFIPS_DLRG' : defaultLine =  new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, Color.fromHex(sCDefaultGrey), 3.0) ; break;
        }
        
        
        // construct field name
        _fieldname =  wSG._getDisplayFieldName();

        // initialize renderer with field name for current bin based on current area
        var _Rndr = new ClassBreaksRenderer(null, _fieldname);
        
        for (var i=1; i<=9; i++) {
          _id = curMapDisp + '_' + curVol_Per + '_' + i.toString();
          _Rndr.addBreak({minValue: bindata[_id].minValue, maxValue: bindata[_id].maxValue,   symbol: new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, defaultLine, Color.fromHex(bindata[_id].Color)), label: bindata[_id].Description});
        }

        if (curLayer >= 0) {
          lyrDispLayers[curLayer].setRenderer(_Rndr);
          lyrDispLayers[curLayer].setOpacity(0.65);
          lyrDispLayers[curLayer].refresh();
        }

        wSG._changeZoom();
        wSG._checkLabel();
      }

    },

    _getDisplayFieldName: function() {
      return curVol_Per.toLowerCase() + '_' + curDayType + curDayPart + curDataPer;
    },

    _getCurDispLayerLoc: function() {
      _curLayerName = curSpecGen + "_gdb - "  + (curSpecGen + " " + curMapDisp).replace(/_/g, ' ');
      for (l in lyrDispLayers) {
        if (lyrDispLayers[l].arcgisProps.title == _curLayerName)
          return l;
      }
      return -1;
    },

    _hideAllDispLayers: function() {
      for (l in lyrDispLayers) {
        lyrDispLayers[l].hide();
      }
    },

    _updateDisplayLayer: function() {
      console.log('_updateDisplayLayer');
      wSG._hideAllDispLayers();
      if (curSpecGen != '' && curMapDisp != '' && curDayType != '' && curDataPer != '' && curDayPart != '') {
        wSG._updateRenderer();
        var _loc = wSG._getCurDispLayerLoc()
        if (_loc >= 0) {
          lyrDispLayers[_loc].show();
        }
      }
    },
    
    _setLegendBar: function() {
      console.log('setLegendBar');

      var _curSpecGen = "";
      var _curDayType = "";
      var _curDataPer = "";
      var _curDayPart = "";

      if (specgen.length>0 && daytype.length>0 && dataper.length>0 && daypart.length>0) {
        _curSpecGen = specgen.filter( function(specgen){return (specgen['value']==curSpecGen);} );
        _curDayType = daytype.filter( function(daytype){return (daytype['value']==curDayType);} );
        _curDataPer = dataper.filter( function(dataper){return (dataper['value']==curDataPer);} );
        _curDayPart = daypart.filter( function(daypart){return (daypart['value']==curDayPart);} );

        var _displaytext = '';
        if (curVol_Per=="P") {
          _displaytext = "Percent of Total Trips to/from "
        } else if (curVol_Per=="V") {
          _displaytext = "Number of Trip Ends to/from "
        }
  
        var _sLegend = '<strong>' + _displaytext + _curSpecGen[0]['label'] + " TAZ<br/>" + _curDataPer[0]['label'] + " - " +  _curDayType[0]['label'] + " - " + _curDayPart[0]['label'] + '</strong>';
  
        dom.byId("LegendName").innerHTML = _sLegend;
  
        if (typeof bindata !== 'undefined') {
          for (var i=1; i<=9; i++) {
            _id = curMapDisp + '_' + curVol_Per + '_' + i.toString();
            dom.byId("divColor" + (i).toString()).style.backgroundColor = bindata[_id].Color;
          }
        }
        dom.byId("divDetailsTitle").innerHTML = '<br/><strong>' + _curSpecGen[0]['label'] + " StreetLight Summary Tables" + '</strong><br/><br/>';
      } else {
        dom.byId("divDetailsTitle").innerHTML = '&nbsp;';
      }
    },

    _showLegend: function(){
      console.log('_showLegend');
      var pm = PanelManager.getInstance();
      var bOpen = false;
    
      // Close Legend Widget if open
      for (var p=0; p < pm.panels.length; p++) {
        if (pm.panels[p].label == "Legend") {
          if (pm.panels[p].state != "closed") {
            bOpen=true;
            pm.closePanel(pm.panels[p]);
          }
        }
      }
    
      // Open Legend Widget if not open
      if (!bOpen) {
        pm.showPanel(wSG.appConfig.widgetPool.widgets[WIDGETPOOLID_LEGEND]);
      }
    },

    _panToSpecGen: function() {
      console.log('_panToSpecGen');

      
      queryTask = new esri.tasks.QueryTask(lyrTAZ.url);
      
      query = new esri.tasks.Query();
      query.returnGeometry = true;
      query.outFields = ["*"];
      query.where = sFNSGTAZID + "='" + wSG._getCurSpecGenTAZID() + "' AND SUBAREAID=1"; // ONLY SETUP FOR WASATCH FRONT AREA
      
      queryTask.execute(query, showResults);
      
      function showResults(featureSet) {
        
        var feature, featureId;
        
        // QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.
        
        if (featureSet.features[0].geometry.type == "polyline" || featureSet.features[0].geometry.type == "polygon") { 
          // clearing any graphics if present. 
          wSG.map.graphics.clear(); 
          newExtent = new Extent(featureSet.features[0].geometry.getExtent()) 
          for (i = 0; i < featureSet.features.length; i++) { 
            var graphic = featureSet.features[i]; 
            var thisExtent = graphic.geometry.getExtent(); 

            // making a union of extent or previous feature and current feature. 
            newExtent = newExtent.union(thisExtent); 
            var _sfs = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID,
              new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
              new Color([255,255,0]), 5),new Color([255,255,0,0.25])
            );
            graphic.setSymbol(_sfs); 
            //graphic.setInfoTemplate(popupTemplate); 
            wSG.map.graphics.add(graphic); 
          } 

          if (dom.byId("chkAutoPan").checked == true) {
            // zoom to new extent
            //wSG.map.setExtent(newExtent.expand(1.5));
            // pan to center of TAZ
            wSG.map.centerAt(newExtent.getCenter()); //recenters the map based on a map coordinate.
          }
        }
      }
    },

    _getCurSpecGenTAZID: function() {
      _curSGData = specgen.filter( function(specgen){return (specgen['value']==curSpecGen);} );
      return _curSGData[0][sFNSGTAZID]; 
    },

    _changeZoom: function(){
      console.log('_changeZoom');
      dScale = wSG.map.getScale();
      if (dScale < wSG._getMinScaleForLabels()) {
        // enable the checkbox
        dom.byId("SG_Labels").style.display = "inline";
      } else {
        // diable the checkbox
        dom.byId("SG_Labels").style.display = 'none';
      }
    },

    _getMinScaleForLabels: function() {
      _curMapDisplayZone = dMapDisplayZones.filter( function(dMapDisplayZones){return (dMapDisplayZones['value']==curMapDisp);} );
      return _curMapDisplayZone[0]['minScaleForLabels']; 
    },

    _checkLabel: function() {
      console.log('_checkLabel');

      // create a text symbol to define the style of labels
      var volumeLabel = new TextSymbol();
      volumeLabel.font.setSize("8pt");
      volumeLabel.font.setFamily("arial");
      volumeLabel.font.setWeight(Font.WEIGHT_BOLD);
      volumeLabel.setHaloColor(sCWhite);
      volumeLabel.setHaloSize(dHaloSize);

      // Setup empty volume label class for when toggle is off
      labelClassOff = ({
        minScale: wSG._getMinScaleForLabels(),
        labelExpressionInfo: {expression: ""}
      })
      labelClassOff.symbol = volumeLabel;
    
      _exp = "";

      if (curVol_Per == 'P') {
        _exp = "Text($feature[\"" + wSG._getDisplayFieldName() + "\"],'#.00%')";
      } else if (curVol_Per == 'V') {
        _exp = "Text($feature[\"" + wSG._getDisplayFieldName() + "\"],'#,##0')";
      }

      // Create a JSON object which contains the labeling properties. At the very least, specify which field to label using the labelExpressionInfo property. Other properties can also be specified such as whether to work with coded value domains, fieldinfos (if working with dates or number formatted fields, and even symbology if not specified as above)
      labelClassOn = {
        minScale: wSG._getMinScaleForLabels(),
        labelExpression: "[" + wSG._getDisplayFieldName() + "]",
        labelExpressionInfo: {expression: _exp}
      };
      labelClassOn.symbol = volumeLabel;
       
      if (dom.byId("chkLabels").checked == true) {
        lyrDispLayers[wSG._getCurDispLayerLoc()].setLabelingInfo([ labelClassOn ]);
      } else {
        lyrDispLayers[wSG._getCurDispLayerLoc()].setLabelingInfo([ labelClassOff]);
      }
      
    },

    onOpen: function(){
      console.log('onOpen');
    },

    onClose: function(){
      // this.ClickClearButton();
      console.log('onClose');
    },

    onMinimize: function(){
      console.log('onMinimize');
    },

    onMaximize: function(){
      console.log('onMaximize');
    },

    onSignIn: function(credential){
      /* jshint unused:false*/
      console.log('onSignIn');
    },

    onSignOut: function(){
      console.log('onSignOut');
    },

    // added from Demo widget Setting.js
    setConfig: function(config){
      // this.textNode.value = config.districtfrom;
    var test = "";
    },

    getConfigFrom: function(){
      // WAB will get config object through this method
      return {
        // districtfrom: this.textNode.value
      };
    }

  });
});