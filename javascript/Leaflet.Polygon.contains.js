/*
    Polygon.contains -method for Leaflet maps.

    Extends the polygon object with a raycasting contains check. Give
    it a latLng object or an array and it'll give you true / false depending
    on whether the point is inside the polygon or not.
 */
L.Polygon.prototype.contains = function(latLng) {

    // Convert to LatLng if needed
    if(L.Util.isArray(latLng)) {
        latLng = new L.LatLng(latLng[0], latLng[1]);
    }

    // First check if we're even inside the bounds
    var bounds = this.getBounds();
    if(bounds != null && !bounds.contains(latLng)) {
        return false;
    }

    // Raycast point in polygon method
    var points = this.getLatLngs();
    var inPoly = false;
    var j = points.length-1;

    for(var i=0; i < points.length; i++) {
        var vertex1 = points[i];
        var vertex2 = points[j];

        if(vertex1.lng < latLng.lng && vertex2.lng >= latLng.lng || vertex2.lng < latLng.lng && vertex1.lng >= latLng.lng) {
            if(vertex1.lat + (latLng.lng - vertex1.lng) / (vertex2.lng - vertex1.lng) * (vertex2.lat - vertex1.lat) < latLng.lat) {
                inPoly = !inPoly;
            }
        }
        j = i;
    }

    return inPoly;
};