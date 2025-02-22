/**
 * Copyright (C) 2015 Klokan Technologies GmbH (info@klokantech.com)
 *
 * The JavaScript code in this page is free software: you can
 * redistribute it and/or modify it under the terms of the GNU
 * General Public License (GNU GPL) as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version.  The code is distributed WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU GPL for more details.
 *
 * USE OF THIS CODE OR ANY PART OF IT IN A NONFREE SOFTWARE IS NOT ALLOWED
 * WITHOUT PRIOR WRITTEN PERMISSION FROM KLOKAN TECHNOLOGIES GMBH.
 *
 * As additional permission under GNU GPL version 3 section 7, you
 * may distribute non-source (e.g., minimized or compacted) forms of
 * that code without the copy of the GNU GPL normally required by
 * section 4, provided you include this license notice and a URL
 * through which recipients can access the Corresponding Source.
 */

/**
 * @author petr.sloup@klokantech.com (Petr Sloup)
 */

goog.provide('kt.decorate');

goog.require('goog.array');
goog.require('goog.dom');

goog.require('kt.CustomMapsControl');
goog.require('kt.DateInput');
goog.require('kt.MultiComplete');
goog.require('kt.Nominatim');
goog.require('kt.OsmNamesAutocomplete');
goog.require('kt.VectorMap');
goog.require('kt.alert');
goog.require('kt.expose');
goog.require('kt.notice');
goog.require('kt.prompt');


/**
 * AUtomatically decorates the elements.
 */
kt.decorate = function() {
  //TODO: decorate controls when it makes sense
  goog.array.forEach(goog.dom.getElementsByClass('autocomplete-nominatim'),
      function(el, i, arr) {
        new kt.Nominatim(el);
      });
};

kt.expose.symbol('kt.decorate', kt.decorate);
