# WayThere
WayThere is a simple yet beautiful weather web/ios app

To compile this project, please run the following:

```shell
npm install     # may need to be administrator or root
bower install
grunt prod
```

Troubleshooting
==========

Make sure to have the following packages installed in this order:

* `npm` is included in `nodejs`
```shell
brew install node                 # For mac user (may require to run with `sudo`)
sudo apt-get install -y nodejs    # For linux user
```
* `bower` you can use bower installed in node_modules/.bin/ by running `npm install bower`. Or run the following :
```shell
npm install -g bower              # may need to be administrator or root
```
* `grunt` run the following
```shell
npm install -g grunt-cli          # may need to be administrator or root
```
