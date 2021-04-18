/// <reference path="../node_modules/@workadventure/iframe-api-typings/iframe_api.d.ts" />

let toiletPopup: any;

// toilet-trigger
WA.onEnterZone('toilet-trigger', () => {
  toiletPopup = WA.openPopup('toiletPopup', 'Bitte 2x Spülen!', [{
    label: "Close",
    className: "primary",
    callback: (popup) => {
      // Close the popup when the "Close" button is pressed.
      popup.close();
    }
  }]);
});
WA.onLeaveZone('toilet-trigger', () => {
  if (toiletPopup) {
    toiletPopup.close();
  }
});
