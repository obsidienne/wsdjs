select users.email, avatars.cld_id, avatars.version
from users
left join avatars on users.id=avatars.user_id

select opinions.kind, users.email, songs.title, songs.artist
from opinions
left join songs on songs.id=opinions.song_id
left join users on users.id=opinions.user_id

select votes.votes, users.email, songs.title, songs.artist, tops.due_date
from votes
left join songs on songs.id=votes.song_id
left join users on users.id=votes.user_id
left join tops on tops.id=votes.top_id

select comments.text, users.email, songs.title, songs.artist
from comments
left join users on users.id=comments.user_id
left join songs on songs.id=comments.song_id


select ranks.position, songs.artist, songs.title, tops.due_date
from ranks
left join songs on songs.id=ranks.song_id
left join tops on tops.id=ranks.top_id



