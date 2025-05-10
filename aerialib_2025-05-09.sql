--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: flow_poses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flow_poses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    flow_id uuid NOT NULL,
    pose_id uuid NOT NULL,
    pose_order integer NOT NULL,
    transition_id uuid
);


ALTER TABLE public.flow_poses OWNER TO postgres;

--
-- Name: flows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flows (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    apparatus text NOT NULL,
    level double precision NOT NULL,
    description text,
    teaching_cues text,
    safety_cues text,
    progressions text,
    created_by uuid NOT NULL,
    updated_by uuid,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    thumbnail_image_id uuid NOT NULL
);


ALTER TABLE public.flows OWNER TO postgres;

--
-- Name: media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_path text NOT NULL,
    media_type text NOT NULL,
    file_size integer,
    name text,
    description text,
    apparatus text,
    uploaded_by uuid NOT NULL,
    uploaded_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.media OWNER TO postgres;

--
-- Name: poses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    primary_media_id uuid NOT NULL,
    apparatus text NOT NULL,
    level double precision NOT NULL,
    description text,
    teaching_cues text,
    safety_cues text,
    progressions text,
    created_by uuid NOT NULL,
    updated_by uuid,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.poses OWNER TO postgres;

--
-- Name: transitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    from_pose_id uuid NOT NULL,
    to_pose_id uuid NOT NULL,
    level double precision NOT NULL,
    name text,
    description text,
    teaching_cues text,
    safety_cues text,
    progressions text,
    transition_type text,
    starting_grip text,
    ending_grip text,
    created_by uuid NOT NULL,
    updated_by uuid,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.transitions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    first_name text,
    last_name text,
    bio text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    last_login timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: flow_poses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flow_poses (id, flow_id, pose_id, pose_order, transition_id) FROM stdin;
\.


