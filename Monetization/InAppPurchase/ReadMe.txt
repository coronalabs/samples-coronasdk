This project demonstrates Corona In-App Purchase support. The code attempts to connect to a store such as iTunes or Google's Android Marketplace to retrieve valid product information and handle transactions.

For more informantion on working with In-App purchases in Corona, see our In-App Purchase guide at:
https://docs.coronalabs.com/guide/monetization/IAP/index.html

### Overview of features added in version 1.3

* All the features of the original are retained, but many specific features to testing IAP on Android with our Google IAP v3 plugin have been added. These new features include:
    + Testing with real product IDs.
    + Button to consume all purchases made in this app. This makes all items purchasable again if they were purchased once before.
    + Ability to issue refunds through Google Wallet.
    + Space for more products.
    + Support for transaction states specific to the Google IAP V3 Plugin

#### Real Product Testing

Assuming you've set up your app correctly in Google Play Development Console, Google will process the purchase on their end as if it were real, but the transaction will be cancelled before it can get to financial institutions to actually make a charge. Our sample has a product ID for every type of non-subscription based in-app product that can be purchased through Google Play, plus an invalid one. These are as follows:

    -- A managed product that can only be purchased once per user account. 
    -- Google Play manages the transaction info.
    "iaptesting.managed"

    -- A product that isn't managed by Google Play. 
    -- The app must store transaction info itself.
    -- In Google IAP V3, unmanaged products are treated
    -- like managed products and need to be explicitly consumed.
    "iaptesting.unmanaged"

    -- A bad product ID. For testing what actually happens in this case.
    "iaptesting.badid"

To do real product testing in this app hit the "Load Products" button after the app launches.

#### Consuming Purchases

On Android, we can reset the state of one time purchases to "available" by consuming them. For puchases that could be bought multiple times over (like in-game currency), after purchasing the item, it would then be consumed to make it available for purchase again. This is also handy when you need to refresh the state of purchased items.

Again, hit the "Test Consume" button to consume all purchases made.

**NOTE:** Consuming all purchases isn't instantaneous. It's recommended you wait a couple minutes after hitting the consume button, then verify that the consumption actually happened.

#### Restoring Purchases

If a user has made many in-app purchases on one device, but then wants to go to another, they can restore their purchases from before. For Google, this has the opposite effect of consuming purchases.

Hit the "Test Restore" button to do this.

#### Issuing Refunds

On Android, users can invoke refunds on their in-app purchases. Since you're the seller of this app, you have the ability to issue these refunds. To test out refunds, hit the "Google Wallet" button. This will prompt you to login with a Google Wallet Merchant account. Enter the credentials for your Google Wallet merchant account and this will take you to Google Wallet Merchant Center. If instead you get redirected to a support page, simply enter this URL in the address bar:
        `https://wallet.google.com/merchant`

From here, follow [these instructions](https://support.google.com/wallet/business/answer/2741495?hl=en) to issue the refund.

## Gotchas

* If loading any of the product lists fails and the app locks up, close the app, and relaunch. Hit the "Test Consume" button and try again. This can happen if the state of purchased products gets weird.
