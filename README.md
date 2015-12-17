#C[loud]S[cripts]

CloudScripts (CS) is where all my day to day scripts, templates and frameworks are stored.

##Installation
Execute only this command to install all the scripts and files of CS in their respective location.

```
curl -s http://cs.johandry.com/install | bash
```

##Updates
Once the scripts are installed, they can be updated with the parameter ``--update``. Example: ``sm --update``

If you only want to update the Common Utility script, execute:

```
source ~/bin/common.sh && common_update
```
##Maintenance
To do a modification just clone the project and deploy the changes with the ``deploy`` script.

```
# Go to your Workspace directory
mkdir CloudScripts && cd $_
git clone git@github.com:johandry/CS.git
./deploy --setup
```


```
# Go to your Workspace directory
mkdir CS && cd $_
git clone git@github.com:johandry/CS.git
cd CS
# do modifications
git add .
git commit -m "Description of the change"
git push origin master
```

If the change is in the install script, make sure to deploy it to the gh-pages branch too.

```
# Go to your Workspace directory
mkdir -p CS && cd $_
git clone -b gh-pages git@github.com:johandry/CS.git Pages
cd $_
# do modifications to pages if needed
cp ../CS/install .
git add .
git commit -m "Description of the change"
git push origin gh-pages # Or just git push
```
