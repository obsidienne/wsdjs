# version 1.6
- invitation deprecated : invitation access removed. Admin can list existing invitation request 
- add a deactivated user toggle. A deactivated user cannot login or get newsletter
- split user save actions to improve security (the user update internal path is different for an admin a std user)
- change song & top visibility access to 12 month (-3 months to -15 months) for DJ profil
- the capacity for a user to add a video to a song is protected by an admin pref
- send an email if a streamed song does not match with WSDJs internal DB
- activate the option to be notified when a new song has been suggested the last 24h
# version 1.5
- apple file for universal link
- move API to v1 
- API for comment, opinions, songs, video
- specific link for signin email from smartphone
- adapt design to device (only the foundation no visible changes)
- add pro's video to song
- use docker for deployment
- reschedule radio update when radioking does not respond
- use srcset to cloudinary_api
- add base for venues and happenings
# version 1.4.3
- authorize empty/null BPM
- UTC correction for client
- base mailing
- use ex_machina as a factory test
- add a lot of unit test
- use boolean for user_profil, it improves usability
- use only scope for index, unauthorized access is not a 404 error

