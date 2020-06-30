# Alfred Salesforce Search

A simple Alfred workflow for searching for companies (accounts) in Salesforce.

## Requirements

-   Python 3: should be already installed on your Mac. If not, macOS will prompt you to install it.
-   Salesforce: I've tested this against my Salesforce account (which is a fresh install), but mine
    may be configured differently from yours. Please reach out to me if this is an issue. You may
    need admin permissions to get the API keys as described below.

## Installation

1. Double-Click the Workflow file to add it to Alfred.
2. Alfred will prompt you for a Salesforce Client ID and Secret. To aquire them:
    1. Go to Salesforce Setup
    2. Search for "App Manager"
    3. Click "New Connected App"
    4. Fill out the settings as shown:
       ![Example Settings](res/salesforce_app_setup.png)
    5. Click next and through the warning page.
    6. Copy the "Consumer Key" and "Consumer Secret" from the next page, and paste them into Alfren
       when prompted.
        - To the best of my knowledge, it is safe to re-use these keys for multiple users within an
          organization. As far as I know, they will not work for a different Salesforce organization.

## Usage

### Log in

Even though you set up the workflow as a Salesforce app during installation, you need to authenticate
with your personal account. To do this, invoke Alfred and type `login-force you@email.com password12345`
(obviously substituting in your email and password). If you have a 2FA security code, add that at the end: `login-force you@email.com password12355 894332`.

### Searching

Invoke Alfred and type `force company name` to search for `company name`. Search works exactly the same
as it does in Salesforce proper. You must type at least two characters for Salesforce to process the
search.

Once you have a search result, you can select it (hit <kbd>Enter</kbd> or Click) to open that item in
Salesforce. Or, if you hold down Command while selecting the item, you can open the company's website
(if it has one in Salesforce). Option/Alt does the same thing, but for calling the company's phone
numbers. (Your Mac needs to be properly configured to make calls via your iPhone for this to work
properly. [See here](https://www.macworld.co.uk/how-to/mac/making-phone-calls-on-mac-3593777/) for instructions.)

### Log out

If you want to sign out for some reason, you can use the `logout-force` command in Alfred to do so.

## License

This workflow is &copy; 2020 Ari Porad, and is licensed under [the MIT License](https://ariporad.mit-license.org/).