--
-- Data for Name: flows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flows (id, name, apparatus, level, description, teaching_cues, safety_cues, progressions, created_by, updated_by, created_at, updated_at, thumbnail_image_id) FROM stdin;
\.


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.media (id, media_path, media_type, file_size, name, description, apparatus, uploaded_by, uploaded_at) FROM stdin;
1f029e9a-7ee2-666a-a817-a05f576d809e	uplift/amazon_-_hands_on.jpg	image	1273336	Amazon - Hands On	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-693c-8c67-01b11ce1a1e6	uplift/amazon_split.jpg	image	2635310	Amazon Split	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-64f6-a336-4602782f6daa	uplift/amazon_top_hand_off.jpg	image	2772908	Amazon Top Hand Off	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6134-af02-7f44d377c06c	uplift/ankle_cuddle.jpg	image	1944694	Ankle Cuddle	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6bdc-a400-04dfb33b2fb7	uplift/ankle_hang_top_bar_-_holding_on.jpg	image	2346491	Ankle Hang Top Bar - Holding On	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6ef7-973a-5091efd6ef10	uplift/ankle_hang_top_bar_-_no_hands.jpg	image	2248250	Ankle Hang Top Bar - No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6d23-975e-dfe4d43793e4	uplift/arabesque_from_seated.jpg	image	1438587	Arabesque From Seated	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-624c-bcaa-baabe3fe0d69	uplift/arm_pit_block_top_bar.jpg	image	2596803	Arm Pit Block Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6e0b-b9ce-e280fa827620	uplift/around_the_world.jpg	image	1194949	Around the World	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6412-a1b5-2c98fbfd6886	uplift/back_balance_-_hands_on.jpg	image	1952342	Back Balance - Hands On	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6b7b-ae1e-8793692a8194	uplift/back_balance_-_no_hands.jpg	image	2224501	Back Balance - No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6486-8686-148f24dbceb1	uplift/bird’s_nest_bottom_bar.jpg	image	1434236	Bird’s Nest Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6f18-bd44-6fe4029735e6	uplift/bird’s_nest_bottom_bar_one_leg.jpg	image	325477	Bird’s Nest Bottom Bar One Leg	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6af6-983f-c4279cc71f83	uplift/bird’s_nest_top_bar.jpg	image	1876607	Bird’s Nest Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6764-97f4-8af02fbd3d9b	uplift/bird’s_nest_top_bar_single_leg.jpg	image	2885933	Bird’s Nest Top Bar Single Leg	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-625f-958a-6aff6d54398b	uplift/bottom_bar_flip_out.jpg	image	1363852	Bottom Bar Flip Out	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-645f-9878-7169fe44e553	uplift/butt_shelf_-_legs_straight_above_no_hands.jpg	image	2225786	Butt Shelf - Legs Straight Above No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6c71-8a1d-e83a3da50fcd	uplift/butt_shelf_-_no_hands.jpg	image	2150116	Butt Shelf - No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-68cc-a372-91de639ef713	uplift/butt_shelf_-_one_leg_straight_other_bent_behind.jpg	image	2945307	Butt Shelf - One Leg Straight Other Bent Behind	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6fc2-a616-e41777179a9f	uplift/butt_shelf_hands_on.jpg	image	2164290	Butt Shelf Hands On	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6989-8ab3-df6682562cc8	uplift/butt_shelf_straight_legs.jpg	image	2262887	Butt Shelf Straight Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-644c-ba4d-2aa2210df4cc	uplift/candlestick.jpg	image	2685744	Candlestick	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6a88-affc-8028f95737e6	uplift/candlestick_reverse_from_stag.jpg	image	2255543	Candlestick Reverse from Stag	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-664f-908d-63ff55e84a5d	uplift/cannon_ball.jpg	image	75900	Cannon Ball	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-69a3-bcad-cb6603cc1d25	uplift/chest_stand_arrow.jpg	image	2139339	Chest Stand Arrow	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6dff-a216-fe3cda338320	uplift/chest_stand_delilah.jpg	image	2035923	Chest Stand Delilah	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-632f-99a9-f5bc310f661f	uplift/chest_stand_pencil.jpg	image	2110650	Chest Stand Pencil	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6b91-8238-20269dcca1d0	uplift/chest_stand_pike.jpg	image	2895499	Chest Stand Pike	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6ed7-8863-f5da52a27c40	uplift/circus_mermaid.jpg	image	2770795	Circus Mermaid	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6937-8e88-362dd04fe6a2	uplift/clock.jpg	image	2234050	Clock	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-66b4-8f11-189e23a34092	uplift/crossed_leg_sit_top_bar.jpg	image	3027607	Crossed Leg Sit Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6a39-914f-5b578cf1cb23	uplift/cuddle.jpg	image	2554828	Cuddle	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6eb2-8b72-d3d393fa307e	uplift/cuddle_roll.jpg	image	2549859	Cuddle Roll	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6e89-a302-49f48ae3ae6a	uplift/cuddle_slide.jpg	image	2056274	Cuddle Slide	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6299-94c1-308a3e726960	uplift/cuddle_top_bar.jpg	image	445703	Cuddle Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6587-8963-56ab48594fc9	uplift/delilah.jpg	image	1620283	Delilah	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6b77-93b4-f46e3fba56d0	uplift/delilah_foot_press_away.jpg	image	74042	Delilah Foot Press Away	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6ec6-bc46-864df51ff699	uplift/delilah_hand_press_away.jpg	image	2106842	Delilah Hand Press Away	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-64f5-8ffc-a2c60ca354b5	uplift/delilah_sideways_top_bar.jpg	image	1944380	Delilah Sideways Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6da7-9183-5f8caeece461	uplift/diving_bird.jpg	image	3082711	Diving Bird	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6657-a9fa-65c8266aeb42	uplift/double_knee_hook_trash_can.jpg	image	2846305	Double Knee Hook Trash Can	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6896-ad12-d12bac3f76ce	uplift/dragonfly.jpg	image	2662380	Dragonfly	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6b2f-b6a8-2cf50f404010	uplift/elbow_hook_double_bottom_bar.jpg	image	3132814	Elbow Hook Double Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6c4b-a303-22a167c67be0	uplift/elbow_hook_double_top_bar.jpg	image	1465253	Elbow Hook Double Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6a1b-b790-67cda1297e3b	uplift/elbow_hook_single_inside_knee_hook_single.jpg	image	2333876	Elbow Hook Single Inside Knee Hook Single	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6fd8-9810-e95e9bbfda95	uplift/fallen_angel.jpg	image	2750652	Fallen Angel	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6d4c-8c10-b98b5b5294ba	uplift/faux_butt_shelf.jpg	image	2566062	Faux Butt Shelf	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-66eb-9679-1175b3926961	uplift/figure_four_foot_block_under_bar.jpg	image	1933747	Figure Four Foot Block Under Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-65d0-9935-c7d0e93538fc	uplift/figure_head.jpg	image	2956564	Figure Head	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-607f-856d-dc51d70e6f86	uplift/fish.jpg	image	1510992	Fish	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6125-a1ae-4491ac25a731	uplift/fish_injured.jpg	image	456827	Fish Injured	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-636d-b786-46afde54e1bd	uplift/flag.jpg	image	1445764	Flag	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6cb5-a317-ab5ce6988b0e	uplift/flamenco_grip_inside_mermaid_knee_hook.jpg	image	167404	Flamenco Grip Inside Mermaid Knee Hook	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6ad7-857b-9ba516138d22	uplift/flamingo.jpg	image	3032936	Flamingo	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6aa2-a268-fe0260b58979	uplift/flying_saucer.jpg	image	2871490	Flying Saucer	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6212-9dd4-34a7f98bb3aa	uplift/gazelle_-_hands_on.jpg	image	1799948	Gazelle - Hands On	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-66c6-b677-9220b8ad7b9c	uplift/gazelle_-_hands_on_knee.jpg	image	1983455	Gazelle - Hands on Knee	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-61c8-b73f-620e6273ac9f	uplift/gazelle_-_one_hand_knee.jpg	image	2044842	Gazelle - One Hand Knee	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-60c5-9aa0-f6f947964265	uplift/gazelle_allegra_bent_leg.jpg	image	3145271	Gazelle Allegra Bent Leg	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6d98-82ae-f1a57b897c3a	uplift/gazelle_allegra_straight_leg.jpg	image	2315723	Gazelle Allegra Straight Leg	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6e2f-acb1-8a1cdc7504af	uplift/gazelle_french.jpg	image	1071312	Gazelle French	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-645a-bb9c-15dec1ba7cce	uplift/gazelle_french_stag_legs.jpg	image	1445009	Gazelle French Stag Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6955-b46e-96dde081e8b3	uplift/gazelle_front_split.jpg	image	2757992	Gazelle Front Split	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6589-b311-963b9290d622	uplift/gazelle_no_hands.jpg	image	1714755	Gazelle No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6c29-8474-16d91dd55eb0	uplift/gazelle_twist_half_split.jpg	image	2136778	Gazelle Twist Half Split	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6621-b1cf-9da83923edc8	uplift/gazelle_twist_split_full.jpg	image	1987712	Gazelle Twist Split Full	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6b5b-b17f-6b6e0b8950b7	uplift/genie_dismount.jpg	image	899455	Genie Dismount	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6031-a0a1-0861ae8ac942	uplift/half_angel_roll.jpg	image	1764006	Half Angel Roll	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6eaa-9822-33d4e97be695	uplift/half_angel_roll_low.jpg	image	1496284	Half Angel Roll Low	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-63c0-9f72-da24b18f09c1	uplift/half_back_balance.jpg	image	1836625	Half Back Balance	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6d59-a0f6-568ff0657cce	uplift/half_back_balance_-_no_hands.jpg	image	142923	Half Back Balance - No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6d0d-90dd-1f94de3fd134	uplift/half_beauty_roll_-_from_high_outside_mermaid.jpg	image	318117	Half Beauty Roll - from High Outside Mermaid	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6555-8d6d-b6abaff6160d	uplift/half_beauty_roll_-_from_inside_lion.jpg	image	288765	Half Beauty Roll - from Inside Lion	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-69ab-abb8-ce779c01dabd	uplift/half_crescent_moon.jpg	image	1576057	Half Crescent Moon	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-684a-948c-30fc65a3a543	uplift/half_mill_roll.jpg	image	2990816	Half Mill Roll	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-666a-a745-4c1001973c33	uplift/half_popsicle_roll.jpg	image	2437922	Half Popsicle Roll	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-67d0-b924-feb33bac0c54	uplift/hh_foot_block_-_both_legs.jpg	image	1453048	HH Foot Block - Both Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6b73-b478-869c60658fee	uplift/high_layout_1_hand.jpg	image	1921970	High Layout - 1 Hand	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6991-bb68-a406679d3ab7	uplift/high_layout_2_hands.jpg	image	2132716	High Layout - 2 Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6dbd-8297-fba809d1f5bd	uplift/high_outside_mermaid.jpg	image	1700973	High Outside Mermaid	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6cb9-a4cf-910ee35411fb	uplift/hip_hang.jpg	image	1473970	Hip Hang	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-69d5-a908-bd962846e00a	uplift/hip_hang_flip_in.jpg	image	2237903	Hip Hang Flip In	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-61c3-a87b-cac813b92a77	uplift/hip_hang_flip_out.jpg	image	2337954	Hip Hang Flip Out	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-661b-8061-9e6c7c8ea6a8	uplift/hip_hang_foot_block.jpg	image	1369029	Hip Hang Foot Block	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6845-9541-84770aad4976	uplift/hip_hang_inverted_flamingo.jpg	image	2043398	Hip Hang Inverted Flamingo	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-65a1-8738-5777e845bf12	uplift/hip_hang_scorpion.jpg	image	2571427	Hip Hang Scorpion	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6158-bd63-56fc94836045	uplift/hip_hang_top_bar.jpg	image	1930780	Hip Hang Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6cd6-b6fb-8a3b078f9ac9	uplift/hip_hang_zipper.jpg	image	3260919	Hip Hang Zipper	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6999-a5aa-3c39c465506f	uplift/hock_hang.jpg	image	12498	Hock Hang	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6f7a-be83-48e5e621c9f4	uplift/hock_hang_top_bar.jpg	image	1939974	Hock Hang Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6d03-baa7-bcbb81cc9763	uplift/horse.jpg	image	2052892	Horse	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-678b-b864-5b8452996cd6	uplift/inside_lion.jpg	image	2496363	Inside Lion	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6a2b-8d0b-bf36040c8c0f	uplift/inside_lion_arabesque.jpg	image	1788250	Inside Lion Arabesque	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-631b-9b6a-621d082c147c	uplift/inside_lion_slide.jpg	image	1939164	Inside Lion Slide	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6707-a63a-924149da29dd	uplift/inside_lion_top_bar.jpg	image	1987796	Inside Lion Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6bc3-89ee-f41eee88d422	uplift/inverted_hoop_flip_bent_legs.jpg	image	1848507	Inverted Hoop Flip Bent Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6952-8e43-86aeb1dd0bc8	uplift/inverted_running_man_top_bar.jpg	image	1361356	Inverted Running Man Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6027-98bc-d644af10b618	uplift/inverted_star_hoop_flip.jpg	image	2124884	Inverted Star Hoop Flip	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6295-89c7-390c07c3c75f	uplift/inverted_star_stag_legs.jpg	image	1440843	Inverted Star Stag Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6a57-a7d9-45b38e005e54	uplift/inverted_star_top_bar.jpg	image	1374317	Inverted Star Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-615e-99c2-9219e6fb415c	uplift/jamilla.jpg	image	3069624	Jamilla	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6354-b218-2acd47a322dd	uplift/knee_hang_bottom_bar_pike.jpg	image	354082	Knee Hang Bottom Bar Pike	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-68e6-ae4b-80a25599233f	uplift/knee_hang_bottom_bar_single_-_one_hand.jpg	image	2738153	Knee Hang Bottom Bar Single - One Hand	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6f92-ae4c-1a6af515e4c5	uplift/knee_hang_double_bottom_bar.jpg	image	1284896	Knee Hang Double Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6739-9ede-1be136f8688d	uplift/knee_hang_double_top_bar_-_no_hands.jpg	image	1259588	Knee Hang Double Top Bar - No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6527-a7ce-3e1706abe397	uplift/knee_hang_top_bar_back_press_away.jpg	image	96467	Knee Hang Top Bar Back Press Away	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-67fd-b0b1-fdd5af2bf574	uplift/knee_hang_top_bar_forward_press_away.jpg	image	1339601	Knee Hang Top Bar Forward Press Away	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6677-8c5f-e7ba34734d86	uplift/knee_hang_top_bar_hands_high.jpg	image	2510452	Knee Hang Top Bar Hands High	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-62f4-9608-582f404a5618	uplift/knee_hang_top_bar_hands_low.jpg	image	89295	Knee Hang Top Bar Hands Low	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6888-a5e5-d2aa9bb2d31a	uplift/knee_hook_layout_under_bar.jpg	image	2243491	Knee Hook Layout Under Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-63fd-b536-edafb2aaa09d	uplift/l_pop.jpg	image	2664342	L Pop	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6c6b-92e9-b8902ec59f98	uplift/l_sit.jpg	image	1906394	L Sit	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-681c-8ba5-76c1cc2e1fb2	uplift/lady_in_the_moon.jpg	image	2877201	Lady in the Moon	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-61ab-9c44-dd40250946c4	uplift/leg_block_faint.jpg	image	50334	Leg Block Faint	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-65b9-9f58-003ee438a5ce	uplift/lion_roll.jpg	image	2673678	Lion Roll	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6d70-b9d1-50fbed763925	uplift/low_man_in_the_moon.jpg	image	1537533	Low Man in the Moon	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6303-8ddb-ce94b5108e3b	uplift/low_outside_mermaid.jpg	image	1227461	Low Outside Mermaid	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6a3a-9362-fff4780b3c57	uplift/man_in_moon_invert.jpg	image	2354679	Man in Moon Invert	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6428-bced-945f0cfe06f1	uplift/man_in_moon_low_legs_crossed.jpg	image	2490642	Man in Moon Low Legs Crossed	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6175-bb30-f1c0e7f4e420	uplift/man_in_moon_straddle.jpg	image	1788332	Man in Moon Straddle	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6bcd-b8c0-0187c2e0a6ec	uplift/man_in_the_moon.jpg	image	328121	Man in the Moon	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-63c7-be17-05848c603659	uplift/man_in_the_moon_press_away.jpg	image	1400542	Man in the Moon Press Away	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6112-89b4-d47e9ce48c77	uplift/martini.jpg	image	2520814	Martini	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-61f5-9231-218b754da468	uplift/martini_top_bar.jpg	image	2031571	Martini Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6b0f-98f5-ac3017c4d7ab	uplift/mermaid_inside.jpg	image	1441799	Mermaid Inside	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6212-855d-6995a59e533f	uplift/mermaid_inside_flamenco_grip.jpg	image	1429195	Mermaid Inside Flamenco Grip	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6ac1-b92e-e23b6341c2a8	uplift/mermaid_inside_split_legs.jpg	image	1954998	Mermaid Inside Split Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-638e-8c07-f31f939c7898	uplift/outside_knee_hook_both_legs.jpg	image	1554845	Outside Knee Hook Both Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6ba3-b0d4-c979f59d7d7a	uplift/outside_lion.jpg	image	2404036	Outside Lion	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6ad5-9874-5ec082532753	uplift/outside_lion_slide.jpg	image	1960714	Outside Lion Slide	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6867-aaca-9db42f4d3085	uplift/outside_lion_top_bar.jpg	image	2356676	Outside Lion Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6ef8-83e3-ff135b0399f2	uplift/outside_mermaid_arabesque.jpg	image	1578309	Outside Mermaid Arabesque	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-60d8-8633-8690132b4493	uplift/outside_mermaid_crossed_legs.jpg	image	1850301	Outside Mermaid Crossed Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-67f8-af3f-d68334125877	uplift/pencil_bottom_bar.jpg	image	2207037	Pencil Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6f66-9ac3-79899cc2196f	uplift/pencil_bottom_bar_pike.jpg	image	2382801	Pencil Bottom Bar Pike	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6075-8318-1c40e707288d	uplift/pencil_bottom_bar_scorpion.jpg	image	1786168	Pencil Bottom Bar Scorpion	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-65d4-bc7c-6abcadbd5029	uplift/pencil_bottom_bar_stag_legs.jpg	image	2522465	Pencil Bottom Bar Stag Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-61f9-8daa-ff07e5e3b436	uplift/pencil_bottom_bar_straddle_split.jpg	image	2376002	Pencil Bottom Bar Straddle Split	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-69da-b821-84cae79ce900	uplift/pencil_top_bar.jpg	image	2889189	Pencil Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6c17-90ee-28ab4915f49d	uplift/pencil_top_bar_front_split.jpg	image	1963635	Pencil Top Bar Front Split	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-68bd-a340-4aafe5a38e49	uplift/pencil_top_bar_pike.jpg	image	1789524	Pencil Top Bar Pike	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-69ef-aa4b-6d93150ffd5c	uplift/pencil_top_bar_scorpion.jpg	image	1267178	Pencil Top Bar Scorpion	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6785-8e11-948a9420f7f6	uplift/pencil_top_bar_side_star.jpg	image	1967066	Pencil Top Bar Side Star	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-669d-b083-1bc773467b2b	uplift/pencil_top_bar_stag_legs.jpg	image	1961140	Pencil Top Bar Stag Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6e7a-b4aa-f7c8e536d158	uplift/pencil_top_bar_straddle_split.jpg	image	2131621	Pencil Top Bar Straddle Split	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6de2-ad67-65049c4d48e3	uplift/pencil_top_bar_tick_tocks.jpg	image	2387605	Pencil Top Bar Tick Tocks	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-617f-ae91-d9fde5111e89	uplift/pike_bottom_bar.jpg	image	1840192	Pike Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6fb3-a17f-08ea1616c29f	uplift/pike_drop.jpg	image	3534781	Pike Drop	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6074-ab14-2c5163889fbd	uplift/pike_top_bar.jpg	image	1671978	Pike Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6fdc-8369-129e44e9e28a	uplift/popsicle_-_arch_&_bent_legs.jpg	image	1863182	Popsicle - Arch & Bent Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6c3c-ae20-92cee6c34b51	uplift/popsicle_-_straight_legs.jpg	image	2414107	Popsicle - Straight Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-681c-bea6-6ca8c499c6fa	uplift/pretzel_hang_low_bar_hands_on.jpg	image	1901320	Pretzel Hang Low Bar Hands On	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6e6f-b526-6f325f573e1a	uplift/pretzel_hang_low_bar_no_hands.jpg	image	2066039	Pretzel Hang Low Bar No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-65f0-acb3-5b1b99140a6e	uplift/pretzel_hang_low_bar_one_hand.jpg	image	2041536	Pretzel Hang Low Bar One Hand	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6a03-8c7b-7226d428e854	uplift/pretzel_single_arm_no_knee_hook.jpg	image	133700	Pretzel Single Arm No Knee Hook	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6d4e-99ea-dd09e08466c1	uplift/profile_plank.jpg	image	2420351	Profile Plank	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-690f-b2e2-a77cc73074cd	uplift/profile_plank_elbow_hook.jpg	image	1354786	Profile Plank Elbow Hook	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-649c-8480-fa366655637c	uplift/profile_plank_l_pop_with_split.jpg	image	2097805	Profile Plank L Pop with Split	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6a89-83bd-9dd1e379d136	uplift/profile_sit.jpg	image	2401013	Profile Sit	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-67ad-889f-503db14f8f4a	uplift/prowl.jpg	image	2784131	Prowl	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6f43-b487-0664b930560b	uplift/running_man.jpg	image	1794134	Running Man	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6cbf-a54d-7b9b1a03b2e0	uplift/running_man_cross_knee_release.jpg	image	1752895	Running Man Cross Knee Release	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6e2d-af68-5706a735f830	uplift/russian_roll.jpg	image	1569476	Russian Roll	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6d00-90ff-bfd6dd0c8a21	uplift/sacrum_balance_invert_top_bar.jpg	image	2816085	Sacrum Balance Invert Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-690c-91e3-f4f459fcb3fe	uplift/scorpion_-_knee_hang_outside_top_bar.jpg	image	2943681	Scorpion - Knee Hang Outside Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6d15-87ac-de8475431d53	uplift/seated_forward_roll_-_legs_bent.jpg	image	3069819	Seated Forward Roll - Legs Bent	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6cd2-9809-ddcba5ad0cc0	uplift/seated_forward_roll_-_legs_straight.jpg	image	1117712	Seated Forward Roll - Legs Straight	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-653a-af87-cce9893ac03d	uplift/secretary_sit_under_bar.jpg	image	3083348	Secretary Sit Under Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-64a9-9ebc-61f8cb7da8c2	uplift/shoulder_stand_arrow.jpg	image	3424758	Shoulder Stand Arrow	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-64a9-a3c4-357b24d53706	uplift/shoulder_stand_delilah.jpg	image	2636528	Shoulder Stand Delilah	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6888-b67b-2e3560efcae6	uplift/shoulder_stand_double_knee_hang.jpg	image	1493398	Shoulder Stand Double Knee Hang	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6f3e-b67c-2c4cba6b7376	uplift/shoulder_stand_pike.jpg	image	1991301	Shoulder Stand Pike	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6d59-8be0-b3c6c174c335	uplift/side_bar_inverted_secretary_sit.jpg	image	2234785	Side Bar Inverted Secretary Sit	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6248-b4d6-248b24376ab3	uplift/side_bar_thigh_hold.jpg	image	2086973	Side Bar Thigh Hold	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6379-a313-babc4504de67	uplift/side_star_top_bar.jpg	image	2616854	Side Star Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6c8f-9d55-2784e7c85081	uplift/single_arm_hang.jpg	image	2671510	Single Arm Hang	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-62b3-9af3-385e94adf5f4	uplift/single_knee_hang_bottom_bar_2_hands.jpg	image	1365258	Single Knee Hang Bottom Bar 2 Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6bc1-8093-22fb191b9cbb	uplift/single_knee_hook_-_no_hands.jpg	image	113622	Single Knee Hook - No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6f37-980f-7d1539f60cff	uplift/single_knee_hook_back_press_away.jpg	image	2445283	Single Knee Hook Back Press Away	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6dde-acaa-852f12dfe769	uplift/single_knee_hook_front_press_away.jpg	image	3199227	Single Knee Hook Front Press Away	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6bec-8ec6-69224a7f00a5	uplift/sitting_top_bar.jpg	image	394230	Sitting Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6c64-ac97-5a7055a1b2bd	uplift/skin_the_cat_bottom_bar.jpg	image	1256679	Skin the Cat Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6d9a-b05b-85b10b19364f	uplift/skin_the_cat_top_bar.jpg	image	263889	Skin the Cat Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-64ea-9b0d-bdb7a85ae48a	uplift/sky_diver_bottom_bar.jpg	image	1521661	Sky Diver Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6570-b6bc-bd8075481c40	uplift/spider_under_bar.jpg	image	1878055	Spider Under Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6fff-a698-e236a4999263	uplift/split_leg_thru_window.jpg	image	1902831	Split Leg Thru Window	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6083-b6d4-75770d1ed8a6	uplift/split_leg_thru_window_reverse.jpg	image	1774639	Split Leg Thru Window Reverse	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-63a3-8812-d2f0ce59bc02	uplift/splits_down_hip_squared.jpg	image	1935146	Splits Down Hip Squared	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6c1d-8616-f7ede22e86ba	uplift/stag.jpg	image	2546396	Stag	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6958-869c-94069261af26	uplift/stag_drop.jpg	image	1459347	Stag Drop	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-67b8-8bda-d2820a30dc2b	uplift/stag_from_wine_glass.jpg	image	83550	Stag from Wine Glass	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6021-95d7-6b5468db0150	uplift/stand_in_hoop_star.jpg	image	300953	Stand in Hoop Star	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6a75-9078-108cd5de9b6c	uplift/stand_in_hoop_star_one_leg.jpg	image	306165	Stand in Hoop Star One Leg	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-64de-985d-b14e98f1335d	uplift/stand_outside_hoop.jpg	image	3172600	Stand Outside Hoop	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6343-8a69-ab17b64a056a	uplift/standing_arabesque_inside_leg.jpg	image	3130456	Standing Arabesque Inside Leg	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-63db-9de8-40ac5c96f8a2	uplift/standing_arabesque_outside_leg.jpg	image	2857404	Standing Arabesque Outside Leg	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6713-84b7-9ab8519ede3b	uplift/standing_in_hoop_stag_legs.jpg	image	2542500	Standing in Hoop Stag Legs	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-69eb-9ee5-5b16ca1abd02	uplift/standing_inside_hoop.jpg	image	1982749	Standing Inside Hoop	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-6b2b-a111-705c5885efc3	uplift/straddle_back_bottom_bar.jpg	image	1892745	Straddle Back Bottom Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee3-640d-b552-03c1dc096879	uplift/straddle_back_drop.jpg	image	2572533	Straddle Back Drop	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6c08-a7bf-a553c132b0fe	uplift/straddle_back_inside_outside_top_bar.jpg	image	2266780	Straddle Back Inside Outside Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6fbd-89e2-4f2d1d5f5477	uplift/straddle_back_top_bar.jpg	image	2736737	Straddle Back Top Bar	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-625f-9559-7ce73ece0eca	uplift/superman_-_hands_on.jpg	image	2139176	Superman - Hands On	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6f8a-ab62-e8d14f4f662e	uplift/superman_-_no_hands.jpg	image	1591053	Superman - No Hands	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-61a9-88ea-4945ab53e0b9	uplift/threaded_leg_elbow_hook.jpg	image	2926416	Threaded Leg Elbow Hook	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6611-8983-c3fbb7dd397b	uplift/threaded_leg_exit.jpg	image	2167269	Threaded Leg Exit	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee0-6b23-9eb6-fcba0c880306	uplift/toe_squat.jpg	image	2307851	Toe Squat	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-60d6-aa23-31813bc421e5	uplift/top_bar_sit_reach_for_hoop.jpg	image	385747	Top Bar Sit Reach for Hoop	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6e58-a109-393925225c05	uplift/tree_frog.jpg	image	1659505	Tree Frog	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-62e5-be20-32ecc1fb7cad	uplift/twisted_pike.jpg	image	6582918	Twisted Pike	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee4-6540-8642-7c00d7736b5e	uplift/twisted_v.jpg	image	2182495	Twisted V	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-6b47-ae91-6e46f26a73f3	uplift/unsupported_mermaid.jpg	image	2774593	Unsupported Mermaid	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee1-6762-be60-7999c152ae01	uplift/vine_crawl.jpg	image	1397362	Vine Crawl	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
1f029e9a-7ee2-62a9-a5a5-f830ced5eb50	uplift/wine_glass.jpg	image	2482791	Wine Glass	Joanne's Flashcards	lyra	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755
32f9c19c-e936-41f4-8a29-ed663b9c6d45	default/missing_image.jpg	image	\N	Missing Image Placeholder	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755284
\.


