--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: arts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.arts (
    cld_id character varying(255) NOT NULL,
    version integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    song_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: arts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.arts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: arts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.arts_id_seq OWNED BY public.arts.id;


--
-- Name: auth_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_tokens (
    value character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    user_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: auth_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_tokens_id_seq OWNED BY public.auth_tokens.id;


--
-- Name: avatars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.avatars (
    cld_id character varying(255) NOT NULL,
    version integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    user_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: avatars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.avatars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: avatars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.avatars_id_seq OWNED BY public.avatars.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    text character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    text_html text,
    user_id bigint NOT NULL,
    song_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    starts_on date NOT NULL,
    ends_on date NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    venue character varying(255),
    coordinates public.geometry(Point,4326),
    fb_url character varying(255),
    user_id bigint NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: opinions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opinions (
    kind character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    user_id bigint NOT NULL,
    song_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: opinions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.opinions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: opinions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.opinions_id_seq OWNED BY public.opinions.id;


--
-- Name: playlist_songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playlist_songs (
    id bigint NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    playlist_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    song_id bigint NOT NULL
);


--
-- Name: playlist_songs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playlist_songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playlist_songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playlist_songs_id_seq OWNED BY public.playlist_songs.id;


--
-- Name: playlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playlists (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) DEFAULT 'playlist'::character varying NOT NULL,
    count integer DEFAULT 0 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    public boolean DEFAULT false NOT NULL,
    front_page boolean DEFAULT false NOT NULL,
    cover_id bigint,
    user_id bigint NOT NULL
);


--
-- Name: playlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playlists_id_seq OWNED BY public.playlists.id;


--
-- Name: ranks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ranks (
    likes integer DEFAULT 0 NOT NULL,
    votes integer DEFAULT 0 NOT NULL,
    bonus integer DEFAULT 0 NOT NULL,
    "position" integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    song_id bigint NOT NULL,
    top_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ranks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ranks_id_seq OWNED BY public.ranks.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs (
    uuid uuid,
    title character varying(255) NOT NULL,
    artist character varying(255) NOT NULL,
    url character varying(255),
    bpm integer DEFAULT 0,
    genre character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    instant_hit boolean DEFAULT false NOT NULL,
    video_id character varying(255),
    public_track boolean DEFAULT false NOT NULL,
    hidden_track boolean DEFAULT false NOT NULL,
    suggestion boolean DEFAULT true NOT NULL,
    user_id bigint NOT NULL,
    id bigint NOT NULL,
    cld_id character varying(255) DEFAULT 'wsdjs/missing_cover'::character varying NOT NULL
);


--
-- Name: songs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.songs_id_seq OWNED BY public.songs.id;


--
-- Name: tops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tops (
    uuid uuid,
    due_date date NOT NULL,
    status text DEFAULT 'checking'::text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    user_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: tops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tops_id_seq OWNED BY public.tops.id;


--
-- Name: users_profils; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_profils (
    description text,
    favorite_genre character varying(255),
    favorite_artist character varying(255),
    djing_start_year integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    youtube character varying(255),
    facebook character varying(255),
    soundcloud character varying(255),
    website character varying(255),
    description_html text,
    user_id bigint NOT NULL,
    id bigint NOT NULL,
    user_country character varying(255),
    name character varying(255),
    djname character varying(255),
    cld_id character varying(255) DEFAULT 'wsdjs/missing_avatar'::character varying NOT NULL
);


--
-- Name: user_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_details_id_seq OWNED BY public.users_profils.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    uuid uuid,
    email public.citext NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    profils character varying(255)[] DEFAULT ARRAY[]::character varying[],
    profil_djvip boolean DEFAULT false NOT NULL,
    profil_dj boolean DEFAULT false NOT NULL,
    confirmed_at timestamp(0) without time zone,
    id bigint NOT NULL,
    hashed_password character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.videos (
    url character varying(255) NOT NULL,
    video_id character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    title character varying(255),
    event character varying(255),
    published_at date,
    provider character varying(255) DEFAULT 'unknown'::character varying NOT NULL,
    event_id bigint,
    user_id bigint NOT NULL,
    song_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votes (
    votes integer DEFAULT 0 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    user_id bigint NOT NULL,
    song_id bigint NOT NULL,
    top_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.votes_id_seq OWNED BY public.votes.id;


--
-- Name: arts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arts ALTER COLUMN id SET DEFAULT nextval('public.arts_id_seq'::regclass);


--
-- Name: auth_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_tokens ALTER COLUMN id SET DEFAULT nextval('public.auth_tokens_id_seq'::regclass);


--
-- Name: avatars id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avatars ALTER COLUMN id SET DEFAULT nextval('public.avatars_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: opinions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opinions ALTER COLUMN id SET DEFAULT nextval('public.opinions_id_seq'::regclass);


--
-- Name: playlist_songs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs ALTER COLUMN id SET DEFAULT nextval('public.playlist_songs_id_seq'::regclass);


--
-- Name: playlists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists ALTER COLUMN id SET DEFAULT nextval('public.playlists_id_seq'::regclass);


--
-- Name: ranks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ranks ALTER COLUMN id SET DEFAULT nextval('public.ranks_id_seq'::regclass);


--
-- Name: songs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs ALTER COLUMN id SET DEFAULT nextval('public.songs_id_seq'::regclass);


--
-- Name: tops id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tops ALTER COLUMN id SET DEFAULT nextval('public.tops_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_profils id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_profils ALTER COLUMN id SET DEFAULT nextval('public.user_details_id_seq'::regclass);


--
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes ALTER COLUMN id SET DEFAULT nextval('public.votes_id_seq'::regclass);


--
-- Name: arts arts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arts
    ADD CONSTRAINT arts_pkey PRIMARY KEY (id);


--
-- Name: auth_tokens auth_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_pkey PRIMARY KEY (id);


--
-- Name: avatars avatars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avatars
    ADD CONSTRAINT avatars_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: opinions opinions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opinions
    ADD CONSTRAINT opinions_pkey PRIMARY KEY (id);


--
-- Name: playlist_songs playlist_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs
    ADD CONSTRAINT playlist_songs_pkey PRIMARY KEY (id);


--
-- Name: playlists playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);


--
-- Name: ranks ranks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ranks
    ADD CONSTRAINT ranks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: tops tops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tops
    ADD CONSTRAINT tops_pkey PRIMARY KEY (id);


--
-- Name: users_profils user_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_profils
    ADD CONSTRAINT user_details_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: arts_cld_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX arts_cld_id_index ON public.arts USING btree (cld_id);


--
-- Name: auth_tokens_value_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX auth_tokens_value_index ON public.auth_tokens USING btree (value);


--
-- Name: avatars_cld_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX avatars_cld_id_index ON public.avatars USING btree (cld_id);


--
-- Name: events_coordinates_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX events_coordinates_index ON public.events USING gist (coordinates);


--
-- Name: playlists_name_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX playlists_name_user_id_index ON public.playlists USING btree (name, user_id);


--
-- Name: songs_full_text_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX songs_full_text_index ON public.songs USING gin (to_tsvector('english'::regconfig, (((artist)::text || ' '::text) || (title)::text)));


--
-- Name: songs_title_artist_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX songs_title_artist_index ON public.songs USING btree (title, artist);


--
-- Name: tops_due_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tops_due_date_index ON public.tops USING btree (due_date);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_tokens_user_id_index ON public.users_tokens USING btree (user_id);


--
-- Name: arts arts_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arts
    ADD CONSTRAINT arts_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: auth_tokens auth_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: avatars avatars_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avatars
    ADD CONSTRAINT avatars_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: comments comments_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: events events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: opinions opinions_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opinions
    ADD CONSTRAINT opinions_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: playlist_songs playlist_songs_playlist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs
    ADD CONSTRAINT playlist_songs_playlist_id_fkey FOREIGN KEY (playlist_id) REFERENCES public.playlists(id);


--
-- Name: playlist_songs playlist_songs_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs
    ADD CONSTRAINT playlist_songs_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id);


--
-- Name: playlists playlists_cover_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_cover_id_fkey FOREIGN KEY (cover_id) REFERENCES public.songs(id) ON DELETE SET NULL;


--
-- Name: playlists playlists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ranks ranks_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ranks
    ADD CONSTRAINT ranks_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id);


--
-- Name: ranks ranks_top_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ranks
    ADD CONSTRAINT ranks_top_id_fkey FOREIGN KEY (top_id) REFERENCES public.tops(id);


--
-- Name: songs songs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tops tops_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tops
    ADD CONSTRAINT tops_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users_profils user_details_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_profils
    ADD CONSTRAINT user_details_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: videos videos_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: videos videos_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id);


--
-- Name: videos videos_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: votes votes_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id);


--
-- Name: votes votes_top_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_top_id_fkey FOREIGN KEY (top_id) REFERENCES public.tops(id);


--
-- Name: votes votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20161128191800);
INSERT INTO public."schema_migrations" (version) VALUES (20161128191920);
INSERT INTO public."schema_migrations" (version) VALUES (20161204104012);
INSERT INTO public."schema_migrations" (version) VALUES (20161214170029);
INSERT INTO public."schema_migrations" (version) VALUES (20161214172551);
INSERT INTO public."schema_migrations" (version) VALUES (20161214174207);
INSERT INTO public."schema_migrations" (version) VALUES (20170101194233);
INSERT INTO public."schema_migrations" (version) VALUES (20170105081341);
INSERT INTO public."schema_migrations" (version) VALUES (20170105082146);
INSERT INTO public."schema_migrations" (version) VALUES (20170105163253);
INSERT INTO public."schema_migrations" (version) VALUES (20170112070224);
INSERT INTO public."schema_migrations" (version) VALUES (20170125083600);
INSERT INTO public."schema_migrations" (version) VALUES (20170216124122);
INSERT INTO public."schema_migrations" (version) VALUES (20170223134337);
INSERT INTO public."schema_migrations" (version) VALUES (20170228114951);
INSERT INTO public."schema_migrations" (version) VALUES (20170418062230);
INSERT INTO public."schema_migrations" (version) VALUES (20170426061624);
INSERT INTO public."schema_migrations" (version) VALUES (20170510120656);
INSERT INTO public."schema_migrations" (version) VALUES (20170619103839);
INSERT INTO public."schema_migrations" (version) VALUES (20170619115109);
INSERT INTO public."schema_migrations" (version) VALUES (20170624134508);
INSERT INTO public."schema_migrations" (version) VALUES (20170624145140);
INSERT INTO public."schema_migrations" (version) VALUES (20170625013620);
INSERT INTO public."schema_migrations" (version) VALUES (20170704154256);
INSERT INTO public."schema_migrations" (version) VALUES (20170717214321);
INSERT INTO public."schema_migrations" (version) VALUES (20170718231635);
INSERT INTO public."schema_migrations" (version) VALUES (20170728184452);
INSERT INTO public."schema_migrations" (version) VALUES (20170815083913);
INSERT INTO public."schema_migrations" (version) VALUES (20170818212841);
INSERT INTO public."schema_migrations" (version) VALUES (20170822194814);
INSERT INTO public."schema_migrations" (version) VALUES (20170826122057);
INSERT INTO public."schema_migrations" (version) VALUES (20170828162022);
INSERT INTO public."schema_migrations" (version) VALUES (20170829170856);
INSERT INTO public."schema_migrations" (version) VALUES (20170831193509);
INSERT INTO public."schema_migrations" (version) VALUES (20170831194651);
INSERT INTO public."schema_migrations" (version) VALUES (20170902193944);
INSERT INTO public."schema_migrations" (version) VALUES (20170905193034);
INSERT INTO public."schema_migrations" (version) VALUES (20170911211947);
INSERT INTO public."schema_migrations" (version) VALUES (20170925071621);
INSERT INTO public."schema_migrations" (version) VALUES (20171018155909);
INSERT INTO public."schema_migrations" (version) VALUES (20171031072653);
INSERT INTO public."schema_migrations" (version) VALUES (20171103171431);
INSERT INTO public."schema_migrations" (version) VALUES (20171103171456);
INSERT INTO public."schema_migrations" (version) VALUES (20171105101859);
INSERT INTO public."schema_migrations" (version) VALUES (20171108073602);
INSERT INTO public."schema_migrations" (version) VALUES (20171114191908);
INSERT INTO public."schema_migrations" (version) VALUES (20171116082350);
INSERT INTO public."schema_migrations" (version) VALUES (20180103075725);
INSERT INTO public."schema_migrations" (version) VALUES (20180111080119);
INSERT INTO public."schema_migrations" (version) VALUES (20180118124303);
INSERT INTO public."schema_migrations" (version) VALUES (20180129081140);
INSERT INTO public."schema_migrations" (version) VALUES (20180130163940);
INSERT INTO public."schema_migrations" (version) VALUES (20180203230353);
INSERT INTO public."schema_migrations" (version) VALUES (20180207220422);
INSERT INTO public."schema_migrations" (version) VALUES (20180207233129);
INSERT INTO public."schema_migrations" (version) VALUES (20180207233658);
INSERT INTO public."schema_migrations" (version) VALUES (20180209080507);
INSERT INTO public."schema_migrations" (version) VALUES (20180215221115);
INSERT INTO public."schema_migrations" (version) VALUES (20180219075617);
INSERT INTO public."schema_migrations" (version) VALUES (20180314161720);
INSERT INTO public."schema_migrations" (version) VALUES (20180314163914);
INSERT INTO public."schema_migrations" (version) VALUES (20180315081556);
INSERT INTO public."schema_migrations" (version) VALUES (20180409151812);
INSERT INTO public."schema_migrations" (version) VALUES (20180411071114);
INSERT INTO public."schema_migrations" (version) VALUES (20180411160150);
INSERT INTO public."schema_migrations" (version) VALUES (20180412160443);
INSERT INTO public."schema_migrations" (version) VALUES (20180502064410);
INSERT INTO public."schema_migrations" (version) VALUES (20180503085933);
INSERT INTO public."schema_migrations" (version) VALUES (20180504171018);
INSERT INTO public."schema_migrations" (version) VALUES (20180704065331);
INSERT INTO public."schema_migrations" (version) VALUES (20180713065800);
INSERT INTO public."schema_migrations" (version) VALUES (20181025205154);
INSERT INTO public."schema_migrations" (version) VALUES (20181025205209);
INSERT INTO public."schema_migrations" (version) VALUES (20181115184632);
INSERT INTO public."schema_migrations" (version) VALUES (20181122080409);
INSERT INTO public."schema_migrations" (version) VALUES (20181228171825);
INSERT INTO public."schema_migrations" (version) VALUES (20200622221822);
INSERT INTO public."schema_migrations" (version) VALUES (20200623144518);
INSERT INTO public."schema_migrations" (version) VALUES (20200624223518);
INSERT INTO public."schema_migrations" (version) VALUES (20200624225334);
INSERT INTO public."schema_migrations" (version) VALUES (20200624232010);
INSERT INTO public."schema_migrations" (version) VALUES (20200624232912);
INSERT INTO public."schema_migrations" (version) VALUES (20200625222023);
INSERT INTO public."schema_migrations" (version) VALUES (20200630211649);
INSERT INTO public."schema_migrations" (version) VALUES (20201029231738);
INSERT INTO public."schema_migrations" (version) VALUES (20201030225815);
