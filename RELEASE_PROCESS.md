# Releasing this module #

 * This module adheres to http://semver.org/
 * Look for API breaking changes using `git diff vX.Y.Z..master`
   * If no API breaking changes, the minor version may be bumped.
   * If there are API breaking changes, the major version must be bumped.
   * If there are only small minor changes, the patch version may be bumped.
 * Update the _CHANGELOG_
 * Update the _Modulefile_
 * Commit these changes with a message along the lines of "_Update CHANGELOG and
   Modulefile for release_"
 * Create an annotated tag with `git tag -a vX.Y.Z -m 'version X.Y.Z'` (NOTE the
   leading v as per _semver.org_)
 * Push the tag with `git push origin --tags`.
 * Build a new package with `puppet module build`.
 * Contact puppet administrators to update public puppet forge.
 * Announce update to kerberos list.