--
-- Data for Name: poses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poses (id, name, primary_media_id, apparatus, level, description, teaching_cues, safety_cues, progressions, created_by, updated_by, created_at, updated_at) FROM stdin;
1f029ef4-7754-6b36-9716-46920d760982	Amazon - Hands On	1f029e9a-7ee2-666a-a817-a05f576d809e	lyra	1	Joanne's Flashcards				35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-05 22:01:17.093
1f029ef4-7753-6840-ac01-ef7be3eed2d5	Amazon Split	1f029e9a-7ee1-693c-8c67-01b11ce1a1e6	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-648c-9153-b704f3fb940a	Amazon Top Hand Off	1f029e9a-7ee3-64f6-a336-4602782f6daa	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-643f-bb7c-b67e0e117a5d	Ankle Cuddle	1f029e9a-7ee2-6134-af02-7f44d377c06c	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6b63-8125-869a9c89463b	Ankle Hang Top Bar - Holding On	1f029e9a-7ee2-6bdc-a400-04dfb33b2fb7	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-63eb-a2fc-8027268018ad	Ankle Hang Top Bar - No Hands	1f029e9a-7ee4-6ef7-973a-5091efd6ef10	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6f40-a80a-8b392b0e7b2a	Arabesque From Seated	1f029e9a-7ee1-6d23-975e-dfe4d43793e4	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-621f-beed-cb2e1dd0b951	Arm Pit Block Top Bar	1f029e9a-7ee4-624c-bcaa-baabe3fe0d69	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-606f-9b4e-72deeeffa7a8	Around the World	1f029e9a-7ee1-6e0b-b9ce-e280fa827620	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-63fe-93b6-560a7fca4897	Back Balance - Hands On	1f029e9a-7ee4-6412-a1b5-2c98fbfd6886	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6f8e-85da-2cb19eb94f29	Back Balance - No Hands	1f029e9a-7ee4-6b7b-ae1e-8793692a8194	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-68de-88d0-f81bcb43c951	Bird’s Nest Bottom Bar	1f029e9a-7ee2-6486-8686-148f24dbceb1	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6ef6-925e-0a8bbca25d78	Bird’s Nest Bottom Bar One Leg	1f029e9a-7ee3-6f18-bd44-6fe4029735e6	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6a34-8ab3-dfcad950b548	Bird’s Nest Top Bar	1f029e9a-7ee2-6af6-983f-c4279cc71f83	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6765-b473-b1c33b62fae4	Bird’s Nest Top Bar Single Leg	1f029e9a-7ee4-6764-97f4-8af02fbd3d9b	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6e98-9743-c8fa2a6ae125	Bottom Bar Flip Out	1f029e9a-7ee1-625f-958a-6aff6d54398b	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-644e-8329-0395143d34b0	Butt Shelf - Legs Straight Above No Hands	1f029e9a-7ee4-645f-9878-7169fe44e553	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6c1b-9019-2eaec5e9250c	Butt Shelf - No Hands	1f029e9a-7ee2-6c71-8a1d-e83a3da50fcd	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6904-89b9-96d933f7ba72	Butt Shelf - One Leg Straight Other Bent Behind	1f029e9a-7ee4-68cc-a372-91de639ef713	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6a45-b76a-2817fa251ef1	Butt Shelf Hands On	1f029e9a-7ee0-6fc2-a616-e41777179a9f	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6906-b5bd-a0e95e7d447a	Butt Shelf Straight Legs	1f029e9a-7ee1-6989-8ab3-df6682562cc8	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-616d-9604-34bed5e8362e	Candlestick	1f029e9a-7ee1-644c-ba4d-2aa2210df4cc	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6a38-98c7-975f8e33183d	Candlestick Reverse from Stag	1f029e9a-7ee3-6a88-affc-8028f95737e6	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-65d4-8ba0-0e95832b461c	Cannon Ball	1f029e9a-7ee3-664f-908d-63ff55e84a5d	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6948-a608-80cfcba0c4e3	Chest Stand Arrow	1f029e9a-7ee3-69a3-bcad-cb6603cc1d25	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6df0-9fd8-4de851d179ad	Chest Stand Delilah	1f029e9a-7ee2-6dff-a216-fe3cda338320	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6314-b5ff-e15bae3be278	Chest Stand Pencil	1f029e9a-7ee4-632f-99a9-f5bc310f661f	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6af6-8e44-c549cf8ae876	Chest Stand Pike	1f029e9a-7ee2-6b91-8238-20269dcca1d0	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6ea2-9205-2d01ecd140a2	Circus Mermaid	1f029e9a-7ee2-6ed7-8863-f5da52a27c40	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-67b4-9e08-d55c4c3d2711	Clock	1f029e9a-7ee0-6937-8e88-362dd04fe6a2	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-66c0-ad01-475584d832c9	Crossed Leg Sit Top Bar	1f029e9a-7ee4-66b4-8f11-189e23a34092	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6929-8810-a0a223c1124c	Cuddle	1f029e9a-7ee0-6a39-914f-5b578cf1cb23	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-6399-a5ee-20517860d112	Cuddle Roll	1f029e9a-7ee4-6eb2-8b72-d3d393fa307e	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6e49-9eb0-e37aa94f0a10	Cuddle Slide	1f029e9a-7ee2-6e89-a302-49f48ae3ae6a	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6277-ad34-5d04d491c686	Cuddle Top Bar	1f029e9a-7ee4-6299-94c1-308a3e726960	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6308-afc5-f636168b2f7a	Delilah	1f029e9a-7ee1-6587-8963-56ab48594fc9	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6b22-961d-84b62c970fd0	Delilah Foot Press Away	1f029e9a-7ee3-6b77-93b4-f46e3fba56d0	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6ea0-b014-85ae61d81913	Delilah Hand Press Away	1f029e9a-7ee3-6ec6-bc46-864df51ff699	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-64e6-98af-c9b068ea7958	Delilah Sideways Top Bar	1f029e9a-7ee4-64f5-8ffc-a2c60ca354b5	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6d94-9a74-50089e53f076	Diving Bird	1f029e9a-7ee2-6da7-9183-5f8caeece461	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6263-8b4a-17959b8a6bca	Double Knee Hook Trash Can	1f029e9a-7ee0-6657-a9fa-65c8266aeb42	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6726-a4c2-2a4c1600cc2c	Dragonfly	1f029e9a-7ee1-6896-ad12-d12bac3f76ce	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6f22-86ca-25ab446366e5	Elbow Hook Double Bottom Bar	1f029e9a-7ee4-6b2f-b6a8-2cf50f404010	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-6097-b406-351e8f59720c	Elbow Hook Double Top Bar	1f029e9a-7ee4-6c4b-a303-22a167c67be0	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6a89-be6e-3c0b87fbde13	Elbow Hook Single Inside Knee Hook Single	1f029e9a-7ee4-6a1b-b790-67cda1297e3b	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6fc8-8c4f-1598f6cf5490	Fallen Angel	1f029e9a-7ee2-6fd8-9810-e95e9bbfda95	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6d06-be56-ca9c3dd1240c	Faux Butt Shelf	1f029e9a-7ee3-6d4c-8c10-b98b5b5294ba	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6673-8c3f-da1328649a4e	Figure Four Foot Block Under Bar	1f029e9a-7ee3-66eb-9679-1175b3926961	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-636b-9952-364cddffcc92	Figure Head	1f029e9a-7ee1-65d0-9935-c7d0e93538fc	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6385-9858-6eecca7095bf	Fish	1f029e9a-7ee2-607f-856d-dc51d70e6f86	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6d05-a93e-e4ee221aaa43	Fish Injured	1f029e9a-7ee1-6125-a1ae-4491ac25a731	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-62e9-a418-43b3d79b583b	Flag	1f029e9a-7ee3-636d-b786-46afde54e1bd	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6c6a-99c4-128b323820cc	Flamenco Grip Inside Mermaid Knee Hook	1f029e9a-7ee3-6cb5-a317-ab5ce6988b0e	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6a1e-8173-369385effeae	Flamingo	1f029e9a-7ee0-6ad7-857b-9ba516138d22	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-69cd-88d0-1bdfeda5f2ce	Flying Saucer	1f029e9a-7ee2-6aa2-a268-fe0260b58979	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6e3a-b302-c2300931ebbd	Gazelle - Hands On	1f029e9a-7ee1-6212-9dd4-34a7f98bb3aa	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-64a4-bdf1-8cfdf7794c3b	Gazelle - Hands on Knee	1f029e9a-7ee1-66c6-b677-9220b8ad7b9c	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-64f2-9ae7-8fa464465d0d	Gazelle - One Hand Knee	1f029e9a-7ee2-61c8-b73f-620e6273ac9f	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6099-bac7-2d420e496f75	Gazelle Allegra Bent Leg	1f029e9a-7ee4-60c5-9aa0-f6f947964265	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6d55-bfde-114e79eb57cb	Gazelle Allegra Straight Leg	1f029e9a-7ee3-6d98-82ae-f1a57b897c3a	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6df5-b9ad-6d1047b20f2c	Gazelle French	1f029e9a-7ee3-6e2f-acb1-8a1cdc7504af	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-63ed-9b08-af0b8a396a78	Gazelle French Stag Legs	1f029e9a-7ee3-645a-bb9c-15dec1ba7cce	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-69a0-92d5-42c7c71da95d	Gazelle Front Split	1f029e9a-7ee4-6955-b46e-96dde081e8b3	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-658b-81b4-cff23b8fae98	Gazelle No Hands	1f029e9a-7ee4-6589-b311-963b9290d622	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6bc0-972c-e577626fe36f	Gazelle Twist Half Split	1f029e9a-7ee2-6c29-8474-16d91dd55eb0	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6627-aaf7-304011c622c7	Gazelle Twist Split Full	1f029e9a-7ee4-6621-b1cf-9da83923edc8	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6c16-bf7e-0090bec79e59	Genie Dismount	1f029e9a-7ee1-6b5b-b17f-6b6e0b8950b7	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-632a-a8a3-b6f95b622b13	Half Angel Roll	1f029e9a-7ee2-6031-a0a1-0861ae8ac942	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-613c-9500-2f32373dbf05	Half Angel Roll Low	1f029e9a-7ee1-6eaa-9822-33d4e97be695	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-633e-a66d-b6cf5ca9796c	Half Back Balance	1f029e9a-7ee3-63c0-9f72-da24b18f09c1	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-61df-8779-b6c3cb43dcc8	Half Back Balance - No Hands	1f029e9a-7ee4-6d59-a0f6-568ff0657cce	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6cd8-b515-163fe00c8bd3	Half Beauty Roll - from High Outside Mermaid	1f029e9a-7ee2-6d0d-90dd-1f94de3fd134	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-64df-ae18-7486bfb56cb5	Half Beauty Roll - from Inside Lion	1f029e9a-7ee3-6555-8d6d-b6abaff6160d	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-68a7-a599-82f8f91c63f8	Half Crescent Moon	1f029e9a-7ee2-69ab-abb8-ce779c01dabd	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-66c1-8953-11881f5e11e7	Half Mill Roll	1f029e9a-7ee1-684a-948c-30fc65a3a543	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6673-8410-ac7bd8814a39	Half Popsicle Roll	1f029e9a-7ee4-666a-a745-4c1001973c33	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6762-873f-77a26018e4fb	HH Foot Block - Both Legs	1f029e9a-7ee3-67d0-b924-feb33bac0c54	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6ae2-946b-bb7955587ae0	High Layout - 1 Hand	1f029e9a-7ee0-6b73-b478-869c60658fee	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6837-a914-36440e923108	High Layout - 2 Hands	1f029e9a-7ee0-6991-bb68-a406679d3ab7	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6010-b0ca-0aae6de0a21d	High Outside Mermaid	1f029e9a-7ee1-6dbd-8297-fba809d1f5bd	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6c60-9f66-42db81c39226	Hip Hang	1f029e9a-7ee0-6cb9-a4cf-910ee35411fb	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-69c3-b732-6820d7a69037	Hip Hang Flip In	1f029e9a-7ee1-69d5-a908-bd962846e00a	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6ddb-8e22-ba5d82a20e17	Hip Hang Flip Out	1f029e9a-7ee1-61c3-a87b-cac813b92a77	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-63c5-87ff-80fbc881d94b	Hip Hang Foot Block	1f029e9a-7ee1-661b-8061-9e6c7c8ea6a8	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6855-a5cb-eb13b6f5ce41	Hip Hang Inverted Flamingo	1f029e9a-7ee4-6845-9541-84770aad4976	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-652d-8e3b-c4efb8c18df0	Hip Hang Scorpion	1f029e9a-7ee3-65a1-8738-5777e845bf12	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-60de-bcb3-b807de7b023d	Hip Hang Top Bar	1f029e9a-7ee3-6158-bd63-56fc94836045	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6edf-9549-7ff0c866736c	Hip Hang Zipper	1f029e9a-7ee1-6cd6-b6fb-8a3b078f9ac9	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-69ec-80cb-c26b452f7c54	Hock Hang	1f029e9a-7ee4-6999-a5aa-3c39c465506f	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-648a-b77f-9ec60bc8574d	Hock Hang Top Bar	1f029e9a-7ee4-6f7a-be83-48e5e621c9f4	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6cce-b1bb-439542ed9f9c	Horse	1f029e9a-7ee0-6d03-baa7-bcbb81cc9763	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-65a7-8b5a-34fe481052a8	Inside Lion	1f029e9a-7ee0-678b-b864-5b8452996cd6	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6a4a-8334-9679459b67c4	Inside Lion Arabesque	1f029e9a-7ee1-6a2b-8d0b-bf36040c8c0f	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-629a-9b5c-d55c921ad4f1	Inside Lion Slide	1f029e9a-7ee3-631b-9b6a-621d082c147c	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-670f-8dfa-4cf7adf3e872	Inside Lion Top Bar	1f029e9a-7ee4-6707-a63a-924149da29dd	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6b6f-9d9e-bfbb3ec0e2f8	Inverted Hoop Flip Bent Legs	1f029e9a-7ee3-6bc3-89ee-f41eee88d422	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-681a-92f9-ef1ab2a3349f	Inverted Running Man Top Bar	1f029e9a-7ee2-6952-8e43-86aeb1dd0bc8	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6022-85e0-296da69c27f2	Inverted Star Hoop Flip	1f029e9a-7ee3-6027-98bc-d644af10b618	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6242-88e9-633266e25910	Inverted Star Stag Legs	1f029e9a-7ee3-6295-89c7-390c07c3c75f	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6970-bb72-0e57a84c3adc	Inverted Star Top Bar	1f029e9a-7ee2-6a57-a7d9-45b38e005e54	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6134-8448-62b640433e7d	Jamilla	1f029e9a-7ee4-615e-99c2-9219e6fb415c	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6014-8172-339de5a5d767	Knee Hang Bottom Bar Pike	1f029e9a-7ee1-6354-b218-2acd47a322dd	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6789-93ca-840cdb47ab09	Knee Hang Bottom Bar Single - One Hand	1f029e9a-7ee1-68e6-ae4b-80a25599233f	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-625e-8dac-00415a219f29	Knee Hang Double Bottom Bar	1f029e9a-7ee1-6f92-ae4c-1a6af515e4c5	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-66c3-9247-cdc472d0ba93	Knee Hang Double Top Bar - No Hands	1f029e9a-7ee3-6739-9ede-1be136f8688d	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-69b8-9903-bd21aaeb6ed5	Knee Hang Top Bar Back Press Away	1f029e9a-7ee2-6527-a7ce-3e1706abe397	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6650-8f1f-82c66d685db7	Knee Hang Top Bar Forward Press Away	1f029e9a-7ee1-67fd-b0b1-fdd5af2bf574	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-643e-b439-b342b41ac806	Knee Hang Top Bar Hands High	1f029e9a-7ee1-6677-8c5f-e7ba34734d86	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6685-9ab6-c08f87b3ee13	Knee Hang Top Bar Hands Low	1f029e9a-7ee2-62f4-9608-582f404a5618	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-671c-9b35-8546752e4ecf	Knee Hook Layout Under Bar	1f029e9a-7ee0-6888-a5e5-d2aa9bb2d31a	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-60fe-8c9c-df0dc5b55639	L Pop	1f029e9a-7ee1-63fd-b536-edafb2aaa09d	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6c04-b091-879130ae684f	L Sit	1f029e9a-7ee0-6c6b-92e9-b8902ec59f98	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6683-bed5-f08103f1168b	Lady in the Moon	1f029e9a-7ee0-681c-8ba5-76c1cc2e1fb2	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6147-a958-e57dfae422f0	Leg Block Faint	1f029e9a-7ee3-61ab-9c44-dd40250946c4	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6a6f-898f-6acf5c2c075a	Lion Roll	1f029e9a-7ee2-65b9-9f58-003ee438a5ce	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6fb2-ab62-816207e47004	Low Man in the Moon	1f029e9a-7ee1-6d70-b9d1-50fbed763925	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6f7c-a4bc-330e5e8d8e4d	Low Outside Mermaid	1f029e9a-7ee1-6303-8ddb-ce94b5108e3b	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-69e8-9668-44edce4e2777	Man in Moon Invert	1f029e9a-7ee3-6a3a-9362-fff4780b3c57	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-67f6-bc08-4b1d8aecdc0b	Man in Moon Low Legs Crossed	1f029e9a-7ee2-6428-bced-945f0cfe06f1	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6d72-ac28-60dd4c38d5ee	Man in Moon Straddle	1f029e9a-7ee1-6175-bb30-f1c0e7f4e420	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6b43-84a3-c14922c5be35	Man in the Moon	1f029e9a-7ee0-6bcd-b8c0-0187c2e0a6ec	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-63b1-bb4b-af0f317ca361	Man in the Moon Press Away	1f029e9a-7ee4-63c7-be17-05848c603659	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-60e6-a8c9-255f10f86e97	Martini	1f029e9a-7ee4-6112-89b4-d47e9ce48c77	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-61d1-ac6c-8aad287981d2	Martini Top Bar	1f029e9a-7ee4-61f5-9231-218b754da468	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6bb9-85da-3e75b8c38e4e	Mermaid Inside	1f029e9a-7ee1-6b0f-98f5-ac3017c4d7ab	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-654c-89f0-e3f7659eace9	Mermaid Inside Flamenco Grip	1f029e9a-7ee2-6212-855d-6995a59e533f	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6b54-a640-a9d2e36d7031	Mermaid Inside Split Legs	1f029e9a-7ee1-6ac1-b92e-e23b6341c2a8	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-673f-9c7c-484775d62481	Outside Knee Hook Both Legs	1f029e9a-7ee2-638e-8c07-f31f939c7898	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6c7a-98a2-e658d504314b	Outside Lion	1f029e9a-7ee1-6ba3-b0d4-c979f59d7d7a	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6a85-9d42-b95e41cdb75b	Outside Lion Slide	1f029e9a-7ee3-6ad5-9874-5ec082532753	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-67ff-9841-b9752ed95a01	Outside Lion Top Bar	1f029e9a-7ee3-6867-aaca-9db42f4d3085	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-619f-99d1-452016ec69c2	Outside Mermaid Arabesque	1f029e9a-7ee1-6ef8-83e3-ff135b0399f2	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-63e1-80fa-6c5c758c18d2	Outside Mermaid Crossed Legs	1f029e9a-7ee2-60d8-8633-8690132b4493	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6806-beed-d0a56ccfb0fd	Pencil Bottom Bar	1f029e9a-7ee4-67f8-af3f-d68334125877	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6f5a-aca4-2ee230e5d4fb	Pencil Bottom Bar Pike	1f029e9a-7ee3-6f66-9ac3-79899cc2196f	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-604a-982f-636e51afa47f	Pencil Bottom Bar Scorpion	1f029e9a-7ee4-6075-8318-1c40e707288d	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-65d8-a80b-6a1202a4b8e7	Pencil Bottom Bar Stag Legs	1f029e9a-7ee4-65d4-bc7c-6abcadbd5029	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-61a0-865e-2a6ea7490b11	Pencil Bottom Bar Straddle Split	1f029e9a-7ee3-61f9-8daa-ff07e5e3b436	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6a3a-9974-66844d03f0b9	Pencil Top Bar	1f029e9a-7ee4-69da-b821-84cae79ce900	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6bbe-9b4d-e316e6a6eb22	Pencil Top Bar Front Split	1f029e9a-7ee3-6c17-90ee-28ab4915f49d	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-684d-9b87-a4da66fb6002	Pencil Top Bar Pike	1f029e9a-7ee3-68bd-a340-4aafe5a38e49	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6996-800b-cbf74df82ff3	Pencil Top Bar Scorpion	1f029e9a-7ee3-69ef-aa4b-6d93150ffd5c	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6714-b725-c7f5b68e17ef	Pencil Top Bar Side Star	1f029e9a-7ee3-6785-8e11-948a9420f7f6	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6623-a73d-7029bcdf1697	Pencil Top Bar Stag Legs	1f029e9a-7ee3-669d-b083-1bc773467b2b	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6e50-88de-d871efdb107a	Pencil Top Bar Straddle Split	1f029e9a-7ee3-6e7a-b4aa-f7c8e536d158	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6da3-92ab-e68ef0c499cc	Pencil Top Bar Tick Tocks	1f029e9a-7ee3-6de2-ad67-65049c4d48e3	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6499-9e8b-c0b360632124	Pike Bottom Bar	1f029e9a-7ee2-617f-ae91-d9fde5111e89	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6fa9-989f-085065993853	Pike Drop	1f029e9a-7ee3-6fb3-a17f-08ea1616c29f	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6c28-b958-a12b5a13dbec	Pike Top Bar	1f029e9a-7ee1-6074-ab14-2c5163889fbd	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-62cd-9d67-69f2f34cd49d	Popsicle - Arch & Bent Legs	1f029e9a-7ee1-6fdc-8369-129e44e9e28a	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6e64-80b2-5bcae6402378	Popsicle - Straight Legs	1f029e9a-7ee1-6c3c-ae20-92cee6c34b51	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-67b0-bfc8-62be72495f02	Pretzel Hang Low Bar Hands On	1f029e9a-7ee3-681c-bea6-6ca8c499c6fa	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-6327-aca8-33ea6eb35829	Pretzel Hang Low Bar No Hands	1f029e9a-7ee4-6e6f-b526-6f325f573e1a	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-657b-8cac-f30ac32d08bb	Pretzel Hang Low Bar One Hand	1f029e9a-7ee3-65f0-acb3-5b1b99140a6e	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-690f-8262-2ff47cc27d8b	Pretzel Single Arm No Knee Hook	1f029e9a-7ee2-6a03-8c7b-7226d428e854	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6d2d-ad3b-130c48598c09	Profile Plank	1f029e9a-7ee0-6d4e-99ea-dd09e08466c1	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6951-9f42-45ef0bc486e3	Profile Plank Elbow Hook	1f029e9a-7ee4-690f-b2e2-a77cc73074cd	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-61e4-ba28-5812fe0e1d59	Profile Plank L Pop with Split	1f029e9a-7ee1-649c-8480-fa366655637c	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6998-9b84-cf3cbb486f87	Profile Sit	1f029e9a-7ee0-6a89-83bd-9dd1e379d136	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-65dc-8aec-221e2ed7805c	Prowl	1f029e9a-7ee1-67ad-889f-503db14f8f4a	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-61fd-9b10-7511c1ece29a	Running Man	1f029e9a-7ee1-6f43-b487-0664b930560b	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6c77-bc19-1c445d5b932d	Running Man Cross Knee Release	1f029e9a-7ee2-6cbf-a54d-7b9b1a03b2e0	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-62d7-8bca-f309242ea02c	Russian Roll	1f029e9a-7ee4-6e2d-af68-5706a735f830	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6cb8-981e-389827947f4e	Sacrum Balance Invert Top Bar	1f029e9a-7ee3-6d00-90ff-bfd6dd0c8a21	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-68a0-b23e-20829bb16e8f	Scorpion - Knee Hang Outside Top Bar	1f029e9a-7ee3-690c-91e3-f4f459fcb3fe	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-618e-b8ff-0f3d0741b315	Seated Forward Roll - Legs Bent	1f029e9a-7ee4-6d15-87ac-de8475431d53	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-613d-a72a-628aa6824158	Seated Forward Roll - Legs Straight	1f029e9a-7ee4-6cd2-9809-ddcba5ad0cc0	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-62a9-95a3-049d37a9290b	Secretary Sit Under Bar	1f029e9a-7ee1-653a-af87-cce9893ac03d	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-643e-b400-e03685f39a37	Shoulder Stand Arrow	1f029e9a-7ee3-64a9-9ebc-61f8cb7da8c2	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-649b-97b5-63f9c59b0e18	Shoulder Stand Delilah	1f029e9a-7ee4-64a9-a3c4-357b24d53706	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-68b2-bb47-e3a65f646f05	Shoulder Stand Double Knee Hang	1f029e9a-7ee4-6888-b67b-2e3560efcae6	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6f11-8951-cdc700199ac1	Shoulder Stand Pike	1f029e9a-7ee2-6f3e-b67c-2c4cba6b7376	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6d37-a423-ed3c826765b5	Side Bar Inverted Secretary Sit	1f029e9a-7ee2-6d59-8be0-b3c6c174c335	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-61f3-bf8f-e6191ef3c54a	Side Bar Thigh Hold	1f029e9a-7ee3-6248-b4d6-248b24376ab3	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6361-8936-478c88072eca	Side Star Top Bar	1f029e9a-7ee4-6379-a313-babc4504de67	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-60ea-99bd-6c0291dce1f7	Single Arm Hang	1f029e9a-7ee4-6c8f-9d55-2784e7c85081	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6f08-a4d5-a3cda8eb83c9	Single Knee Hang Bottom Bar 2 Hands	1f029e9a-7ee1-62b3-9af3-385e94adf5f4	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6fe4-95bd-33bae501bfe9	Single Knee Hook - No Hands	1f029e9a-7ee4-6bc1-8093-22fb191b9cbb	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-643b-9135-d700ba3658a6	Single Knee Hook Back Press Away	1f029e9a-7ee4-6f37-980f-7d1539f60cff	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-6286-9b2b-4cefff3df43f	Single Knee Hook Front Press Away	1f029e9a-7ee4-6dde-acaa-852f12dfe769	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6dde-b7c1-f458571e1e74	Sitting Top Bar	1f029e9a-7ee1-6bec-8ec6-69224a7f00a5	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6c17-822d-64028d72e2be	Skin the Cat Bottom Bar	1f029e9a-7ee3-6c64-ac97-5a7055a1b2bd	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-6235-8127-53714aa7408a	Skin the Cat Top Bar	1f029e9a-7ee4-6d9a-b05b-85b10b19364f	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6246-a742-4e4bee91c107	Sky Diver Bottom Bar	1f029e9a-7ee1-64ea-9b0d-bdb7a85ae48a	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6a13-938c-b3f690a446a5	Spider Under Bar	1f029e9a-7ee2-6570-b6bc-bd8075481c40	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6ff9-bc5e-f7ec4f182ad9	Split Leg Thru Window	1f029e9a-7ee3-6fff-a698-e236a4999263	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-607d-af67-fb486899b97d	Split Leg Thru Window Reverse	1f029e9a-7ee3-6083-b6d4-75770d1ed8a6	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-607a-a02d-4804140cafb9	Splits Down Hip Squared	1f029e9a-7ee1-63a3-8812-d2f0ce59bc02	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6ba1-8549-9b0f350e366e	Stag	1f029e9a-7ee0-6c1d-8616-f7ede22e86ba	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-68f9-b8c3-603af27ab9bc	Stag Drop	1f029e9a-7ee3-6958-869c-94069261af26	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-67b8-9c75-2b13719d3465	Stag from Wine Glass	1f029e9a-7ee4-67b8-8bda-d2820a30dc2b	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6ba2-9389-5869f4995b0b	Stand in Hoop Star	1f029e9a-7ee1-6021-95d7-6b5468db0150	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6add-93c4-ec7fb8239d7d	Stand in Hoop Star One Leg	1f029e9a-7ee1-6a75-9078-108cd5de9b6c	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6959-b6d3-493332b988ae	Stand Outside Hoop	1f029e9a-7ee2-64de-985d-b14e98f1335d	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-66e4-8246-c532b4706711	Standing Arabesque Inside Leg	1f029e9a-7ee2-6343-8a69-ab17b64a056a	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-679a-83f6-1e7563e6d27f	Standing Arabesque Outside Leg	1f029e9a-7ee2-63db-9de8-40ac5c96f8a2	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-650a-a9ac-a021453c1855	Standing in Hoop Stag Legs	1f029e9a-7ee1-6713-84b7-9ab8519ede3b	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-68ae-8178-7cd3bc9bea96	Standing Inside Hoop	1f029e9a-7ee0-69eb-9ee5-5b16ca1abd02	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-6ad3-8301-9f7fa7123f70	Straddle Back Bottom Bar	1f029e9a-7ee3-6b2b-a111-705c5885efc3	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7756-639c-982d-84464cf83da6	Straddle Back Drop	1f029e9a-7ee3-640d-b552-03c1dc096879	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-6044-a9e0-62153051f11a	Straddle Back Inside Outside Top Bar	1f029e9a-7ee4-6c08-a7bf-a553c132b0fe	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7758-64d9-8112-ca44e69ee548	Straddle Back Top Bar	1f029e9a-7ee4-6fbd-89e2-4f2d1d5f5477	lyra	3	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-65aa-8146-a7caa55fc5af	Superman - Hands On	1f029e9a-7ee2-625f-9559-7ce73ece0eca	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6f6d-9cea-f65bdc559b49	Superman - No Hands	1f029e9a-7ee2-6f8a-ab62-e8d14f4f662e	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6183-b6a6-cdf0bbc0b5c5	Threaded Leg Elbow Hook	1f029e9a-7ee4-61a9-88ea-4945ab53e0b9	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6ad8-8332-7a160d78d4c5	Threaded Leg Exit	1f029e9a-7ee2-6611-8983-c3fbb7dd397b	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7751-6a7b-ade7-c6e5aadc0e9d	Toe Squat	1f029e9a-7ee0-6b23-9eb6-fcba0c880306	lyra	0	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7752-6c92-8813-8a807aa03f6f	Top Bar Sit Reach for Hoop	1f029e9a-7ee1-60d6-aa23-31813bc421e5	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-60d1-8960-2850a4e98f1d	Tree Frog	1f029e9a-7ee1-6e58-a109-393925225c05	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-62c6-b312-297a9e8ef403	Twisted Pike	1f029e9a-7ee4-62e5-be20-32ecc1fb7cad	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7757-6534-9f38-b97b40c9c6ed	Twisted V	1f029e9a-7ee4-6540-8642-7c00d7736b5e	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7755-6a9a-9057-426848fdfb82	Unsupported Mermaid	1f029e9a-7ee2-6b47-ae91-6e46f26a73f3	lyra	2	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7753-6572-ab44-173e4aba8c4e	Vine Crawl	1f029e9a-7ee1-6762-be60-7999c152ae01	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
1f029ef4-7754-6617-8f39-a7a9646c036b	Wine Glass	1f029e9a-7ee2-62a9-a5a5-f830ced5eb50	lyra	1	Joanne's Flashcards	\N	\N	\N	35327f2b-9205-440f-8e38-f6da18f4dd54	35327f2b-9205-440f-8e38-f6da18f4dd54	2025-05-02 18:15:17.755	2025-05-02 18:15:17.755
\.


