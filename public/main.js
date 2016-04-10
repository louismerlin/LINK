const openedChannel = "";

function post(url, data) {
  var postRequest = new XMLHttpRequest();
  postRequest.open('POST', url, true);
  postRequest.send(data);
}

function fetch(url, func) {
  var getRequest = new XMLHttpRequest();
  getRequest.open('GET', url, true);
  getRequest.onerror = function() {
    // There was a connection error of some sort
    console.log('connection error');
  };
  getRequest.onload = function() {
    if (getRequest.status >= 200 && getRequest.status < 400) {
      func(JSON.parse(getRequest.responseText));
    } else {
      // We reached our target server, but it returned an error
      console.log("error from server");
    }
  };
  getRequest.send();
}

function updateData() {
  fetch('channels', function(arg) {
    fillChannels(arg)
  });
  //fetch('channels/'+openedChannel, fillContent());
  //fetch('users/whatever', fillDigest());
}

function fillChannels(data) {
  var panel = '';

  data.forEach(function(value, index) {
    panel += `<div class='channelSelect' id='chS_${value.id}'>
                <p>${value.name}</p>
              </div>`;
  });

  document.getElementById("channelsPanel").innerHTML = panel;

  data.forEach(function(value, index) {
    document.getElementById("chS_" + value.id).onclick = function() {
      selectChannel(value.id)
    };
  })

}

function fillContent(data) {
  var panel = '';

  data.forEach(function(value, index) {
    panel += `<div class='linkBox'>
                <a href="${value.url}">${value.url}</a>
                <p>${value.description}</p>
              </div>`;
  });

  document.getElementById("contentPanel").innerHTML = panel;
}

function fillDigest(data) {

}

function selectChannel(id) {
  fetch('channels/' + id, function(arg) {
    fillContent(arg)
  });
}

function checkLoginStatus(status) {
  if (status) {
    updateData();
    hideLogin();
  } else {
    showLogin();
  }
}

fetch('status', function(arg) {
  checkLoginStatus(arg)
});
