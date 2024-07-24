// Initialize and add the map
function initMap() {
    // The location of the bounce house
    var location = { lat: parseFloat(document.getElementById('latitude').value), lng: parseFloat(document.getElementById('longitude').value) };
    
    // The map, centered at the bounce house location
    var map = new google.maps.Map(
      document.getElementById('map'), { zoom: 15, center: location }
    );
    
    // The marker, positioned at the bounce house location
    var marker = new google.maps.Marker({ position: location, map: map });
  }
  
  // Event listener for map initialization
  document.addEventListener("DOMContentLoaded", function() {
    if (document.getElementById('map')) {
      initMap();
    }
  });
  