--
-- Data for Name: transitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transitions (id, from_pose_id, to_pose_id, level, name, description, teaching_cues, safety_cues, progressions, transition_type, starting_grip, ending_grip, created_by, updated_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password, first_name, last_name, bio, created_at, updated_at, last_login) FROM stdin;
35327f2b-9205-440f-8e38-f6da18f4dd54	admin	bshweta@proton.me	$2b$08$3V8BHDcM8rchfhR45p1gB.jEA0wLU4zVLmhM7LEpsobGEYQGEw4Pa	\N	\N	\N	2025-05-01 01:12:05.393595	2025-05-01 01:12:05.393595	2025-05-01 01:12:05.393595
78d840fd-964e-4224-a24e-423a1406c62e	test	test123@gmail.com	$2b$08$3G4G9EWDuaPQ.mTh8lQvKO1JnoftTeyAJ2FqSk2r0Mw7PHjHi4nsy	\N	\N	\N	2025-05-09 22:25:23.140791	2025-05-09 22:25:23.140791	2025-05-09 22:25:23.140791
\.


--
-- Name: flow_poses flow_poses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_poses
    ADD CONSTRAINT flow_poses_pkey PRIMARY KEY (id);


--
-- Name: flows flows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT flows_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: poses poses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poses
    ADD CONSTRAINT poses_pkey PRIMARY KEY (id);


