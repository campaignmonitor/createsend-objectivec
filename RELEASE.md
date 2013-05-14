# Releasing createsend-objectivec

## Requirements

- You should be familiar with [CocoaPods](http://cocoapods.org/) and have the `cocoapods` gem installed:

  ```
  gem install cocoapods
  pod setup
  ```

## Prepare the release

- Increment the version numbers in the the following files, ensuring that you use [Semantic Versioning](http://semver.org/):
  * `CreateSend/CreateSend.m`
  * `CreateSend.podspec`
- Add an entry to `HISTORY.md` which clearly explains the new release.
- Commit your changes:

  ```
  git commit -am "Version X.Y.Z"
  ```

- Tag the new version:

  ```
  git tag -a vX.Y.Z -m "Version X.Y.Z"
  ```

- Push your changes to GitHub, including the tag you just created:

  ```
  git push origin master --tags
  ```

- Ensure that all [tests](https://travis-ci.org/campaignmonitor/createsend-objectivec) pass.
- Also lint `CreateSend.podspec` to ensure that it passes validation _without any warnings_, by running:

  ```
  rake lint
  ```

## Release the pod

To release the latest version of `CreateSend.podspec`, you'll need to have a fork of the [CocoaPods/Specs](https://github.com/CocoaPods/Specs) repo if you don't already:

```
git clone git://github.com/CocoaPods/Specs.git ~/CocoaPods/
```

Once you have a fork of the master Specs repository (in, for example, `~/CocoaPods/Specs/`) you need to copy your `CreateSend.podspec` file into the Specs repository, and commit your changes, as follows:

```
mkdir ~/CocoaPods/Specs/CreateSend/X.Y.Z
cp CreateSend.podspec ~/CocoaPods/Specs/CreateSend/X.Y.Z/
cd ~/CocoaPods/Specs/
git checkout -b createsend-version-X.Y.Z
git add CreateSend/X.Y.Z/CreateSend.podspec
git commit -m "CreateSend.podspec version X.Y.Z"
git push origin createsend-version-X.Y.Z
```

You now need to submit the changes you made in your `createsend-version-X.Y.Z` branch as a pull request to [CocoaPods/Specs](https://github.com/CocoaPods/Specs).

Once your pull request is merged, this publishes the pod to [CocoaPods.org](http://cocoapods.org/?q=name%3ACreateSend). You should see the newly published version of the pod there. All done!