--
-- Name: transitions transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transitions
    ADD CONSTRAINT transitions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: flow_poses flow_poses_flow_id_flows_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_poses
    ADD CONSTRAINT flow_poses_flow_id_flows_id_fk FOREIGN KEY (flow_id) REFERENCES public.flows(id) ON DELETE CASCADE;


--
-- Name: flow_poses flow_poses_pose_id_poses_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_poses
    ADD CONSTRAINT flow_poses_pose_id_poses_id_fk FOREIGN KEY (pose_id) REFERENCES public.poses(id) ON DELETE CASCADE;


--
-- Name: flow_poses flow_poses_transition_id_transitions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flow_poses
    ADD CONSTRAINT flow_poses_transition_id_transitions_id_fk FOREIGN KEY (transition_id) REFERENCES public.transitions(id) ON DELETE CASCADE;


--
-- Name: flows flows_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT flows_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET DEFAULT;


--
-- Name: flows flows_thumbnail_image_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT flows_thumbnail_image_id_media_id_fk FOREIGN KEY (thumbnail_image_id) REFERENCES public.media(id);


--
-- Name: flows flows_updated_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT flows_updated_by_users_id_fk FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: media media_uploaded_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_uploaded_by_users_id_fk FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: poses poses_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poses
    ADD CONSTRAINT poses_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: poses poses_primary_media_id_media_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poses
    ADD CONSTRAINT poses_primary_media_id_media_id_fk FOREIGN KEY (primary_media_id) REFERENCES public.media(id);


--
-- Name: poses poses_updated_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poses
    ADD CONSTRAINT poses_updated_by_users_id_fk FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: transitions transitions_created_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transitions
    ADD CONSTRAINT transitions_created_by_users_id_fk FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transitions transitions_from_pose_id_poses_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transitions
    ADD CONSTRAINT transitions_from_pose_id_poses_id_fk FOREIGN KEY (from_pose_id) REFERENCES public.poses(id);


--
-- Name: transitions transitions_to_pose_id_poses_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transitions
    ADD CONSTRAINT transitions_to_pose_id_poses_id_fk FOREIGN KEY (to_pose_id) REFERENCES public.poses(id);


--
-- Name: transitions transitions_updated_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transitions
    ADD CONSTRAINT transitions_updated_by_users_id_fk FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

